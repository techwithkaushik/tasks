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
        buildWhen: (_, curr) {
          return curr.maybeMap(effect: (_) => false, orElse: () => true);
        },
        builder: (context, state) {
          return state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (msg) => Center(child: Text(msg)),
            effect: (_, _, _) {
              // We ignore effect here (no rebuild)
              return const SizedBox.shrink();
            },
            data: (tasks) {
              final deletedTasks = tasks
                  .where((t) => t.status == TaskStatus.deleted)
                  .toList();

              if (deletedTasks.isEmpty) {
                return const Center(child: Text("Recycle bin is empty"));
              }

              return ListView.builder(
                itemCount: deletedTasks.length,
                itemBuilder: (_, i) {
                  final task = deletedTasks[i];
                  final deletedTime = task.updatedAt ?? task.createdAt;

                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text("Deleted on $deletedTime"),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        switch (value) {
                          case 'restore':
                            context.read<TaskBloc>().add(
                              TaskEvent.updateStatus(
                                taskId: task.id,
                                status: task.lastStatus,
                                showSnackBar: false, // 🔥 important
                              ),
                            );
                            break;
                          case 'delete_forever':
                            context.read<TaskBloc>().add(
                              TaskEvent.delete(task.id),
                            );
                            break;
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'restore', child: Text("Restore")),
                        PopupMenuItem(
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
          );
        },
      ),
    );
  }
}
