import 'package:flutter/cupertino.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';

import 'register_step.dart';
import 'stepper_step.dart';

class FullDemoSteps {
  final PasskeyService passkeyService;
  List<StepperStep> steps = [];
  List<bool> completed = [];
  List<bool> enabled = [];


  FullDemoSteps({required this.passkeyService});

  void setup() {
    steps.clear();

    addStep(
        stepEnabled: true,
        title: "CREATE NEW REGISTRATION",
        child: RegisterStepWidget(
          passkeyService: passkeyService,
          onResult: (output) {
            if (output.successful == true) {
              onComplete(0);
            }
          },
        ));
    addStep(title: "LOGIN WITH USERNAME");
  }

  void addStep(
      {required String title, bool stepEnabled = false, Widget? child}) {
    enabled.add(stepEnabled);
    completed.add(false);
    steps.add(StepperStep(steps.length,
        titleText: title,
        onComplete: onComplete,
        isEnabled: stepEnabled,
        isPrevStepCompleted: steps.isEmpty ? true : completed[steps.length - 1],
        child: child));
  }

  void onComplete(int index) {
    completed[index] = true;
  }
}
