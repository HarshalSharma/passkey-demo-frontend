import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:passkey_demo_frontend/entities/webauthn.dart';
import 'package:passkey_demo_frontend/native/web/passkey_native_api_web.dart'
    if (kIsWeb) 'package:passkey_demo_frontend/native/passkey_native_unsupported.dart'
    as platform;
import 'package:passkey_demo_frontend/server/WebauthnServer.dart';

class PasskeyService {

  final _passkeyNativeAPI = platform.getPasskeyNativeAPIInstance();

  final _webauthnServer = WebauthnServer();

  /// creates a passkey credential and registers it with server.
  Future<bool> registerCredential() async {
    /// Obtains the challenge and other options from the server endpoint.
    dynamic publicKeyCreationOptions =
        await _webauthnServer.getPublicKeyCreationOptions();

    /// passes the server options to native api.
    Map<String, dynamic>? cred =
        await _passkeyNativeAPI.createCredential(publicKeyCreationOptions);

    if (cred == null) {
      log("native api didn't created credential");
      return false;
    }

    PublicKeyCreationResponse publicKeyCreationResponse =
        PublicKeyCreationResponse.fromJson(cred);
    log(jsonEncode(publicKeyCreationResponse.toJson()));

    // TODO: Register the credential to the server endpoint.
    log("registration successful");
    if (publicKeyCreationResponse.credentialId != null) {
      log("credential id - ${publicKeyCreationResponse.credentialId}");
      _webauthnServer
          .setCurrentCredentialId(publicKeyCreationResponse.credentialId!);
    }

    return true;
  }

  Future<bool> login() async {
    /// Obtains the challenge and other options from the server endpoint.
    dynamic publicKeyAuthNOptions =
        await _webauthnServer.getPublicKeyAuthNOptions();

    /// passes the server options to native api.
    Map<String, dynamic>? loginResponse =
        await _passkeyNativeAPI.login(publicKeyAuthNOptions);

    if (loginResponse == null) {
      log("native api didn't found credential to authenticate.");
      return false;
    }

    PublicKeyAuthNResponse publicKeyAuthNResponse =
        PublicKeyAuthNResponse.fromJson(loginResponse);
    log(jsonEncode(publicKeyAuthNResponse.toJson()));

    // TODO: Register the credential to the server endpoint.
    log("authentication successful");

    return true;
  }
}
