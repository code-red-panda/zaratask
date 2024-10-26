import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zaratask/database/app_database.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverAppBar(title: Text('Admin Panel')),
          SliverList.list(
            children: [
              ListTile(
                title: const Text('SELECT * FROM tasks;'),
                onTap: () async {
                  final result =
                      await appDatabase.select(appDatabase.tasks).get();

                  if (kDebugMode) {
                    for (final r in result) {
                      debugPrint(r.toString());
                    }
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
