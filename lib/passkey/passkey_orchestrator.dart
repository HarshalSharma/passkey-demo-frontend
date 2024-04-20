import 'dart:async';
import 'dart:developer';

import 'package:passkey_demo_frontend/native/web/passkey_native_api_web.dart'
    if (kIsWeb) 'package:passkey_demo_frontend/native/passkey_native_unsupported.dart'
    as platform;
import 'package:passkey_demo_frontend/passkey/user.dart';
import 'package:passkey_demo_frontend/passkey_service.dart';
import 'package:passkey_demo_frontend/server/api/webauthn_api.dart';
import 'package:passkey_demo_frontend/server/models/authentication_request.dart';
import 'package:passkey_demo_frontend/server/models/public_key_credential_creation_options_response.dart';
import 'package:passkey_demo_frontend/server/models/public_key_credential_request_options_response.dart';
import 'package:passkey_demo_frontend/server/models/registration_request.dart';

import '../native/entities.dart';

class PasskeyOrchestrator implements PasskeyService {
  final _passkeyNativeAPI = platform.getPasskeyNativeAPIInstance();

  final WebauthnAPI webauthnAPI;

  PasskeyOrchestrator({required this.webauthnAPI});

  @override
  Future<User?> enroll() async {
    /// Obtains the challenge and other options from the server endpoint.
    var publicKeyCreationOptions = await webauthnAPI.registrationGet();

    if (publicKeyCreationOptions == null) {
      log("server api didn't created credential options.");
      return null;
    }

    /// passes the server options to native api.
    PublicKeyCreationResponse? cred = await _passkeyNativeAPI.createCredential(
        getPublicKeyCreationOptions(publicKeyCreationOptions));

    if (cred == null) {
      log("native api didn't created credential");
      return null;
    }

    log("registration successful");
    log("credential id - ${cred.credentialId!}");

    var registrationSuccessful = await webauthnAPI.registrationPost(
        RegistrationRequest(
            userHandle: publicKeyCreationOptions.userId,
            clientDataJson: cred.clientDataJson,
            attestationObject: cred.attestationObject));

    if (registrationSuccessful != null && registrationSuccessful) {
      return User(
          userHandle: publicKeyCreationOptions.userId!,
          userName: publicKeyCreationOptions.userName!,
          displayName: publicKeyCreationOptions.displayName!);
    }

    return null;
  }

  @override
  Future<User?> authenticate(String userHandle) async {
    /// Obtains the challenge and other options from the server endpoint.
    var publicKeyAuthNOptions =
        await webauthnAPI.authenticationUserHandleGet(userHandle);

    if (publicKeyAuthNOptions == null) {
      log("server api didn't responded with matching credentials options.");
      return null;
    }

    var options = getPublicKeyAuthNOptions(publicKeyAuthNOptions);
    log(options);

    /// passes the server options to native api.
    PublicKeyAuthNResponse? loginResponse =
        await _passkeyNativeAPI.login(options);

    if (loginResponse == null) {
      log("native api didn't found credential to authenticate.");
      return null;
    }

    // it is not mandatory to provide credential id in login response, as server would anyway know it.
    AuthenticationRequest body = AuthenticationRequest(
        credentialId: "",
        authenticatorData: loginResponse.authData!,
        clientDataJson: loginResponse.clientDataJson!,
        signature: loginResponse.signature!);
    var authenticationResponse =
        await webauthnAPI.authenticationUserHandlePost(body, userHandle);

    if (authenticationResponse != null) {
      log("authentication successful");
      return User(
          userHandle: userHandle,
          userName: "",
          displayName: "",
          token: authenticationResponse.accessToken);
    }
    log("authentication failed.");
    return null;
  }

  getPublicKeyCreationOptions(
      PublicKeyCredentialCreationOptionsResponse publicKeyCreationOptions) {
    return {
      "publicKey": {
        "rp": {
          "id": publicKeyCreationOptions.rpId,
          "name": publicKeyCreationOptions.rpName
        },
        "user": {
          "id": publicKeyCreationOptions.userId,
          "name": publicKeyCreationOptions.userName,
          "displayName": publicKeyCreationOptions.displayName
        },
        "challenge": publicKeyCreationOptions.challenge,
        "pubKeyCredParams": [
          {"type": "public-key", "alg": -7},
          {"type": "public-key", "alg": -257}
        ]
      }
    };
  }

  getPublicKeyAuthNOptions(
      PublicKeyCredentialRequestOptionsResponse publicKeyRequestOptions) {
    var allowedCredentials = publicKeyRequestOptions.allowedCredentials;
    if (allowedCredentials == null) {
      log("server response do not have credentials.");
      throw Exception(
          "Could not login as no matching credentials found on the server.");
    }
    var credentials = allowedCredentials.map((e) => e.toJson());
    return {
      "publicKey": {
        "challenge": publicKeyRequestOptions.challenge,
        "rpId": publicKeyRequestOptions.rpId,
        "allowCredentials": credentials,
        "userVerification": "required",
      }
    };
  }
}
