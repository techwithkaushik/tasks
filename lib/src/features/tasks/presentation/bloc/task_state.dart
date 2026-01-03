part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskLoading extends TaskState {
  @override
  List<Object?> get props => [];
}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  const TaskLoaded(this.tasks);
  @override
  List<Object?> get props => [tasks];
}

class TaskFailure extends TaskState {
  final String message;
  const TaskFailure(this.message);
  @override
  List<Object?> get props => [message];
}
