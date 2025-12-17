import 'package:flutter/material.dart';
import 'package:tasks/l10n/app_localizations.dart';
import 'package:tasks/core/features/tasks/data/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  const TaskCard({super.key, required this.task, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Card(
      margin: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(maxLines: 2, task.content),
                  ],
                ),
                InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(50),
                  key: ValueKey(task.id),
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(2),
                    child: Icon(
                      task.isFavorite ? Icons.favorite : Icons.favorite_outline,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '${l.created}: ${task.createdAt.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),

            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${l.status}: ${task.isCompleted ? l.completed : l.pending}',
                  style: TextStyle(
                    fontSize: 12,
                    color: task.isCompleted ? Colors.green : Colors.red,
                  ),
                ),

                Text(
                  task.type.name,
                  style: TextStyle(color: Colors.deepOrange),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
