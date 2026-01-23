// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TaskEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function() stop,
    required TResult Function(Task task) add,
    required TResult Function(Task task) update,
    required TResult Function(
      String taskId,
      TaskStatus status,
      bool showSnackBar,
    )
    updateStatus,
    required TResult Function(String taskId) delete,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function()? stop,
    TResult? Function(Task task)? add,
    TResult? Function(Task task)? update,
    TResult? Function(String taskId, TaskStatus status, bool showSnackBar)?
    updateStatus,
    TResult? Function(String taskId)? delete,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function()? stop,
    TResult Function(Task task)? add,
    TResult Function(Task task)? update,
    TResult Function(String taskId, TaskStatus status, bool showSnackBar)?
    updateStatus,
    TResult Function(String taskId)? delete,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Load value) load,
    required TResult Function(_Stop value) stop,
    required TResult Function(_Add value) add,
    required TResult Function(_Update value) update,
    required TResult Function(_UpdateStatus value) updateStatus,
    required TResult Function(_Delete value) delete,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Load value)? load,
    TResult? Function(_Stop value)? stop,
    TResult? Function(_Add value)? add,
    TResult? Function(_Update value)? update,
    TResult? Function(_UpdateStatus value)? updateStatus,
    TResult? Function(_Delete value)? delete,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Load value)? load,
    TResult Function(_Stop value)? stop,
    TResult Function(_Add value)? add,
    TResult Function(_Update value)? update,
    TResult Function(_UpdateStatus value)? updateStatus,
    TResult Function(_Delete value)? delete,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskEventCopyWith<$Res> {
  factory $TaskEventCopyWith(TaskEvent value, $Res Function(TaskEvent) then) =
      _$TaskEventCopyWithImpl<$Res, TaskEvent>;
}

/// @nodoc
class _$TaskEventCopyWithImpl<$Res, $Val extends TaskEvent>
    implements $TaskEventCopyWith<$Res> {
  _$TaskEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LoadImplCopyWith<$Res> {
  factory _$$LoadImplCopyWith(
    _$LoadImpl value,
    $Res Function(_$LoadImpl) then,
  ) = __$$LoadImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadImplCopyWithImpl<$Res>
    extends _$TaskEventCopyWithImpl<$Res, _$LoadImpl>
    implements _$$LoadImplCopyWith<$Res> {
  __$$LoadImplCopyWithImpl(_$LoadImpl _value, $Res Function(_$LoadImpl) _then)
    : super(_value, _then);
}

/// @nodoc

class _$LoadImpl implements _Load {
  const _$LoadImpl();

  @override
  String toString() {
    return 'TaskEvent.load()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function() stop,
    required TResult Function(Task task) add,
    required TResult Function(Task task) update,
    required TResult Function(
      String taskId,
      TaskStatus status,
      bool showSnackBar,
    )
    updateStatus,
    required TResult Function(String taskId) delete,
  }) {
    return load();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function()? stop,
    TResult? Function(Task task)? add,
    TResult? Function(Task task)? update,
    TResult? Function(String taskId, TaskStatus status, bool showSnackBar)?
    updateStatus,
    TResult? Function(String taskId)? delete,
  }) {
    return load?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function()? stop,
    TResult Function(Task task)? add,
    TResult Function(Task task)? update,
    TResult Function(String taskId, TaskStatus status, bool showSnackBar)?
    updateStatus,
    TResult Function(String taskId)? delete,
    required TResult orElse(),
  }) {
    if (load != null) {
      return load();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Load value) load,
    required TResult Function(_Stop value) stop,
    required TResult Function(_Add value) add,
    required TResult Function(_Update value) update,
    required TResult Function(_UpdateStatus value) updateStatus,
    required TResult Function(_Delete value) delete,
  }) {
    return load(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Load value)? load,
    TResult? Function(_Stop value)? stop,
    TResult? Function(_Add value)? add,
    TResult? Function(_Update value)? update,
    TResult? Function(_UpdateStatus value)? updateStatus,
    TResult? Function(_Delete value)? delete,
  }) {
    return load?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Load value)? load,
    TResult Function(_Stop value)? stop,
    TResult Function(_Add value)? add,
    TResult Function(_Update value)? update,
    TResult Function(_UpdateStatus value)? updateStatus,
    TResult Function(_Delete value)? delete,
    required TResult orElse(),
  }) {
    if (load != null) {
      return load(this);
    }
    return orElse();
  }
}

