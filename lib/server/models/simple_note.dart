class SimpleNote {
  /* A simple note. */
  String note = "";

  SimpleNote(this.note);

  @override
  String toString() {
    return 'SimpleNote[note=$note, ]';
  }

  SimpleNote.fromJson(Map<String, dynamic> json) {
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    return {'note': note};
  }
}
