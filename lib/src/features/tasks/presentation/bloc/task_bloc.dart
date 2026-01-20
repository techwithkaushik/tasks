import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tasks/service_locator.dart';
import 'package:tasks/src/features/app_auth/domain/entities/user_entity.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/domain/usecases/add_task_use_case.dart';
import 'package:tasks/src/features/tasks/domain/usecases/update_task_use_case.dart';
import 'package:tasks/src/features/tasks/domain/usecases/delete_task_use_case.dart';
import 'package:tasks/src/features/tasks/domain/usecases/load_task_use_case.dart';

part 'task_event.dart';
part 'task_state.dart';
part 'task_bloc.freezed.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final LoadTaskUseCase loadTaskUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  TaskBloc(
    this.loadTaskUseCase,
    this.addTaskUseCase,
    this.updateTaskUseCase,
    this.deleteTaskUseCase,
  ) : super(const TaskState.loading()) {
    on<_Load>(_onLoad);
    on<_Stop>(_onStop);
    on<_Add>(_onAdd);
    on<_Update>(_onUpdate);
    on<_UpdateStatus>(_onUpdateStatus);
    on<_Delete>(_onDelete);
  }

  Future<void> _onLoad(_Load event, Emitter<TaskState> emit) async {
    emit(const TaskState.loading());
    final authBloc = sl<AppAuthBloc>();
    UserEntity? user;

    // Case 1: Already authenticated
    authBloc.state.mapOrNull(
      authenticated: (auth) async {
        user = auth.user;
      },
    );
    if (user == null) {
      emit(const TaskState.error("User not authenticated"));
      return;
    }

    await emit.forEach<List<Task>>(
      loadTaskUseCase(user!.uid),
      onData: (tasks) => TaskState.data(tasks: tasks),
      onError: (error, stackTrace) => TaskState.error(error.toString()),
    );
  }

  Future<void> _onStop(_Stop event, Emitter<TaskState> emit) async {
    emit(const TaskState.loading());
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
