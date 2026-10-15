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
class TaskPage extends StatefulWidget {
  final String title;
  const TaskPage({super.key, required this.title});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String _query = '';
  TaskStatus? _statusFilter;

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
        title: Text(widget.title),
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
                final isConnectionNotice = message.startsWith("Connection lost.");
                final action = taskId.isEmpty
                    ? (isConnectionNotice
                        ? SnackBarAction(
                            label: "Retry",
                            onPressed: () => context.read<TaskBloc>().add(
                              const TaskEvent.load(),
                            ),
                          )
                        : null)
                    : SnackBarAction(
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
                      );
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(message),
                    duration: const Duration(seconds: 4),
                    persist: false,
                    action: action,
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
                error: (msg) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_off_outlined, size: 40),
                        const SizedBox(height: 12),
                        const Text(
                          "Could not load tasks",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(msg, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () => context.read<TaskBloc>().add(
                            const TaskEvent.load(),
                          ),
                          icon: const Icon(Icons.refresh),
                          label: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                ),

                effect: (_, _, _) => const SizedBox.shrink(),

                data: (tasks) {
                  final taskList = tasks
                      .where((t) => t.status != TaskStatus.deleted && t.status != TaskStatus.archived)
                      .toList();
                  final pendingCount = taskList.where((t) => t.status == TaskStatus.pending).length;
                  final progressCount = taskList.where((t) => t.status == TaskStatus.inProgress).length;
                  final completedCount = taskList.where((t) => t.status == TaskStatus.completed).length;
                  final overdueCount = taskList.where((t) =>
                    t.dueDate != null && t.dueDate!.isBefore(DateTime.now()) &&
                    t.status != TaskStatus.completed && t.status != TaskStatus.skipped
                  ).length;
                  final query = _query.trim().toLowerCase();
                  final visibleTasks = taskList.where((task) {
                    final matchesQuery = query.isEmpty ||
                        task.title.toLowerCase().contains(query) ||
                        (task.description ?? '').toLowerCase().contains(query) ||
                        task.tags.any((tag) => tag.toLowerCase().contains(query));
                    final matchesStatus = _statusFilter == null || task.status == _statusFilter;
                    return matchesQuery && matchesStatus;
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 12, 8, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your workspace',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                            const SizedBox(height: 4),
                            Text('Stay focused. Make today count.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant)),
                            const SizedBox(height: 18),
                            Row(children: [
                              Expanded(child: _TaskSummaryCard(label: 'To do', count: pendingCount,
                                icon: Icons.radio_button_unchecked_rounded,
                                color: Theme.of(context).colorScheme.primary)),
                              const SizedBox(width: 8),
                              Expanded(child: _TaskSummaryCard(label: 'In progress', count: progressCount,
                                icon: Icons.timelapse_rounded, color: const Color(0xFF159D85))),
                              const SizedBox(width: 8),
                              Expanded(child: _TaskSummaryCard(label: 'Completed', count: completedCount,
                                icon: Icons.task_alt_rounded, color: const Color(0xFF8260D8))),
                            ]),
                            if (overdueCount > 0) ...[
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.errorContainer,
                                  borderRadius: BorderRadius.circular(14)),
                                child: Row(children: [
                                  Icon(Icons.warning_amber_rounded,
                                    color: Theme.of(context).colorScheme.onErrorContainer),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text('$overdueCount overdue task(s) need attention',
                                    style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer,
                                      fontWeight: FontWeight.w600))),
                                ]),
                              ),
                            ],
                            const SizedBox(height: 20),
                            TextField(
                              onChanged: (value) => setState(() => _query = value),
                              decoration: InputDecoration(
                                hintText: 'Search tasks, notes or tags',
                                prefixIcon: const Icon(Icons.search_rounded),
                                suffixIcon: _query.isEmpty
                                    ? null
                                    : IconButton(
                                        tooltip: 'Clear search',
                                        onPressed: () => setState(() => _query = ''),
                                        icon: const Icon(Icons.close_rounded),
                                      ),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildFilterChip('All', null),
                                  const SizedBox(width: 8),
                                  _buildFilterChip('To do', TaskStatus.pending),
                                  const SizedBox(width: 8),
                                  _buildFilterChip('In progress', TaskStatus.inProgress),
                                  const SizedBox(width: 8),
                                  _buildFilterChip('Completed', TaskStatus.completed),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(children: [
                              Expanded(child: Text('Your tasks',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800))),
                              Text('${taskList.length} total',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
                            ]),
                          ],
                        ),
                      ),
                      if (visibleTasks.isEmpty)
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    query.isEmpty ? Icons.task_alt_rounded : Icons.search_off_rounded,
                                    size: 44,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    query.isEmpty && _statusFilter == null
                                        ? 'No tasks yet. Tap + to create one.'
                                        : 'No tasks match your filters',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  if (query.isNotEmpty || _statusFilter != null) ...[
                                    const SizedBox(height: 8),
                                    TextButton(
                                      onPressed: () => setState(() {
                                        _query = '';
                                        _statusFilter = null;
                                      }),
                                      child: const Text('Clear filters'),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        Expanded(child: ImplicitlyAnimatedList(
                    itemData: visibleTasks,
                    itemEquality: (a, b) => a.id == b.id,
                    initialAnimation: true,
                    itemBuilder: (context, task) {
                      double progress = 0.0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: StatefulBuilder(
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
                                  // Let the Firestore-backed TaskBloc state
                                  // remove the row only after persistence
                                  // succeeds. Dismissible must not hide it
                                  // optimistically if the write fails.
                                  return false;
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
                  ),
                        ),
                    ],
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


  Widget _buildFilterChip(String label, TaskStatus? status) {
    final selected = _statusFilter == status;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => setState(() => _statusFilter = status),
      avatar: selected
          ? const Icon(Icons.check_rounded, size: 16)
          : null,
    );
  }
}

class _TaskSummaryCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color color;
  const _TaskSummaryCard({required this.label, required this.count, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 10),
        Text('$count', style: theme.textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, maxLines: 1, overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
