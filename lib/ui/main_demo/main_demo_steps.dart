import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';

import 'register_step.dart';

class MainDemoSteps {
  PasskeyService passkeyService;

  MainDemoSteps(this.passkeyService);

  List<DemoStep> create() {
    List<DemoStep> steps = [];
    steps.add(DemoStep(
        "CREATE NEW REGISTRATION",
        RegisterStepWidget(
          passkeyService: passkeyService,
        ),
        true));
    return steps;
  }
}

class DemoStep {
  String title;
  Widget widget;
  bool isEnabled;

  DemoStep(this.title, this.widget, this.isEnabled);
}
