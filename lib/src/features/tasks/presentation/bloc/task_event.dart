part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class StartTaskStream extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;

  const AddTaskEvent(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;
  final TaskStatus to;

  const UpdateTaskEvent(this.task, this.to);

  @override
  List<Object> get props => [task, to];
}

class DeleteTaskEvent extends TaskEvent {
  final String id;
  const DeleteTaskEvent(this.id);

  @override
  List<Object> get props => [id];
}

class TasksUpdated extends TaskEvent {
  final List<Task> tasks;
  const TasksUpdated(this.tasks);

  @override
  List<Object> get props => [tasks];
}
