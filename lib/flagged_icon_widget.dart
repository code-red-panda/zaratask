import 'package:flutter/material.dart';
import 'package:zaratask/database/queries.dart';

class FlaggedIconWidget extends StatelessWidget {
  const FlaggedIconWidget(this.id, {this.isFlagged = false, super.key});

  final int id;
  final bool isFlagged;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.flag),
      iconSize: 18,
      isSelected: isFlagged,
      onPressed: () async {
        await AppQueries.updateTaskIsFlaggedById(
          id,
          isFlagged: !isFlagged,
        );
      },
      selectedIcon: const Icon(Icons.flag, color: Colors.amber, size: 18),
      visualDensity: VisualDensity.compact,
    );
  }
}
