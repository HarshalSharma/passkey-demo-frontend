import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';
import 'package:passkey_demo_frontend/ui/main_demo/authn_by_location_step.dart';
import 'package:passkey_demo_frontend/ui/main_demo/home_location_update_step.dart';
import 'package:passkey_demo_frontend/ui/main_demo/notes_editor_step.dart';
import 'package:passkey_demo_frontend/ui/main_demo/user_logout_step.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/step_widgets.dart';

import 'authn_by_userhandle_step.dart';
import 'register_step.dart';

class MainDemoSteps {
  PasskeyService passkeyService;

  MainDemoSteps(this.passkeyService);

  List<DemoStep> create() {
    List<DemoStep> steps = [];

    steps.add(DemoStep(
        title: "CREATE NEW REGISTRATION",
        widget: RegisterStepWidget(
          passkeyService: passkeyService,
        ),
        isEnabled: true));
    steps.add(DemoStep(
        title: "LOGIN WITH USERNAME",
        widget: AuthNByUserHandleStepWidget(
          passkeyService: passkeyService,
        ),
        isEnabled: true));
    steps.add(DemoStep(
        title: "USER USES SECURE APIS",
        widget: NotesEditorStepWidget(
          passkeyService: passkeyService,
        ),

        //TODO: remove
        isEnabled: true));
    steps.add(DemoStep(
        title: "USER MARKS HOME LOCATION",
        widget: HomeLocationUpdateStepWidget(
          passkeyService: passkeyService,
        ),

        //TODO: remove
        isEnabled: true));
    steps.add(DemoStep(
        title: "USER LOGOUT",
        widget: const UserLogoutStep(),

        //TODO: remove
        isEnabled: true));
    steps.add(DemoStep(
        title: "USER LOGIN AT HOME (ANY PREFERRED LOCATION)",
        widget: AuthNByLocationStepWidget(
          passkeyService: passkeyService,
        ),
        isEnabled: true));
    steps.add(DemoStep(
        title: "USER USES SECURE APIS",
        widget: NotesEditorStepWidget(
          passkeyService: passkeyService,
        ),

        //TODO: remove
        isEnabled: true));
    return steps;
  }
}

class DemoStep {
  String title;
  Widget widget;
  bool isEnabled;

  DemoStep({required this.title, required this.widget, this.isEnabled = false});
}

class TestStepWidget extends StatelessWidget {
  const TestStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BasicStep(
      title: "Test Step",
      description: "You can mark it done.",
      children: [
        StepButton("DONE", onTap: () {
          markItDone(context);
        })
      ],
    );
  }

  markItDone(BuildContext context) {
    context.findAncestorWidgetOfExactType<StepBodyWidget>()?.onSuccess();
  }
}
