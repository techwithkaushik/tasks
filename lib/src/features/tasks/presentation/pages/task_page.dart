import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';
import 'package:tasks/service_locator.dart';
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
              icon: const Icon(Icons.menu),
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
                return const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(),
                );
              }
              return TextButton(
                onPressed: () => signOutBloc.add(SignOutRequested()),
                child: const Text("Logout"),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: BlocListener<TaskBloc, TaskState>(
          listenWhen: (_, current) =>
              current.maybeMap(effect: (_) => true, orElse: () => false),
          listener: (_, state) {
            state.whenOrNull(
              effect: (message, taskId, previous) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    duration: const Duration(seconds: 3),
                    persist: false,
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        context.read<TaskBloc>().add(
                          TaskEvent.updateStatus(
                            taskId: taskId,
                            status: previous,
                            showSnackBar: false,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
          child: BlocBuilder<TaskBloc, TaskState>(
            buildWhen: (_, current) =>
                current.maybeMap(data: (_) => true, orElse: () => false),
            builder: (context, state) {
              return state.when(
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
                error: (msg) => Center(child: Text("Error: $msg")),

                effect: (_, _, _) => const SizedBox.shrink(),

                data: (tasks) {
                  final taskList = tasks
                      .where((t) => t.status != TaskStatus.deleted)
                      .toList();

                  if (taskList.isEmpty) {
                    return const Center(child: Text("No Tasks Yet"));
                  }

                  return ImplicitlyAnimatedList(
                    itemData: taskList,
                    itemEquality: (a, b) => a.id == b.id,
                    itemBuilder: (context, task) {
                      double progress = 0.0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            return Dismissible(
                              key: ValueKey(task),
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
                                iconColor: Theme.of(
                                  context,
                                ).colorScheme.onError,
                              ),
                              secondaryBackground: SwipeableBackground(
                                progress: progress,
                                alignment: Alignment.centerRight,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                iconData: Icons.done_all,
                                iconColor: Theme.of(
                                  context,
                                ).colorScheme.onPrimary,
                              ),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  context.read<TaskBloc>().add(
                                    TaskEvent.updateStatus(
                                      taskId: task.id,
                                      status: TaskStatus.deleted,
                                      showSnackBar: true,
                                    ),
                                  );
                                  return true;
                                } else if (direction ==
                                    DismissDirection.endToStart) {
                                  context.read<TaskBloc>().add(
                                    TaskEvent.updateStatus(
                                      taskId: task.id,
                                      status: TaskStatus.completed,
                                      showSnackBar: true,
                                    ),
                                  );
                                }
                                return false;
                              },
                              child: TaskRow(task: task),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),

      drawer: sideDrawer(context),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddTaskPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
