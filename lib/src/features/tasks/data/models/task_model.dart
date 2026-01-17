import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';

class TaskModel {
  static Map<String, dynamic> toJson(Task task) => {
    "userId": task.userId,
    "title": task.title,
    "description": task.description,
    "type": task.type.name,
    "priority": task.priority.name,
    "status": task.status.name,
    "lastStatus": task.lastStatus.name,
    "createdAt": task.createdAt,
    "dueDate": task.dueDate,
    "updatedAt": task.updatedAt,
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
      userId: d["userId"],
      title: d["title"],
      description: d["description"],
      type: TaskType.values.byName(d["type"]),
      priority: TaskPriority.values.byName(d["priority"]),
      status: TaskStatus.values.byName(d["status"]),
      lastStatus: TaskStatus.values.byName(d["lastStatus"]),
      createdAt: (d["createdAt"] as Timestamp).toDate(),
      dueDate: d["dueDate"] != null
          ? (d["dueDate"] as Timestamp).toDate()
          : null,
      updatedAt: d["updatedAt"] != null
          ? (d["updatedAt"] as Timestamp).toDate()
          : null,
      estimatedMinutes: d["estimatedMinutes"],
      actualMinutes: d["actualMinutes"],
      tags: List<String>.from(d["tags"] ?? []),
      isPrivate: d["isPrivate"] ?? false,
      metadata: Map<String, dynamic>.from(d["metadata"] ?? {}),
    );
  }
}
