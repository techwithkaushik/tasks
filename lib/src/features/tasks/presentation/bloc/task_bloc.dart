/// Business Logic Component for managing tasks state and operations.
///
/// This BLoC handles:
/// - Loading tasks for the authenticated user
/// - Adding, updating, and deleting tasks
/// - Listening to authentication state changes
/// - Automatically reloading tasks when user changes
/// - Handling task status updates with undo functionality
///
/// The BLoC automatically listens to AppAuthBloc and reloads tasks when:
/// - User first authenticates
/// - User switches to a different account
/// - User logs out
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tasks/service_locator.dart';
import 'package:tasks/src/features/app_auth/domain/entities/user_entity.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_state.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/domain/usecases/add_task_use_case.dart';
import 'package:tasks/src/features/tasks/domain/usecases/update_task_use_case.dart';
import 'package:tasks/src/features/tasks/domain/usecases/delete_task_use_case.dart';
import 'package:tasks/src/features/tasks/domain/usecases/load_task_use_case.dart';

part 'task_event.dart';
part 'task_state.dart';
part 'task_bloc.freezed.dart';

/// Manages task state and operations
///
/// Events:
/// - `load`: Loads tasks for the current user
/// - `stop`: Stops loading and clears tasks
/// - `add`: Adds a new task
/// - `update`: Updates an existing task
/// - `updateStatus`: Changes a task's status (completed, pending, deleted)
/// - `delete`: Marks a task as deleted
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final LoadTaskUseCase loadTaskUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  late StreamSubscription<AppAuthState> _authSubscription;
  UserEntity? _currentUser;

  TaskBloc(
    this.loadTaskUseCase,
    this.addTaskUseCase,
    this.updateTaskUseCase,
    this.deleteTaskUseCase,
  ) : super(const TaskState.loading()) {
    /// Register event handlers
    on<_Load>(_onLoad);
    on<_Stop>(_onStop);
    on<_Add>(_onAdd);
    on<_Update>(_onUpdate);
    on<_UpdateStatus>(_onUpdateStatus);
    on<_Delete>(_onDelete);

    // Initialize listener for auth state changes
    _initializeAuthListener();
  }

  /// Sets up listener for authentication state changes
  ///
  /// This ensures that:
  /// 1. Tasks are loaded when user authenticates
  /// 2. Tasks are reloaded if user switches accounts
  /// 3. Tasks are cleared when user logs out
  void _initializeAuthListener() {
    final authBloc = sl<AppAuthBloc>();

    // Load tasks if user is already authenticated on startup
    authBloc.state.whenOrNull(
      authenticated: (user) {
        _currentUser = user;
        add(const TaskEvent.load());
      },
    );

    // Listen for future auth state changes
    _authSubscription = authBloc.stream.listen((authState) {
      authState.whenOrNull(
        authenticated: (user) {
          // If user changed, reload tasks for new user
          if (_currentUser?.uid != user.uid) {
            _currentUser = user;
            add(const TaskEvent.load());
          }
        },
        unauthenticated: (form) {
          // Clear current user and stop task loading
          _currentUser = null;
          add(const TaskEvent.stop());
        },
      );
    });
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  /// Loads tasks for the current authenticated user
  ///
  /// Emits:
  /// - `TaskState.loading()` initially
  /// - `TaskState.data(tasks)` when tasks are loaded
  /// - `TaskState.error(message)` if user is not authenticated or error occurs
  Future<void> _onLoad(_Load event, Emitter<TaskState> emit) async {
    emit(const TaskState.loading());

    if (_currentUser == null) {
      emit(const TaskState.error("User not authenticated"));
      return;
    }

    try {
      await emit.forEach<List<Task>>(
        loadTaskUseCase(_currentUser!.uid),
        onData: (tasks) => TaskState.data(tasks: tasks),
        onError: (error, stackTrace) => TaskState.error(error.toString()),
      );
    } catch (e) {
      // Ignore errors when event is interrupted
    }
  }

  Future<void> _onStop(_Stop event, Emitter<TaskState> emit) async {
    emit(const TaskState.error("User not authenticated"));
  }

  Future<void> _onAdd(_Add event, _) async => addTaskUseCase(event.task);

  Future<void> _onUpdate(_Update event, _) async =>
      updateTaskUseCase(event.task);

  Future<void> _onUpdateStatus(
    _UpdateStatus event,
    Emitter<TaskState> emit,
  ) async {
    final current = state;
    if (current is! _Data) return;

    final task = current.tasks.firstWhere((t) => t.id == event.taskId);
    if (task.status == event.status) return;
    final updated = task.copyWith(
      status: event.status,
      lastStatus: task.status,
      updatedAt: DateTime.now(),
    );

    updateTaskUseCase(updated);

    final newList = current.tasks
        .map((t) => t.id == updated.id ? updated : t)
        .toList();
    emit(TaskState.data(tasks: newList));
    if (event.showSnackBar) {
      emit(
        TaskState.effect(
          message: "Status changed to ${updated.status.name}",
          taskId: updated.id,
          previous: updated.lastStatus,
        ),
      );
    }
  }

  Future<void> _onDelete(_Delete event, _) async =>
      deleteTaskUseCase(event.taskId);
}
