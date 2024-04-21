import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passkey_demo_frontend/app_constants.dart';
import 'package:passkey_demo_frontend/passkey/passkey_orchestrator.dart';
import 'package:passkey_demo_frontend/server/WebauthnServer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'app_state.dart';
import 'ui/setup_backend_widgets.dart';
import 'ui/simple_demo/simple_demo.dart';

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
    final passkeyService =
        PasskeyOrchestrator(webauthnAPI: webauthnServer);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Passkey Demo',
      theme: AppConstants.theme,
      home: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text(
                  "Passkey Demo",
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            foregroundColor: AppConstants.theme.colorScheme.secondary,
            actions: [
              if (context.watch<IdentityState>().user != null)
                IconButton(
                  onPressed: resetUser,
                  icon: Icon(
                    Icons.lock_reset,
                    color: AppConstants.theme.colorScheme.primary,
                  ),
                  tooltip: "LOGOUT",
                )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text.rich(TextSpan(
                      text:
                          "Backend server needs to be running on the docker within your network to be able to use this tool. \n\n"
                          "Complete source code is available online at - ",
                      children: [
                        TextSpan(
                          text: "https://github.com/HarshalSharma/passkey-demo",
                          style: TextStyle(
                              color: AppConstants.theme.colorScheme.secondary),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              const url =
                                  'https://github.com/HarshalSharma/passkey-demo';
                              if (await canLaunchUrlString(url)) {
                                await launchUrlString(url);
                              }
                            },
                        )
                      ],
                      // "  docker run -p 8080:8080 harshalworks/passkey-demo-harshalsharma:v1",
                      style: GoogleFonts.roboto(fontSize: 14),
                    )),
                  ),
                  SetupBackendWidget(webauthnServer: webauthnServer),
                  const Divider(
                    height: 10,
                    thickness: 1,
                    color: Colors.grey,
                    indent: 20,
                    endIndent: 20,
                  ),
                  SimpleDemo(
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
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "2024 | Developed by Harshal Sharma (er.harshalsharma@gmail.com) \n"
                          "Masters in Software Engineering | BIRLA INSTITUTE OF TECHNOLOGY & SCIENCE, PILANI",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  void resetUser() {
    Provider.of<IdentityState>(context, listen: false).clearState();
  }
}
