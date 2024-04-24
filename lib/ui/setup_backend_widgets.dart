import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passkey_demo_frontend/app_state.dart';
import 'package:passkey_demo_frontend/remote_services.dart';
import 'package:provider/provider.dart';

import '../app_constants.dart';
import 'utility_widgets/loading_widget.dart';
import 'utility_widgets/step_widgets.dart';

class SetupBackendWidget extends StatelessWidget {
  final RemoteServices remoteServices;

  const SetupBackendWidget({
    super.key,
    required this.remoteServices,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ExpansionTile(
          leading: const Icon(Icons.settings),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "CONFIGURE CUSTOM SERVER",
              style: AppConstants.textTheme.labelLarge,
            ),
          ),
          subtitle:
              Consumer<ServerState>(builder: (context, serverState, child) {
            return Text(
                serverState.serverOrigin() == AppConstants.defaultServer
                    ? "Currently Using Default Server"
                    : serverState.serverOrigin(),
                style: AppConstants.textTheme.labelMedium);
          }),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          textColor: AppConstants.theme.colorScheme.secondary,
          expandedAlignment: Alignment.topLeft,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ServerConfigWidget(remoteServices: remoteServices),
            )
          ],
        ));
  }
}

class ServerConfigWidget extends StatefulWidget {
  final RemoteServices remoteServices;

  const ServerConfigWidget({super.key, required this.remoteServices});

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
              serverState.serverOrigin() == AppConstants.defaultServer
                  ? "Currently Using Default Server"
                  : serverState.serverOrigin(),
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
                      Provider.of<ServerState>(context, listen: false)
                          .setHost(value);
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
                      Provider.of<ServerState>(context, listen: false)
                          .setPort(value);
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Enter port',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            )
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
    try {
      var result = await widget.remoteServices.webauthnApi.registrationGet();
      if (result != null) {
        return true;
      }
    } catch (e) {
      //ignored}
      return false;
    }
    return false;
  }
}
