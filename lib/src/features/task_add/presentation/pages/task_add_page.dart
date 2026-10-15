import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/l10n/app_localizations.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/task_add/presentation/bloc/task_add_bloc.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/presentation/bloc/task_bloc.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskAddBloc(taskBloc: context.read<TaskBloc>()),
      child: const _AddTaskView(),
    );
  }
}

class _AddTaskView extends StatelessWidget {
  const _AddTaskView();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return BlocListener<TaskAddBloc, TaskAddState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.of(context).pop();
        }
        if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.addTask),
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: BlocBuilder<TaskAddBloc, TaskAddState>(
              builder: (context, state) {
                return _TaskForm(
                  state: state,
                  onTitleChanged: (title) {
                    context.read<TaskAddBloc>().add(TaskAddTitleChanged(title));
                  },
                  onDescriptionChanged: (desc) {
                    context.read<TaskAddBloc>().add(
                      TaskAddDescriptionChanged(desc),
                    );
                  },
                  onTypeChanged: (type) {
                    context.read<TaskAddBloc>().add(TaskAddTypeChanged(type));
                  },
                  onPriorityChanged: (priority) {
                    context.read<TaskAddBloc>().add(
                      TaskAddPriorityChanged(priority),
                    );
                  },
                  onEstimatedMinutesChanged: (minutes) {
                    context.read<TaskAddBloc>().add(
                      TaskAddEstimatedMinutesChanged(minutes),
                    );
                  },
                  onDueDateChanged: (date) {
                    context.read<TaskAddBloc>().add(
                      TaskAddDueDateChanged(date),
                    );
                  },
                  onSubmit: () {
                    final authState = context.read<AppAuthBloc>().state;
                    authState.mapOrNull(
                      authenticated: (value) {
                        // Create task with user ID
                        context.read<TaskAddBloc>().add(
                          const TaskAddSubmitted(),
                        );
                      },
                      unauthenticated: (_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l.mustBeAuthenticated)),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskForm extends StatelessWidget {
  final TaskAddState state;
  final Function(String) onTitleChanged;
  final Function(String) onDescriptionChanged;
  final Function(TaskType) onTypeChanged;
  final Function(TaskPriority) onPriorityChanged;
  final Function(int) onEstimatedMinutesChanged;
  final Function(DateTime?) onDueDateChanged;
  final VoidCallback onSubmit;

  const _TaskForm({
    required this.state,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    required this.onTypeChanged,
    required this.onPriorityChanged,
    required this.onEstimatedMinutesChanged,
    required this.onDueDateChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Form(
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.surfaceContainerHighest,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.add_task_rounded,
                    color: Theme.of(context).colorScheme.primary, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Make it happen',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        )),
                      const SizedBox(height: 4),
                      Text('Give your next task a clear goal and priority.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text('TASK DETAILS',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            )),
          const SizedBox(height: 10),
          // TITLE
          TextFormField(
            initialValue: state.title,
            textCapitalization: TextCapitalization.sentences,
            maxLength: 120,
            decoration: InputDecoration(
              labelText: l.title,
              hintText: 'e.g. Finish project proposal',
              prefixIcon: const Icon(Icons.edit_note_rounded),
              errorText: state.titleError,
              errorMaxLines: 2,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
              ),
            ),
            onChanged: onTitleChanged,
            validator: (v) => v == null || v.trim().isEmpty ? l.required : null,
          ),

          // Duplicate warning
          if (state.isDuplicate && state.title.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.65),
                  border: Border.all(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.4)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_outlined,
                      color: Theme.of(context).colorScheme.error,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'A task with this title already exists',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 12),

          // DESCRIPTION
          TextFormField(
            initialValue: state.description,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l.description,
              hintText: 'Add details or notes (optional)',
              prefixIcon: const Icon(Icons.notes_rounded),
              alignLabelWithHint: true,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
            maxLines: 3,
            onChanged: onDescriptionChanged,
          ),

          const SizedBox(height: 16),

          // TYPE
          DropdownButtonFormField<TaskType>(
            initialValue: state.type,
            decoration: InputDecoration(
              labelText: l.taskType,
              prefixIcon: const Icon(Icons.category_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
            items: TaskType.values
                .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                .toList(),
            onChanged: (v) => onTypeChanged(v!),
          ),

          const SizedBox(height: 12),

          // PRIORITY
          DropdownButtonFormField<TaskPriority>(
            initialValue: state.priority,
            decoration: InputDecoration(
              labelText: l.priority,
              prefixIcon: const Icon(Icons.flag_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
            items: TaskPriority.values
                .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                .toList(),
            onChanged: (v) => onPriorityChanged(v!),
          ),

          const SizedBox(height: 12),

          // ESTIMATED TIME
          TextFormField(
            initialValue: state.estimatedMinutes.toString(),
            decoration: InputDecoration(
              labelText: l.estimatedMinutes,
              hintText: '30',
              prefixIcon: const Icon(Icons.timer_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
            keyboardType: TextInputType.number,
            onChanged: (v) {
              final parsed = int.tryParse(v);
              if (parsed != null && parsed > 0 && parsed <= 1440) {
                onEstimatedMinutesChanged(parsed);
              }
            },
          ),

          const SizedBox(height: 12),

          // DUE DATE
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: ListTile(
            leading: const Icon(Icons.event_outlined),
            title: Text(
              state.dueDate == null
                  ? l.noDueDate
                  : '${l.due}: ${_formatDueDate(state.dueDate!)}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.dueDate != null)
                  IconButton(
                    tooltip: 'Clear due date',
                    onPressed: () => onDueDateChanged(null),
                    icon: const Icon(Icons.close_rounded),
                  ),
                const Icon(Icons.calendar_today_rounded),
              ],
            ),
            onTap: () async {
              var picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                barrierDismissible: false,
                lastDate: DateTime.now().add(const Duration(days: 365)),
                initialDate: state.dueDate ?? DateTime.now(),
              );

              if (picked != null && context.mounted) {
                final pickedTime = await showTimePicker(
                  context: context,
                  barrierDismissible: false,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  final now = DateTime.now();
                  picked = picked.copyWith(
                    hour: pickedTime.hour,
                    minute: pickedTime.minute,
                    second: now.second,
                  );
                  onDueDateChanged(picked);
                }
              }
            },
            ),
          ),

          const SizedBox(height: 24),

          // SUBMIT
          ElevatedButton(
            onPressed:
                (state.isSubmitting ||
                    state.title.trim().isEmpty ||
                    state.titleError != null ||
                    state.isDuplicate ||
                    state.estimatedMinutes <= 0)
                ? null
                : onSubmit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: state.isSubmitting
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20, width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(width: 10),
                      Text('Saving task…'),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_task_rounded),
                      const SizedBox(width: 8),
                      Text(l.add),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

String _formatDueDate(DateTime dt) {
  return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} "
      "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
}