abstract class _Load implements TaskEvent {
  const factory _Load() = _$LoadImpl;
}

/// @nodoc
abstract class _$$StopImplCopyWith<$Res> {
  factory _$$StopImplCopyWith(
    _$StopImpl value,
    $Res Function(_$StopImpl) then,
  ) = __$$StopImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StopImplCopyWithImpl<$Res>
    extends _$TaskEventCopyWithImpl<$Res, _$StopImpl>
    implements _$$StopImplCopyWith<$Res> {
  __$$StopImplCopyWithImpl(_$StopImpl _value, $Res Function(_$StopImpl) _then)
    : super(_value, _then);
}

/// @nodoc

class _$StopImpl implements _Stop {
  const _$StopImpl();

  @override
  String toString() {
    return 'TaskEvent.stop()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StopImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function() stop,
    required TResult Function(Task task) add,
    required TResult Function(Task task) update,
    required TResult Function(
      String taskId,
      TaskStatus status,
      bool showSnackBar,
    )
    updateStatus,
    required TResult Function(String taskId) delete,
  }) {
    return stop();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function()? stop,
    TResult? Function(Task task)? add,
    TResult? Function(Task task)? update,
    TResult? Function(String taskId, TaskStatus status, bool showSnackBar)?
    updateStatus,
    TResult? Function(String taskId)? delete,
  }) {
    return stop?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function()? stop,
    TResult Function(Task task)? add,
    TResult Function(Task task)? update,
    TResult Function(String taskId, TaskStatus status, bool showSnackBar)?
    updateStatus,
    TResult Function(String taskId)? delete,
    required TResult orElse(),
  }) {
    if (stop != null) {
      return stop();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Load value) load,
    required TResult Function(_Stop value) stop,
    required TResult Function(_Add value) add,
    required TResult Function(_Update value) update,
    required TResult Function(_UpdateStatus value) updateStatus,
    required TResult Function(_Delete value) delete,
  }) {
    return stop(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Load value)? load,
    TResult? Function(_Stop value)? stop,
    TResult? Function(_Add value)? add,
    TResult? Function(_Update value)? update,
    TResult? Function(_UpdateStatus value)? updateStatus,
    TResult? Function(_Delete value)? delete,
  }) {
    return stop?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Load value)? load,
    TResult Function(_Stop value)? stop,
    TResult Function(_Add value)? add,
    TResult Function(_Update value)? update,
    TResult Function(_UpdateStatus value)? updateStatus,
    TResult Function(_Delete value)? delete,
    required TResult orElse(),
  }) {
    if (stop != null) {
      return stop(this);
    }
    return orElse();
  }
}

abstract class _Stop implements TaskEvent {
  const factory _Stop() = _$StopImpl;
}

/// @nodoc
abstract class _$$AddImplCopyWith<$Res> {
  factory _$$AddImplCopyWith(_$AddImpl value, $Res Function(_$AddImpl) then) =
      __$$AddImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Task task});

  $TaskCopyWith<$Res> get task;
}

