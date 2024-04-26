import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/app_constants.dart';
import 'package:passkey_demo_frontend/location_service.dart';
import 'package:passkey_demo_frontend/native/default_location_service.dart';
import 'package:passkey_demo_frontend/passkey/passkey_orchestrator.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';
import 'package:passkey_demo_frontend/remote_services.dart';
import 'package:passkey_demo_frontend/server/WebauthnServer.dart';
import 'package:passkey_demo_frontend/ui/main_demo/main_demo.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/step_widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'app_state.dart';
import 'ui/setup_backend_widgets.dart';
import 'ui/utility_widgets/code_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => IdentityState()),
    ChangeNotifierProvider(create: (_) => ServerState()),
    ChangeNotifierProvider(create: (_) => DemoEventBus()),
  ], child: const RootWidget()));
}

class RootWidget extends StatefulWidget {
  const RootWidget({super.key});

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  late final WebauthnServer webauthnServer;
  late final LocationService locationService;
  late final PasskeyService passkeyService;
  late final RemoteServices remoteServices;

  @override
  void initState() {
    super.initState();
    webauthnServer = WebauthnServer(context);
    remoteServices = RemoteServices(webauthnServer);
    passkeyService = PasskeyOrchestrator(webauthnAPI: webauthnServer);
    locationService = DefaultLocationService();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seamless Authentication Suite Demo',
      theme: AppConstants.theme,
      home: Scaffold(
          appBar: AppBar(
            title: Text(
              "Seamless Authentication Suite Demo",
              style: screenSize.width > 500
                  ? AppConstants.textTheme.titleLarge
                  : AppConstants.textTheme.titleSmall,
            ),
            leading: const Icon(Icons.vpn_key),
            backgroundColor: Colors.white,
            foregroundColor: AppConstants.theme.colorScheme.secondary,
          ),
          body: LayoutBuilder(builder: (context, constraints) {
            var homePage = HomePage(
              remoteServices: remoteServices,
              passkeyService: passkeyService,
              locationService: locationService,
            );
            double maxWidth = 1024;
            if (constraints.maxWidth > maxWidth) {
              return Center(
                child: SizedBox(
                  width: maxWidth,
                  child: homePage,
                ),
              );
            }
            return homePage;
          })),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.remoteServices,
    required this.passkeyService,
    required this.locationService,
  });

  final RemoteServices remoteServices;
  final PasskeyService passkeyService;
  final LocationService locationService;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Demo Objectives:",
                style: AppConstants.textTheme.titleMedium,
              ),
            ),
            const NumberedStep(
                number: "1.",
                title:
                    "To showcase functional E2E Webauthn Password-less Authentication."),
            const NumberedStep(
                number: "2.",
                title:
                    "To offer a suite to the community for seamless integration of password-less authentication workflows."),
            const NumberedStep(
                number: "3.",
                title:
                    "To affirm that WebAuthn authentication doesn't require precise user identification prior to authentication,\n"
                    "By demonstrating login at their home location."),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Open-Source Suite Offerings:",
                style: AppConstants.textTheme.titleMedium,
              ),
            ),
            NumberedStep(
              number: "1.",
              title:
                  "An Open-Source WebAuthn Java library to do all required backend Webauthn operations.\n"
                  "This includes parsing encoded attestationObjects, public-keys etc.",
              children: [
                Text.rich(TextSpan(
                  text: "https://github.com/HarshalSharma/webauthn-commons/",
                  style: AppConstants.textTheme.bodyMedium?.copyWith(
                      color: AppConstants.theme.colorScheme.secondary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      const url =
                          'https://github.com/HarshalSharma/webauthn-commons/';
                      if (await canLaunchUrlString(url)) {
                        await launchUrlString(url);
                      }
                    },
                ))
              ],
            ),
            NumberedStep(
              number: "2.",
              title:
                  "An Open-Source Dockerized Spring Boot Service to quickly deploy WebAuthn Backends.\n"
                  "The backend service code is available at below Github link:",
              children: [
                Text.rich(TextSpan(
                  text: "https://github.com/HarshalSharma/passkey-demo",
                  style: AppConstants.textTheme.bodyMedium?.copyWith(
                      color: AppConstants.theme.colorScheme.secondary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      const url =
                          'https://github.com/HarshalSharma/passkey-demo';
                      if (await canLaunchUrlString(url)) {
                        await launchUrlString(url);
                      }
                    },
                )),
                Text(
                  "and is also available for quick docker deployment with the below command:",
                  style: AppConstants.textTheme.bodyMedium,
                ),
                const CodeWidget(
                    "docker run -p 8080:8080 harshalworks/passkey-demo-harshalsharma:v1"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Pre-Demo Guidelines:",
                style: AppConstants.textTheme.titleMedium,
              ),
            ),
            const NumberedStep(
                title:
                    "This demo can also be configured to use a self-hosted backend server.\nUse the docker command shared above,"
                    " and Start the docker container. \nConfigure the server and port details below, for example host: http://localhost and port:8080"
                    "\nNote that this is not required when Default Server is online."),
            SetupBackendWidget(remoteServices: remoteServices),
            const Divider(
              height: 10,
              thickness: 1,
              color: Colors.grey,
              indent: 20,
              endIndent: 20,
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "THE DEMO:",
                style: AppConstants.textTheme.titleLarge,
              ),
            ),
            const NumberedStep(
                title:
                    "Flow could be started from any of the active steps i.e. \n"
                    "Step 1 - From first time Registration, \n"
                    "Step 2 - From authentication with known username, or \n"
                    "Step 6 - From authentication at preferred location after configuration."),
            MainDemo(
                remoteServices: remoteServices,
                passkeyService: passkeyService,
                locationService: locationService),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "CONCLUSION:",
                style: AppConstants.textTheme.titleLarge,
              ),
            ),
            const NumberedStep(
                title:
                    "It is demonstrated that the need to securely identify users to give access to their data can be easily full-filled with passkeys, without communicating with any third party services. "
                    "\nThe User's of the websites/app also need not remember any new password to access their accounts and data securely on apps/websites that uses passkeys."
                    "\n\nWe experimented to improve upon the current frictions of using passkeys, one of which is that users need to provide their username or email, Or the system has to use stored information from cookies to identify who is trying to login."),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(TextSpan(children: [
                TextSpan(
                  text: "What was Made: ",
                  style: AppConstants.textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "We created an open-source library and a deployable Docker container. Any new website or app can use these tools to let users sign in with passkeys easily.",
                  style: AppConstants.textTheme.bodyMedium,
                ),
              ])),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(TextSpan(children: [
                TextSpan(
                  text: "What is Learned: ",
                  style: AppConstants.textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "We found out that it's possible to identify and let users sign in without needing usernames or cookies, just by knowing their current location. But this method has limitations, it may need other supporting factors and needs study.",
                  style: AppConstants.textTheme.bodyMedium,
                ),
              ])),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(TextSpan(children: [
                TextSpan(
                  text: "Good Things About Passkey Authentication: ",
                  style: AppConstants.textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "Users can create and access their accounts data on any website/apps without needing to remember any passwords or giving many details.",
                  style: AppConstants.textTheme.bodyMedium,
                ),
              ])),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Pros and Cons of Using Home Location:",
                style: AppConstants.textTheme.bodyLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Good Points:",
                style: AppConstants.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const NumberedStep(
              number: "1",
              title:
                  "Users can easily sign in from home without needing usernames or passwords.",
            ),
            const NumberedStep(
              number: "2",
              title:
                  "Very useful for elderly who don't remember any of their account names or passwords.",
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Not-So-Good Points:",
                style: AppConstants.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const NumberedStep(
              number: "1",
              title:
                  "You can only use this feature at home, not when you're away.",
            ),
            const NumberedStep(
              number: "2",
              title:
                  "It might be slower in busy places with lots of people. example a tall flat buildings where many people have the same location.",
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Other Ideas:",
                style: AppConstants.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const NumberedStep(
                title:
                    "Instead of using location, we could try something called device fingerprinting to solve the problems we found. But that comes with its own privacy and debate-able issues."),
            const SizedBox(
              height: 50,
            ),
            const Divider(
              height: 10,
              thickness: 1,
              color: Colors.grey,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  "Thank you",
                  textAlign: TextAlign.center,
                  style: AppConstants.textTheme.titleLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  "2024 \n Developed by Harshal Sharma \n (er.harshalsharma@gmail.com) \n"
                  "Masters in Software Engineering \n BIRLA INSTITUTE OF TECHNOLOGY & SCIENCE, PILANI",
                  style: AppConstants.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
