part of 'task_bloc.dart';

/// States representing the different states of task management
///
/// The TaskBloc can be in one of these states:
/// - `loading`: Tasks are being fetched from the server
/// - `data`: Tasks have been successfully loaded and are ready to display
/// - `error`: An error occurred while loading or processing tasks
/// - `effect`: A one-time side effect like showing a snackbar with undo
@Freezed()
sealed class TaskState with _$TaskState {
  /// Loading state - shows progress indicator
  /// Emitted when: App starts, user logs in, tasks are being refreshed
  const factory TaskState.loading() = _Loading;

  /// Data state - contains the list of tasks
  ///
  /// Parameters:
  /// - `tasks`: List of Task objects to display
  const factory TaskState.data({required List<Task> tasks}) = _Data;

  /// Error state - an error message is displayed
  ///
  /// Parameters:
  /// - `message`: The error message to display to the user
  /// Common messages:
  /// - "User not authenticated": No active user session
  /// - Firebase error messages: Network or permission issues
  const factory TaskState.error(String message) = _Error;

  /// One-shot side-effect for UI notifications
  /// This state is emitted once and should not persist
  /// Used for showing snackbar notifications with undo functionality
  ///
  /// Parameters:
  /// - `message`: The notification message to show
  /// - `taskId`: ID of the task that was modified
  /// - `previous`: The previous status for undo functionality
  ///
  /// Example: "Status changed to completed" with undo button
  const factory TaskState.effect({
    required String message,
    required String taskId,
    required TaskStatus previous,
  }) = _Effect;
}
