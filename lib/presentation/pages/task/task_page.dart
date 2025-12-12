import 'package:flutter/material.dart';
import 'package:tasks/presentation/pages/task/task_page_content.dart';

class TaskPage extends StatelessWidget {
  final String title;
  const TaskPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return TaskPageContent(title);
  }
}
