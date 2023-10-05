import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final Logger _log = Logger('RegisterView');

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
        title: const Text('Register'),
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
              _log.fine('Call backend with $email and $password');

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
                _log.warning('Exception with: $e');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            child: const Text('Already registered? Login here'),
            onPressed: () {
              _log.fine('Login here clicked');
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login/', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
