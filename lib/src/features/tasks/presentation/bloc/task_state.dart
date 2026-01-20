part of 'task_bloc.dart';

@Freezed()
sealed class TaskState with _$TaskState {
  const factory TaskState.loading() = _Loading;
  const factory TaskState.data({required List<Task> tasks}) = _Data;
  const factory TaskState.error(String message) = _Error;

  /// One-shot side-effect (snackbar + undo action)
  const factory TaskState.effect({
    required String message,
    required String taskId,
    required TaskStatus previous,
  }) = _Effect;
}
