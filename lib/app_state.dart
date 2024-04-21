import 'package:flutter/material.dart';

import 'passkey/user.dart';

class ServerState with ChangeNotifier {
  String _host = "http://localhost";
  String _port = "8080";

  get serverOrigin => "$_host:$_port";

  get host => _host;

  get port => _port;

  void setHost(String host) {
    if (host.isNotEmpty) {
      _host = host;
      notifyListeners();
    }
  }

  void setPort(String port) {
    if (port.isNotEmpty) {
      _port = port;
      notifyListeners();
    }
  }
}

class IdentityState with ChangeNotifier {
  User? _user;

  get isLoggedIn => _user ?? _user!.token != null;

  get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearState() {
    _user = null;
    notifyListeners();
  }
}
