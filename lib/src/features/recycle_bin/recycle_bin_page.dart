import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/presentation/bloc/task_bloc.dart';

class RecycleBinPage extends StatelessWidget {
  const RecycleBinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycle Bin'),
        actions: [
          IconButton(
            tooltip: 'Refresh tasks',
            onPressed: () => context.read<TaskBloc>().add(const TaskEvent.load()),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        buildWhen: (_, current) =>
            current.maybeMap(effect: (_) => false, orElse: () => true),
        builder: (context, state) {
          return state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_off_rounded, size: 44, color: colors.error),
                    const SizedBox(height: 12),
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
              final deleted = tasks
                  .where((task) => task.status == TaskStatus.deleted)
                  .toList()
                ..sort((a, b) {
                  final aDate = a.updatedAt ?? a.createdAt;
                  final bDate = b.updatedAt ?? b.createdAt;
                  if (aDate == null) return 1;
                  if (bDate == null) return -1;
                  return bDate.compareTo(aDate);
                });

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colors.errorContainer.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.delete_sweep_outlined,
                              size: 34, color: colors.onErrorContainer),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Recently deleted',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: colors.onErrorContainer,
                                    )),
                                const SizedBox(height: 4),
                                Text(
                                  '${deleted.length} ${deleted.length == 1 ? 'task' : 'tasks'} in the recycle bin',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: colors.onErrorContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (deleted.isEmpty)
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  color: colors.surfaceContainerHighest,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.delete_outline_rounded,
                                    size: 42, color: colors.onSurfaceVariant),
                              ),
                              const SizedBox(height: 18),
                              Text('Your bin is empty',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  )),
                              const SizedBox(height: 8),
                              Text(
                                'Deleted tasks will appear here. You can restore them whenever you need.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        itemCount: deleted.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final task = deleted[index];
                          final deletedAt = task.updatedAt ?? task.createdAt;
                          final dateLabel = deletedAt == null
                              ? 'Deletion date unavailable'
                              : 'Deleted ${MaterialLocalizations.of(context).formatMediumDate(deletedAt)}';
                          return Card(
                            elevation: 0,
                            color: colors.surfaceContainerLow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.6)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: colors.errorContainer.withValues(alpha: 0.7),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(Icons.description_outlined, color: colors.onErrorContainer),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(task.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 4),
                                        Text(dateLabel,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          children: [
                                            TextButton.icon(
                                              onPressed: () => context.read<TaskBloc>().add(
                                                TaskEvent.updateStatus(
                                                  taskId: task.id,
                                                  status: task.lastStatus == TaskStatus.deleted
                                                      ? TaskStatus.pending
                                                      : task.lastStatus,
                                                ),
                                              ),
                                              icon: const Icon(Icons.restore_rounded, size: 18),
                                              label: const Text('Restore'),
                                            ),
                                            TextButton.icon(
                                              style: TextButton.styleFrom(foregroundColor: colors.error),
                                              onPressed: () => _confirmPermanentDelete(context, task),
                                              icon: const Icon(Icons.delete_forever_rounded, size: 18),
                                              label: const Text('Delete forever'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
    );
  }

  Future<void> _confirmPermanentDelete(BuildContext context, Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded),
        title: const Text('Delete permanently?'),
        content: Text('“${task.title}” will be permanently removed. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
              foregroundColor: Theme.of(dialogContext).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete forever'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<TaskBloc>().add(TaskEvent.delete(task.id));
    }
  }
}
