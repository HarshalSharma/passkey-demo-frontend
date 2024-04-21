import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passkey_demo_frontend/app_constants.dart';
import 'package:passkey_demo_frontend/passkey/passkey_orchestrator.dart';
import 'package:passkey_demo_frontend/server/WebauthnServer.dart';
import 'package:passkey_demo_frontend/ui/utility_widgets/step_widgets.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'ui/setup_backend_widgets.dart';
import 'ui/simple_demo/simple_demo.dart';
import 'ui/utility_widgets/loading_widget.dart';

final passkeyService = PasskeyOrchestrator(
    webauthnAPI: WebauthnServer(host: "http://localhost:9090"));

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
                  style:
                      GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 24),
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
                  SetupBackendWidget(),
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
                        child: Text("2024 | Developed by Harshal Sharma (er.harshalsharma@gmail.com) \n"
                            "Masters in Software Engineering | BIRLA INSTITUTE OF TECHNOLOGY & SCIENCE, PILANI",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.jetBrainsMono(fontSize: 12,),),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  onLogin() async {
    var user = await passkeyService.authenticate("");
    print("authentication status - $bool");
    if (user != null) {
      Provider.of<IdentityState>(context, listen: false).setUser(user);
    }
  }

  void resetUser() {
    Provider.of<IdentityState>(context, listen: false).clearState();
  }
}
