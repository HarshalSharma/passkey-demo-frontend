abstract class PasskeyNativeAPI {
  Future<bool> isPasskeySupported();

  Future<Map<String, dynamic>?> createCredential(Map<String, dynamic> options);

  Future<Map<String, dynamic>?> login(Map<String, dynamic> options);
}
