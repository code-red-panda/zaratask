import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:zaratask/database/app_database.dart';
import 'package:zaratask/database/queries.dart';
import 'package:zaratask/flagged_icon_widget.dart';
import 'package:zaratask/remind_me_at_icon_widget.dart';
import 'package:zaratask/task_list_page.dart';
import 'package:zaratask/url_icon_widget.dart';

class TaskListTileWidget extends StatefulWidget {
  const TaskListTileWidget({
    required this.task,
    this.hasFocus = false,
    super.key,
  });

  final Task task;
  final bool hasFocus;

  @override
  State<TaskListTileWidget> createState() => _TaskListTileWidgetState();
}

class _TaskListTileWidgetState extends State<TaskListTileWidget> {
  late final FocusNode _nameFocusNode;
  late final TextEditingController _nameTextController;

  late final FocusNode _noteFocusNode;
  late final TextEditingController _noteTextController;

  @override
  void initState() {
    _nameFocusNode = FocusNode();
    _nameTextController = TextEditingController(text: widget.task.name);

    _noteFocusNode = FocusNode();
    _noteTextController = TextEditingController(text: widget.task.note);

    if (widget.hasFocus) {
      _nameFocusNode.requestFocus();
    }

    // If the name text field loses focus and the name is empty, delete the
    // task (this is an assumption on user experience).
    _nameFocusNode.addListener(() async {
      if (!_nameFocusNode.hasFocus &&
          _nameTextController.text.isEmpty &&
          !_noteFocusNode.hasFocus) {
        await AppQueries.deleteTaskById(widget.task.id);
      }
    });

    _noteFocusNode.addListener(() async {
      if (!_nameFocusNode.hasFocus &&
          _nameTextController.text.isEmpty &&
          !_noteFocusNode.hasFocus) {
        await AppQueries.deleteTaskById(widget.task.id);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _nameTextController.dispose();

    _noteFocusNode.dispose();
    _noteTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: TextFormField(
            key: Key('task${widget.task.id}NameFormField'),
            controller: _nameTextController,
            decoration: const InputDecoration.collapsed(hintText: ''),
            focusNode: _nameFocusNode,
            onChanged: (value) => _nameTextController.text = value,

            // On field submitted, if either name or note has changed, update
            // both name and note fields.
            onFieldSubmitted: (value) async {
              print('name field submitted');
              {
                if (taskListFormKey.currentState?.validate() ?? false) {
                  if (widget.task.name != _nameTextController.text ||
                      widget.task.note != _nameTextController.text) {
                    await AppQueries.updateTaskNameNoteById(
                      widget.task.id,
                      name: _nameTextController.text,
                      note: _noteTextController.text,
                    );
                  }

                  _nameFocusNode.unfocus();
                }
              }
            },
            style: Theme.of(context).textTheme.bodyLarge,
            textCapitalization: TextCapitalization.words,
            validator: ValidationBuilder().minLength(2).build(),
          ),
          subtitle: TextFormField(
            key: Key('task${widget.task.id}NoteFormField'),
            controller: _noteTextController,
            decoration: const InputDecoration.collapsed(hintText: 'Add note'),
            focusNode: _noteFocusNode,
            onChanged: (value) => _noteTextController.text = value,

            // On field submitted, if either name or note has changed, update
            // both name and note fields.
            onFieldSubmitted: (value) async {
              print('note field submitted');
              {
                if (taskListFormKey.currentState?.validate() ?? false) {
                  if (widget.task.name != _nameTextController.text ||
                      widget.task.note != _noteTextController.text) {
                    await AppQueries.updateTaskNameNoteById(
                      widget.task.id,
                      name: _nameTextController.text,
                      note: _noteTextController.text,
                    );
                  }

                  _noteFocusNode.unfocus();
                }
              }
            },
            style: Theme.of(context).textTheme.bodySmall,
            textCapitalization: TextCapitalization.sentences,
          ),
          trailing: Checkbox(
            value: widget.task.isComplete,

            // On changed, if isComplete has changed, update isComplete field.
            onChanged: (value) async {
              if (value != null && value != widget.task.isComplete) {
                await AppQueries.updateTaskIsCompleteById(
                  widget.task.id,
                  isComplete: value,
                );
              }
            },
          ),
        ),
        Column(
          children: [
            Row(
              children: [
                const RemindMeAtIconWidget(),
                UrlIconWidget(widget.task.id, hasUrl: false),
                FlaggedIconWidget(
                  widget.task.id,
                  isFlagged: widget.task.isFlagged,
                ),
              ],
            ),
            // Remind Me Builder
            Visibility(
              visible: widget.task.remindMeAt > 0,
              child: const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                      'show remind me at options') /*RemindMeBuilder(
                  toggleRemindMeBuilder: _toggleRemindMeBuilder,
                  initialDateTime: task.remindMe != null
                      ? DateTime.fromMillisecondsSinceEpoch(
                          task.remindMe!,
                        )
                      : null,
                ),*/
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
