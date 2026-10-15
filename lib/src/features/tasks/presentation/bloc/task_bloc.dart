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
  List<Task> _lastTasks = [];
  String? _tasksUserId;
  bool _hasLoadedTasks = false;

  TaskBloc(
    this.loadTaskUseCase,
    this.addTaskUseCase,
    this.updateTaskUseCase,
    this.deleteTaskUseCase,
  ) : super(const TaskState.loading()) {
    on<_Load>(_onLoad, transformer: restartable());
    on<_Stop>(_onStop);
    // Serialize creates so concurrent submits are checked against the latest state.
    on<_Add>(_onAdd, transformer: sequential());
    // Serialize writes so quick repeated actions cannot race each other.
    on<_Update>(_onUpdate, transformer: sequential());
    on<_UpdateStatus>(_onUpdateStatus, transformer: sequential());
    on<_Delete>(_onDelete, transformer: sequential());

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
            _lastTasks = [];
            _tasksUserId = user.uid;
            _hasLoadedTasks = false;
            add(const TaskEvent.load());
          }
        },
        unauthenticated: (_) {
          _currentUser = null;
          _lastTasks = [];
          _tasksUserId = null;
          _hasLoadedTasks = false;
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
    // Capture the identity for this subscription. Never allow a stream started
    // for one account to publish data after the active account changes.
    final user = _currentUser;
    if (user == null) {
      emit(const TaskState.loading());
      _lastTasks = [];
      _tasksUserId = null;
      _hasLoadedTasks = false;
      emit(const TaskState.error("User not authenticated"));
      return;
    }
    if (_tasksUserId != user.uid) {
      _lastTasks = [];
      _tasksUserId = user.uid;
      _hasLoadedTasks = false;
    }

    // Keep the last synced list visible while retrying a transient network
    // failure. A fresh account or first load still shows the loading state.
    if (!_hasLoadedTasks) emit(const TaskState.loading());

    try {
      await emit.forEach<List<Task>>(
        loadTaskUseCase(user.uid),
        onData: (tasks) {
          if (_currentUser?.uid != user.uid) {
            return _currentUser == null
                ? const TaskState.error("User not authenticated")
                : const TaskState.loading();
          }
          _lastTasks = tasks;
          _hasLoadedTasks = true;
          return TaskState.data(tasks: tasks);
        },
        onError: (error, stackTrace) {
          if (_currentUser?.uid != user.uid) {
            return _currentUser == null
                ? const TaskState.error("User not authenticated")
                : const TaskState.loading();
          }
          if (_hasLoadedTasks) {
            return TaskState.effect(
              message: "Connection lost. Showing the last synced tasks.",
              taskId: "",
              previous: TaskStatus.pending,
            );
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

  void _notifyWriteFailure(Emitter<TaskState> emit, String message) {
    emit(
      TaskState.effect(
        message: message,
        taskId: "",
        previous: TaskStatus.pending,
      ),
    );
  }

  Future<void> _onAdd(_Add event, Emitter<TaskState> emit) async {
    final user = _currentUser;
    if (user == null || event.task.userId != user.uid) {
      _notifyWriteFailure(
        emit,
        "Couldn't add the task. Your session may have changed; please try again.",
      );
      return;
    }

    // Re-check the latest in-memory snapshot in the BLoC as well as the
    // form. This closes the common race where two forms submit the same title.
    final normalizedTitle = _normalizeTaskTitle(event.task.title);
    final alreadyExists = _lastTasks.any(
      (task) =>
          task.userId == user.uid &&
          task.status != TaskStatus.deleted &&
          task.status != TaskStatus.archived &&
          _normalizeTaskTitle(task.title) == normalizedTitle,
    );
    if (alreadyExists) {
      _notifyWriteFailure(
        emit,
        "Couldn't add the task. A task with this title already exists. Please choose a different title.",
      );
      return;
    }

    try {
      await addTaskUseCase(event.task);
      if (_currentUser?.uid != user.uid) return;

      // Emit the latest list state before the one-shot UI effect. This keeps
      // dashboards and counters rebuilding even if Firestore delivered its
      // snapshot before the write future completed.
      emit(TaskState.data(tasks: _lastTasks));
      emit(
        TaskState.effect(
          message: "Task added successfully",
          taskId: "",
          previous: TaskStatus.pending,
        ),
      );
    } catch (_) {
      if (_currentUser?.uid == user.uid) {
        _notifyWriteFailure(
          emit,
          "Couldn't add the task. Check your connection and try again.",
        );
      }
    }
  }

  Future<void> _onUpdate(_Update event, Emitter<TaskState> emit) async {
    final user = _currentUser;
    if (user == null || event.task.userId != user.uid) return;

    try {
      await updateTaskUseCase(event.task);
    } catch (_) {
      if (_currentUser?.uid == user.uid) {
        _notifyWriteFailure(
          emit,
          "Couldn't save task changes. Check your connection and try again.",
        );
      }
    }
  }

  Future<void> _onUpdateStatus(
    _UpdateStatus event,
    Emitter<TaskState> emit,
  ) async {
    final user = _currentUser;
    if (user == null || !_hasLoadedTasks) return;

    final taskIndex = _lastTasks.indexWhere(
      (t) => t.id == event.taskId && t.userId == user.uid,
    );
    if (taskIndex < 0) return;

    final task = _lastTasks[taskIndex];
    if (task.status == event.status) return;

    final updated = task.copyWith(
      status: event.status,
      lastStatus: task.status,
      updatedAt: DateTime.now(),
    );

    // Persist before publishing the changed state. A failed write must not
    // leave the UI showing a status that Firestore rejected.
    try {
      await updateTaskUseCase(updated);
    } catch (_) {
      if (_currentUser?.uid == user.uid) {
        _notifyWriteFailure(
          emit,
          "Couldn't update task status. No changes were applied.",
        );
      }
      return;
    }

    // A Firestore snapshot may have updated the list while the write was
    // in flight. Apply the status change to the latest state, not the stale
    // snapshot captured before awaiting the write.
    // Do not let a write started for a previous account mutate the new
    // account's state after an authentication switch.
    if (_currentUser?.uid != user.uid) return;

    final newList = _lastTasks
        .map((t) {
          if (t.id != updated.id || t.userId != user.uid) return t;
          // Preserve any unrelated fields delivered by a newer Firestore
          // snapshot while the write was in flight.
          return t.copyWith(
            status: event.status,
            lastStatus: t.status == event.status ? t.lastStatus : t.status,
            updatedAt: updated.updatedAt,
          );
        })
        .toList();
    _lastTasks = newList;
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

  Future<void> _onDelete(_Delete event, Emitter<TaskState> emit) async {
    final user = _currentUser;
    if (user == null || !_hasLoadedTasks) return;

    final belongsToUser = _lastTasks.any(
      (task) => task.id == event.taskId && task.userId == user.uid,
    );
    if (!belongsToUser) return;

    try {
      await deleteTaskUseCase(event.taskId);
    } catch (_) {
      if (_currentUser?.uid == user.uid) {
        _notifyWriteFailure(
          emit,
          "Couldn't delete the task. Check your connection and try again.",
        );
      }
    }
  }
}


String _normalizeTaskTitle(String value) =>
    value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
