class PublicKeyCredentialParam {
  /* type of key. ex. public-key */
  String? type;
/* algorithm to use. */
  double? alg;

  PublicKeyCredentialParam();

  @override
  String toString() {
    return 'PublicKeyCredentialParam[type=$type, alg=$alg, ]';
  }

  PublicKeyCredentialParam.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    alg = json['alg'];
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'alg': alg
     };
  }

  static List<PublicKeyCredentialParam> listFromJson(List<dynamic> json) {
    return json.map((value) => PublicKeyCredentialParam.fromJson(value)).toList();
  }
}
