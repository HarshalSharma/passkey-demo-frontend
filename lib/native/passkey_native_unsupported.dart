import 'package:passkey_demo_frontend/native/entities.dart';
import 'package:passkey_demo_frontend/native/passkey_native_api.dart';

PasskeyNativeAPI getPasskeyNativeAPIInstance() {
  return PasskeyNativeUnsupported();
}

class PasskeyNativeUnsupported implements PasskeyNativeAPI {
  @override
  Future<PublicKeyCreationResponse?> createCredential(
      Map<String, dynamic> options) {
    // TODO: implement createCredential
    throw UnimplementedError();
  }

  @override
  Future<bool> isPasskeySupported() {
    return Future.value(false);
  }

  @override
  Future<PublicKeyAuthNResponse?> login(Map<String, dynamic> options) {
    // TODO: implement login
    throw UnimplementedError();
  }
}
