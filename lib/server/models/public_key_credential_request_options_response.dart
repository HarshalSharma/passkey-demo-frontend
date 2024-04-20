import 'allowed_credential.dart';

class PublicKeyCredentialRequestOptionsResponse {
  /* generated challenge string. */
  String? challenge;
/* user verification type requested. */
  String? userVerification;
/* rpId to which this credential is tied. */
  String? rpId;
/* allowed credentials available with server to complete this request. */
  List<AllowedCredential>? allowedCredentials = [];

  PublicKeyCredentialRequestOptionsResponse();

  @override
  String toString() {
    return 'PublicKeyCredentialRequestOptionsResponse[challenge=$challenge, userVerification=$userVerification, rpId=$rpId, allowedCredentials=$allowedCredentials, ]';
  }

  PublicKeyCredentialRequestOptionsResponse.fromJson(Map<String, dynamic> json) {
    challenge = json['challenge'];
    userVerification = json['user_verification'];
    rpId = json['rp_id'];
    allowedCredentials = AllowedCredential.listFromJson(json['allowed_credentials']);
  }

  Map<String, dynamic> toJson() {
    return {
      'challenge': challenge,
      'user_verification': userVerification,
      'rp_id': rpId,
      'allowed_credentials': allowedCredentials
     };
  }

  static List<PublicKeyCredentialRequestOptionsResponse> listFromJson(List<dynamic> json) {
    return json.map((value) => new PublicKeyCredentialRequestOptionsResponse.fromJson(value)).toList();
  }
}
