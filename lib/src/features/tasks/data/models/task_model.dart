import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';

class TaskModel {
  static Map<String, dynamic> toJson(Task task) => {
    "title": task.title,
    "description": task.description,
    "type": task.type.name,
    "priority": task.priority.name,
    "status": task.status.name,
    "createdAt": task.createdAt,
    "dueDate": task.dueDate,
    "completedAt": task.completedAt,
    "estimatedMinutes": task.estimatedMinutes,
    "actualMinutes": task.actualMinutes,
    "tags": task.tags,
    "isPrivate": task.isPrivate,
    "metadata": task.metadata,
  };

  static Task fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: d["title"],
      description: d["description"],
      type: TaskType.values.byName(d["type"]),
      priority: TaskPriority.values.byName(d["priority"]),
      status: TaskStatus.values.byName(d["status"]),
      createdAt: (d["createdAt"] as Timestamp).toDate(),
      dueDate: d["dueDate"] != null
          ? (d["dueDate"] as Timestamp).toDate()
          : null,
      completedAt: d["completedAt"] != null
          ? (d["completedAt"] as Timestamp).toDate()
          : null,
      estimatedMinutes: d["estimatedMinutes"],
      actualMinutes: d["actualMinutes"],
      tags: List<String>.from(d["tags"] ?? []),
      isPrivate: d["isPrivate"] ?? false,
      metadata: Map<String, dynamic>.from(d["metadata"] ?? {}),
    );
  }
}
