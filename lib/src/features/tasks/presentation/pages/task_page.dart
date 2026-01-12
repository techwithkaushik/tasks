import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/service_locator.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/sign_out/sign_out_bloc.dart';
import 'package:tasks/src/features/task_add/presentation/pages/task_add_page.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/presentation/bloc/task_bloc.dart';

class TaskPage extends StatelessWidget {
  final String title;
  const TaskPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final signOutBloc = sl<SignOutBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          BlocBuilder(
            bloc: signOutBloc,
            builder: (context, state) {
              if (state is SignOutLoading) {
                return CircularProgressIndicator();
              }
              return IconButton(
                onPressed: () {
                  signOutBloc.add(SignOutRequested());
                },
                icon: Icon(Icons.login),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          switch (state) {
            case TaskLoading():
              return const Center(child: CircularProgressIndicator());
            case TaskEmpty():
              return const Center(child: Text("No Tasks Yet"));
            case TaskError(:final message):
              return Center(child: Text(message));
            case TaskLoaded(:final tasks):
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 5),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return TaskPlayStoreRow(
                      task: tasks[index],
                      onTap: () {
                        // TODO
                        // open detail page
                      },
                      onDelete: () {
                        context.read<TaskBloc>().add(
                          DeleteTaskEvent(tasks[index].id),
                        );
                      },
                    );
                  },
                ),
              );
            default:
              return Center(child: Text("Init: Something went wrong."));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => AddTaskPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

String priorityIcon(TaskPriority p) {
  return switch (p) {
    TaskPriority.low => "🟢",
    TaskPriority.medium => "🔵",
    TaskPriority.high => "🟠",
    TaskPriority.critical => "🔴",
  };
}

class PlayStorePill extends StatelessWidget {
  final Widget child;
  const PlayStorePill({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.12)
            : Colors.black.withOpacity(0.06),
        borderRadius: BorderRadius.circular(50),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        child: child,
      ),
    );
  }
}

String dueIn(Task task) {
  if (task.dueDate == null) return "No due date";

  final diff = task.dueDate!.difference(DateTime.now()).inDays;

  if (diff < 0) return "Overdue";
  if (diff == 0) return "Due today";
  if (diff == 1) return "Due tomorrow";
  return "Due in $diff days";
}

List<Widget> taskPills(Task task, BuildContext context) {
  return [
    PlayStorePill(
      child: Text("${priorityIcon(task.priority)} ${task.status.name}"),
    ),
    PlayStorePill(child: Text("💼 ${task.priority.name}")),
    PlayStorePill(child: Text("⏱ ${task.estimatedMinutes}m")),
    if (task.dueDate != null) PlayStorePill(child: Text(dueIn(task))),
    ...task.tags.map((t) => PlayStorePill(child: Text("#$t"))),
  ];
}

class TaskPlayStoreRow extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TaskPlayStoreRow({
    super.key,
    required this.task,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ICON / TYPE INDICATOR
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

            // MAIN CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: onSurface,
                    ),
                  ),

                  const SizedBox(height: 2),

                  // DESCRIPTION
                  if (task.description != null)
                    Text(
                      task.description!,
                      style: TextStyle(fontSize: 12.5, color: onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: 6),

                  // METADATA + PILLS
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [...taskPills(task, context)],
                  ),
                ],
              ),
            ),

            // TRAILING DELETE (OPTIONAL)
            if (onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}