/// @nodoc
class __$$AddImplCopyWithImpl<$Res>
    extends _$TaskEventCopyWithImpl<$Res, _$AddImpl>
    implements _$$AddImplCopyWith<$Res> {
  __$$AddImplCopyWithImpl(_$AddImpl _value, $Res Function(_$AddImpl) _then)
    : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? task = null}) {
    return _then(
      _$AddImpl(
        null == task
            ? _value.task
            : task // ignore: cast_nullable_to_non_nullable
                  as Task,
      ),
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $TaskCopyWith<$Res> get task {
    return $TaskCopyWith<$Res>(_value.task, (value) {
      return _then(_value.copyWith(task: value));
    });
  }
}

/// @nodoc

class _$AddImpl implements _Add {
  const _$AddImpl(this.task);

  @override
  final Task task;

  @override
  String toString() {
    return 'TaskEvent.add(task: $task)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddImpl &&
            (identical(other.task, task) || other.task == task));
  }

  @override
  int get hashCode => Object.hash(runtimeType, task);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddImplCopyWith<_$AddImpl> get copyWith =>
      __$$AddImplCopyWithImpl<_$AddImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function() stop,
    required TResult Function(Task task) add,
    required TResult Function(Task task) update,
    required TResult Function(
      String taskId,
      TaskStatus status,
      bool showSnackBar,
    )
    updateStatus,
    required TResult Function(String taskId) delete,
  }) {
    return add(task);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function()? stop,
    TResult? Function(Task task)? add,
    TResult? Function(Task task)? update,
    TResult? Function(String taskId, TaskStatus status, bool showSnackBar)?
    updateStatus,
    TResult? Function(String taskId)? delete,
  }) {
    return add?.call(task);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function()? stop,
    TResult Function(Task task)? add,
    TResult Function(Task task)? update,
    TResult Function(String taskId, TaskStatus status, bool showSnackBar)?
    updateStatus,
    TResult Function(String taskId)? delete,
    required TResult orElse(),
  }) {
    if (add != null) {
      return add(task);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Load value) load,
    required TResult Function(_Stop value) stop,
    required TResult Function(_Add value) add,
    required TResult Function(_Update value) update,
    required TResult Function(_UpdateStatus value) updateStatus,
    required TResult Function(_Delete value) delete,
  }) {
    return add(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Load value)? load,
    TResult? Function(_Stop value)? stop,
    TResult? Function(_Add value)? add,
    TResult? Function(_Update value)? update,
    TResult? Function(_UpdateStatus value)? updateStatus,
    TResult? Function(_Delete value)? delete,
  }) {
    return add?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Load value)? load,
    TResult Function(_Stop value)? stop,
    TResult Function(_Add value)? add,
    TResult Function(_Update value)? update,
    TResult Function(_UpdateStatus value)? updateStatus,
    TResult Function(_Delete value)? delete,
    required TResult orElse(),
  }) {
    if (add != null) {
      return add(this);
    }
    return orElse();
  }
}

abstract class _Add implements TaskEvent {
  const factory _Add(final Task task) = _$AddImpl;

  Task get task;
  @JsonKey(ignore: true)
  _$$AddImplCopyWith<_$AddImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateImplCopyWith<$Res> {
  factory _$$UpdateImplCopyWith(
    _$UpdateImpl value,
    $Res Function(_$UpdateImpl) then,
  ) = __$$UpdateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Task task});

  $TaskCopyWith<$Res> get task;
}

/// @nodoc
class __$$UpdateImplCopyWithImpl<$Res>
    extends _$TaskEventCopyWithImpl<$Res, _$UpdateImpl>
    implements _$$UpdateImplCopyWith<$Res> {
  __$$UpdateImplCopyWithImpl(
    _$UpdateImpl _value,
    $Res Function(_$UpdateImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? task = null}) {
    return _then(
      _$UpdateImpl(
        null == task
            ? _value.task
            : task // ignore: cast_nullable_to_non_nullable
                  as Task,
      ),
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $TaskCopyWith<$Res> get task {
    return $TaskCopyWith<$Res>(_value.task, (value) {
      return _then(_value.copyWith(task: value));
    });
  }
}

/// @nodoc

class _$UpdateImpl implements _Update {
  const _$UpdateImpl(this.task);

  @override
  final Task task;

  @override
  String toString() {
    return 'TaskEvent.update(task: $task)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateImpl &&
            (identical(other.task, task) || other.task == task));
  }

  @override
  int get hashCode => Object.hash(runtimeType, task);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateImplCopyWith<_$UpdateImpl> get copyWith =>
      __$$UpdateImplCopyWithImpl<_$UpdateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function() stop,
    required TResult Function(Task task) add,
    required TResult Function(Task task) update,
    required TResult Function(
      String taskId,
      TaskStatus status,
      bool showSnackBar,
    )
    updateStatus,
    required TResult Function(String taskId) delete,
  }) {
    return update(task);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function()? stop,
    TResult? Function(Task task)? add,
    TResult? Function(Task task)? update,
    TResult? Function(String taskId, TaskStatus status, bool showSnackBar)?
    updateStatus,
    TResult? Function(String taskId)? delete,
  }) {
    return update?.call(task);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function()? stop,
    TResult Function(Task task)? add,
    TResult Function(Task task)? update,
    TResult Function(String taskId, TaskStatus status, bool showSnackBar)?
    updateStatus,
    TResult Function(String taskId)? delete,
    required TResult orElse(),
  }) {
    if (update != null) {
      return update(task);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Load value) load,
    required TResult Function(_Stop value) stop,
    required TResult Function(_Add value) add,
    required TResult Function(_Update value) update,
    required TResult Function(_UpdateStatus value) updateStatus,
    required TResult Function(_Delete value) delete,
  }) {
    return update(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Load value)? load,
    TResult? Function(_Stop value)? stop,
    TResult? Function(_Add value)? add,
    TResult? Function(_Update value)? update,
    TResult? Function(_UpdateStatus value)? updateStatus,
    TResult? Function(_Delete value)? delete,
  }) {
    return update?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Load value)? load,
    TResult Function(_Stop value)? stop,
    TResult Function(_Add value)? add,
    TResult Function(_Update value)? update,
    TResult Function(_UpdateStatus value)? updateStatus,
    TResult Function(_Delete value)? delete,
    required TResult orElse(),
  }) {
    if (update != null) {
      return update(this);
    }
    return orElse();
  }
}

