// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Task {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  TaskType get type => throw _privateConstructorUsedError;
  TaskPriority get priority => throw _privateConstructorUsedError;
  TaskStatus get status => throw _privateConstructorUsedError;
  TaskStatus get lastStatus => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  int get estimatedMinutes => throw _privateConstructorUsedError;
  int? get actualMinutes => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  bool get isPrivate => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res, Task>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String? description,
      TaskType type,
      TaskPriority priority,
      TaskStatus status,
      TaskStatus lastStatus,
      DateTime? createdAt,
      DateTime? dueDate,
      DateTime? updatedAt,
      int estimatedMinutes,
      int? actualMinutes,
      List<String> tags,
      bool isPrivate,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$TaskCopyWithImpl<$Res, $Val extends Task>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? priority = null,
    Object? status = null,
    Object? lastStatus = null,
    Object? createdAt = freezed,
    Object? dueDate = freezed,
    Object? updatedAt = freezed,
    Object? estimatedMinutes = null,
    Object? actualMinutes = freezed,
    Object? tags = null,
    Object? isPrivate = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TaskType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      lastStatus: null == lastStatus
          ? _value.lastStatus
          : lastStatus // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      estimatedMinutes: null == estimatedMinutes
          ? _value.estimatedMinutes
          : estimatedMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      actualMinutes: freezed == actualMinutes
          ? _value.actualMinutes
          : actualMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
          _$TaskImpl value, $Res Function(_$TaskImpl) then) =
      __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String? description,
      TaskType type,
      TaskPriority priority,
      TaskStatus status,
      TaskStatus lastStatus,
      DateTime? createdAt,
      DateTime? dueDate,
      DateTime? updatedAt,
      int estimatedMinutes,
      int? actualMinutes,
      List<String> tags,
      bool isPrivate,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$TaskImplCopyWithImpl<$Res>
    extends _$TaskCopyWithImpl<$Res, _$TaskImpl>
    implements _$$TaskImplCopyWith<$Res> {
  __$$TaskImplCopyWithImpl(_$TaskImpl _value, $Res Function(_$TaskImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? priority = null,
    Object? status = null,
    Object? lastStatus = null,
    Object? createdAt = freezed,
    Object? dueDate = freezed,
    Object? updatedAt = freezed,
    Object? estimatedMinutes = null,
    Object? actualMinutes = freezed,
    Object? tags = null,
    Object? isPrivate = null,
    Object? metadata = null,
  }) {
    return _then(_$TaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TaskType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      lastStatus: null == lastStatus
          ? _value.lastStatus
          : lastStatus // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      estimatedMinutes: null == estimatedMinutes
          ? _value.estimatedMinutes
          : estimatedMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      actualMinutes: freezed == actualMinutes
          ? _value.actualMinutes
          : actualMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$TaskImpl implements _Task {
  const _$TaskImpl(
      {required this.id,
      required this.userId,
      required this.title,
      this.description,
      required this.type,
      required this.priority,
      required this.status,
      required this.lastStatus,
      this.createdAt,
      this.dueDate,
      this.updatedAt,
      required this.estimatedMinutes,
      this.actualMinutes,
      final List<String> tags = const [],
      this.isPrivate = false,
      final Map<String, dynamic> metadata = const {}})
      : _tags = tags,
        _metadata = metadata;

  @override
  final String id;
  @override
  final String userId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final TaskType type;
  @override
  final TaskPriority priority;
  @override
  final TaskStatus status;
  @override
  final TaskStatus lastStatus;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? dueDate;
  @override
  final DateTime? updatedAt;
  @override
  final int estimatedMinutes;
  @override
  final int? actualMinutes;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final bool isPrivate;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'Task(id: $id, userId: $userId, title: $title, description: $description, type: $type, priority: $priority, status: $status, lastStatus: $lastStatus, createdAt: $createdAt, dueDate: $dueDate, updatedAt: $updatedAt, estimatedMinutes: $estimatedMinutes, actualMinutes: $actualMinutes, tags: $tags, isPrivate: $isPrivate, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.lastStatus, lastStatus) ||
                other.lastStatus == lastStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.estimatedMinutes, estimatedMinutes) ||
                other.estimatedMinutes == estimatedMinutes) &&
            (identical(other.actualMinutes, actualMinutes) ||
                other.actualMinutes == actualMinutes) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      title,
      description,
      type,
      priority,
      status,
      lastStatus,
      createdAt,
      dueDate,
      updatedAt,
      estimatedMinutes,
      actualMinutes,
      const DeepCollectionEquality().hash(_tags),
      isPrivate,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);
}

abstract class _Task implements Task {
  const factory _Task(
      {required final String id,
      required final String userId,
      required final String title,
      final String? description,
      required final TaskType type,
      required final TaskPriority priority,
      required final TaskStatus status,
      required final TaskStatus lastStatus,
      final DateTime? createdAt,
      final DateTime? dueDate,
      final DateTime? updatedAt,
      required final int estimatedMinutes,
      final int? actualMinutes,
      final List<String> tags,
      final bool isPrivate,
      final Map<String, dynamic> metadata}) = _$TaskImpl;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get title;
  @override
  String? get description;
  @override
  TaskType get type;
  @override
  TaskPriority get priority;
  @override
  TaskStatus get status;
  @override
  TaskStatus get lastStatus;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get dueDate;
  @override
  DateTime? get updatedAt;
  @override
  int get estimatedMinutes;
  @override
  int? get actualMinutes;
  @override
  List<String> get tags;
  @override
  bool get isPrivate;
  @override
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
