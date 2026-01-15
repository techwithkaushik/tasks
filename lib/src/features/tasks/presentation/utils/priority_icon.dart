import '../../domain/entities/task_entity.dart';

String priorityIcon(TaskPriority p) {
  return switch (p) {
    TaskPriority.low => "🟢",
    TaskPriority.medium => "🔵",
    TaskPriority.high => "🟠",
    TaskPriority.critical => "🔴",
  };
}
