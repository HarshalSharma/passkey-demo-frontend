import 'entities.dart';

abstract class PasskeyNativeAPI {
  Future<bool> isPasskeySupported();

  Future<PublicKeyCreationResponse?> createCredential(
      Map<String, dynamic> options);

  Future<PublicKeyAuthNResponse?> login(Map<String, dynamic> options);
}
