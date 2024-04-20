import 'public_key_credential_param.dart';


class PublicKeyCredentialCreationOptionsResponse {
  /* relying party to which this credential is tied. */
  String? rpId;
/* relying party name to which this credential is tied. */
  String? rpName;
/* the user identifier or user handle */
  String? userId;
/* name of the user. */
  String? userName;
/* Name to be shown for this credential to the user. */
  String? displayName;
/* generated challenge string. */
  String? challenge;
/* public key credential parameters */
  List<PublicKeyCredentialParam>? pubKeyCredParams = [];

  @override
  String toString() {
    return 'PublicKeyCredentialCreationOptionsResponse[rpId=$rpId, rpName=$rpName, userId=$userId, userName=$userName, displayName=$displayName, challenge=$challenge, pubKeyCredParams=$pubKeyCredParams, ]';
  }

  PublicKeyCredentialCreationOptionsResponse.fromJson(Map<String, dynamic> json) {
    rpId = json['rp_id'];
    rpName = json['rp_name'];
    userId = json['user_id'];
    userName = json['user_name'];
    displayName = json['display_name'];
    challenge = json['challenge'];
    pubKeyCredParams = PublicKeyCredentialParam.listFromJson(json['pub_key_cred_params']);
  }

  Map<String, dynamic> toJson() {
    return {
      'rp_id': rpId,
      'rp_name': rpName,
      'user_id': userId,
      'user_name': userName,
      'display_name': displayName,
      'challenge': challenge,
      'pub_key_cred_params': pubKeyCredParams
     };
  }
}
