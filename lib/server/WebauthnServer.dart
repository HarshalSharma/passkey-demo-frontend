import 'dart:convert';

class WebauthnServer {
  // static const _serverAddress = "harshal-bits-final-project.web.app";
  static const _serverAddress = "localhost";

  String? credentialId;

  /// https://w3c.github.io/webauthn/#dictdef-publickeycredentialcreationoptions
  getPublicKeyCreationOptions() async {
    return Future.value({
      "publicKey": {
        "rp": {"id": _serverAddress, "name": _serverAddress},
        "user": {
          "id": "ZGO0yp6G/apFbyZetyMtog==",
          "name": "xyz",
          "displayName": "Chrome Touch ID"
        },
        "challenge": "ZGO0yp6G/apFbyZetyMtog==",
        "pubKeyCredParams": [
          {"type": "public-key", "alg": -7},
          {"type": "public-key", "alg": -257}
        ]
      }
    });
  }

  getPublicKeyAuthNOptions() async {
    return Future.value({
      "publicKey": {
        "challenge": "ZGO0yp6G/apFbyZetyMtog==",
        "rpId": _serverAddress,
        "allowCredentials": [
          {"type": "public-key", "id": credentialId}
        ],
        "userVerification": "required",
      }
    });
  }

  void setCurrentCredentialId(String credentialId) {
      this.credentialId = credentialId;
  }
}
