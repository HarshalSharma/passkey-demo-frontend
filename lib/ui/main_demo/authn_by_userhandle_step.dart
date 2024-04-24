import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/passkey/user.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/loading_widget.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/notification.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/step_widgets.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';

class AuthNByUserHandleStepWidget extends StatefulWidget {
  final PasskeyService passkeyService;

  const AuthNByUserHandleStepWidget({super.key, required this.passkeyService});

  @override
  State<AuthNByUserHandleStepWidget> createState() =>
      _AuthNByUserHandleStepWidgetState();
}

class _AuthNByUserHandleStepWidgetState
    extends State<AuthNByUserHandleStepWidget> {
  late TextEditingController userHandleController;
  StepOutput? output;
  bool isWaiting = false;

  @override
  void initState() {
    super.initState();
    userHandleController = TextEditingController();
    User? user = Provider.of<IdentityState>(context, listen: false).user;
    if (user != null) {
      userHandleController.text = user.userHandle;
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
            child: Consumer<IdentityState>(
              builder:
                  (BuildContext context, IdentityState value, Widget? child) {
                if (value.user != null) {
                  userHandleController.text = value.user.userHandle;
                }
                return child!;
              },
              child: TextField(
                controller: userHandleController,
                decoration: const InputDecoration(
                  labelText: 'Enter UserHandle',
                  border: OutlineInputBorder(),
                ),
              ),
            )),
        StepButton(
          "LOGIN WITH USERNAME",
          onTap: userHandleController.text.isNotEmpty
              ? () {
                  onLogin(context);
                }
              : null,
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

  onLogin(BuildContext context) async {
    User? user;
    try {
      user = await widget.passkeyService.authenticate(userHandleController.text);

      if (user != null) {
        setState(() {
          Provider.of<IdentityState>(context, listen: false).setUser(user!);
          output = StepOutput(
              timestamp: DateTime.now(),
              output: "${user.userHandle} Successfully Logged In.",
              successful: true);
          StepStateApi.onSuccess(context);
          NotificationUtils.notify(
              context, "Registered with username - ${user.userHandle}");
        });
      } else {
        output = StepOutput(
            successful: false,
            timestamp: DateTime.now(),
            output: "Error Authenticating User.");
      }
    } catch (e) {
      output = StepOutput(
          successful: false, timestamp: DateTime.now(), output: e.toString());
      return;
    }
    setState(() {
      isWaiting = false;
    });
  }
}
