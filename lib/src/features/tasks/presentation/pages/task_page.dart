import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/service_locator.dart';
import 'package:tasks/src/core/utils/utils.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/sign_out/sign_out_bloc.dart';
import 'package:tasks/src/features/task_add/presentation/pages/task_add_page.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:tasks/src/features/tasks/presentation/widgets/side_drawer.dart';
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
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
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
      body: BlocConsumer<TaskBloc, TaskState>(
        listenWhen: (previous, current) =>
            previous.showSnackBar != current.showSnackBar ||
            previous.undoStatus != current.undoStatus,
        listener: (context, state) {
          if (state.showSnackBar) {
            final messenger = ScaffoldMessenger.of(context);
            final undoTask = state.tasks.firstWhere(
              (t) => t.id == state.undoTaskId,
            );
            messenger.hideCurrentSnackBar();
            messenger.showSnackBar(
              SnackBar(
                content: Text(undoTask.status.name.capitalize()),
                duration: Duration(seconds: 2),
                persist: false,
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () {
                    context.read<TaskBloc>().add(
                      UpdateTaskStatusEvent(
                        state.undoTaskId,
                        undoTask.lastStatus,
                        false,
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error.isNotEmpty) {
            return Center(child: Text("Error at $state : ${state.error}"));
          }
          final taskList = state.tasks.where(
            (t) => t.status != TaskStatus.deleted,
          );
          if (taskList.isEmpty) {
            return const Center(child: Text("No Tasks Yet"));
          }
          if (taskList.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 5),
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  Task task = taskList.elementAt(index);
                  double progress = 0;
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Dismissible(
                        key: ValueKey(task),
                        onUpdate: (details) =>
                            setState(() => progress = details.progress),
                        onDismissed: (direction) {
                          progress = 0;
                          return;
                        },
                        background: SwipeableBackground(
                          progress: progress,
                          alignment: Alignment.centerLeft,
                          backgroundColor: Theme.of(context).colorScheme.error,
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
                              UpdateTaskStatusEvent(
                                task.id,
                                TaskStatus.deleted,
                                true,
                              ),
                            );
                          } else if (directcion ==
                              DismissDirection.endToStart) {
                            context.read<TaskBloc>().add(
                              UpdateTaskStatusEvent(
                                task.id,
                                TaskStatus.completed,
                                true,
                              ),
                            );
                          }
                          return false;
                        },
                        child: TaskRow(task: task),
                      );
                    },
                  );
                },
              ),
            );
          }
          return Center(child: Text("Something went wrong $state"));
        },
      ),
      drawer: sideDrawer(context),
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
