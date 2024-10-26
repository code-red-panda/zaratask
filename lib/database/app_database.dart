import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift/remote.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:zaratask/database/tasks_table.dart';
import 'package:zaratask/exceptions.dart';

part 'app_database.g.dart';

/// Table documentation:
/// https://drift.simonbinder.eu/docs/getting-started/advanced_dart_tables/

@DriftDatabase(
  tables: [
    Tasks,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() => driftDatabase(name: 'zaratask');
}

AppDatabase appDatabase = AppDatabase();
