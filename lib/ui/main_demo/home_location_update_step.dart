import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';

class HomeLocationUpdateStepWidget extends StatefulWidget {
  final PasskeyService passkeyService;
  const HomeLocationUpdateStepWidget({super.key, required this.passkeyService});

  @override
  State<HomeLocationUpdateStepWidget> createState() => _HomeLocationUpdateStepWidgetState();
}

class _HomeLocationUpdateStepWidgetState extends State<HomeLocationUpdateStepWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
