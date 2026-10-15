import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:tasks/src/features/tasks/presentation/widgets/task_row.dart';

class TaskCalendarPage extends StatefulWidget {
  const TaskCalendarPage({super.key});

  @override
  State<TaskCalendarPage> createState() => _TaskCalendarPageState();
}

class _TaskCalendarPageState extends State<TaskCalendarPage> {
  DateTime _selectedDate = DateTime.now();

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task calendar'),
        actions: [
          IconButton(
            tooltip: 'Today',
            onPressed: () => setState(() => _selectedDate = DateTime.now()),
            icon: const Icon(Icons.today_rounded),
          ),
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
        builder: (context, state) => state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off_rounded, size: 42),
                  const SizedBox(height: 12),
                  const Text('Could not load your calendar'),
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
            final dayTasks = tasks.where((task) {
              final due = task.dueDate;
              return due != null &&
                  _sameDay(due, _selectedDate) &&
                  task.status != TaskStatus.deleted &&
                  task.status != TaskStatus.archived;
            }).toList()
              ..sort((a, b) {
                final aDue = a.dueDate!;
                final bDue = b.dueDate!;
                final timeOrder = aDue.compareTo(bDue);
                if (timeOrder != 0) return timeOrder;
                return b.priority.index.compareTo(a.priority.index);
              });

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.55)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  child: CalendarDatePicker(
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    currentDate: DateTime.now(),
                    onDateChanged: (date) => setState(() => _selectedDate = date),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        MaterialLocalizations.of(context).formatMediumDate(_selectedDate),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Chip(
                      avatar: const Icon(Icons.event_note_rounded, size: 17),
                      label: Text('${dayTasks.length} ${dayTasks.length == 1 ? 'task' : 'tasks'}'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (dayTasks.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.event_available_rounded, size: 42, color: colors.onSurfaceVariant),
                        const SizedBox(height: 12),
                        Text('Nothing scheduled',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text('Tasks with a due date on this day will appear here.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
                      ],
                    ),
                  )
                else
                  ...dayTasks.map((task) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          TimeOfDay.fromDateTime(task.dueDate!).format(context),
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TaskRow(
                          task: task,
                          onTap: () => showModalBottomSheet<void>(
                            context: context,
                            showDragHandle: true,
                            builder: (sheetContext) => SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(task.title,
                                      style: Theme.of(sheetContext).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 10),
                                    Text(task.description?.trim().isNotEmpty == true
                                      ? task.description!.trim()
                                      : 'No description'),
                                    const SizedBox(height: 16),
                                    FilledButton.icon(
                                      onPressed: task.status == TaskStatus.completed ? null : () {
                                        context.read<TaskBloc>().add(TaskEvent.updateStatus(
                                          taskId: task.id,
                                          status: TaskStatus.completed,
                                          showSnackBar: true,
                                        ));
                                        Navigator.of(sheetContext).pop();
                                      },
                                      icon: const Icon(Icons.task_alt_rounded),
                                      label: const Text('Mark completed'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              ],
            );
          },
        ),
      ),
    );
  }
}
