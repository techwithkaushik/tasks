part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TaskEvent {}

class StopTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;
  const AddTaskEvent(this.task);
  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;

  const UpdateTaskEvent(this.task);
  @override
  List<Object?> get props => [task];
}

class UpdateTaskStatusEvent extends TaskEvent {
  final String taskId;
  final TaskStatus status;
  final bool showSnackBar;

  const UpdateTaskStatusEvent(this.taskId, this.status, this.showSnackBar);
  @override
  List<Object?> get props => [taskId, status, showSnackBar];
}

class DeleteTaskEvent extends TaskEvent {
  final String id;
  const DeleteTaskEvent(this.id);
  @override
  List<Object?> get props => [id];
}
