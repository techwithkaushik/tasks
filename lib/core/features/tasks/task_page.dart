import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/core/features/tasks/data/models/task.dart';
import 'package:tasks/core/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:tasks/core/features/tasks/task_card.dart';
import 'package:tasks/core/features/tasks/task_fab.dart';
import 'package:tasks/l10n/app_localizations.dart';

class TaskPage extends StatelessWidget {
  final String title;
  final bool isCompleted;
  const TaskPage({super.key, required this.title, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    final taskBloc = context.read<TaskBloc>();
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          List<Task> tasks = state.tasks
              .where((t) => t.isCompleted == isCompleted)
              .toList();
          tasks.sort(
            (a, b) => isCompleted
                ? b.updatedAt.compareTo(a.updatedAt)
                : b.createdAt.compareTo(a.createdAt),
          );

          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskError) {
            return Center(child: Text('${l.error}: ${state.error}'));
          } else if (state is TaskLoaded && tasks.isEmpty) {
            return Center(
              child: Text(!isCompleted ? l.noTaskAdded : l.noTaskCompleted),
            );
          }
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Padding(
                padding: const EdgeInsets.only(left: 18, right: 18, top: 5),
                child: Dismissible(
                  key: Key(task.id),
                  background: Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: !task.isCompleted
                      ? Container(
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.check, color: Colors.white),
                        )
                      : Container(),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      taskBloc.add(DeleteTaskEvent(task.id));
                      return true;
                    } else {
                      if (!task.isCompleted) {
                        taskBloc.add(ToggleTaskCompletionEvent(task.id));
                        return false;
                      }
                    }
                    return false;
                  },
                  child: TaskCard(
                    task: task,
                    onTap: () => taskBloc.add(ToggleTaskFavoriteEvent(task.id)),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: const TaskFab(),
    );
  }
}
