import 'package:flutter/material.dart';
import 'package:tasks/src/core/utils/utils.dart';
import 'package:tasks/src/features/tasks/presentation/utils/priority_icon.dart';
import 'package:tasks/src/features/tasks/presentation/widgets/due_text_widget.dart';
import 'package:tasks/src/features/tasks/presentation/widgets/task_pill.dart';

import '../../domain/entities/task_entity.dart';

class TaskPills extends StatelessWidget {
  final Task task;
  const TaskPills({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        TaskPill(
          child: Text(
            "${priorityIcon(task.priority)} ${task.status.name.capitalize()}",
          ),
        ),
        TaskPill(child: Text("💼 ${task.priority.name.capitalize()}")),
        TaskPill(child: Text("⏱ ${task.estimatedMinutes}m")),
        if (task.dueDate != null)
          TaskPill(child: DueTextWidget(due: task.dueDate)),
        ...task.tags.map((t) => TaskPill(child: Text("#$t"))),
      ],
    );
  }
}
