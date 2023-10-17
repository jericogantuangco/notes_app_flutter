import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:notes_app/constants/routes.dart';

class LoginView extends StatefulWidget {
  final Logger logger;
  const LoginView({super.key, required this.logger});

  @override
  State<LoginView> createState() => _LoginViewState(logger);
}

class _LoginViewState extends State<LoginView> {
  _LoginViewState(this.logger);
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final Logger logger;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
              logger.fine('Call Login backend with $email and $password');

              final http.Response response;

              final url = Uri.parse(
                  'https://dc6v35fk1h.execute-api.us-east-1.amazonaws.com/login');
              final body = jsonEncode({
                'username': email,
                'password': password,
              });

              Map<String, String> headers = {
                'Content-Type': 'application/json; charset=UTF-8',
              };

              try {
                response = await http.post(url, headers: headers, body: body);

                if (response.statusCode == 200) {
                  final responseBody = json.decode(response.body);
                  logger.fine(responseBody['message']);
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                } else {
                  logger.fine(
                      'Request failed with status: ${response.statusCode}');
                }
              } catch (e) {
                logger.severe(e);
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              logger.fine('Register here clicked.');
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Not registered yet? Register here.'),
          )
        ],
      ),
    );
  }
}
