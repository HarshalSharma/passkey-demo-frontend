class SuccessfulAuthenticationResponse {
  /* bearer access token. */
  String accessToken = "";

  @override
  String toString() {
    return 'SuccessfulAuthenticationResponse[accessToken=$accessToken, ]';
  }

  SuccessfulAuthenticationResponse(this.accessToken);

  SuccessfulAuthenticationResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    return {'access_token': accessToken};
  }
}
