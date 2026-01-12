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
  final TaskStatus to;

  const UpdateTaskEvent(this.task, this.to);
  @override
  List<Object?> get props => [task, to];
}

class DeleteTaskEvent extends TaskEvent {
  final String id;
  const DeleteTaskEvent(this.id);
  @override
  List<Object?> get props => [id];
}

// class TasksUpdatedEvent extends TaskEvent {
//   final List<Task> tasks;
//   const TasksUpdatedEvent(this.tasks);

//   @override
//   List<Object> get props => [List<Object?>.from(tasks)];
// }
