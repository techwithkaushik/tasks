/// Polished, compact task card used by the animated task list.
library;

import 'package:flutter/material.dart';
import 'package:tasks/src/core/utils/utils.dart';
import 'package:tasks/src/features/tasks/presentation/utils/task_pills.dart';

import '../../domain/entities/task_entity.dart';

class TaskRow extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskRow({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDone = task.status == TaskStatus.completed;
    final priorityColor = switch (task.priority) {
      TaskPriority.critical => colors.error,
      TaskPriority.high => const Color(0xFFE58A28),
      TaskPriority.medium => colors.primary,
      TaskPriority.low => colors.tertiary,
    };
    final typeIcon = switch (task.type) {
      TaskType.single => Icons.check_circle_outline_rounded,
      TaskType.habit => Icons.spa_outlined,
      TaskType.focus => Icons.center_focus_strong_rounded,
      TaskType.recurring => Icons.repeat_rounded,
      TaskType.location => Icons.place_outlined,
    };

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colors.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: colors.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(typeIcon, color: priorityColor, size: 23),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            task.title.capitalize(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                              decoration: isDone ? TextDecoration.lineThrough : null,
                              color: isDone ? colors.onSurfaceVariant : colors.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            color: priorityColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    if (task.description?.trim().isNotEmpty ?? false) ...[
                      const SizedBox(height: 5),
                      Text(
                        task.description!.trim(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    TaskPills(task: task),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
