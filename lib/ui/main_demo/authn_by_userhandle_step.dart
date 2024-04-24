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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    userHandleController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BasicStep(
      title: "Login with just your Username !",
      description:
          "Enter your registered username below and click LOGIN to proceed using passkey to access the services.",
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<IdentityState>(
              builder:
                  (BuildContext context, IdentityState value, Widget? child) {
                User? user = value.user;
                if (user != null) {
                  userHandleController.text = user.userHandle;
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
          onTap: onLogin,
        ),
        if (output != null) StepOutputWidget(stepOutput: output!),
        if (isLoading == true)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Loading(),
          )
      ],
    );
  }

  onLogin() async {
    if (userHandleController.text.isEmpty) {
      NotificationUtils.notify(context, "Please enter a username !");
      return;
    }

    setState(() {
      isLoading = true;
    });
    User? user;

    //try to login the user
    try {
      user =
          await widget.passkeyService.authenticate(userHandleController.text);
    } catch (e) {
      setState(() {
        isLoading = false;
        output = StepOutput(
            successful: false,
            timestamp: DateTime.now(),
            output:
                "Error logging-in the user, please verify the server configuration.\n"
                "Error details- $e");
      });
      return;
    }

    //if user is not present
    if (user == null) {
      setState(() {
        isLoading = false;
        output = StepOutput(
            successful: false,
            timestamp: DateTime.now(),
            output: "Error Authenticating User.");
      });
      return;
    }

    setState(() {
      isLoading = false;
      Provider.of<IdentityState>(context, listen: false).setUser(user!);
      output = StepOutput(
          timestamp: DateTime.now(),
          output: "${user.userHandle} Successfully Logged In.",
          successful: true);
      StepStateApi.onSuccess(context);
      NotificationUtils.notify(
          context, "Successfully logged in as - ${user.userHandle}");
    });
  }
}
