import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/passkey/user.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/step_widgets.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';

class AuthNByUserHandleStepWidget extends StatefulWidget {
  final PasskeyService passkeyService;
  final Function(StepOutput) onResult;

  const AuthNByUserHandleStepWidget(
      {super.key, required this.passkeyService, required this.onResult});

  @override
  State<AuthNByUserHandleStepWidget> createState() =>
      _AuthNByUserHandleStepWidgetState();
}

class _AuthNByUserHandleStepWidgetState
    extends State<AuthNByUserHandleStepWidget> {
  String userHandle = "";
  late TextEditingController userHandleController;
  StepOutput? output;

  @override
  void initState() {
    super.initState();
    userHandleController = TextEditingController();
    User? user = Provider.of<IdentityState>(context, listen: false).user;
    if (user != null) {
      userHandleController.text = user.userHandle;
      userHandle = user.userHandle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasicStep(
      title: "Login with UserName and Passkey",
      description:
          "User would need to provide a UserName/UserHandle, using which passkey LOGIN could be triggered to securely enter into the system.",
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: userHandleController,
            onChanged: (value) {
              setState(() {
                  userHandle = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Enter UserHandle',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        StepButton(
          "LOGIN WITH USERNAME",
          onTap: userHandle.isNotEmpty ? () {
            onLogin(context);
          } : null,
        ),
        if (output != null) StepOutputWidget(stepOutput: output!)
      ],
    );
  }

  onLogin(BuildContext context) async {
    User? user;
    try {
      user = await widget.passkeyService.authenticate(userHandle);

      if (user != null) {
        setState(() {
          Provider.of<IdentityState>(context, listen: false).setUser(user!);
          output = StepOutput(
              timestamp: DateTime.now(),
              output: "Registered Credential with User : ${user.toString()}",
              successful: true);
          widget.onResult(output!);
        });
      } else {
        output = StepOutput(
            successful: false,
            timestamp: DateTime.now(),
            output: "Error Authenticating User.");
        widget.onResult(output!);
      }
    } catch (e) {
      output = StepOutput(
          successful: false, timestamp: DateTime.now(), output: e.toString());
      widget.onResult(output!);
      return;
    }
  }
}
