import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/bloc/task/task_bloc.dart';
import 'package:tasks/models/task.dart';
import 'package:tasks/presentation/widgets/task_card.dart';

class TaskCompletedContent extends StatelessWidget {
  final String title;
  const TaskCompletedContent(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final taskBloc = context.read<TaskBloc>();

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          List<Task> tasks = state.tasks.where((t) => t.isCompleted).toList();
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskError) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is TaskLoaded && tasks.isEmpty) {
            return const Center(child: Text('No tasks completed yet.'));
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
                  secondaryBackground: Container(),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      taskBloc.add(DeleteTaskEvent(task.id));
                      return true;
                    }
                    return false;
                  },
                  child: TaskCard(
                    task: task,
                    onPressed: () =>
                        taskBloc.add(ToggleTaskFavoriteEvent(task.id)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
