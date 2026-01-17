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
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 64,
                  height: 64,
                  color: Colors.blueGrey.shade200,
                  alignment: Alignment.center,
                  child: Text(
                    task.type.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title.capitalize(),
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (task.description != null)
                      Text(
                        task.description!,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [...taskPills(task, context)],
                    ),
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
