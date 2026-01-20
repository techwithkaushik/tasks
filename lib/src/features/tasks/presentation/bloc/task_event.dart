part of 'task_bloc.dart';

@Freezed()
sealed class TaskEvent with _$TaskEvent {
  const factory TaskEvent.load() = _Load;
  const factory TaskEvent.stop() = _Stop;
  const factory TaskEvent.add(Task task) = _Add;
  const factory TaskEvent.update(Task task) = _Update;
  const factory TaskEvent.updateStatus({
    required String taskId,
    required TaskStatus status,
    @Default(false) bool showSnackBar,
  }) = _UpdateStatus;
  const factory TaskEvent.delete(String taskId) = _Delete;
}
