import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/app_state.dart';
import 'package:passkey_demo_frontend/location_service.dart';
import 'package:passkey_demo_frontend/passkey/user.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/loading_widget.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/step_widgets.dart';
import 'package:provider/provider.dart';

class AuthNByLocationStepWidget extends StatefulWidget {
  final PasskeyService passkeyService;
  final LocationService locationService;

  const AuthNByLocationStepWidget(
      {super.key, required this.passkeyService, required this.locationService});

  @override
  State<AuthNByLocationStepWidget> createState() =>
      _AuthNByLocationStepWidgetState();
}

class _AuthNByLocationStepWidgetState extends State<AuthNByLocationStepWidget> {
  var isLoading = false;
  StepOutput? output;


  @override
  void initState() {
    super.initState();
    Provider.of<DemoEventBus>(context, listen: false).events.listen((event) {
      if(event == DemoEvent.reset) {
        setState(() {
          output = null;
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasicStep(
        title: "Login user at their home !",
        description: "After user has configured their preferred location,\n"
            "backend server can lookup all the credentials for that location, \n"
            "it may have some credentials from other users at this location too, however,\n"
            "which credential can be used and user can authenticate against it, depends on the individual device or security key.\n\n"
            "Even With this, we are still doing MFA complaint login, by User Presence verification with passkeys fingerprint/iris/faceid logins.",
        children: [
          StepButton("LOGIN AT HOME", onTap: loginWithLocation),
          if (isLoading) const Loading(),
          if (output != null) StepOutputWidget(stepOutput: output!)
        ]);
  }

  loginWithLocation() async {
    setState(() {
      isLoading = true;
    });
    //validate location is available.
    Location? location = await widget.locationService.requestCurrentLocation();
    if (location == null) {
      setState(() {
        isLoading = false;
        output = StepOutput(
            timestamp: DateTime.now(),
            output:
                "Unable to get location, Please grant location permission to proceed.");
      });
      return;
    }

    //validate if authentication is successful.
    User? user;
    try {
      user = await widget.passkeyService.autoAuthenticate(location);
    } catch (e) {
      var msg =
          "Error logging-in the user, please verify the server configuration.\n"
          "Error details- $e";
      if (e is ServiceValidationException) {
        msg = e.toString();
      }
      setState(() {
        isLoading = false;
        output = StepOutput(timestamp: DateTime.now(), output: msg);
      });
      return;
    }
    if (user == null || user.token == null) {
      setState(() {
        isLoading = false;
        output = StepOutput(
            timestamp: DateTime.now(), output: "Failed to login the user.");
      });
      return;
    }

    //success
    setState(() {
      isLoading = false;
      output = StepOutput(
          successful: true,
          timestamp: DateTime.now(),
          output: "User ${user?.userHandle} Successfully logged In.");
      StepStateApi.onSuccess(context);
    });
  }
}
