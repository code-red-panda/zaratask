import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift/remote.dart';
import 'package:flutter/foundation.dart';
import 'package:zaratask/database/app_database.dart';
import 'package:zaratask/database/task_lists_table.dart';
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

  /// Default for now just order by name
  ///
  /// Returns stream of lists
  static Stream<List<TaskList>> watchTaskListsById(
    int id, {
    bool createdAtAsc = true,
  }) {
    final q =
        appDatabase.managers.taskLists.orderBy((o) => o.name.asc()).watch();

    if (kDebugMode) {
      debugPrint('watchTaskListsById($id)');
    }

    return _stream<List<TaskList>>(q);
  }

  /// Incomplete tasks are always sorted first.
  ///
  /// Next, users can sort by "priority", meaning they can choose to either
  /// sort by isFlagged or RemindMeAt.
  ///
  /// Lastly, users can sort by createdAt.
  ///
  /// Returns stream of tasks
  static Stream<List<Task>> watchTasksByListId(
    int id, {
    bool createdAtAsc = true,
    bool isFlagged = true,
  }) {
    final q = appDatabase.managers.tasks.orderBy((o) {
      final createdAt = createdAtAsc ? o.createdAt.asc() : o.createdAt.desc();
      final priority = isFlagged ? o.isFlagged.desc() : o.remindMeAt.asc();

      return o.isComplete.asc() & priority & createdAt;
    }).watch();

    if (kDebugMode) {
      debugPrint(
        'watchTasksByListId($id, createdAtAsc: $createdAtAsc, isFlagged: '
        '$isFlagged)',
      );
    }

    return _stream<List<Task>>(q);
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

  static Stream<T> _stream<T>(Stream<T> stream) {
    try {
      return stream;
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
