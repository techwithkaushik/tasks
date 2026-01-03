import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';

class TaskStateMachine {
  static const Map<TaskStatus, List<TaskStatus>> _allowedTransitions = {
    TaskStatus.pending: [
      TaskStatus.inProgress,
      TaskStatus.completed,
      TaskStatus.skipped,
    ],
    TaskStatus.inProgress: [TaskStatus.completed, TaskStatus.skipped],
    TaskStatus.completed: [TaskStatus.archived],
    TaskStatus.skipped: [TaskStatus.archived],
    TaskStatus.archived: [],
  };

  /// Safe check (UI / Bloc friendly)
  static bool canTransition(TaskStatus from, TaskStatus to) {
    return _allowedTransitions[from]?.contains(to) ?? false;
  }

  /// Enforced transition (Domain rule)
  static Task transition(Task task, TaskStatus to) {
    if (!canTransition(task.status, to)) {
      throw StateError('Invalid task transition: ${task.status} → $to');
    }

    return task.copyWith(
      status: to,
      completedAt: to == TaskStatus.completed
          ? DateTime.now()
          : task.completedAt,
    );
  }
}
