import '../models/simple_note.dart';

abstract class NotesAPI {
  /// Reads notes of logged in user.
  ///
  ///
  Future<SimpleNote> notesGet(String token);

  /// Updates notes of logged in user.
  ///
  ///
  Future notesPut(String token, SimpleNote body);
}
