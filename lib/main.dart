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
              return NotesView(logger: logger);
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

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  final Logger logger;
  const NotesView({super.key, required this.logger});

  @override
  State<NotesView> createState() => _NotesViewState(logger);
}

class _NotesViewState extends State<NotesView> {
  _NotesViewState(this.logger);
  late final Logger logger;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main UI'), actions: [
        PopupMenuButton<MenuAction>(
          onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final loggingOut = await showLogoutDialog(context);
                logger.fine('Logging out: ${loggingOut.toString()}');

                if (loggingOut) {
                  // Put call to logout api here.
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login/',
                    (_) => false,
                  );
                }
                break;
            }
          },
          itemBuilder: (context) {
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Logout'),
              )
            ];
          },
        ),
      ]),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text('Sign out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Logout'),
              ),
            ]);
      }).then((value) => value ?? false);
}
