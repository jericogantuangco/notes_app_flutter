import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class VerifyEmailView extends StatefulWidget {
  final Logger logger;
  const VerifyEmailView({super.key, required this.logger});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState(logger);
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  _VerifyEmailViewState(this.logger);
  late final Logger logger;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text('Please verify your email address'),
          TextButton(
            onPressed: () => logger.fine('Sent verification email'),
            child: const Text('Send email verification'),
          )
        ],
      ),
    );
  }
}
