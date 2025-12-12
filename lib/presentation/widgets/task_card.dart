import 'package:flutter/material.dart';
import 'package:tasks/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onPressed;
  const TaskCard({super.key, required this.task, required this.onPressed});
  @override
  Widget build(BuildContext context) {
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
                  onTap: onPressed,
                  borderRadius: BorderRadius.circular(50),
                  key: ValueKey(task.id),
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(2),
                    child: Icon(
                      Icons.favorite,
                      color: task.isFavorite
                          ? Colors.red[700]
                          : Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Created: ${task.createdAt.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),

            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status: ${task.isCompleted ? "Completed" : "Pending"}',
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
