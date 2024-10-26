import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift/remote.dart';
import 'package:flutter/foundation.dart';
import 'package:zaratask/database/app_database.dart';
import 'package:zaratask/exceptions.dart';

class AppQueries {
  /// Returns the number of rows deleted
  static Future<int> deleteTaskById(int id) async {
    final q =
        appDatabase.managers.tasks.filter((f) => f.id.equals(id)).delete();

    if (kDebugMode) {
      debugPrint('deleteTaskById($id)');
    }

    return _execute<int>(q);
  }

  /// Returns the number of rows updated
  static Future<int> updateTaskIsCompleteById(
    int id, {
    required bool isComplete,
  }) async {
    final q = appDatabase.managers.tasks
        .filter((f) => f.id.equals(id))
        .update((o) => o(isComplete: Value(isComplete)));

    if (kDebugMode) {
      debugPrint('updateTaskCompleteById($id, $isComplete)');
    }

    return _execute<int>(q);
  }

  /// Returns the number of rows updated
  static Future<int> updateTaskIsFlaggedById(
    int id, {
    required bool isFlagged,
  }) async {
    final q = appDatabase.managers.tasks
        .filter((f) => f.id.equals(id))
        .update((o) => o(isFlagged: Value(isFlagged)));

    if (kDebugMode) {
      debugPrint('updateTaskIsFlaggedById($id, $isFlagged)');
    }

    return _execute<int>(q);
  }

  /// Returns the number of rows updated
  static Future<int> updateTaskNameById(int id, {required String name}) async {
    final q = appDatabase.managers.tasks
        .filter((f) => f.id.equals(id))
        .update((o) => o(name: Value(name)));

    if (kDebugMode) {
      debugPrint('updateTasksNameById($id, $name)');
    }

    return _execute<int>(q);
  }

  /// Returns the number of rows updated
  static Future<int> updateTaskNameNoteById(
    int id, {
    required String name,
    required String note,
  }) async {
    final q = appDatabase.managers.tasks
        .filter((f) => f.id.equals(id))
        .update((o) => o(name: Value(name), note: Value(note)));

    if (kDebugMode) {
      debugPrint('updateTasksNameNoteById($id, $name, $note)');
    }

    return _execute<int>(q);
  }

  /// Returns the number of rows updated
  static Future<int> updateTaskNoteById(int id, {required String note}) async {
    final q = appDatabase.managers.tasks
        .filter((f) => f.id.equals(id))
        .update((o) => o(note: Value(note)));

    if (kDebugMode) {
      debugPrint('updateTasksNameById($id, $note)');
    }

    return _execute<int>(q);
  }

  static Future<T> _execute<T>(Future<T> query) async {
    try {
      return await query;
    } on DriftRemoteException catch (e, stackTrace) {
      final exception = e.remoteCause;

      if (exception is SqliteException) {
        throw LocalException.sqlite(
          message: exception.message,
          causingStatement: exception.causingStatement ?? '',
          explanation: exception.explanation ?? '',
          parametersToStatement: exception.parametersToStatement ?? [],
          trace: stackTrace,
        );
      } else {
        throw LocalException.drift(
          remoteCause: '$exception',
          exceptionType: exception.runtimeType,
          trace: stackTrace,
        );
      }
    } catch (e, stackTrace) {
      throw LocalException.unknown(args: {}, trace: stackTrace);
    }
  }
}
