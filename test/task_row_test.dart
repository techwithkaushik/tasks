import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/presentation/widgets/task_row.dart';

void main() {
  testWidgets('TaskRow renders when description is null', (tester) async {
    const task = Task(
      id: 'task-1',
      userId: 'user-1',
      title: 'Example task',
      description: null,
      type: TaskType.single,
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      lastStatus: TaskStatus.pending,
      estimatedMinutes: 15,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TaskRow(task: task),
        ),
      ),
    );

    expect(find.text('Example task'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('TaskRow renders when description is empty', (tester) async {
    const task = Task(
      id: 'task-2',
      userId: 'user-1',
      title: 'Another task',
      description: '',
      type: TaskType.single,
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      lastStatus: TaskStatus.pending,
      estimatedMinutes: 15,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TaskRow(task: task),
        ),
      ),
    );

    expect(find.text('Another task'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
