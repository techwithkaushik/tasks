part of 'task_add_bloc.dart';

abstract class TaskAddEvent extends Equatable {
  const TaskAddEvent();

  @override
  List<Object?> get props => [];
}

class TaskAddTitleChanged extends TaskAddEvent {
  final String title;
  const TaskAddTitleChanged(this.title);

  @override
  List<Object?> get props => [title];
}

class TaskAddDescriptionChanged extends TaskAddEvent {
  final String description;
  const TaskAddDescriptionChanged(this.description);

  @override
  List<Object?> get props => [description];
}

class TaskAddTypeChanged extends TaskAddEvent {
  final TaskType type;
  const TaskAddTypeChanged(this.type);

  @override
  List<Object?> get props => [type];
}

class TaskAddPriorityChanged extends TaskAddEvent {
  final TaskPriority priority;
  const TaskAddPriorityChanged(this.priority);

  @override
  List<Object?> get props => [priority];
}

class TaskAddEstimatedMinutesChanged extends TaskAddEvent {
  final int minutes;
  const TaskAddEstimatedMinutesChanged(this.minutes);

  @override
  List<Object?> get props => [minutes];
}

class TaskAddDueDateChanged extends TaskAddEvent {
  final DateTime? dueDate;
  const TaskAddDueDateChanged(this.dueDate);

  @override
  List<Object?> get props => [dueDate];
}

class TaskAddSubmitted extends TaskAddEvent {
  const TaskAddSubmitted();
}

class TaskAddReset extends TaskAddEvent {
  const TaskAddReset();
}
