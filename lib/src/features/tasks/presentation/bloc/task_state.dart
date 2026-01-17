part of 'task_bloc.dart';

class TaskState extends Equatable {
  final bool isLoading;
  final List<Task> tasks;
  final String error;
  final String undoTaskId;
  final TaskStatus undoStatus;
  final bool showSnackBar;
  const TaskState({
    required this.isLoading,
    required this.tasks,
    required this.error,
    required this.undoTaskId,
    required this.undoStatus,
    required this.showSnackBar,
  });

  factory TaskState.initial() => const TaskState(
    isLoading: true,
    tasks: [],
    error: "",
    undoTaskId: "",
    undoStatus: TaskStatus.pending,
    showSnackBar: false,
  );

  TaskState copyWith({
    bool? isLoading,
    List<Task>? tasks,
    String? error,
    String? undoTaskId,
    TaskStatus? undoStatus,
    bool? showSnackBar,
  }) {
    return TaskState(
      isLoading: isLoading ?? this.isLoading,
      tasks: tasks ?? this.tasks,
      error: error ?? this.error,
      undoTaskId: undoTaskId ?? this.undoTaskId,
      undoStatus: undoStatus ?? this.undoStatus,
      showSnackBar: showSnackBar ?? this.showSnackBar,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    tasks,
    error,
    undoTaskId,
    undoStatus,
    showSnackBar,
  ];
}
