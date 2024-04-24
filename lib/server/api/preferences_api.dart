import 'package:passkey_demo_frontend/server/models/preferences.dart';

abstract class UserPreferencesAPI {
  /// Reads notes of logged in user.
  ///
  ///
  Future<Preferences?> preferencesGet(String token);

  /// Updates notes of logged in user.
  ///
  ///
  Future preferencesPut(String token, Preferences body);
}
