import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_entity.freezed.dart';

enum TaskType { single, habit, focus, recurring, location }

enum TaskPriority { low, medium, high, critical }

enum TaskStatus { pending, inProgress, completed, deleted, skipped, archived }

@Freezed()
class Task with _$Task {
  const factory Task({
    required String id,
    required String userId,
    required String title,
    String? description,
    required TaskType type,
    required TaskPriority priority,
    required TaskStatus status,
    required TaskStatus lastStatus,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? updatedAt,
    required int estimatedMinutes,
    int? actualMinutes,
    @Default([]) List<String> tags,
    @Default(false) bool isPrivate,
    @Default({}) Map<String, dynamic> metadata,
  }) = _Task;
}

extension TaskEntityX on Task {
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "title": title,
      "description": description,
      "type": type.name,
      "priority": priority.name,
      "status": status.name,
      "lastStatus": lastStatus.name,
      "createdAt": createdAt,
      "dueDate": dueDate,
      "updatedAt": updatedAt,
      "estimatedMinutes": estimatedMinutes,
      "actualMinutes": actualMinutes,
      "tags": tags,
      "isPrivate": isPrivate,
      "metadata": metadata,
    };
  }
}
