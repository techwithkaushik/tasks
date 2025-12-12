import 'package:hive/hive.dart';
part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String content;
  @HiveField(3)
  final DateTime createdAt;
  @HiveField(4)
  final DateTime updatedAt;
  @HiveField(5)
  final TaskType type;
  @HiveField(6)
  final bool isCompleted;
  @HiveField(7)
  final DateTime? dueDate;
  @HiveField(8)
  final int? priority; // 1-5, where 5 is highest
  @HiveField(9)
  final List<String>? tags;
  @HiveField(10)
  final bool isFavorite;

  Task({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    this.isCompleted = false,
    this.dueDate,
    this.priority,
    this.tags,
    this.isFavorite = false,
  });

  // Copy with method for immutability
  Task copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    TaskType? type,
    bool? isCompleted,
    DateTime? dueDate,
    int? priority,
    List<String>? tags,
    bool? isFavorite,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      type: type ?? this.type,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

@HiveType(typeId: 1)
enum TaskType {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  monthly,
  @HiveField(3)
  yearly,
  @HiveField(4)
  atGivenTime,
  @HiveField(5)
  onceOnly,
}

// To generate the adapter, run:
// flutter packages pub run build_runner build
