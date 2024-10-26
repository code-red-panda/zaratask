import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:zaratask/database/queries.dart';
import 'package:zaratask/date_time_functions.dart';
import 'package:zaratask/database/app_database.dart';
import 'package:zaratask/task_list_tile_widget.dart';
import 'package:zaratask/task_model.dart';

final taskListFormKey = GlobalKey<FormState>();

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () =>
                appDatabase.into(appDatabase.tasks).insertOnConflictUpdate(
                      TasksCompanion.insert(
                        name: 'Tint',
                        createdAt: getEpochFromDateTime(
                          DateTime.now().subtract(const Duration(days: 1)),
                        ),
                        isComplete: const Value(true),
                        note: const Value(r'$650'),
                        remindMeAt: Value(
                          getEpochFromDateTime(
                            DateTime.now().add(const Duration(days: 1)),
                          ),
                        ),
                      ),
                    ),
            child: const Text('Tint'),
          ),
          TextButton(
            onPressed: () =>
                appDatabase.into(appDatabase.tasks).insertOnConflictUpdate(
                      TasksCompanion.insert(
                        name: 'Enkei TR6 Rims',
                        createdAt: getEpochFromDateTime(
                          DateTime.now().subtract(const Duration(days: 5)),
                        ),
                        isFlagged: const Value(true),
                        note: const Value(r'$215 each, \$860 for a set of 4'),
                        remindMeAt: Value(
                          getEpochFromDateTime(
                            DateTime.now().add(const Duration(days: 7)),
                          ),
                        ),
                        url: const Value(
                            'https://www.procivic.com/p/gm/8th-gen/civic/enkei-t6r-wheels.html'),
                      ),
                    ),
            child: const Text('Rims'),
          ),
          TextButton(
            onPressed: () =>
                appDatabase.into(appDatabase.tasks).insertOnConflictUpdate(
                      TasksCompanion.insert(
                        name: 'Skunk2 Coil Overs',
                        createdAt: getEpochFromDateTime(
                          DateTime.now().subtract(const Duration(days: 2)),
                        ),
                        isFlagged: const Value(true),
                      ),
                    ),
            child: const Text('Coils'),
          ),
        ],
      ),
      body: Form(
        key: taskListFormKey,
        child: CustomScrollView(
          slivers: [
            const SliverAppBar.large(
              title: Text('Project Civic SI'),
            ),
            StreamBuilder<List<Task>>(
              stream: appDatabase.managers.tasks.watch(),
              builder: (context, snapshot) {
                final result = snapshot.data ?? [];

                if (snapshot.hasError) {
                  print(
                      'move this to local exception - snapshot has error: ${snapshot.error}');
                }

                return SliverList.separated(
                  itemBuilder: (context, index) {
                    final hasFocus = result[index].name.isEmpty &&
                        result.length == index + 1;

                    return Dismissible(
                      key: Key('${result[index].id}'),
                      direction: DismissDirection.endToStart,
                      dismissThresholds: const {
                        DismissDirection.startToEnd: 0.6,
                        DismissDirection.endToStart: 0.6,
                      },

                      // Delete the task from the database.
                      onDismissed: (direction) async {
                        await AppQueries.deleteTaskById(result[index].id);
                      },
                      resizeDuration: const Duration(milliseconds: 900),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: TaskListTileWidget(
                        task: result[index],
                        hasFocus: hasFocus,
                      ),
                    );
                  },
                  itemCount: result.length,
                  separatorBuilder: (context, index) => const Divider(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          appDatabase.into(appDatabase.tasks).insertOnConflictUpdate(
                TasksCompanion.insert(
                  name: '',
                  createdAt: getEpochFromDateTime(DateTime.now()),
                ),
              );
        },
        label: const Icon(Icons.add_task),
      ),
    );
  }
}