abstract class _Update implements TaskEvent {
  const factory _Update(final Task task) = _$UpdateImpl;

  Task get task;
  @JsonKey(ignore: true)
  _$$UpdateImplCopyWith<_$UpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateStatusImplCopyWith<$Res> {
  factory _$$UpdateStatusImplCopyWith(
    _$UpdateStatusImpl value,
    $Res Function(_$UpdateStatusImpl) then,
  ) = __$$UpdateStatusImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String taskId, TaskStatus status, bool showSnackBar});
}

/// @nodoc
class __$$UpdateStatusImplCopyWithImpl<$Res>
    extends _$TaskEventCopyWithImpl<$Res, _$UpdateStatusImpl>
    implements _$$UpdateStatusImplCopyWith<$Res> {
  __$$UpdateStatusImplCopyWithImpl(
    _$UpdateStatusImpl _value,
    $Res Function(_$UpdateStatusImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? status = null,
    Object? showSnackBar = null,
  }) {
    return _then(
      _$UpdateStatusImpl(
        taskId: null == taskId
            ? _value.taskId
            : taskId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TaskStatus,
        showSnackBar: null == showSnackBar
            ? _value.showSnackBar
            : showSnackBar // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$UpdateStatusImpl implements _UpdateStatus {
  const _$UpdateStatusImpl({
    required this.taskId,
    required this.status,
    this.showSnackBar = false,
  });

  @override
  final String taskId;
  @override
  final TaskStatus status;
  @override
  @JsonKey()
  final bool showSnackBar;

  @override
  String toString() {
    return 'TaskEvent.updateStatus(taskId: $taskId, status: $status, showSnackBar: $showSnackBar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateStatusImpl &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.showSnackBar, showSnackBar) ||
                other.showSnackBar == showSnackBar));
  }

  @override
  int get hashCode => Object.hash(runtimeType, taskId, status, showSnackBar);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateStatusImplCopyWith<_$UpdateStatusImpl> get copyWith =>
      __$$UpdateStatusImplCopyWithImpl<_$UpdateStatusImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function() stop,
    required TResult Function(Task task) add,
    required TResult Function(Task task) update,
    required TResult Function(
      String taskId,
      TaskStatus status,
      bool showSnackBar,
    )
    updateStatus,
    required TResult Function(String taskId) delete,
  }) {
    return updateStatus(taskId, status, showSnackBar);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function()? stop,
    TResult? Function(Task task)? add,
    TResult? Function(Task task)? update,
    TResult? Function(String taskId, TaskStatus status, bool showSnackBar)?
    updateStatus,
    TResult? Function(String taskId)? delete,
  }) {
    return updateStatus?.call(taskId, status, showSnackBar);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function()? stop,
    TResult Function(Task task)? add,
    TResult Function(Task task)? update,
    TResult Function(String taskId, TaskStatus status, bool showSnackBar)?
    updateStatus,
    TResult Function(String taskId)? delete,
    required TResult orElse(),
  }) {
    if (updateStatus != null) {
      return updateStatus(taskId, status, showSnackBar);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Load value) load,
    required TResult Function(_Stop value) stop,
    required TResult Function(_Add value) add,
    required TResult Function(_Update value) update,
    required TResult Function(_UpdateStatus value) updateStatus,
    required TResult Function(_Delete value) delete,
  }) {
    return updateStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Load value)? load,
    TResult? Function(_Stop value)? stop,
    TResult? Function(_Add value)? add,
    TResult? Function(_Update value)? update,
    TResult? Function(_UpdateStatus value)? updateStatus,
    TResult? Function(_Delete value)? delete,
  }) {
    return updateStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Load value)? load,
    TResult Function(_Stop value)? stop,
    TResult Function(_Add value)? add,
    TResult Function(_Update value)? update,
    TResult Function(_UpdateStatus value)? updateStatus,
    TResult Function(_Delete value)? delete,
    required TResult orElse(),
  }) {
    if (updateStatus != null) {
      return updateStatus(this);
    }
    return orElse();
  }
}

