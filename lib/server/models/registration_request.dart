class RegistrationRequest {
  /* Server provided user handle */
  String? userHandle;

/* Base64 encoded String. */
  String? clientDataJson;

/* Base64 encoded String. */
  String? attestationObject;

  RegistrationRequest(
      {required this.userHandle,
      required this.clientDataJson,
      required this.attestationObject});

  @override
  String toString() {
    return 'RegistrationRequest[userHandle=$userHandle, clientDataJson=$clientDataJson, attestationObject=$attestationObject, ]';
  }

  RegistrationRequest.fromJson(Map<String, dynamic> json) {
    userHandle = json['user_handle'];
    clientDataJson = json['client_data_json'];
    attestationObject = json['attestation_object'];
  }

  Map<String, dynamic> toJson() {
    return {
      'user_handle': userHandle,
      'client_data_json': clientDataJson,
      'attestation_object': attestationObject
    };
  }
}
