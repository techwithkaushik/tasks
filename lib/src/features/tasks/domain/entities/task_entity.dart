enum TaskType { single, habit, focus, recurring, location }

enum TaskPriority { low, medium, high, critical }

enum TaskStatus { pending, inProgress, completed, deleted, skipped, archived }

class Task {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final TaskType type;
  final TaskPriority priority;
  final TaskStatus status;
  final TaskStatus lastStatus;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? updatedAt;
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
    required this.lastStatus,
    required this.createdAt,
    this.dueDate,
    this.updatedAt,
    required this.estimatedMinutes,
    this.actualMinutes,
    this.tags = const [],
    this.isPrivate = false,
    this.metadata = const {},
  });

  Task copyWith({
    String? title,
    String? description,
    TaskType? type,
    TaskPriority? priority,
    TaskStatus? status,
    TaskStatus? lastStatus,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? updatedAt,
    int? estimatedMinutes,
    int? actualMinutes,
    List<String>? tags,
    bool? isPrivate,
    Map<String, dynamic>? metadata,
  }) {
    return Task(
      id: id,
      userId: userId,
      title: title ?? this.title,
      description: description,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      lastStatus: lastStatus ?? this.lastStatus,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      updatedAt: updatedAt ?? this.updatedAt,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      actualMinutes: actualMinutes ?? this.actualMinutes,
      tags: tags ?? this.tags,
      isPrivate: isPrivate ?? this.isPrivate,
      metadata: metadata ?? this.metadata,
    );
  }
}
