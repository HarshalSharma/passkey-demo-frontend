class AuthenticationRequest {
  /* Base64 encoded Credential Id. */
  String credentialId;

/* Base64 encoded String. */
  String authenticatorData;

/* Base64 encoded String. */
  String clientDataJson;

/* Base64 encoded String. */
  String signature;

  AuthenticationRequest(
      {required this.credentialId,
      required this.authenticatorData,
      required this.clientDataJson,
      required this.signature});

  @override
  String toString() {
    return 'AuthenticationRequest[credentialId=$credentialId, '
        'authenticatorData=$authenticatorData, '
        'clientDataJson=$clientDataJson, signature=$signature, ]';
  }

  Map<String, dynamic> toJson() {
    return {
      'credential_id': credentialId,
      'authenticator_data': authenticatorData,
      'client_data_json': clientDataJson,
      'signature': signature
    };
  }
}
