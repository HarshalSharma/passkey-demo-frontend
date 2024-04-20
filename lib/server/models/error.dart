part of swagger.api;

class Error {
  /* name of the error. */
  String? error;
/* defines the reason for this error. */
  String? description;

  @override
  String toString() {
    return 'Error[error=$error, description=$description, ]';
  }

  Error.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'description': description
     };
  }
}
