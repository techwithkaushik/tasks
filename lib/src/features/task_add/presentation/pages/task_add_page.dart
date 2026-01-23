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
        appBar: AppBar(title: Text(l.addTask)),
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
          // TITLE
          TextFormField(
            initialValue: state.title,
            decoration: InputDecoration(
              labelText: l.title,
              errorText: state.titleError,
              errorMaxLines: 2,
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
                  color: Colors.orange[50],
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_outlined,
                      color: Colors.orange[700],
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'A task with this title already exists',
                        style: TextStyle(
                          color: Colors.orange[700],
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
            decoration: InputDecoration(labelText: l.description),
            maxLines: 3,
            onChanged: onDescriptionChanged,
          ),

          const SizedBox(height: 16),

          // TYPE
          DropdownButtonFormField<TaskType>(
            initialValue: state.type,
            decoration: InputDecoration(labelText: l.taskType),
            items: TaskType.values
                .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                .toList(),
            onChanged: (v) => onTypeChanged(v!),
          ),

          const SizedBox(height: 12),

          // PRIORITY
          DropdownButtonFormField<TaskPriority>(
            initialValue: state.priority,
            decoration: InputDecoration(labelText: l.priority),
            items: TaskPriority.values
                .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                .toList(),
            onChanged: (v) => onPriorityChanged(v!),
          ),

          const SizedBox(height: 12),

          // ESTIMATED TIME
          TextFormField(
            initialValue: state.estimatedMinutes.toString(),
            decoration: InputDecoration(labelText: l.estimatedMinutes),
            keyboardType: TextInputType.number,
            onChanged: (v) => onEstimatedMinutesChanged(int.tryParse(v) ?? 30),
          ),

          const SizedBox(height: 12),

          // DUE DATE
          ListTile(
            title: Text(
              state.dueDate == null
                  ? l.noDueDate
                  : '${l.due}: ${_formatDueDate(state.dueDate!)}',
            ),
            trailing: const Icon(Icons.calendar_today),
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

          const SizedBox(height: 24),

          // SUBMIT
          ElevatedButton(
            onPressed:
                (state.isSubmitting ||
                    state.titleError != null ||
                    state.isDuplicate)
                ? null
                : onSubmit,
            child: state.isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l.add),
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
