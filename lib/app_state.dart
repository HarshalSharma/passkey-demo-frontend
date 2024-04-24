import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passkey_demo_frontend/app_constants.dart';

import 'passkey/user.dart';

class ServerState with ChangeNotifier {
  String _host = "";
  String _port = "";

  String serverOrigin() {
    if (_host.isEmpty && _port.isEmpty) {
      return AppConstants.defaultServer;
    }
    if (_port.isEmpty) {
      return _host;
    }
    return "$_host:$_port";
  }

  get host => _host;

  get port => _port;

  void setHost(String host) {
    _host = host;
    notifyListeners();
  }

  void setPort(String port) {
    _port = port;
    notifyListeners();
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

enum DemoEvent {
  reset
}

class DemoEventBus with ChangeNotifier {

  final _eventController = StreamController<DemoEvent>.broadcast();

  Stream<DemoEvent> get events => _eventController.stream;

  void fireEvent(DemoEvent event) {
    _eventController.add(event);
    notifyListeners();
  }
}
