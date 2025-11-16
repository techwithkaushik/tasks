import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasks/controllers/auth_controller.dart';
import 'package:tasks/models/task_model.dart';

import '../controllers/home_controller.dart';
import '../routes/route_names.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final HomeController controller = Get.put(HomeController());

  Widget _buildLabelRich(String label, Color statusColor) {
    final parenIndex = label.indexOf('(');
    final baseStyle = TextStyle(
      fontSize: 12,
      fontStyle: FontStyle.italic,
      color: Colors.grey[800],
    );
    if (parenIndex != -1) {
      final prefix = label.substring(0, parenIndex).trimRight();
      final paren = label.substring(parenIndex);
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: prefix, style: baseStyle),
            TextSpan(text: ' ', style: baseStyle),
            TextSpan(
              text: paren,
              style: baseStyle.copyWith(color: statusColor),
            ),
          ],
        ),
      );
    }
    return Text(label, style: baseStyle);
  }

  String _relativeFrom(Duration d) {
    final seconds = d.inSeconds.abs();
    if (seconds < 60) return '${seconds}s';
    final minutes = d.inMinutes.abs();
    if (minutes < 60) return '${minutes}m';
    final hours = d.inHours.abs();
    if (hours < 24) return '${hours}h';
    final days = d.inDays.abs();
    if (days < 7) return '${days}d';
    final weeks = (days / 7).floor();
    if (weeks < 5) return '${weeks}w';
    return '${days}d';
  }

  String _relativeToNow(DateTime target) {
    final now = DateTime.now();
    final diff = target.difference(now);
    if (diff.inSeconds > 0) return 'in ${_relativeFrom(diff)}';
    return '${_relativeFrom(diff)} ago';
  }

  Widget _statusWidget(Task task) {
    // Compute status locally from Task fields so this file works with the
    // existing HomeController implementation.
    final whenStr = task.whenComplete ?? '';

    // Completed path
    if (task.isCompleted ?? false) {
      final completedTs = task.completedAt;
      if (completedTs != null) {
        final completedDate = completedTs.toDate();

        final rel = _relativeToNow(completedDate);

        String statusLabel = 'Completed';
        Color parenColor = Colors.green[800]!;
        if (whenStr.isNotEmpty) {
          try {
            final whenDate = DateFormat('yyyy-MM-dd hh:mm a').parse(whenStr);
            if (completedDate.isAfter(whenDate)) {
              statusLabel = 'Completed (late)';
              parenColor = Colors.red[800]!;
            } else {
              statusLabel = 'Completed (on time)';
              parenColor = Colors.green[800]!;
            }
          } catch (e) {
            // ignore parse errors
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildLabelRich(statusLabel, parenColor),
            SizedBox(width: 4),
            Text(rel, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          ],
        );
      }

      return _buildLabelRich('Completed', Colors.green[800]!);
    }

    if (whenStr.isEmpty) {
      return Text(
        'No due date',
        style: TextStyle(
          fontSize: 12,
          fontStyle: FontStyle.italic,
          color: Colors.grey[700],
        ),
      );
    }

    try {
      final whenDate = DateFormat('yyyy-MM-dd hh:mm a').parse(whenStr);
      final rel = _relativeToNow(whenDate);
      if (whenDate.isBefore(DateTime.now())) {
        return Row(
          children: [
            Text(
              'Overdue',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.red[900],
              ),
            ),
            SizedBox(width: 4),
            Text(rel, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          ],
        );
      }
      return Row(
        children: [
          Text(
            'Due',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.orange[900],
            ),
          ),
          SizedBox(width: 4),
          Text(rel, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      );
    } catch (e) {
      return Text('Invalid date', style: TextStyle(color: Colors.grey));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          IconButton(
            onPressed: () => AuthController.instance.logout(),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        final tasks = controller.tasks;
        if (tasks.isEmpty) return Center(child: Text('No tasks'));
        return ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            final docId = task.docId!;

            return Dismissible(
              key: ValueKey("dis_$docId"),
              background: Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.only(left: 16),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red[800]),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
              secondaryBackground: Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.only(right: 16),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Complete'),
                    SizedBox(width: 8),
                    Icon(Icons.done_all, color: Colors.green[800]),
                  ],
                ),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  controller.deleteTask(index);
                  return true;
                }
                if (direction == DismissDirection.endToStart) {
                  controller.updateTask(index, !task.isCompleted!);
                  return false; // keep in list
                }
                return false;
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: task.isCompleted! ? Colors.green[50] : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(task.content),
                          SizedBox(height: 8),
                          _statusWidget(task),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      task.isCompleted!
                          ? Icons.done_all
                          : Icons.pending_actions,
                      color: task.isCompleted!
                          ? Colors.green[800]
                          : Colors.grey[700],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(RouteNames.getAddEditTaskPage()),
        child: Icon(Icons.add),
      ),
    );
  }
}
