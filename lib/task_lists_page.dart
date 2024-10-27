import 'package:flutter/material.dart';
import 'package:zaratask/database/queries.dart';
import 'package:zaratask/database/task_lists_table.dart';

class TaskListsPage extends StatelessWidget {
  const TaskListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(title: Text('ZaraTask')),
          StreamBuilder<List<TaskLists>>(
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
    );
  }
}
