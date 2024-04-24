
import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';

class NotesEditorStepWidget extends StatefulWidget {
  final PasskeyService passkeyService;

  const NotesEditorStepWidget({super.key, required this.passkeyService});

  @override
  State<NotesEditorStepWidget> createState() => _NotesEditorStepWidgetState();
}

class _NotesEditorStepWidgetState extends State<NotesEditorStepWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
