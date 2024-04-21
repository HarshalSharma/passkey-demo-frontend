import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/app_constants.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/step_widgets.dart';

import 'register_step.dart';

class SimpleDemo extends StatefulWidget {
  final PasskeyService passkeyService;

  const SimpleDemo({super.key, required this.passkeyService});

  @override
  State<SimpleDemo> createState() => _SimpleDemoState();
}

class _SimpleDemoState extends State<SimpleDemo> {
  int _currentStep = 0;
  int _maxSteps = 2;
  StepOutput step2 = StepOutput();

  @override
  Widget build(BuildContext context) {
    return Stepper(
        currentStep: _currentStep,
        // connectorColor: MaterialStatePropertyAll<Color>(
        //     AppConstants.theme.colorScheme.secondary),
        controlsBuilder: (context, _) {
          return const Row(
            children: <Widget>[],
          );
        },
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() {
              _currentStep += 1;
            });
          }
        },
        onStepTapped: (int index) {
          setState(() {
            _currentStep = index;
          });
        },
        steps: <Step>[
          Step(
              title: Text("Register New Passkey"),
              isActive: 0 <= _currentStep,
              content: Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 24),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: RegisterStepWidget(
                    passkeyService: widget.passkeyService,
                  ),
                ),
              )),
          Step(
              title: Text("Password-less ways to login."),
              isActive: 1 <= _currentStep,
              content: Text("Explained different ways to login...")),
          Step(
            title: Text("Login with UserName and Passkey"),
            isActive: 2 <= _currentStep,
            content: BasicStep(
              title: "Login with UserName and Passkey",
              description:
                  "User would need to provide a UserName/UserHandle, using which passkey LOGIN could be triggered to securely enter into the system.",
              children: [
                StepButton(
                  "LOGIN WITH USERNAME",
                  onTap: () {},
                )
              ],
            ),
          ),
          Step(
            title: Text("Login at User's home location with Passkey"),
            isActive: 3 <= _currentStep,
            state: StepState.indexed,
            content: Align(
              alignment: Alignment.topLeft,
              child: BasicStep(
                title: "Login at User's home location with Passkey",
                description:
                    "UserHandle/UserName could be identified using cookies, location, or other techniques like fingerprinting. \n"
                    "User Home Location or cookies help identify the possible UserHandle/UserName without uniquely identifying the user. \n"
                    "We only need to ensure that one of the identified credentials can trigger passkey login securely.",
                children: [
                  StepButton("LOGIN WITH PASSKEY AT HOME", onTap: () {
                    if (step2.successful == null) {
                      setState(() {
                        step2.successful = true;
                        step2.output = "It worked";
                        step2.timestamp = DateTime.now();
                      });
                    } else {
                      setState(() {
                        step2.successful = null;
                        step2.output = null;
                        step2.timestamp = null;
                      });
                    }
                  }),
                  StepOutputWidget(
                    stepOutput: step2,
                  )
                ],
              ),
            ),
          ),
        ]);

    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     RegisterStepWidget(
    //       passkeyService: widget.passkeyService,
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.only(top: 24.0, left: 24),
    //       child: Text(
    //         "Password-Less ways to Login :",
    //         style:
    //             GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 18),
    //       ),
    //     ),
    //     NumberedStep(
    //       number: "1.",
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
    //     NumberedStep(
    //       number: "2.",
    //       title: "Login at User's home location with Passkey",
    //       description:
    //           "UserHandle/UserName could be identified using cookies, location, or other techniques like fingerprinting. \n"
    //           "User Home Location or cookies help identify the possible UserHandle/UserName without uniquely identifying the user. \n"
    //           "We only need to ensure that one of the identified credentials can trigger passkey login securely.",
    //       children: [
    //         StepButton("LOGIN WITH PASSKEY AT HOME", onTap: () {
    //           if (step2.successful == null) {
    //             setState(() {
    //               step2.successful = true;
    //               step2.output = "It worked";
    //               var now = DateTime.now();
    //               step2.timestamp =
    //                   "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
    //             });
    //           } else {
    //             setState(() {
    //               step2.successful = null;
    //               step2.output = null;
    //               step2.timestamp = null;
    //             });
    //           }
    //         }),
    //         StepOutputWidget(
    //           stepOutput: step2,
    //         )
    //       ],
    //     ),
    //   ],
    // );
  }
}