abstract class _UpdateStatus implements TaskEvent {
  const factory _UpdateStatus({
    required final String taskId,
    required final TaskStatus status,
    final bool showSnackBar,
  }) = _$UpdateStatusImpl;

  String get taskId;
  TaskStatus get status;
  bool get showSnackBar;
  @JsonKey(ignore: true)
  _$$UpdateStatusImplCopyWith<_$UpdateStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteImplCopyWith<$Res> {
  factory _$$DeleteImplCopyWith(
    _$DeleteImpl value,
    $Res Function(_$DeleteImpl) then,
  ) = __$$DeleteImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String taskId});
}

/// @nodoc
class __$$DeleteImplCopyWithImpl<$Res>
    extends _$TaskEventCopyWithImpl<$Res, _$DeleteImpl>
    implements _$$DeleteImplCopyWith<$Res> {
  __$$DeleteImplCopyWithImpl(
    _$DeleteImpl _value,
    $Res Function(_$DeleteImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? taskId = null}) {
    return _then(
      _$DeleteImpl(
        null == taskId
            ? _value.taskId
            : taskId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DeleteImpl implements _Delete {
  const _$DeleteImpl(this.taskId);

  @override
  final String taskId;

  @override
  String toString() {
    return 'TaskEvent.delete(taskId: $taskId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteImpl &&
            (identical(other.taskId, taskId) || other.taskId == taskId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, taskId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteImplCopyWith<_$DeleteImpl> get copyWith =>
      __$$DeleteImplCopyWithImpl<_$DeleteImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function() stop,
    required TResult Function(Task task) add,
    required TResult Function(Task task) update,
    required TResult Function(
      String taskId,
      TaskStatus status,
      bool showSnackBar,
    )
    updateStatus,
    required TResult Function(String taskId) delete,
  }) {
    return delete(taskId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function()? stop,
    TResult? Function(Task task)? add,
    TResult? Function(Task task)? update,
    TResult? Function(String taskId, TaskStatus status, bool showSnackBar)?
    updateStatus,
    TResult? Function(String taskId)? delete,
  }) {
    return delete?.call(taskId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function()? stop,
    TResult Function(Task task)? add,
    TResult Function(Task task)? update,
    TResult Function(String taskId, TaskStatus status, bool showSnackBar)?
    updateStatus,
    TResult Function(String taskId)? delete,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete(taskId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Load value) load,
    required TResult Function(_Stop value) stop,
    required TResult Function(_Add value) add,
    required TResult Function(_Update value) update,
    required TResult Function(_UpdateStatus value) updateStatus,
    required TResult Function(_Delete value) delete,
  }) {
    return delete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Load value)? load,
    TResult? Function(_Stop value)? stop,
    TResult? Function(_Add value)? add,
    TResult? Function(_Update value)? update,
    TResult? Function(_UpdateStatus value)? updateStatus,
    TResult? Function(_Delete value)? delete,
  }) {
    return delete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Load value)? load,
    TResult Function(_Stop value)? stop,
    TResult Function(_Add value)? add,
    TResult Function(_Update value)? update,
    TResult Function(_UpdateStatus value)? updateStatus,
    TResult Function(_Delete value)? delete,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete(this);
    }
    return orElse();
  }
}

abstract class _Delete implements TaskEvent {
  const factory _Delete(final String taskId) = _$DeleteImpl;

