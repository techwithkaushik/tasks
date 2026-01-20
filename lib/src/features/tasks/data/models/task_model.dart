import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks/src/features/tasks/data/models/timestamp_converter.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@Freezed()
class TaskModel with _$TaskModel {
  const factory TaskModel({
    required String userId,
    required String title,
    String? description,
    required String type,
    required String priority,
    required String status,
    required String lastStatus,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? dueDate,
    @TimestampConverter() DateTime? updatedAt,
    required int estimatedMinutes,
    int? actualMinutes,
    @Default([]) List<String> tags,
    @Default(false) bool isPrivate,
    @Default({}) Map<String, dynamic> metadata,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  // Firestore Document → Model
  factory TaskModel.fromDoc(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;
    return TaskModel.fromJson(json);
  }
}

extension TaskModelX on TaskModel {
  Task toEntity(String id) {
    return Task(
      id: id,
      userId: userId,
      title: title,
      description: description,
      type: TaskType.values.byName(type),
      priority: TaskPriority.values.byName(priority),
      status: TaskStatus.values.byName(status),
      lastStatus: TaskStatus.values.byName(lastStatus),
      createdAt: createdAt,
      dueDate: dueDate,
      updatedAt: updatedAt,
      estimatedMinutes: estimatedMinutes,
      actualMinutes: actualMinutes,
      tags: tags,
      isPrivate: isPrivate,
      metadata: metadata,
    );
  }
}
