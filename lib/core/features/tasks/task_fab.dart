import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/core/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:tasks/l10n/app_localizations.dart';
import 'package:tasks/core/features/tasks/presentation/cubit/task_type_cubit.dart';
import 'package:uuid/uuid.dart';

import 'data/models/task.dart';

class TaskFab extends StatelessWidget {
  const TaskFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _showAddTaskDialog(context);
      },
      child: const Icon(Icons.add),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final l = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.addTask,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: l.title,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  labelText: l.content,
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              BlocBuilder<TaskTypeCubit, TaskType>(
                builder: (context, selectedType) {
                  return DropdownButton<TaskType>(
                    value: selectedType,
                    isExpanded: true,
                    items: TaskType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        context.read<TaskTypeCubit>().setTaskType(value);
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l.cancel),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isNotEmpty &&
                          contentController.text.isNotEmpty) {
                        final task = Task(
                          id: const Uuid().v4(),
                          title: titleController.text,
                          content: contentController.text,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                          type: context.read<TaskTypeCubit>().state,
                        );
                        context.read<TaskBloc>().add(AddTaskEvent(task));
                        Navigator.pop(context);
                      }
                    },
                    child: Text(l.add),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
