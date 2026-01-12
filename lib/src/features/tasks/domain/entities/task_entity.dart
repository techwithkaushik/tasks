enum TaskType { single, habit, focus, recurring, location }

enum TaskPriority { low, medium, high, critical }

enum TaskStatus { pending, inProgress, completed, skipped, archived }

class Task {
  final String id;
  final String userId;
  final String title;
  final String? description;

  final TaskType type;
  final TaskPriority priority;
  final TaskStatus status;

  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? completedAt;

  final int estimatedMinutes;
  final int? actualMinutes;

  final List<String> tags;
  final bool isPrivate;
  final Map<String, dynamic> metadata;

  const Task({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.type,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
    required this.estimatedMinutes,
    this.actualMinutes,
    this.tags = const [],
    this.isPrivate = false,
    this.metadata = const {},
  });

  Task copyWith({
    TaskStatus? status,
    DateTime? dueDate,
    DateTime? completedAt,
  }) {
    return Task(
      id: id,
      userId: userId,
      title: title,
      description: description,
      type: type,
      priority: priority,
      status: status ?? this.status,
      createdAt: createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      estimatedMinutes: estimatedMinutes,
      actualMinutes: actualMinutes,
      tags: tags,
      isPrivate: isPrivate,
      metadata: metadata,
    );
  }
}
