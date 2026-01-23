part of 'task_add_bloc.dart';

class TaskAddState extends Equatable {
  final String title;
  final String description;
  final TaskType type;
  final TaskPriority priority;
  final int estimatedMinutes;
  final DateTime? dueDate;
  final bool isSubmitting;
  final String? error;
  final bool isSuccess;
  final String? titleError;
  final bool isDuplicate;

  const TaskAddState({
    required this.title,
    required this.description,
    required this.type,
    required this.priority,
    required this.estimatedMinutes,
    this.dueDate,
    this.isSubmitting = false,
    this.error,
    this.isSuccess = false,
    this.titleError,
    this.isDuplicate = false,
  });

  factory TaskAddState.initial() => const TaskAddState(
    title: '',
    description: '',
    type: TaskType.single,
    priority: TaskPriority.medium,
    estimatedMinutes: 30,
  );

  TaskAddState copyWith({
    String? title,
    String? description,
    TaskType? type,
    TaskPriority? priority,
    int? estimatedMinutes,
    DateTime? dueDate,
    bool? isSubmitting,
    String? error,
    bool? isSuccess,
    String? titleError,
    bool? isDuplicate,
  }) {
    return TaskAddState(
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      dueDate: dueDate ?? this.dueDate,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
      titleError: titleError,
      isDuplicate: isDuplicate ?? this.isDuplicate,
    );
  }

  @override
  List<Object?> get props => [
    title,
    description,
    type,
    priority,
    estimatedMinutes,
    dueDate,
    isSubmitting,
    error,
    isSuccess,
    titleError,
    isDuplicate,
  ];
}
