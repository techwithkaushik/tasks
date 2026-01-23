// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskModelImpl _$$TaskModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskModelImpl(
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      priority: json['priority'] as String,
      status: json['status'] as String,
      lastStatus: json['lastStatus'] as String,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      dueDate: const TimestampConverter().fromJson(json['dueDate']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
      estimatedMinutes: (json['estimatedMinutes'] as num).toInt(),
      actualMinutes: (json['actualMinutes'] as num?)?.toInt(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      isPrivate: json['isPrivate'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$TaskModelImplToJson(_$TaskModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'priority': instance.priority,
      'status': instance.status,
      'lastStatus': instance.lastStatus,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'dueDate': const TimestampConverter().toJson(instance.dueDate),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'estimatedMinutes': instance.estimatedMinutes,
      'actualMinutes': instance.actualMinutes,
      'tags': instance.tags,
      'isPrivate': instance.isPrivate,
      'metadata': instance.metadata,
    };
