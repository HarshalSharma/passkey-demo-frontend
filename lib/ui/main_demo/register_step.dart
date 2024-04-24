import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/app_constants.dart';
import 'package:passkey_demo_frontend/passkey/user.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/code_widget.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/loading_widget.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/notification.dart';
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
  StepOutput? output;
  var isLoading = false;
  User? user;

  @override
  Widget build(BuildContext context) {
    return BasicStep(
      title: "Sign Up with just your device!",
      description:
          "User would need to create an account (register a new passkey credential) to proceed further with the demo.\n\n"
          "A random Username would be provided post Sign-Up.",
      children: [
        StepButton(
          "SIGN UP",
          onTap: onSignUp,
        ),
        if (output != null) StepOutputWidget(stepOutput: output!),
        if (user != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Click to copy your username - ",
              style: AppConstants.textTheme.bodyMedium,
            ),
          ),
        if (user != null)
          CodeWidget(
            "${user?.userHandle}",
          ),
        if (isLoading == true)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Loading(),
          )
      ],
    );
  }

  onSignUp() async {
    setState(() {
      output = null;
      isLoading = true;
    });

    //validate user signup is successful.
    User? user;
    try {
      user = await widget.passkeyService.enroll();
    } catch (e) {
      String msg =
          "Error connecting server, please check the server config.\n\n"
          "details - $e";
      if(e is ServiceValidationException) {
        msg = e.toString();
      }
      setState(() {
        isLoading = false;
        output = StepOutput(
            successful: false, timestamp: DateTime.now(), output: msg);
      });
      return;
    }

    // check if user is not empty.
    if (user == null) {
      output = StepOutput(
          successful: false,
          timestamp: DateTime.now(),
          output: "Error Registering the user. please try again.");
      return;
    }

    //success
    setState(() {
      Provider.of<IdentityState>(context, listen: false).setUser(user!);
      isLoading = false;
      output = StepOutput(
          timestamp: DateTime.now(),
          output: "Registered Credential with Generated User Name : ${user.userHandle}",
          successful: true);
      StepStateApi.onSuccess(context);
      this.user = user;
      NotificationUtils.notify(
          context, "Registered with username - ${user.userHandle}");
    });
  }
}
