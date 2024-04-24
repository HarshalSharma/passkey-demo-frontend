import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/app_state.dart';
import 'package:passkey_demo_frontend/location_service.dart';
import 'package:passkey_demo_frontend/passkey/user.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';
import 'package:passkey_demo_frontend/server/api/preferences_api.dart';
import 'package:passkey_demo_frontend/server/models/preferences.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/loading_widget.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/step_widgets.dart';
import 'package:provider/provider.dart';

class HomeLocationUpdateStepWidget extends StatefulWidget {
  final UserPreferencesAPI preferencesAPI;
  final PasskeyService passkeyService;
  final LocationService locationService;

  const HomeLocationUpdateStepWidget(
      {super.key,
      required this.preferencesAPI,
      required this.passkeyService,
      required this.locationService});

  @override
  State<HomeLocationUpdateStepWidget> createState() =>
      _HomeLocationUpdateStepWidgetState();
}

class _HomeLocationUpdateStepWidgetState
    extends State<HomeLocationUpdateStepWidget> {
  Location? location;
  bool isLoading = false;
  StepOutput? output;

  @override
  Widget build(BuildContext context) {
    return Consumer<IdentityState>(
        builder: (BuildContext context, IdentityState value, Widget? child) {
      User? user = value.user;
      if (user != null && user.token != null) {
        return BasicStep(
            title: "Update Preferred Location To Auto-Login",
            description:
                "Update the home location where the user feels safe and would like to login without username or password.\n"
                "Just like we don't always carry passport inside our state, but can be identified, \n"
                "similarly, 'Where you are' could be taken as one of the Authentication factors.\n\n\n"
                "User ${user.userHandle} will be able to login without providing their username again in this location.",
            children: [
              StepButton("Update Home Location", onTap: updateLocation),
              if (isLoading) const Loading(),
              if (output != null) StepOutputWidget(stepOutput: output!)
            ]);
      }
      return StepOutputWidget(
          stepOutput: StepOutput(
              timestamp: DateTime.now(), output: "User is not logged In."));
    });
  }

  updateLocation() async {
    setState(() {
      isLoading = true;
    });
    //validate user is logged in.
    User? user = Provider.of<IdentityState>(context, listen: false).user;
    if (user == null || user.token == null) {
      setState(() {
        isLoading = false;
        output = StepOutput(
            timestamp: DateTime.now(), output: "User is not logged In.");
      });
      return;
    }
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

    //update location on the server
    try {
      await widget.preferencesAPI.preferencesPut(user.token!,
          Preferences(homeLat: location.latitude, homeLog: location.longitude));
    } catch (e) {
      var msg = "Error updating location on the server, check server config.";
      if (e is ServiceValidationException) {
        msg = e.toString();
      }
      setState(() {
        isLoading = false;
        output = StepOutput(timestamp: DateTime.now(), output: msg);
      });
      return;
    }

    //success
    setState(() {
      this.location = location;
      isLoading = false;
      output = StepOutput(
          successful: true,
          timestamp: DateTime.now(),
          output: "Updated home location at latitude: ${location.latitude}, "
              "longitude: ${location.longitude} for the user ${user.userHandle}");
      StepStateApi.onSuccess(context);
    });
  }
}
