import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/presentation/bloc/task_bloc.dart';

class RecycleBinPage extends StatelessWidget {
  const RecycleBinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recycle Bin")),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final deletedTasks = state.tasks
              .where((t) => t.status == TaskStatus.deleted)
              .toList();

          if (deletedTasks.isEmpty) {
            return const Center(child: Text("Recycle bin is empty"));
          }

          return ListView.builder(
            itemCount: deletedTasks.length,
            itemBuilder: (_, i) {
              final task = deletedTasks[i];
              return ListTile(
                title: Text(task.title),
                subtitle: Text(
                  "Deleted on ${task.updatedAt ?? task.createdAt}",
                ),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'restore') {
                      context.read<TaskBloc>().add(
                        UpdateTaskStatusEvent(task.id, task.lastStatus, false),
                      );
                    } else if (value == 'delete_forever') {
                      context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'restore',
                      child: Text("Restore"),
                    ),
                    const PopupMenuItem(
                      value: 'delete_forever',
                      child: Text(
                        "Delete permanently",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
