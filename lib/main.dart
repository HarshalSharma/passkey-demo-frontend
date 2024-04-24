import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/app_constants.dart';
import 'package:passkey_demo_frontend/passkey/passkey_orchestrator.dart';
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
  ], child: const RootWidget()));
}

class RootWidget extends StatefulWidget {
  const RootWidget({super.key});

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  @override
  Widget build(BuildContext context) {
    var webauthnServer = WebauthnServer(context);
    final passkeyService = PasskeyOrchestrator(webauthnAPI: webauthnServer);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seamless Authentication Suite Demo',
      theme: AppConstants.theme,
      home: Scaffold(
          appBar: AppBar(
            title: Text(
              "Seamless Authentication Suite Demo",
              style: AppConstants.textTheme.titleLarge,
              softWrap: true,
              maxLines: 2,
            ),
            leading: const Icon(Icons.vpn_key),
            backgroundColor: Colors.white,
            foregroundColor: AppConstants.theme.colorScheme.secondary,
          ),
          body: LayoutBuilder(builder: (context, constraints) {
            var homePage = HomePage(
                webauthnServer: webauthnServer, passkeyService: passkeyService);
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
    required this.webauthnServer,
    required this.passkeyService,
  });

  final WebauthnServer webauthnServer;
  final PasskeyOrchestrator passkeyService;

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
            SetupBackendWidget(webauthnServer: webauthnServer),
            const Divider(
              height: 10,
              thickness: 1,
              color: Colors.grey,
              indent: 20,
              endIndent: 20,
            ),
            const SizedBox(height: 50,),
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
              passkeyService: passkeyService,
            ),
            const Divider(
              height: 10,
              thickness: 1,
              color: Colors.grey,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "2024 \n Developed by Harshal Sharma \n (er.harshalsharma@gmail.com) \n"
                    "Masters in Software Engineering \n BIRLA INSTITUTE OF TECHNOLOGY & SCIENCE, PILANI",
                    textAlign: TextAlign.center,
                    style: AppConstants.textTheme.bodySmall,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
