/// Any changes here must also be made in the database table
/// lib/drift/tasks_table.dart
class TaskModel {
  const TaskModel({
    required this.id,
    required this.name,
    required this.createdAt,
    this.isComplete = false,
    this.isFlagged = false,
    this.note = '',
    this.remindMeAt = 0,
    this.url = '',
  });

  final int id;
  final String name;
  final int createdAt; // epoch
  final bool isComplete;
  final bool isFlagged;
  final String note;
  final int remindMeAt; // epoch
  final String url;
}
