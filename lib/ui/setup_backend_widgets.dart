import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passkey_demo_frontend/app_state.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../app_constants.dart';
import 'utility_widgets/loading_widget.dart';
import 'utility_widgets/step_widgets.dart';

class SetupBackendWidget extends StatelessWidget {
  const SetupBackendWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ExpansionTile(
          leading: Icon(Icons.settings),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "CONFIGURE DEMO SERVER",
              style:
                  GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          subtitle:
              Consumer<ServerState>(builder: (context, serverState, child) {
            return Text(
              "${serverState.serverOrigin}",
              style: GoogleFonts.roboto(fontSize: 14),
            );
          }),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          textColor: AppConstants.theme.colorScheme.secondary,
          expandedAlignment: Alignment.topLeft,
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
                  ),
                  const TextSpan(
                      text:
                          "\n\nJust simply run the command below to get started with the backend server:")
                ],
                // "  docker run -p 8080:8080 harshalworks/passkey-demo-harshalsharma:v1",
                style: GoogleFonts.roboto(fontSize: 14),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    copyDockerCodeToClipboard(context);
                  },
                  child: Container(
                    color: Colors.black12,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text.rich(TextSpan(
                          text:
                              "docker run -p 8080:8080 harshalworks/passkey-demo-harshalsharma:v1",
                          style: GoogleFonts.jetBrainsMono(
                              color: AppConstants.theme.colorScheme.secondary),
                          children: [
                            WidgetSpan(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.copy,
                                  size: 14,
                                  color:
                                      AppConstants.theme.colorScheme.secondary,
                                ),
                              ),
                            )
                          ])),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ServerConfigWidget(),
            )
          ],
        ));
  }

  void copyDockerCodeToClipboard(BuildContext context) {
    Clipboard.setData(const ClipboardData(
        text:
            "docker run -p 8080:8080 harshalworks/passkey-demo-harshalsharma:v1"));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppConstants.theme.primaryColor,
        content: Text(
          'Code copied to clipboard',
          style: GoogleFonts.jetBrainsMono(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ServerConfigWidget extends StatefulWidget {
  const ServerConfigWidget({super.key});

  @override
  State<ServerConfigWidget> createState() => _ServerConfigWidgetState();
}

class _ServerConfigWidgetState extends State<ServerConfigWidget> {
  bool? isTested;
  bool isWaiting = false;

  late TextEditingController hostController;
  late TextEditingController portController;

  @override
  void initState() {
    super.initState();

    hostController = TextEditingController();
    portController = TextEditingController();
    hostController.text = Provider.of<ServerState>(context, listen: false).host;
    portController.text = Provider.of<ServerState>(context, listen: false).port;
  }

  @override
  void dispose() {
    hostController.dispose();
    portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<ServerState>(builder: (context, serverState, child) {
            return Text(
              "${serverState.serverOrigin}",
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: AppConstants.theme.colorScheme.secondary),
            );
          }),
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: hostController,
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        Provider.of<ServerState>(context, listen: false)
                            .setHost(value);
                      }
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Enter hostname',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: portController,
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        Provider.of<ServerState>(context, listen: false)
                            .setPort(value);
                      }
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Enter port',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const Expanded(child: SizedBox())
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StepButton("TEST SERVER", onTap: () async {
            setState(() {
              isWaiting = true;
              isTested = null;
            });
            bool? result = await testServer();
            setState(() {
              isTested = result;
              isWaiting = false;
            });
          }),
        ),
        if (isTested != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StepOutputWidget(
                stepOutput: StepOutput(
                    timestamp: DateTime.now(),
                    successful: isTested!,
                    output: isTested!
                        ? "Successfully Connected."
                        : "Error Connecting Server.")),
          ),
        if (isWaiting == true)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Loading(),
          )
      ],
    );
  }

  Future<bool?> testServer() async {
    return Future.delayed(const Duration(seconds: 1), () => false);
  }
}
