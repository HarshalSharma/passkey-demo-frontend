import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/app_state.dart';
import 'package:passkey_demo_frontend/location_service.dart';
import 'package:passkey_demo_frontend/passkey/user.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';
import 'package:passkey_demo_frontend/server/api/preferences_api.dart';
import 'package:passkey_demo_frontend/server/models/preferences.dart';
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

  @override
  Widget build(BuildContext context) {
    return BasicStep(
      title: "Test Location Fetch",
      description:
          "latitude: ${location?.latitude}, longitude: ${location?.longitude}",
      children: [
        StepButton("Read Location", onTap: () async {
          User? user = Provider.of<IdentityState>(context, listen: false).user;
          Location? location =
              await widget.locationService.requestCurrentLocation();
          if (user != null && user.token != null) {
            await widget.preferencesAPI.preferencesPut(
                user.token!,
                Preferences(
                    homeLat: location!.latitude, homeLog: location!.longitude));
          }
          setState(() {
            this.location = location;
          });
        })
      ],
    );
  }
}
