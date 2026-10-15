import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:tasks/src/features/tasks/presentation/widgets/side_drawer.dart';
import 'package:tasks/src/features/tasks/presentation/widgets/task_row.dart';
import 'package:tasks/src/features/task_add/presentation/pages/task_add_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        leading: Builder(
          builder: (context) => IconButton(
            tooltip: 'Open menu',
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh tasks',
            onPressed: () => context.read<TaskBloc>().add(const TaskEvent.load()),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      drawer: sideDrawer(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddTaskPage()),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New task'),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        buildWhen: (_, current) =>
            current.maybeMap(effect: (_) => false, orElse: () => true),
        builder: (context, state) => state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off_rounded, size: 44),
                  const SizedBox(height: 12),
                  const Text('Your dashboard could not load'),
                  const SizedBox(height: 8),
                  Text(message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => context.read<TaskBloc>().add(const TaskEvent.load()),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try again'),
                  ),
                ],
              ),
            ),
          ),
          effect: (_, _, _) => const SizedBox.shrink(),
          data: (tasks) {
            final active = tasks.where((t) =>
              t.status != TaskStatus.deleted && t.status != TaskStatus.archived).toList();
            final pending = active.where((t) => t.status == TaskStatus.pending).length;
            final inProgress = active.where((t) => t.status == TaskStatus.inProgress).length;
            final completed = active.where((t) => t.status == TaskStatus.completed).length;
            final now = DateTime.now();
            final overdue = active.where((t) =>
              t.dueDate != null &&
              t.dueDate!.isBefore(now) &&
              t.status != TaskStatus.completed &&
              t.status != TaskStatus.skipped).length;
            final recent = active.where((t) => t.status != TaskStatus.completed)
              .toList()
              ..sort((a, b) {
                final aDate = a.dueDate ?? a.createdAt ?? DateTime(2100);
                final bDate = b.dueDate ?? b.createdAt ?? DateTime(2100);
                return aDate.compareTo(bDate);
              });

            return RefreshIndicator(
              onRefresh: () async => context.read<TaskBloc>().add(const TaskEvent.load()),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colors.primaryContainer, colors.surfaceContainerLow],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your day at a glance',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colors.onSurface,
                          )),
                        const SizedBox(height: 6),
                        Text(
                          active.isEmpty
                            ? 'A fresh start. Add a task to get moving.'
                            : '${active.length} active ${active.length == 1 ? 'task' : 'tasks'} to keep things moving.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(child: _MetricCard(label: 'To do', count: pending, icon: Icons.radio_button_unchecked_rounded)),
                            const SizedBox(width: 8),
                            Expanded(child: _MetricCard(label: 'In progress', count: inProgress, icon: Icons.timelapse_rounded)),
                            const SizedBox(width: 8),
                            Expanded(child: _MetricCard(label: 'Done', count: completed, icon: Icons.task_alt_rounded)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: overdue > 0 ? colors.errorContainer : colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: overdue > 0 ? colors.error.withValues(alpha: .25) : colors.outlineVariant.withValues(alpha: .5)),
                    ),
                    child: Row(
                      children: [
                        Icon(overdue > 0 ? Icons.warning_amber_rounded : Icons.event_available_rounded,
                          color: overdue > 0 ? colors.error : colors.primary, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(overdue > 0 ? 'Overdue tasks' : 'You’re on track',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 3),
                              Text(overdue > 0
                                ? '$overdue task${overdue == 1 ? '' : 's'} need your attention.'
                                : 'No overdue tasks right now.',
                                style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                        Text('$overdue', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: overdue > 0 ? colors.error : colors.primary,
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: Text('Up next',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800))),
                      TextButton(
                        onPressed: () => context.read<NavCubit>().setIndex(1),
                        child: const Text('All tasks'),
                      ),
                    ],
                  ),
                  if (recent.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(color: colors.surfaceContainerLow, borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Icon(Icons.celebration_rounded, size: 38, color: colors.primary),
                          const SizedBox(height: 10),
                          Text('Nothing waiting for you',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          const Text('You’re all caught up. Add a task whenever you’re ready.',
                            textAlign: TextAlign.center),
                        ],
                      ),
                    )
                  else
                    ...recent.take(4).map((task) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TaskRow(task: task),
                    )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;

  const _MetricCard({required this.label, required this.count, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: .72),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colors.primary),
          const SizedBox(height: 10),
          Text('$count', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
