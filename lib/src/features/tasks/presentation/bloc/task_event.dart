part of 'task_bloc.dart';

/// Events that can be triggered on the TaskBloc
///
/// These events represent user actions or system events that update the task state
@Freezed()
sealed class TaskEvent with _$TaskEvent {
  /// Loads tasks for the current authenticated user
  /// Emitted when: App starts, user logs in, or user switches accounts
  const factory TaskEvent.load() = _Load;

  /// Stops loading and clears tasks
  /// Emitted when: User logs out
  const factory TaskEvent.stop() = _Stop;

  /// Adds a new task to the list
  ///
  /// Parameters:
  /// - `task`: The new task to add
  const factory TaskEvent.add(Task task) = _Add;

  /// Updates an existing task
  ///
  /// Parameters:
  /// - `task`: The task with updated values
  const factory TaskEvent.update(Task task) = _Update;

  /// Updates only the status of a task (completed, pending, deleted)
  ///
  /// Parameters:
  /// - `taskId`: ID of the task to update
  /// - `status`: The new status for the task
  /// - `showSnackBar`: Whether to show a snackbar notification with undo action
  const factory TaskEvent.updateStatus({
    required String taskId,
    required TaskStatus status,
    @Default(false) bool showSnackBar,
  }) = _UpdateStatus;

  /// Marks a task as deleted (soft delete)
  ///
  /// Parameters:
  /// - `taskId`: ID of the task to delete
  const factory TaskEvent.delete(String taskId) = _Delete;
}
