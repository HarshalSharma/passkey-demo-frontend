import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/app_constants.dart';
import 'package:passkey_demo_frontend/passkey/user.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/loading_widget.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/notification.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/step_widgets.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';

class RegisterStepWidget extends StatefulWidget {
  final PasskeyService passkeyService;

  const RegisterStepWidget(
      {super.key, required this.passkeyService});

  @override
  State<RegisterStepWidget> createState() => _RegisterStepWidgetState();
}

class _RegisterStepWidgetState extends State<RegisterStepWidget> {
  StepOutput? output;
  var isWaiting = false;
  User? user;

  @override
  Widget build(BuildContext context) {
    return BasicStep(
      title: "Enroll new Credential.",
      description:
          "First, User would need to create an account / register a new passkey credential. \nAn username would be auto provided after this step.",
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
        if (user != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SelectableText(
              "A UserHandle is generated in the output: ${user?.userHandle}",
              style: AppConstants.textTheme.labelLarge,
            ),
          ),
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
          context.findAncestorWidgetOfExactType<StepBodyWidget>()?.onSuccess();
          this.user = user;
          NotificationUtils.notify(
              context, "Registered with username - ${user.userHandle}");
        });
      } else {
        output = StepOutput(
            successful: false,
            timestamp: DateTime.now(),
            output:
                "Error Registering, please check backend service configuration.");
      }
    } catch (e) {
      exception = e.toString();
      output = StepOutput(
          successful: false, timestamp: DateTime.now(), output: exception);
    }
    setState(() {
      isWaiting = false;
    });
  }
}
