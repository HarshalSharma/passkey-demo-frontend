import 'dart:async';

import 'passkey/user.dart';

abstract class PasskeyService {
  ///Enrolls the user device passkey with the web server.
  ///
  Future<User?> enroll();

  ///Authenticates the user device passkey with the web server,
  ///using the provided userHandle.
  ///
  Future<User?> authenticate(String userHandle);
}
