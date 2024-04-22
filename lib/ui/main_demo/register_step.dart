import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/passkey/user.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/loading_widget.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/step_widgets.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';

class RegisterStepWidget extends StatefulWidget {
  final PasskeyService passkeyService;
  final Function(StepOutput) onResult;

  const RegisterStepWidget(
      {super.key, required this.passkeyService, required this.onResult});

  @override
  State<RegisterStepWidget> createState() => _RegisterStepWidgetState();
}

class _RegisterStepWidgetState extends State<RegisterStepWidget> {
  StepOutput? output;
  var isWaiting = false;

  @override
  Widget build(BuildContext context) {
    return BasicStep(
      title: "Register New Passkey",
      description:
          "User could choose to register for NEW passkey, which they could later use to LOGIN into the system.",
      children: [
        StepButton(
          "REGISTER",
          onTap: () {
            setState(() {
              output = null;
              isWaiting = true;
            });
            onSignup(context);
          },
        ),
        if (output != null) StepOutputWidget(stepOutput: output!),
        if (isWaiting == true)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Loading(),
          )
      ],
    );
  }

  onSignup(BuildContext context) async {
    User? user;
    String? exception;
    try {
      user = await widget.passkeyService.enroll();

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
            output:
                "Error Registering, please check backend service configuration.");
        widget.onResult(output!);
      }
    } catch (e) {
      exception = e.toString();
      output = StepOutput(
          successful: false, timestamp: DateTime.now(), output: exception);
      widget.onResult(output!);
    }
    setState(() {
      isWaiting = false;
    });
  }
}
