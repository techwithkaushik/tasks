/// Business Logic Component for managing tasks state and operations.
///
/// This BLoC handles:
/// - Loading tasks for the authenticated user
/// - Adding, updating, and deleting tasks
/// - Listening to authentication state changes
/// - Automatically reloading tasks when user changes
/// - Handling task status updates with undo functionality
library;

import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
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

/// Manages task state and operations.
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
    on<_Load>(_onLoad, transformer: restartable());
    on<_Stop>(_onStop);
    on<_Add>(_onAdd);
    on<_Update>(_onUpdate);
    on<_UpdateStatus>(_onUpdateStatus);
    on<_Delete>(_onDelete);

    _initializeAuthListener();
  }

  void _initializeAuthListener() {
    final authBloc = sl<AppAuthBloc>();

    authBloc.state.whenOrNull(
      authenticated: (user) {
        _currentUser = user;
        add(const TaskEvent.load());
      },
    );

    _authSubscription = authBloc.stream.listen((authState) {
      authState.whenOrNull(
        authenticated: (user) {
          if (_currentUser?.uid != user.uid) {
            _currentUser = user;
            add(const TaskEvent.load());
          }
        },
        unauthenticated: (_) {
          _currentUser = null;
          // A new load event uses restartable() to cancel any previous user's
          // Firestore stream before displaying the signed-out state.
          add(const TaskEvent.load());
        },
      );
    });
  }

  @override
  Future<void> close() async {
    await _authSubscription.cancel();
    await super.close();
  }

  Future<void> _onLoad(_Load event, Emitter<TaskState> emit) async {
    emit(const TaskState.loading());

    // Capture the identity for this subscription. Never allow a stream started
    // for one account to publish data after the active account changes.
    final user = _currentUser;
    if (user == null) {
      emit(const TaskState.error("User not authenticated"));
      return;
    }

    try {
      await emit.forEach<List<Task>>(
        loadTaskUseCase(user.uid),
        onData: (tasks) {
          if (_currentUser?.uid != user.uid) {
            return _currentUser == null
                ? const TaskState.error("User not authenticated")
                : const TaskState.loading();
          }
          return TaskState.data(tasks: tasks);
        },
        onError: (error, stackTrace) {
          if (_currentUser?.uid != user.uid) {
            return _currentUser == null
                ? const TaskState.error("User not authenticated")
                : const TaskState.loading();
          }
          return TaskState.error(error.toString());
        },
      );
    } catch (_) {
      // A restarted load intentionally cancels the previous stream handler.
    }
  }

  Future<void> _onStop(_Stop event, Emitter<TaskState> emit) async {
    // Route stop through the restartable load handler so an active task stream
    // is cancelled before the signed-out state is emitted.
    add(const TaskEvent.load());
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

    final taskIndex = current.tasks.indexWhere((t) => t.id == event.taskId);
    if (taskIndex < 0) return;

    final task = current.tasks[taskIndex];
    if (task.status == event.status) return;

    final updated = task.copyWith(
      status: event.status,
      lastStatus: task.status,
      updatedAt: DateTime.now(),
    );

    // Persist before publishing the changed state. A failed write must not
    // leave the UI showing a status that Firestore rejected.
    await updateTaskUseCase(updated);

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
