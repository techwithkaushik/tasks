import 'dart:async';
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
  late final StreamSubscription<TaskState> _taskSubscription;

  TaskAddBloc({required this.taskBloc}) : super(TaskAddState.initial()) {
    _taskSubscription = taskBloc.stream.listen((taskState) {
      taskState.whenOrNull(
        effect: (message, taskId, previous) {
          if (message == 'Task added successfully') {
            add(const TaskAddPersistenceResult(success: true));
          } else if (message.startsWith("Couldn't add the task.")) {
            add(TaskAddPersistenceResult(success: false, message: message));
          }
        },
      );
    });
    on<TaskAddTitleChanged>(_onTitleChanged);
    on<TaskAddDescriptionChanged>(_onDescriptionChanged);
    on<TaskAddTypeChanged>(_onTypeChanged);
    on<TaskAddPriorityChanged>(_onPriorityChanged);
    on<TaskAddEstimatedMinutesChanged>(_onEstimatedMinutesChanged);
    on<TaskAddDueDateChanged>(_onDueDateChanged);
    on<TaskAddSubmitted>(_onSubmitted);
    on<TaskAddPersistenceResult>(_onPersistenceResult);
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
        final normalizedTitle = _normalizeTitle(title);
        isDuplicate = normalizedTitle.isNotEmpty && tasks.any(
          (task) =>
              task.status != TaskStatus.deleted &&
              task.status != TaskStatus.archived &&
              _normalizeTitle(task.title) == normalizedTitle,
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
      // Keep the form in a submitting state until TaskBloc confirms that the
      // repository write succeeded. A failed Firestore write must not close
      // the form or falsely report success.
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
    }
  }

  void _onPersistenceResult(
    TaskAddPersistenceResult event,
    Emitter<TaskAddState> emit,
  ) {
    if (event.success) {
      emit(state.copyWith(isSubmitting: false, isSuccess: true, error: null));
    } else {
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        error: event.message ?? "Couldn't add the task. Please try again.",
      ));
    }
  }

  @override
  Future<void> close() async {
    await _taskSubscription.cancel();
    await super.close();
  }

  void _onReset(TaskAddReset event, Emitter<TaskAddState> emit) {
    emit(TaskAddState.initial());
  }
}


/// Normalizes whitespace and case so accidental formatting differences do not
/// create duplicate tasks. Deleted/archived tasks are handled separately above.
String _normalizeTitle(String value) =>
    value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
