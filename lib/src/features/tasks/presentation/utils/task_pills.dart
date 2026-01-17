import 'package:flutter/material.dart';
import 'package:tasks/src/core/utils/utils.dart';
import 'package:tasks/src/features/tasks/presentation/utils/priority_icon.dart';
import 'package:tasks/src/features/tasks/presentation/widgets/due_text_widget.dart';
import 'package:tasks/src/features/tasks/presentation/widgets/task_pill.dart';

import '../../domain/entities/task_entity.dart';

List<Widget> taskPills(Task task, BuildContext context) {
  return [
    TaskPill(
      child: Text(
        "${priorityIcon(task.priority)} ${task.status.name.capitalize()}",
      ),
    ),
    TaskPill(child: Text("💼 ${task.priority.name.capitalize()}")),
    TaskPill(child: Text("⏱ ${task.estimatedMinutes}m")),
    if (task.dueDate != null) TaskPill(child: DueTextWidget(due: task.dueDate)),
    ...task.tags.map((t) => TaskPill(child: Text("#$t"))),
  ];
}
