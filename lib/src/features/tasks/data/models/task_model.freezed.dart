// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) {
  return _TaskModel.fromJson(json);
}

/// @nodoc
mixin _$TaskModel {
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get lastStatus => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get dueDate => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  int get estimatedMinutes => throw _privateConstructorUsedError;
  int? get actualMinutes => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  bool get isPrivate => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TaskModelCopyWith<TaskModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskModelCopyWith<$Res> {
  factory $TaskModelCopyWith(TaskModel value, $Res Function(TaskModel) then) =
      _$TaskModelCopyWithImpl<$Res, TaskModel>;
  @useResult
  $Res call(
      {String userId,
      String title,
      String? description,
      String type,
      String priority,
      String status,
      String lastStatus,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? dueDate,
      @TimestampConverter() DateTime? updatedAt,
      int estimatedMinutes,
      int? actualMinutes,
      List<String> tags,
      bool isPrivate,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$TaskModelCopyWithImpl<$Res, $Val extends TaskModel>
    implements $TaskModelCopyWith<$Res> {
  _$TaskModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
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
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      lastStatus: null == lastStatus
          ? _value.lastStatus
          : lastStatus // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$TaskModelImplCopyWith<$Res>
    implements $TaskModelCopyWith<$Res> {
  factory _$$TaskModelImplCopyWith(
          _$TaskModelImpl value, $Res Function(_$TaskModelImpl) then) =
      __$$TaskModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String title,
      String? description,
      String type,
      String priority,
      String status,
      String lastStatus,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? dueDate,
      @TimestampConverter() DateTime? updatedAt,
      int estimatedMinutes,
      int? actualMinutes,
      List<String> tags,
      bool isPrivate,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$TaskModelImplCopyWithImpl<$Res>
    extends _$TaskModelCopyWithImpl<$Res, _$TaskModelImpl>
    implements _$$TaskModelImplCopyWith<$Res> {
  __$$TaskModelImplCopyWithImpl(
      _$TaskModelImpl _value, $Res Function(_$TaskModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
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
    return _then(_$TaskModelImpl(
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
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      lastStatus: null == lastStatus
          ? _value.lastStatus
          : lastStatus // ignore: cast_nullable_to_non_nullable
              as String,
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
@JsonSerializable()
class _$TaskModelImpl implements _TaskModel {
  const _$TaskModelImpl(
      {required this.userId,
      required this.title,
      this.description,
      required this.type,
      required this.priority,
      required this.status,
      required this.lastStatus,
      @TimestampConverter() this.createdAt,
      @TimestampConverter() this.dueDate,
      @TimestampConverter() this.updatedAt,
      required this.estimatedMinutes,
      this.actualMinutes,
      final List<String> tags = const [],
      this.isPrivate = false,
      final Map<String, dynamic> metadata = const {}})
      : _tags = tags,
        _metadata = metadata;

  factory _$TaskModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskModelImplFromJson(json);

  @override
  final String userId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String type;
  @override
  final String priority;
  @override
  final String status;
  @override
  final String lastStatus;
  @override
  @TimestampConverter()
  final DateTime? createdAt;
  @override
  @TimestampConverter()
  final DateTime? dueDate;
  @override
  @TimestampConverter()
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
    return 'TaskModel(userId: $userId, title: $title, description: $description, type: $type, priority: $priority, status: $status, lastStatus: $lastStatus, createdAt: $createdAt, dueDate: $dueDate, updatedAt: $updatedAt, estimatedMinutes: $estimatedMinutes, actualMinutes: $actualMinutes, tags: $tags, isPrivate: $isPrivate, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskModelImpl &&
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
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
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      __$$TaskModelImplCopyWithImpl<_$TaskModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskModelImplToJson(
      this,
    );
  }
}

abstract class _TaskModel implements TaskModel {
  const factory _TaskModel(
      {required final String userId,
      required final String title,
      final String? description,
      required final String type,
      required final String priority,
      required final String status,
      required final String lastStatus,
      @TimestampConverter() final DateTime? createdAt,
      @TimestampConverter() final DateTime? dueDate,
      @TimestampConverter() final DateTime? updatedAt,
      required final int estimatedMinutes,
      final int? actualMinutes,
      final List<String> tags,
      final bool isPrivate,
      final Map<String, dynamic> metadata}) = _$TaskModelImpl;

  factory _TaskModel.fromJson(Map<String, dynamic> json) =
      _$TaskModelImpl.fromJson;

  @override
  String get userId;
  @override
  String get title;
  @override
  String? get description;
  @override
  String get type;
  @override
  String get priority;
  @override
  String get status;
  @override
  String get lastStatus;
  @override
  @TimestampConverter()
  DateTime? get createdAt;
  @override
  @TimestampConverter()
  DateTime? get dueDate;
  @override
  @TimestampConverter()
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
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
