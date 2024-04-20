import 'package:passkey_demo_frontend/native/passkey_native_api.dart';

PasskeyNativeAPI getPasskeyNativeAPIInstance() {
  return PasskeyNativeUnsupported();
}

class PasskeyNativeUnsupported implements PasskeyNativeAPI {
  @override
  Future<Map<String, dynamic>?> createCredential(Map<String, dynamic> options) {
    // TODO: implement createCredential
    throw UnimplementedError();
  }

  @override
  Future<bool> isPasskeySupported() {
    // TODO: implement isPasskeySupported
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> login(Map<String, dynamic> options) {
    // TODO: implement login
    throw UnimplementedError();
  }
}
