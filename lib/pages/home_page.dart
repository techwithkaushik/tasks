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

  Widget _statusWidget(Task task) {
    const double iconSize = 15;

    Widget row(IconData icon, Color iconColor, Color parenColor, Widget text) {
      return Row(
        children: [
          Icon(icon, size: iconSize, color: iconColor),
          SizedBox(width: 4),
          text,
        ],
      );
    }

    final whenStr = task.whenComplete ?? '';

    // ---------------------------------------------------------------------------
    // COMPLETED CASES
    // ---------------------------------------------------------------------------
    if (task.isCompleted ?? false) {
      final completedTs = task.completedAt;
      if (completedTs != null) {
        final completedDate = completedTs.toDate();

        String statusLabel = "Completed";
        Color parenColor = Colors.green[900]!;
        IconData icon = Icons.check_circle;
        Color iconColor = Colors.green[900]!;

        if (whenStr.isNotEmpty) {
          try {
            final whenDate = DateFormat('yyyy-MM-dd hh:mm:ss a').parse(whenStr);

            if (completedDate.isAfter(whenDate)) {
              statusLabel = "Completed (late)";
              parenColor = Colors.red[900]!;
            } else {
              statusLabel = "Completed (on time)";
            }
          } catch (_) {}
        }

        return Obx(
          () => row(
            icon,
            iconColor,
            parenColor,
            Row(
              children: [
                _buildLabelRich(statusLabel, parenColor),
                SizedBox(width: 4),
                Text(
                  controller.relativeToNow(completedDate),
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return row(
        Icons.check_circle,
        Colors.green[900]!,
        Colors.green[800]!,
        _buildLabelRich("Completed", Colors.green[900]!),
      );
    }

    // ---------------------------------------------------------------------------
    // NO DUE DATE
    // ---------------------------------------------------------------------------
    if (whenStr.isEmpty) {
      return row(
        Icons.remove_circle_outline,
        Colors.grey[800]!,
        Colors.grey[700]!,
        Text(
          'No due date',
          style: TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: Colors.grey[700],
          ),
        ),
      );
    }

    // ---------------------------------------------------------------------------
    // DUE / OVERDUE
    // ---------------------------------------------------------------------------
    try {
      final whenDate = DateFormat('yyyy-MM-dd hh:mm:ss a').parse(whenStr);

      return Obx(() {
        final now = controller.currentTime;
        final isDue = !whenDate.isBefore(now); // now <= whenDate
        final icon = isDue ? Icons.schedule : Icons.warning_amber_rounded;
        final color = isDue ? Colors.orange[900] : Colors.red[900];
        final textLabel = isDue ? "Due" : "Overdue";

        return row(
          icon,
          color!,
          color,
          Row(
            children: [
              Text(
                textLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: color,
                ),
              ),
              SizedBox(width: 4),
              Text(
                controller.relativeToNow(whenDate),
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        );
      });
    } catch (e) {
      return row(
        Icons.error_outline,
        Colors.grey[800]!,
        Colors.grey,
        Text('Invalid date', style: TextStyle(color: Colors.grey)),
      );
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
            final task = tasks.elementAt(index);
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
                  controller.timer?.cancel();
                  controller.deleteTask(index);
                  return true;
                }
                if (direction == DismissDirection.endToStart) {
                  controller.timer?.cancel();
                  controller.updateTask(index, !task.isCompleted!);
                  return false; // keep in list
                }
                return false;
              },
              child: GestureDetector(
                onTap: () {
                  controller.timer?.cancel();
                  Get.toNamed(
                    RouteNames.getAddEditTaskPage(),
                    arguments: {'task': task},
                  );
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
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.timer?.cancel();
          Get.toNamed(RouteNames.getAddEditTaskPage());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
