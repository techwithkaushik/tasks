import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/presentation/bloc/task_bloc.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  TaskType _type = TaskType.single;
  TaskPriority _priority = TaskPriority.medium;
  DateTime? _dueDate;
  int _estimatedMinutes = 30;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final task = Task(
      id: '', // Firestore generates ID
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      type: _type,
      priority: _priority,
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
      dueDate: _dueDate,
      completedAt: null,
      estimatedMinutes: _estimatedMinutes,
    );

    context.read<TaskBloc>().add(AddTaskEvent(task));

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // TITLE
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 12),

              // DESCRIPTION
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),

              const SizedBox(height: 16),

              // TYPE
              DropdownButtonFormField<TaskType>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Task Type'),
                items: TaskType.values
                    .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                    .toList(),
                onChanged: (v) => setState(() => _type = v!),
              ),

              const SizedBox(height: 12),

              // PRIORITY
              DropdownButtonFormField<TaskPriority>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: TaskPriority.values
                    .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                    .toList(),
                onChanged: (v) => setState(() => _priority = v!),
              ),

              const SizedBox(height: 12),

              // ESTIMATED TIME
              TextFormField(
                initialValue: _estimatedMinutes.toString(),
                decoration: const InputDecoration(
                  labelText: 'Estimated Minutes',
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => _estimatedMinutes = int.tryParse(v) ?? 30,
              ),

              const SizedBox(height: 12),

              // DUE DATE
              ListTile(
                title: Text(
                  _dueDate == null
                      ? 'No due date'
                      : 'Due: ${_dueDate!.toLocal()}'.split(' ')[0],
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    initialDate: _dueDate ?? DateTime.now(),
                  );

                  if (picked != null) {
                    setState(() => _dueDate = picked);
                  }
                },
              ),

              const SizedBox(height: 24),

              // SUBMIT
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Create Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
