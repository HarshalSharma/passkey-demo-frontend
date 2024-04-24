import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';

class AuthNByLocationStepWidget extends StatefulWidget {
  final PasskeyService passkeyService;

  const AuthNByLocationStepWidget({super.key, required this.passkeyService});

  @override
  State<AuthNByLocationStepWidget> createState() =>
      _AuthNByLocationStepWidgetState();
}

class _AuthNByLocationStepWidgetState extends State<AuthNByLocationStepWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
