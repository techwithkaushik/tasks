part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  final List<Task> tasks;
  final String? error;
  final bool isLoading;

  const TaskState({this.tasks = const [], this.error, this.isLoading = false});

  @override
  List<Object?> get props => [tasks, error, isLoading];
}

final class TaskInitial extends TaskState {
  const TaskInitial() : super();
}

final class TaskLoading extends TaskState {
  const TaskLoading({super.tasks}) : super(isLoading: true);
}

final class TaskLoaded extends TaskState {
  const TaskLoaded({required super.tasks});
}

final class TaskError extends TaskState {
  const TaskError({required String super.error, super.tasks});
}
