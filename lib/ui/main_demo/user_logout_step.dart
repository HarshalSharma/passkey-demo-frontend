import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/app_state.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/notification.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/step_widgets.dart';
import 'package:provider/provider.dart';

class UserLogoutStep extends StatefulWidget {
  const UserLogoutStep({super.key});

  @override
  State<UserLogoutStep> createState() => _UserLogoutStepState();
}

class _UserLogoutStepState extends State<UserLogoutStep> {
  @override
  Widget build(BuildContext context) {
    return BasicStep(
        title: "Logout",
        description:
            "This would make the frontend forget the user completely, No Cookies !",
    children: [
      StepButton("LOGOUT", onTap: logout)
    ],);
  }

  logout() {
    setState(() {
      Provider.of<IdentityState>(context, listen: false).clearState();
      Provider.of<DemoEventBus>(context, listen: false).fireEvent(DemoEvent.reset);
      StepStateApi.onSuccess(context);
      NotificationUtils.notify(context, "Logged out the current user.");
    });
  }
}
