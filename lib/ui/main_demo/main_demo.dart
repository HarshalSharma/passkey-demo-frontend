import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passkey_demo_frontend/app_constants.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';
import 'package:passkey_demo_frontend/ui/main_demo/main_demo_steps.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/step_widgets.dart';

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
  List<Step> stepperSteps = [];

  @override
  void initState() {
    super.initState();
    createSteps();
  }

  void reset() {
    setState(() {
      enabledSteps.clear();
      completedSteps.clear();
      stepperSteps.clear();
      createSteps();
      _currentStep = 0;
    });
  }

  void createSteps() {
    var mainDemoSteps = MainDemoSteps(widget.passkeyService);
    List<DemoStep> steps = mainDemoSteps.create();
    for (int i = 0; i < steps.length; i++) {
      stepperSteps.add(buildStep(i, steps[i].title, steps[i].widget,
          getState: getStepState, isActive: isActive, onComplete: onComplete));
      enabledSteps.add(steps[i].isEnabled);
      completedSteps.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(
      physics: const ClampingScrollPhysics(),
      currentStep: _currentStep,
      controlsBuilder: (context, _) {
        return Row(
          children: <Widget>[
            TextButton(
                onPressed: completedSteps[_currentStep] ? onStepContinue : null,
                child: Text(
                  "continue",
                  style: GoogleFonts.roboto(
                      fontSize: 16,
                      color:
                          completedSteps[_currentStep] ? Colors.green : null),
                ))
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
      // steps: <Step>[
      //   buildRegistrationStep(
      //       0,
      //       "CREATE NEW REGISTRATION",
      //       RegisterStepWidget(
      //         passkeyService: widget.passkeyService,
      //       ),
      //       getState: getStepState,
      //       isActive: isActive,
      //       onComplete: onComplete),
      //   Step(
      //     title: Text(
      //       "AUTHENTICATION (with username)",
      //       style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
      //     ),
      //     state: completedSteps[1] ? StepState.complete : StepState.indexed,
      //     isActive: completedSteps[0] || enabledSteps[1],
      //     content: Padding(
      //       padding: const EdgeInsets.only(top: 24.0, bottom: 24),
      //       child: Align(
      //         alignment: Alignment.topLeft,
      //         child: AuthNByUserHandleStepWidget(
      //           passkeyService: widget.passkeyService,
      //           onResult: (output) {
      //             if (output.successful == true) {
      //               completedSteps[0] = true;
      //             }
      //           },
      //         ),
      //       ),
      //     ),
      //   ),
      //   Step(
      //     title: Text(
      //       "ACCESS NOTES",
      //       style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
      //     ),
      //     state: completedSteps[2] ? StepState.complete : StepState.indexed,
      //     isActive: completedSteps[1] || enabledSteps[2],
      //     content: BasicStep(
      //       title: "Login with UserName and Passkey",
      //       description:
      //           "User would need to provide a UserName/UserHandle, using which passkey LOGIN could be triggered to securely enter into the system.",
      //       children: [
      //         StepButton(
      //           "LOGIN WITH USERNAME",
      //           onTap: () {},
      //         )
      //       ],
      //     ),
      //   ),
      //   Step(
      //     title: Text(
      //       "LOGOUT",
      //       style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
      //     ),
      //     state: completedSteps[3] ? StepState.complete : StepState.indexed,
      //     isActive: completedSteps[2] || enabledSteps[3],
      //     content: BasicStep(
      //       title: "Login with UserName and Passkey",
      //       description:
      //           "User would need to provide a UserName/UserHandle, using which passkey LOGIN could be triggered to securely enter into the system.",
      //       children: [
      //         StepButton(
      //           "LOGIN WITH USERNAME",
      //           onTap: () {},
      //         )
      //       ],
      //     ),
      //   ),
      //   Step(
      //     title: Text(
      //       "AUTHENTICATION (at User's home)",
      //       style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
      //     ),
      //     state: completedSteps[4] ? StepState.complete : StepState.indexed,
      //     isActive: completedSteps[3] || enabledSteps[4],
      //     content: Align(
      //       alignment: Alignment.topLeft,
      //       child: BasicStep(
      //         title: "Login at User's home location with Passkey",
      //         description:
      //             "UserHandle/UserName could be identified using cookies, location, or other techniques like fingerprinting. \n"
      //             "User Home Location or cookies help identify the possible UserHandle/UserName without uniquely identifying the user. \n"
      //             "We only need to ensure that one of the identified credentials can trigger passkey login securely.",
      //         children: [
      //           StepButton("LOGIN WITH PASSKEY AT HOME", onTap: () {
      //             if (step2.successful == null) {
      //               setState(() {
      //                 step2.successful = true;
      //                 step2.output = "It worked";
      //                 step2.timestamp = DateTime.now();
      //               });
      //             } else {
      //               setState(() {
      //                 step2.successful = null;
      //                 step2.output = null;
      //                 step2.timestamp = null;
      //               });
      //             }
      //           }),
      //           StepOutputWidget(
      //             stepOutput: step2,
      //           )
      //         ],
      //       ),
      //     ),
      //   ),
      //   Step(
      //     title: Text(
      //       "ACCESS NOTES",
      //       style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
      //     ),
      //     state: completedSteps[5] ? StepState.complete : StepState.indexed,
      //     isActive: enabledSteps[5] || completedSteps[4],
      //     content: BasicStep(
      //       title: "Login with UserName and Passkey",
      //       description:
      //           "User would need to provide a UserName/UserHandle, using which passkey LOGIN could be triggered to securely enter into the system.",
      //       children: [
      //         StepButton(
      //           "LOGIN WITH USERNAME",
      //           onTap: () {},
      //         )
      //       ],
      //     ),
      //   ),
      //   Step(
      //     title: Text(
      //       "LOGOUT",
      //       style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
      //     ),
      //     state: completedSteps[6] ? StepState.complete : StepState.indexed,
      //     isActive: completedSteps[5] || enabledSteps[6],
      //     content: BasicStep(
      //       title: "Login with UserName and Passkey",
      //       description:
      //           "User would need to provide a UserName/UserHandle, using which passkey LOGIN could be triggered to securely enter into the system.",
      //       children: [
      //         StepButton(
      //           "LOGIN WITH USERNAME",
      //           onTap: () {},
      //         )
      //       ],
      //     ),
      //   ),
      // ]
    );
  }

  Step buildStep(int index, String title, Widget child,
      {required Function(int index) getState,
      required Function(int index) isActive,
      required Function(int index) onComplete}) {
    return Step(
        title: Text(title, style: AppConstants.textTheme.titleMedium),
        state: getState(index),
        isActive: isActive(index),
        content: Padding(
          padding: const EdgeInsets.only(top: 24.0, bottom: 24),
          child: Align(
            alignment: Alignment.topLeft,
            child: StepBodyWidget(
                onSuccess: () {
                  onComplete(index);
                },
                child: child),
          ),
        ));
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
