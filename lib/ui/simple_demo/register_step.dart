import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/step_widgets.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';

class RegisterStepWidget extends StatefulWidget {
  final PasskeyService passkeyService;

  const RegisterStepWidget({super.key, required this.passkeyService});

  @override
  State<RegisterStepWidget> createState() => _RegisterStepWidgetState();
}

class _RegisterStepWidgetState extends State<RegisterStepWidget> {
  @override
  Widget build(BuildContext context) {
    return BasicStep(
      title: "Register New Passkey",
      description:
          "User could choose to register for NEW passkey, which they could later use to LOGIN into the system.",
      children: [
        StepButton(
          "REGISTER",
          onTap: () {},
        )
      ],
    );
  }

  onSignup(BuildContext context) async {
    var user = await widget.passkeyService.enroll();
    log("registration status - $bool");
    if (user != null) {
      setState(() {
        Provider.of<IdentityState>(context, listen: false).setUser(user);
      });
    }
  }
}
