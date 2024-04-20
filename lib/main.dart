import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/passkey/passkey_orchestrator.dart';
import 'package:passkey_demo_frontend/server/WebauthnServer.dart';
import 'package:passkey_demo_frontend/utility_widgets/loading_widget.dart';
import 'package:provider/provider.dart';

import 'utility_widgets/identity_widget.dart';

final passkeyService = PasskeyOrchestrator(webauthnAPI: WebauthnServer());

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
      title: 'Passkey_Basic_Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueGrey.shade900, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: Scaffold(
          backgroundColor: Colors.blueGrey.shade900,
          appBar: AppBar(
            title: const Text("Passkey Demo"),
            backgroundColor: Colors.black54,
            foregroundColor: Colors.white,
            actions: [
              if (context.watch<IdentityState>().user != null)
                IconButton(
                  onPressed: resetId,
                  icon: const Icon(Icons.lock_reset),
                  tooltip: "Forget User",
                )
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (context.watch<IdentityState>().user != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Hello, ${context.watch<IdentityState>().user} \n"
                    "${context.watch<IdentityState>().isLoggedIn ? 'You are logged In 😊' : 'Please login with Passkey'}",
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              IdentityButton(
                onSignUp: onSignup,
                onLogin: onLogin,
                onLogout: onLogout,
              ),
            ],
          )),
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
