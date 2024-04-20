class AllowedCredential {
  /* type of credential. */
  String type = "";

/* Base64 encoded credential id. */
  String id = "";

  AllowedCredential({required this.type, required this.id});

  @override
  String toString() {
    return 'AllowedCredential[type=$type, id=$id, ]';
  }

  AllowedCredential.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'id': id};
  }

  static List<AllowedCredential> listFromJson(List<dynamic> json) {
    return json.map((value) => AllowedCredential.fromJson(value)).toList();
  }

  static Map<String, AllowedCredential> mapFromJson(
      Map<String, Map<String, dynamic>> json) {
    var map = <String, AllowedCredential>{};
    if (json.isNotEmpty) {
      json.forEach((String key, Map<String, dynamic> value) =>
          map[key] = AllowedCredential.fromJson(value));
    }
    return map;
  }
}
