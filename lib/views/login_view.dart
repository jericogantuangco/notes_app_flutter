import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final Logger _log;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void configureLogger() {
    Logger.root.level = Level.FINE;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  @override
  Widget build(BuildContext context) {
    configureLogger();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Enter email.')),
          TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(hintText: 'Enter password.')),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              _log.fine('Call Login backend with $email and $password');

              final http.Response response;
              try {
                final url = Uri.parse(
                    'https://80f1em8so7.execute-api.us-east-1.amazonaws.com/');
                response = await http.get(url);

                if (response.statusCode == 200) {
                  final responseBody = json.decode(response.body);
                  _log.fine(responseBody['message']);
                } else {
                  _log.fine(
                      'Request failed with status: ${response.statusCode}');
                }
              } catch (e) {
                _log.severe(e);
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
