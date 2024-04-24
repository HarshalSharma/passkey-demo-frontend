import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/notification.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/step_widgets.dart';

import 'register_step.dart';

class MainDemoSteps {
  PasskeyService passkeyService;

  MainDemoSteps(this.passkeyService);

  List<DemoStep> create() {
    List<DemoStep> steps = [];
    // steps.add(DemoStep(
    //     title: "CREATE NEW REGISTRATION",
    //     widget: RegisterStepWidget(
    //       passkeyService: passkeyService,
    //     ),
    //     isEnabled: true));
    steps.add(DemoStep(
        title: "CREATE NEW REGISTRATION",
        widget: TestStepWidget(),
        isEnabled: true));
    steps.add(DemoStep(
      title: "LOGIN WITH USERNAME",
      widget: const TestStepWidget(),
    ));
    steps.add(DemoStep(
      title: "USER USES APIS",
      widget: const TestStepWidget(),
    ));
    steps.add(DemoStep(
      title: "USER UPDATES HOME LOCATION",
      widget: const TestStepWidget(),
    ));
    steps.add(DemoStep(
      title: "USER LOGOUT",
      widget: const TestStepWidget(),
    ));
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
