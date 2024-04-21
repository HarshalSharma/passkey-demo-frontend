import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/app_state.dart';
import 'package:provider/provider.dart';

class IdentityButton extends StatefulWidget {
  final Function onSignUp, onLogin, onLogout;

  const IdentityButton(
      {super.key,
      required this.onSignUp,
      required this.onLogin,
      required this.onLogout});

  @override
  State<IdentityButton> createState() => _IdentityButtonState();
}

class _IdentityButtonState extends State<IdentityButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<IdentityState>(
      builder: (BuildContext context, IdentityState value, Widget? child) {
        if (value.user == null) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              onPressed: () => widget.onSignUp(),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("SIGN UP"),
              ),
            ),
          );
        }

        if (!value.isLoggedIn) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              onPressed: () => widget.onLogin(),
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "LOGIN",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: FilledButton(
            onPressed: () => widget.onLogout(),
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.red),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "LOGOUT",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
