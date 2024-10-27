import 'package:drift/drift.dart';
import 'package:zaratask/database/task_lists_table.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get createdAt => integer()();
  BoolColumn get isComplete => boolean().withDefault(const Constant(false))();
  BoolColumn get isFlagged => boolean().withDefault(const Constant(false))();
  TextColumn get note => text().withDefault(const Constant(''))();
  IntColumn get remindMeAt => integer().withDefault(const Constant(0))();
  IntColumn get taskListId => integer().references(TaskLists, #id)();
  TextColumn get url => text().withDefault(const Constant(''))();
}
