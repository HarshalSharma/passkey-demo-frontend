import 'dart:async';

import 'package:passkey_demo_frontend/location_service.dart';

import 'passkey/user.dart';

abstract class PasskeyService {
  ///Enrolls the user device passkey with the web server.
  ///
  Future<User?> enroll();

  ///Authenticates the user device passkey with the web server,
  ///using the provided userHandle.
  ///
  Future<User?> authenticate(String userHandle);

  ///Authenticates the user device passkey with the web server,
  ///using the provided user location.
  ///
  Future<User?> autoAuthenticate(Location location);
}

class ServiceValidationException implements Exception {
  final String message;

  ServiceValidationException(this.message);

  @override
  String toString() {
    return message;
  }
}
