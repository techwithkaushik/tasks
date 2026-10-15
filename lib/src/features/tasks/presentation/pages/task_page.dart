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
  bool _overdueOnly = false;
  _TaskSort _sortBy = _TaskSort.dueDate;

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
                  final overdueCount = taskList.where((t) =>
                    t.dueDate != null && t.dueDate!.isBefore(DateTime.now()) &&
                    t.status != TaskStatus.completed && t.status != TaskStatus.skipped
                  ).length;
                  final query = _query.trim().toLowerCase();
                  final now = DateTime.now();
                  final visibleTasks = taskList.where((task) {
                    final matchesQuery = query.isEmpty ||
                        task.title.toLowerCase().contains(query) ||
                        (task.description ?? '').toLowerCase().contains(query) ||
                        task.tags.any((tag) => tag.toLowerCase().contains(query));
                    final matchesStatus = _statusFilter == null || task.status == _statusFilter;
                    final isOverdue = task.dueDate != null &&
                        task.dueDate!.isBefore(now) &&
                        task.status != TaskStatus.completed &&
                        task.status != TaskStatus.skipped;
                    return matchesQuery &&
                        matchesStatus &&
                        (!_overdueOnly || isOverdue);
                  }).toList()
                    ..sort((a, b) {
                      switch (_sortBy) {
                        case _TaskSort.dueDate:
                          if (a.dueDate == null && b.dueDate == null) return 0;
                          if (a.dueDate == null) return 1;
                          if (b.dueDate == null) return -1;
                          return a.dueDate!.compareTo(b.dueDate!);
                        case _TaskSort.priority:
                          return b.priority.index.compareTo(a.priority.index);
                        case _TaskSort.newest:
                          return (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
                              .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0));
                        case _TaskSort.oldest:
                          return (a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
                              .compareTo(b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0));
                      }
                    });

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 16, 8, 12),
                        child: Text(
                          'Find and manage your tasks',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                  const SizedBox(width: 8),
                                  _buildFilterChip('Skipped', TaskStatus.skipped),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                FilterChip(
                                  avatar: Icon(
                                    Icons.warning_amber_rounded,
                                    size: 18,
                                    color: _overdueOnly
                                        ? Theme.of(context).colorScheme.onErrorContainer
                                        : Theme.of(context).colorScheme.error,
                                  ),
                                  label: Text('Overdue ($overdueCount)'),
                                  selected: _overdueOnly,
                                  onSelected: (selected) =>
                                      setState(() => _overdueOnly = selected),
                                ),
                                const Spacer(),
                                const Text('Sort: '),
                                const SizedBox(width: 6),
                                DropdownButton<_TaskSort>(
                                  value: _sortBy,
                                  underline: const SizedBox.shrink(),
                                  borderRadius: BorderRadius.circular(12),
                                  items: const [
                                    DropdownMenuItem(
                                      value: _TaskSort.dueDate,
                                      child: Text('Due date'),
                                    ),
                                    DropdownMenuItem(
                                      value: _TaskSort.priority,
                                      child: Text('Priority'),
                                    ),
                                    DropdownMenuItem(
                                      value: _TaskSort.newest,
                                      child: Text('Newest'),
                                    ),
                                    DropdownMenuItem(
                                      value: _TaskSort.oldest,
                                      child: Text('Oldest'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _sortBy = value);
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Your tasks',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${taskList.length} total',
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
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
                                    query.isEmpty &&
                                            _statusFilter == null &&
                                            !_overdueOnly
                                        ? 'No tasks yet. Tap + to create one.'
                                        : 'No tasks match your filters',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  if (query.isNotEmpty ||
                                      _statusFilter != null ||
                                      _overdueOnly) ...[
                                    const SizedBox(height: 8),
                                    TextButton(
                                      onPressed: () => setState(() {
                                        _query = '';
                                        _statusFilter = null;
                                        _overdueOnly = false;
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
                              child: TaskRow(task: task, onTap: () => _showTaskDetails(context, task)),
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

  Future<void> _showTaskDetails(BuildContext context, Task task) async {
    final colors = Theme.of(context).colorScheme;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: Theme.of(sheetContext).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close details',
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _detailChip(sheetContext, task.status.name, Icons.circle_outlined),
                    _detailChip(sheetContext, task.priority.name, Icons.flag_outlined),
                    _detailChip(sheetContext, task.type.name, Icons.category_outlined),
                    _detailChip(sheetContext, '${task.estimatedMinutes} min', Icons.timer_outlined),
                  ],
                ),
                if ((task.description ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text('Description',
                    style: Theme.of(sheetContext).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(task.description!.trim(),
                    style: Theme.of(sheetContext).textTheme.bodyMedium),
                ],
                if (task.dueDate != null) ...[
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Icon(Icons.event_outlined, color: colors.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Due ${MaterialLocalizations.of(sheetContext).formatMediumDate(task.dueDate!)} · ${MaterialLocalizations.of(sheetContext).formatTimeOfDay(TimeOfDay.fromDateTime(task.dueDate!))}',
                        ),
                      ),
                    ],
                  ),
                ],
                if (task.tags.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    children: task.tags.map((tag) => Chip(label: Text('#$tag'))).toList(),
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: task.status == TaskStatus.completed
                        ? null
                        : () {
                            final nextStatus = switch (task.status) {
                              TaskStatus.pending => TaskStatus.inProgress,
                              TaskStatus.inProgress => TaskStatus.completed,
                              TaskStatus.skipped => TaskStatus.pending,
                              TaskStatus.completed => TaskStatus.completed,
                              TaskStatus.deleted => TaskStatus.pending,
                              TaskStatus.archived => TaskStatus.pending,
                            };
                            context.read<TaskBloc>().add(TaskEvent.updateStatus(
                              taskId: task.id,
                              status: nextStatus,
                              showSnackBar: true,
                            ));
                            Navigator.of(sheetContext).pop();
                          },
                    icon: Icon(
                      task.status == TaskStatus.pending
                          ? Icons.play_arrow_rounded
                          : task.status == TaskStatus.inProgress
                              ? Icons.task_alt_rounded
                              : Icons.replay_rounded,
                    ),
                    label: Text(
                      switch (task.status) {
                        TaskStatus.pending => 'Start task',
                        TaskStatus.inProgress => 'Mark completed',
                        TaskStatus.skipped => 'Resume task',
                        TaskStatus.completed => 'Completed',
                        TaskStatus.deleted => 'Restore task',
                        TaskStatus.archived => 'Restore task',
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailChip(BuildContext context, String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 17),
      label: Text(label),
      side: BorderSide.none,
    );
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

enum _TaskSort { dueDate, priority, newest, oldest }