  String get taskId;
  @JsonKey(ignore: true)
  _$$DeleteImplCopyWith<_$DeleteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TaskState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Task> tasks) data,
    required TResult Function(String message) error,
    required TResult Function(
      String message,
      String taskId,
      TaskStatus previous,
    )
    effect,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Task> tasks)? data,
    TResult? Function(String message)? error,
    TResult? Function(String message, String taskId, TaskStatus previous)?
    effect,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Task> tasks)? data,
    TResult Function(String message)? error,
    TResult Function(String message, String taskId, TaskStatus previous)?
    effect,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Loading value) loading,
    required TResult Function(_Data value) data,
    required TResult Function(_Error value) error,
    required TResult Function(_Effect value) effect,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Data value)? data,
    TResult? Function(_Error value)? error,
    TResult? Function(_Effect value)? effect,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Data value)? data,
    TResult Function(_Error value)? error,
    TResult Function(_Effect value)? effect,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskStateCopyWith<$Res> {
  factory $TaskStateCopyWith(TaskState value, $Res Function(TaskState) then) =
      _$TaskStateCopyWithImpl<$Res, TaskState>;
}

/// @nodoc
class _$TaskStateCopyWithImpl<$Res, $Val extends TaskState>
    implements $TaskStateCopyWith<$Res> {
  _$TaskStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
    _$LoadingImpl value,
    $Res Function(_$LoadingImpl) then,
  ) = __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$TaskStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
    _$LoadingImpl _value,
    $Res Function(_$LoadingImpl) _then,
  ) : super(_value, _then);
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'TaskState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Task> tasks) data,
    required TResult Function(String message) error,
    required TResult Function(
      String message,
      String taskId,
      TaskStatus previous,
    )
    effect,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Task> tasks)? data,
    TResult? Function(String message)? error,
    TResult? Function(String message, String taskId, TaskStatus previous)?
    effect,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Task> tasks)? data,
    TResult Function(String message)? error,
    TResult Function(String message, String taskId, TaskStatus previous)?
    effect,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Loading value) loading,
    required TResult Function(_Data value) data,
    required TResult Function(_Error value) error,
    required TResult Function(_Effect value) effect,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Data value)? data,
    TResult? Function(_Error value)? error,
    TResult? Function(_Effect value)? effect,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Data value)? data,
    TResult Function(_Error value)? error,
    TResult Function(_Effect value)? effect,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements TaskState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$DataImplCopyWith<$Res> {
  factory _$$DataImplCopyWith(
    _$DataImpl value,
    $Res Function(_$DataImpl) then,
  ) = __$$DataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Task> tasks});
}

/// @nodoc
class __$$DataImplCopyWithImpl<$Res>
    extends _$TaskStateCopyWithImpl<$Res, _$DataImpl>
    implements _$$DataImplCopyWith<$Res> {
  __$$DataImplCopyWithImpl(_$DataImpl _value, $Res Function(_$DataImpl) _then)
    : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tasks = null}) {
    return _then(
      _$DataImpl(
        tasks: null == tasks
            ? _value._tasks
            : tasks // ignore: cast_nullable_to_non_nullable
                  as List<Task>,
      ),
    );
  }
}

/// @nodoc

class _$DataImpl implements _Data {
  const _$DataImpl({required final List<Task> tasks}) : _tasks = tasks;

