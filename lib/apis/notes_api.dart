import 'package:bloc_learning_path/models.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class NotesApiProtocol {
  const NotesApiProtocol();

  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle});
}

@immutable
class NoteApi implements NotesApiProtocol {
  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) =>
      Future.delayed(const Duration(seconds: 2),
          () => loginHandle == const LoginHandle.fooBar() ? mockNotes : null);
}
