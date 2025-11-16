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
    final whenStr = task.whenComplete!;

    // prefer explicit completed flag
    if (task.isCompleted!) {
      final completedTs = task.completedAt;
      if (completedTs != null) {
        final completedDate = completedTs.toDate();
        final formatted = DateFormat(
          'yyyy-MM-dd hh:mm a',
        ).format(completedDate);
        final rel = _relativeToNow(completedDate);

        // Determine on-time vs late if a due/whenCompleted string exists
        final whenStr = task.whenComplete ?? '';
        String statusLabel = 'Completed';
        TextStyle statusStyle = TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.green[800],
        );
        if (whenStr.isNotEmpty) {
          try {
            final whenDate = DateFormat('yyyy-MM-dd hh:mm a').parse(whenStr);
            if (completedDate.isAfter(whenDate)) {
              statusLabel = 'Completed (late)';
              statusStyle = TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.red[800],
              );
            } else {
              statusLabel = 'Completed (on time)';
              statusStyle = TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.green[800],
              );
            }
          } catch (e) {
            // ignore parse errors and keep generic 'Completed'
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(statusLabel, style: statusStyle),
            SizedBox(height: 4),
            Text(
              'Completed $rel • $formatted',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ],
        );
      }

      return Text(
        'Completed',
        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green[800]),
      );
    }

    if (whenStr.isEmpty) {
      return Text(
        'No due date',
        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[700]),
      );
    }

    try {
      final whenDate = DateFormat('yyyy-MM-dd hh:mm a').parse(whenStr);
      final formattedWhen = DateFormat('yyyy-MM-dd hh:mm a').format(whenDate);
      final rel = _relativeToNow(whenDate);
      if (whenDate.isBefore(DateTime.now())) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overdue',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.red[900],
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Due $formattedWhen • $rel',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ],
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Due',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.orange[900],
            ),
          ),
          SizedBox(height: 4),
          Text(
            '$formattedWhen • $rel',
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
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