  final List<Task> _tasks;
  @override
  List<Task> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  @override
  String toString() {
    return 'TaskState.data(tasks: $tasks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataImpl &&
            const DeepCollectionEquality().equals(other._tasks, _tasks));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_tasks));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DataImplCopyWith<_$DataImpl> get copyWith =>
      __$$DataImplCopyWithImpl<_$DataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Task> tasks) data,
    required TResult Function(String message) error,
    required TResult Function(
      String message,
      String taskId,
      TaskStatus previous,
    )
    effect,
  }) {
    return data(tasks);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Task> tasks)? data,
    TResult? Function(String message)? error,
    TResult? Function(String message, String taskId, TaskStatus previous)?
    effect,
  }) {
    return data?.call(tasks);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Task> tasks)? data,
    TResult Function(String message)? error,
    TResult Function(String message, String taskId, TaskStatus previous)?
    effect,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(tasks);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Loading value) loading,
    required TResult Function(_Data value) data,
    required TResult Function(_Error value) error,
    required TResult Function(_Effect value) effect,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Data value)? data,
    TResult? Function(_Error value)? error,
    TResult? Function(_Effect value)? effect,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Data value)? data,
    TResult Function(_Error value)? error,
    TResult Function(_Effect value)? effect,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class _Data implements TaskState {
  const factory _Data({required final List<Task> tasks}) = _$DataImpl;

  List<Task> get tasks;
  @JsonKey(ignore: true)
  _$$DataImplCopyWith<_$DataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
    _$ErrorImpl value,
    $Res Function(_$ErrorImpl) then,
  ) = __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$TaskStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
    _$ErrorImpl _value,
    $Res Function(_$ErrorImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'TaskState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Task> tasks) data,
    required TResult Function(String message) error,
    required TResult Function(
      String message,
      String taskId,
      TaskStatus previous,
    )
    effect,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Task> tasks)? data,
    TResult? Function(String message)? error,
    TResult? Function(String message, String taskId, TaskStatus previous)?
    effect,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Task> tasks)? data,
    TResult Function(String message)? error,
    TResult Function(String message, String taskId, TaskStatus previous)?
    effect,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Loading value) loading,
    required TResult Function(_Data value) data,
    required TResult Function(_Error value) error,
    required TResult Function(_Effect value) effect,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Data value)? data,
    TResult? Function(_Error value)? error,
    TResult? Function(_Effect value)? effect,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Data value)? data,
    TResult Function(_Error value)? error,
    TResult Function(_Effect value)? effect,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements TaskState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EffectImplCopyWith<$Res> {
  factory _$$EffectImplCopyWith(
    _$EffectImpl value,
    $Res Function(_$EffectImpl) then,
  ) = __$$EffectImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, String taskId, TaskStatus previous});
}

/// @nodoc
class __$$EffectImplCopyWithImpl<$Res>
    extends _$TaskStateCopyWithImpl<$Res, _$EffectImpl>
    implements _$$EffectImplCopyWith<$Res> {
  __$$EffectImplCopyWithImpl(
    _$EffectImpl _value,
    $Res Function(_$EffectImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? taskId = null,
    Object? previous = null,
  }) {
    return _then(
      _$EffectImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        taskId: null == taskId
            ? _value.taskId
            : taskId // ignore: cast_nullable_to_non_nullable
                  as String,
        previous: null == previous
            ? _value.previous
            : previous // ignore: cast_nullable_to_non_nullable
                  as TaskStatus,
      ),
    );
  }
}

/// @nodoc

class _$EffectImpl implements _Effect {
  const _$EffectImpl({
    required this.message,
    required this.taskId,
    required this.previous,
  });

  @override
  final String message;
  @override
  final String taskId;
  @override
  final TaskStatus previous;

  @override
  String toString() {
    return 'TaskState.effect(message: $message, taskId: $taskId, previous: $previous)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EffectImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.previous, previous) ||
                other.previous == previous));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, taskId, previous);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EffectImplCopyWith<_$EffectImpl> get copyWith =>
      __$$EffectImplCopyWithImpl<_$EffectImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(List<Task> tasks) data,
    required TResult Function(String message) error,
    required TResult Function(
      String message,
      String taskId,
      TaskStatus previous,
    )
    effect,
  }) {
    return effect(message, taskId, previous);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(List<Task> tasks)? data,
    TResult? Function(String message)? error,
    TResult? Function(String message, String taskId, TaskStatus previous)?
    effect,
  }) {
    return effect?.call(message, taskId, previous);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(List<Task> tasks)? data,
    TResult Function(String message)? error,
    TResult Function(String message, String taskId, TaskStatus previous)?
    effect,
    required TResult orElse(),
  }) {
    if (effect != null) {
      return effect(message, taskId, previous);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Loading value) loading,
    required TResult Function(_Data value) data,
    required TResult Function(_Error value) error,
    required TResult Function(_Effect value) effect,
  }) {
    return effect(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Data value)? data,
    TResult? Function(_Error value)? error,
    TResult? Function(_Effect value)? effect,
  }) {
    return effect?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Data value)? data,
    TResult Function(_Error value)? error,
    TResult Function(_Effect value)? effect,
    required TResult orElse(),
  }) {
    if (effect != null) {
      return effect(this);
    }
    return orElse();
  }
}

abstract class _Effect implements TaskState {
  const factory _Effect({
    required final String message,
    required final String taskId,
    required final TaskStatus previous,
  }) = _$EffectImpl;

  String get message;
  String get taskId;
  TaskStatus get previous;
  @JsonKey(ignore: true)
  _$$EffectImplCopyWith<_$EffectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
