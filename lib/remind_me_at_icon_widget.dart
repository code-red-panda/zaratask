import 'package:flutter/material.dart';

class RemindMeAtIconWidget extends StatefulWidget {
  const RemindMeAtIconWidget({super.key});

  @override
  State<RemindMeAtIconWidget> createState() => _RemindMeAtIconWidgetState();
}

class _RemindMeAtIconWidgetState extends State<RemindMeAtIconWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.calendar_today),
      iconSize: 16,
      onPressed: () => print('remindMeAt icon pressed'),
      visualDensity: VisualDensity.compact,
    );
  }
}
