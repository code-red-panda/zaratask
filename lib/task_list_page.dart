import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:zaratask/database/app_database.dart';
import 'package:zaratask/database/queries.dart';
import 'package:zaratask/date_time_functions.dart';
import 'package:zaratask/task_list_tile_widget.dart';

final taskListFormKey = GlobalKey<FormState>();

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: taskListFormKey,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const SliverAppBar.large(
              title: Text('Project Civic SI'),
            ),
            StreamBuilder<List<Task>>(
              stream: AppQueries.watchTasksByListId(
                1,
                createdAtAsc: true,
                isFlagged: true,
              ),
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
                      resizeDuration: Durations.medium4,
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
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton.outlined(
                  onPressed: () => print('delete completed'),
                  icon: const Icon(Icons.delete_sweep),
                ),
                IconButton.outlined(
                  onPressed: () => print('show hide completed'),
                  icon: const Icon(Icons.visibility),
                ),
                IconButton.outlined(
                  onPressed: () => print('sort'),
                  icon: const Icon(Icons.sort),
                ),
              ],
            ),
            FilledButton(
              child: const Text('Add task'),
              onPressed: () async {
                await appDatabase
                    .into(appDatabase.tasks)
                    .insertOnConflictUpdate(
                      TasksCompanion.insert(
                        name: '',
                        createdAt: getEpochFromDateTime(DateTime.now()),
                      ),
                    );

                await _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: Durations.medium4,
                  curve: Curves.easeIn,
                );
              },
            ),
          ],
        ),
      ],
      resizeToAvoidBottomInset: true,
    );
  }
}
