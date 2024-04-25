class SuccessfulAuthenticationResponse {
  /* bearer access token. */
  String accessToken = "";
  String userHandle = "";

  @override
  String toString() {
    return 'SuccessfulAuthenticationResponse[userHandle=$userHandle, ]';
  }

  SuccessfulAuthenticationResponse(this.accessToken);

  SuccessfulAuthenticationResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    userHandle = json['user_handle'];
  }

  Map<String, dynamic> toJson() {
    return {'access_token': accessToken, 'user_handle': userHandle};
  }
}
