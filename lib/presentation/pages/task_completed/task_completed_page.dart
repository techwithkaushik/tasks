import 'package:flutter/material.dart';
import 'package:tasks/presentation/pages/task_completed/task_completed_content.dart';

class TaskCompletedPage extends StatelessWidget {
  final String title;
  const TaskCompletedPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return TaskCompletedContent(title);
  }
}
