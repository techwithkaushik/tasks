import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/service_locator.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/sign_out/sign_out_bloc.dart';
import 'package:tasks/src/features/task_add/presentation/pages/task_add_page.dart';
import 'package:tasks/src/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:tasks/src/features/tasks/presentation/widgets/swipeable_background.dart';
import 'package:tasks/src/features/tasks/presentation/widgets/task_row.dart';

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
              return TextButton(
                onPressed: () {
                  signOutBloc.add(SignOutRequested());
                },
                child: Text("Logout"),
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 5),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    double progress = 0;
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Dismissible(
                          key: ValueKey(task.id),
                          onUpdate: (details) =>
                              setState(() => progress = details.progress),
                          onDismissed: (_) => progress = 0,
                          background: SwipeableBackground(
                            progress: progress,
                            alignment: Alignment.centerLeft,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                            iconData: Icons.delete_outline,
                            iconColor: Theme.of(context).colorScheme.onError,
                          ),
                          secondaryBackground: SwipeableBackground(
                            progress: progress,
                            alignment: Alignment.centerRight,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            iconData: Icons.done_all,
                            iconColor: Theme.of(context).colorScheme.onPrimary,
                          ),
                          confirmDismiss: (directcion) async {
                            if (directcion == DismissDirection.startToEnd) {
                              context.read<TaskBloc>().add(
                                DeleteTaskEvent(task.id),
                              );
                              return true;
                            } else {
                              return false;
                            }
                          },
                          child: TaskRow(task: task),
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
