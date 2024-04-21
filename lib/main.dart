import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passkey_demo_frontend/passkey/passkey_orchestrator.dart';
import 'package:passkey_demo_frontend/server/WebauthnServer.dart';
import 'package:passkey_demo_frontend/theme.dart';
import 'package:passkey_demo_frontend/utility_widgets/loading_widget.dart';
import 'package:provider/provider.dart';

import 'utility_widgets/identity_widget.dart';

final passkeyService = PasskeyOrchestrator(
    webauthnAPI: WebauthnServer(host: "http://localhost:9090"));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LoadingState()),
    ChangeNotifierProvider(create: (_) => IdentityState())
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
            title: Text(
              "Passkey Demo",
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold, fontSize: 24),
            ),
            backgroundColor: Colors.white,
            foregroundColor: AppConstants.theme.colorScheme.secondary,
            actions: [
              if (context.watch<IdentityState>().user != null)
                IconButton(
                  onPressed: resetId,
                  icon: const Icon(Icons.lock_reset),
                  tooltip: "Forget User",
                )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildCard(
                            "Register New Passkey",
                            "User could choose to register for NEW passkey, which they could later use to LOGIN into the system.",
                            [
                              ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            Colors.black87)),
                                onPressed: () => onSignup(),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    "REGISTER",
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              )
                            ]),
                      ),
                      const Divider(
                        height: 10,
                        thickness: 1,
                        color: Colors.black,
                        indent: 20,
                        endIndent: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0, left: 24),
                        child: Text("Password-Less ways to Login :",
                        style: GoogleFonts.roboto(fontWeight: FontWeight.bold,
                            fontSize: 18), ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildCard(
                            "1. Login with UserName and Passkey",
                            "User would need to provide a UserName/UserHandle, using which passkey LOGIN could be triggered to securely enter into the system.",
                            [
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll<
                                            Color>(
                                        Colors.black87)),
                                onPressed: () => onSignup(),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "LOGIN WITH USERNAME",
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildCard(
                            "2. Login at User's home location with Passkey",
                            "UserHandle/UserName could also be identified using cookies, their location and different other techniques like fingerprinting, "
                                "user Home Location or cookies is a privacy preserving technique to identify the possible UserHandle/UserName.\n"
                                "We are not required to uniquely identify the user before triggering passkey login, Instead we should be just sure enough that one of the identified credentials would be identified by "
                                "the authentication and using which passkey LOGIN could be triggered to securely enter into the system.",
                            [
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            AppConstants.theme.colorScheme.secondary)),
                                onPressed: () => onSignup(),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "LOGIN WITH PASSKEY AT HOME",
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            ]),
                      ),

                      // if (context.watch<IdentityState>().user != null)
                      //   Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Text(
                      //       "Hello, ${context.watch<IdentityState>().user} \n"
                      //       "${context.watch<IdentityState>().isLoggedIn ? 'You are logged In 😊' : 'Please login with Passkey'}",
                      //       style: const TextStyle(fontSize: 28),
                      //     ),
                      //   ),
                      // IdentityButton(
                      //   onSignUp: onSignup,
                      //   onLogin: onLogin,
                      //   onLogout: onLogout,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget buildCard(String title, String body, List<Widget> extraWidgets) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              body,
              style: GoogleFonts.roboto(fontSize: 18),
            ),
          ),
          for (var value in extraWidgets)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: value,
            )
        ],
      ),
    );
  }

  onSignup() async {
    var user = await passkeyService.enroll();
    print("registration status - $bool");
    if (user != null) {
      Provider.of<IdentityState>(context, listen: false).setUser(user);
    }
  }

  onLogin() async {
    var user = await passkeyService.authenticate("");
    print("authentication status - $bool");
    if (user != null) {
      Provider.of<IdentityState>(context, listen: false).setLoggedIn(true);
    }
  }

  onLogout() {
    Provider.of<IdentityState>(context, listen: false).setLoggedIn(false);
  }

  void resetId() {
    onLogout();
    Provider.of<IdentityState>(context, listen: false).clearUser();
  }
}
