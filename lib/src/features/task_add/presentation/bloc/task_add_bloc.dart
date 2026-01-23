import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/service_locator.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/presentation/bloc/task_bloc.dart';

part 'task_add_event.dart';
part 'task_add_state.dart';

class TaskAddBloc extends Bloc<TaskAddEvent, TaskAddState> {
  final TaskBloc taskBloc;

  TaskAddBloc({required this.taskBloc}) : super(TaskAddState.initial()) {
    on<TaskAddTitleChanged>(_onTitleChanged);
    on<TaskAddDescriptionChanged>(_onDescriptionChanged);
    on<TaskAddTypeChanged>(_onTypeChanged);
    on<TaskAddPriorityChanged>(_onPriorityChanged);
    on<TaskAddEstimatedMinutesChanged>(_onEstimatedMinutesChanged);
    on<TaskAddDueDateChanged>(_onDueDateChanged);
    on<TaskAddSubmitted>(_onSubmitted);
    on<TaskAddReset>(_onReset);
  }

  void _onTitleChanged(TaskAddTitleChanged event, Emitter<TaskAddState> emit) {
    final title = event.title;

    // Validate title
    String? titleError;
    if (title.trim().isEmpty) {
      titleError = 'Title is required';
    }

    // Check for duplicate title
    bool isDuplicate = false;
    taskBloc.state.maybeWhen(
      data: (tasks) {
        isDuplicate = tasks.any(
          (task) =>
              task.title.toLowerCase().trim() == title.toLowerCase().trim(),
        );
      },
      orElse: () {},
    );

    emit(
      state.copyWith(
        title: title,
        error: null,
        titleError: titleError,
        isDuplicate: isDuplicate,
      ),
    );
  }

  void _onDescriptionChanged(
    TaskAddDescriptionChanged event,
    Emitter<TaskAddState> emit,
  ) {
    emit(state.copyWith(description: event.description, error: null));
  }

  void _onTypeChanged(TaskAddTypeChanged event, Emitter<TaskAddState> emit) {
    emit(state.copyWith(type: event.type, error: null));
  }

  void _onPriorityChanged(
    TaskAddPriorityChanged event,
    Emitter<TaskAddState> emit,
  ) {
    emit(state.copyWith(priority: event.priority, error: null));
  }

  void _onEstimatedMinutesChanged(
    TaskAddEstimatedMinutesChanged event,
    Emitter<TaskAddState> emit,
  ) {
    emit(state.copyWith(estimatedMinutes: event.minutes, error: null));
  }

  void _onDueDateChanged(
    TaskAddDueDateChanged event,
    Emitter<TaskAddState> emit,
  ) {
    emit(state.copyWith(dueDate: event.dueDate, error: null));
  }

  void _onSubmitted(TaskAddSubmitted event, Emitter<TaskAddState> emit) {
    // Validate title
    if (state.title.trim().isEmpty) {
      emit(state.copyWith(error: 'Title is required'));
      return;
    }

    // Check for duplicate
    if (state.isDuplicate) {
      emit(state.copyWith(error: 'A task with this title already exists'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, error: null));

    try {
      final now = DateTime.now();
      DateTime? finalDue;
      if (state.dueDate != null) {
        finalDue = state.dueDate!.copyWith(
          second: now.second,
          millisecond: now.millisecond,
          microsecond: now.microsecond,
        );
      }

      // Get authenticated user ID from AppAuthBloc
      final authBloc = sl<AppAuthBloc>();
      String userId = '';

      authBloc.state.mapOrNull(
        authenticated: (value) {
          userId = value.user.uid;
        },
      );

      if (userId.isEmpty) {
        emit(
          state.copyWith(isSubmitting: false, error: 'User not authenticated'),
        );
        return;
      }

      final task = Task(
        id: '',
        userId: userId,
        title: state.title.trim(),
        description: state.description.trim(),
        type: state.type,
        priority: state.priority,
        status: TaskStatus.pending,
        lastStatus: TaskStatus.pending,
        createdAt: now,
        dueDate: finalDue,
        updatedAt: null,
        estimatedMinutes: state.estimatedMinutes,
      );

      taskBloc.add(TaskEvent.add(task));
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
    }
  }

  void _onReset(TaskAddReset event, Emitter<TaskAddState> emit) {
    emit(TaskAddState.initial());
  }
}
