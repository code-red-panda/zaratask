import 'package:flutter/material.dart';
import 'package:zaratask/database/queries.dart';

class UrlIconWidget extends StatelessWidget {
  const UrlIconWidget(this.id, {this.hasUrl = false, super.key});

  final int id;
  final bool hasUrl;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.link),
      iconSize: 18,
      isSelected: hasUrl,
      onPressed: () async {
       // await AppQueries.updateTaskIsFlaggedById(
       //   id,
       //   isFlagged: !hasUrl,
       // );
      },
      selectedIcon: const Icon(Icons.link, color: Colors.blue, size: 18),
      visualDensity: VisualDensity.compact,
    );
  }
}
