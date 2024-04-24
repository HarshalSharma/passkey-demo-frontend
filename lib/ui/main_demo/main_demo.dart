import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passkey_demo_frontend/app_constants.dart';
import 'package:passkey_demo_frontend/app_state.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';
import 'package:passkey_demo_frontend/ui/main_demo/main_demo_steps.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/notification.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/step_widgets.dart';
import 'package:provider/provider.dart';

class MainDemo extends StatefulWidget {
  final PasskeyService passkeyService;

  const MainDemo({super.key, required this.passkeyService});

  @override
  State<MainDemo> createState() => _MainDemoState();
}

class _MainDemoState extends State<MainDemo> {
  int _currentStep = 0;
  List<bool> enabledSteps = [];
  List<bool> completedSteps = [];

  late MainDemoSteps mainDemoSteps;
  late List<DemoStep> steps;

  @override
  void initState() {
    super.initState();
    mainDemoSteps = MainDemoSteps(widget.passkeyService);
    steps = mainDemoSteps.create();
    createSteps();
  }

  void reset() {
    setState(() {
      enabledSteps.clear();
      completedSteps.clear();
      _currentStep = 0;
      createSteps();
    });
    Provider.of<IdentityState>(context, listen: false).clearState();
    NotificationUtils.notify(context, "Reset Done, User Logged Out.");
  }

  void createSteps() {
    for (int i = 0; i < steps.length; i++) {
      enabledSteps.add(steps[i].isEnabled);
      completedSteps.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var stepperSteps = steps
        .asMap()
        .map((index, e) => MapEntry(
            index,
            buildStep(index, steps[index].title, steps[index].widget, context,
                getState: getStepState,
                isActive: isActive,
                onComplete: onComplete)))
        .values
        .toList();
    return Column(
      children: [
        Stepper(
          physics: const ClampingScrollPhysics(),
          currentStep: _currentStep,
          controlsBuilder: (context, _) {
            return Row(
              children: <Widget>[
                if (_currentStep < (stepperSteps.length - 1))
                  TextButton(
                      onPressed:
                          completedSteps[_currentStep] ? onStepContinue : null,
                      child: Text(
                        "continue",
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: completedSteps[_currentStep]
                                ? Colors.green
                                : null),
                      )),
                if (completedSteps[_currentStep] && _currentStep == completedSteps.length - 1)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("All Finished !", style: AppConstants.textTheme.bodySmall,),
                  )
              ],
            );
          },
          onStepContinue: onStepContinue,
          onStepTapped: (int index) {
            if (enabledSteps[index]) {
              setState(() {
                _currentStep = index;
              });
            }
          },
          steps: stepperSteps,
        ),
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
                onPressed: reset,
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.refresh,
                        color: AppConstants.theme.colorScheme.secondary,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Reset Demo",
                          style: AppConstants.textTheme.labelLarge,
                        ),
                      )
                    ],
                  ),
                )),
          ),
        )
      ],
    );
  }

  Step buildStep(int index, String title, Widget child, BuildContext context,
      {required Function(int index) getState,
      required Function(int index) isActive,
      required Function(int index) onComplete}) {
    return Step(
        title: Text(title, style: AppConstants.textTheme.titleMedium),
        state: getState(index),
        isActive: isActive(index),
        content: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 24),
            child: Align(
              alignment: Alignment.topLeft,
              child: StepBodyWidget(
                  onSuccess: () {
                    setState(() {
                      onComplete(index);
                    });
                  },
                  child: child),
            ),
          );
        }));
  }

  StepState getStepState(int index) {
    return completedSteps[index] ? StepState.complete : StepState.indexed;
  }

  bool isActive(int index) {
    if (index == 0) {
      return enabledSteps[index];
    }
    return completedSteps[index] || enabledSteps[index];
  }

  onComplete(int index) {
    completedSteps[index] = true;
  }

  void onStepContinue() {
    if (completedSteps[_currentStep]) {
      if (_currentStep < enabledSteps.length) {
        setState(() {
          _currentStep += 1;
        });
      }
    }
  }
}
