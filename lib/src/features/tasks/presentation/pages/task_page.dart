/// Main task management page
///
/// Displays a list of active tasks with the ability to:
/// - View all tasks in an animated list
/// - Swipe left to delete a task
/// - Swipe right to mark task as completed
/// - Add new tasks via floating action button
/// - Access app menu and logout
/// - Undo task status changes via snackbar
///
/// The page listens to TaskBloc for state changes and shows:
/// - Loading indicator while tasks are being fetched
/// - Error message if something goes wrong
/// - Task list with animated transitions when tasks change
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';
// service_locator no longer needed in this file; use Bloc context instead
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_state.dart';
import 'package:tasks/src/features/task_add/presentation/pages/task_add_page.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:tasks/src/features/tasks/presentation/widgets/side_drawer.dart';
import 'package:tasks/src/features/tasks/presentation/widgets/swipeable_background.dart';
import 'package:tasks/src/features/tasks/presentation/widgets/task_row.dart';

/// Displays the main task list UI
///
/// Features:
/// - Animated list of tasks
/// - Swipe gestures for quick actions
/// - Real-time updates as tasks change
/// - Error handling and loading states
class TaskPage extends StatelessWidget {
  final String title;
  const TaskPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AppAuthBloc>();
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
          BlocBuilder<AppAuthBloc, AppAuthState>(
            bloc: authBloc,
            builder: (context, state) {
              final isSubmitting = state.maybeWhen(
                unauthenticated: (form) => form.isSubmitting,
                orElse: () => false,
              );
              if (isSubmitting) {
                return const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(),
                );
              }
              return TextButton(
                onPressed: () => authBloc.add(AppAuthSignOutRequested()),
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
                final messenger = ScaffoldMessenger.of(context);
                messenger.hideCurrentSnackBar();
                messenger.showSnackBar(
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
            buildWhen: (_, current) => current.maybeMap(
              data: (_) => true,
              error: (_) => true,
              loading: (_) => true,
              orElse: () => false,
            ),
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
                    initialAnimation: true,
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
