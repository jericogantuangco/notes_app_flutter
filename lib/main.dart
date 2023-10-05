import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/register_view.dart';

import 'views/verify_email_view.dart';

void main() {
  final logger = Logger('HomePage');
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(MaterialApp(
    title: 'Flutter Demo Now',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: HomePage(logger: logger),
    routes: {
      '/login/': (context) => LoginView(logger: logger),
      '/register/': (context) => const RegisterView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  final Logger logger;
  const HomePage({super.key, required this.logger});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: http.get(Uri.parse(
          'https://80f1em8so7.execute-api.us-east-1.amazonaws.com/verify-email')),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final responseData = snapshot.data?.body ?? "";
            final user = json.decode(responseData)['user'];
            logger.fine(user);

            if (user != null && !user['verified']) {
              logger.fine('You need to verify your email first');
              return VerifyEmailView(logger: logger);
            } else if (user != null) {
              return const NotesView();
            }

            logger.fine('You are a verified user');
            return LoginView(logger: logger);

          default:
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
      ),
    );
  }
}
