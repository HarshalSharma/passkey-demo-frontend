class PublicKeyCreationResponse {
  String? _attestationObject;
  String? _clientDataJson;
  String? _credentialId;


  PublicKeyCreationResponse(this._attestationObject, this._clientDataJson,
      this._credentialId);

  String? get attestationObject => _attestationObject;

  String? get clientDataJson => _clientDataJson;

  String? get credentialId => _credentialId;

  PublicKeyCreationResponse.fromJson(Map<String, dynamic> json) {
    _attestationObject = json['attestation_object'];
    _clientDataJson = json['client_data_json'];
    _credentialId = json['credential_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attestation_object'] = _attestationObject;
    data['client_data_json'] = _clientDataJson;
    data['credential_id'] = _credentialId;
    return data;
  }

}

class PublicKeyAuthNResponse {
  String? _authData;
  String? _clientDataJson;
  String? _signature;
  String? _userHandle;


  PublicKeyAuthNResponse(this._authData, this._clientDataJson, this._signature,
      this._userHandle);

  String? get authData => _authData;

  String? get clientDataJson => _clientDataJson;

  String? get userHandle => _userHandle;

  String? get signature => _signature;

  PublicKeyAuthNResponse.fromJson(Map<String, dynamic> json) {
    _authData = json['auth_data'];
    _clientDataJson = json['client_data_json'];
    _signature = json['signature'];
    _userHandle = json['user_handle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['auth_data'] = _authData;
    data['client_data_json'] = _clientDataJson;
    data['user_handle'] = _userHandle;
    data['signature'] = _signature;
    return data;
  }

}
