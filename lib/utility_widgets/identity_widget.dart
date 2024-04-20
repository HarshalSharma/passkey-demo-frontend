import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class User {
  final String username;

  User({required this.username});

  @override
  String toString() {
    return username;
  }
}

class IdentityState with ChangeNotifier {
  User? _user;
  bool _isLoggedIn = false;

  get isLoggedIn => _isLoggedIn;

  get user => _user;

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}

class IdentityButton extends StatefulWidget {
  final Function onSignUp, onLogin, onLogout;

  const IdentityButton(
      {super.key, required this.onSignUp, required this.onLogin, required this.onLogout});

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
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
              ),
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
                child: Text("LOGIN", style: TextStyle(color: Colors.white),),
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
              child: Text("LOGOUT", style: TextStyle(color: Colors.white),),
            ),
          ),
        );
      },
    );
  }
}
