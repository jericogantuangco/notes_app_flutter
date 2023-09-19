import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/register_view.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo Now',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = Logger('HomePage');
    Logger.root.level = Level.FINE;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        body: FutureBuilder(
          future: http.get(Uri.parse(
              'https://80f1em8so7.execute-api.us-east-1.amazonaws.com/verify-email')),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final responseData = snapshot.data?.body ?? "";
                final user = json.decode(responseData)['user'];
                logger.fine(user);

                if (user['verified']) {
                  print('You are a verified user');
                  return LoginView(logger: logger);
                } else {
                  print('You need to verify your email first');
                  return const VerifyEmailView();
                }
                return const Text('Done');
              default:
                return const Text('Loading...');
            }
          },
        ));
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Please verify your email address'),
        TextButton(
          onPressed: () => print('Sent verification email'),
          child: const Text('Send email verification'),
        )
      ],
    );
  }
}
