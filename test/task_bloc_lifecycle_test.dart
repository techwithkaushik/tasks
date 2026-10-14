import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tasks/service_locator.dart';
import 'package:tasks/src/features/app_auth/domain/entities/user_entity.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_state.dart';
import 'package:tasks/src/features/app_auth/presentation/models/auth_form_model.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/domain/repositories/task_repository.dart';
import 'package:tasks/src/features/tasks/domain/usecases/add_task_use_case.dart';
import 'package:tasks/src/features/tasks/domain/usecases/delete_task_use_case.dart';
import 'package:tasks/src/features/tasks/domain/usecases/load_task_use_case.dart';
import 'package:tasks/src/features/tasks/domain/usecases/update_task_use_case.dart';
import 'package:tasks/src/features/tasks/presentation/bloc/task_bloc.dart';

class _FakeAppAuthBloc implements AppAuthBloc {
  _FakeAppAuthBloc(this.state);

  @override
  AppAuthState state;

  final _controller = StreamController<AppAuthState>.broadcast();

  @override
  Stream<AppAuthState> get stream => _controller.stream;

  Future<void> emitState(AppAuthState next) async {
    state = next;
    _controller.add(next);
  }

  Future<void> dispose() => _controller.close();

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeTaskRepository implements TaskRepository {
  final taskStream = StreamController<List<Task>>();
  final updateGate = Completer<void>();
  Task? lastUpdatedTask;

  @override
  Stream<List<Task>> loadTasks(String userId) => taskStream.stream;

  @override
  Future<void> updateTask(Task task) {
    lastUpdatedTask = task;
    return updateGate.future;
  }

  @override
  Future<void> addTask(Task task) async {}

  @override
  Future<void> deleteTask(String taskId) async {}

  Future<void> dispose() => taskStream.close();
}

Task _task() => Task(
  id: 'task-1',
  userId: 'user-1',
  title: 'Test task',
  type: TaskType.single,
  priority: TaskPriority.medium,
  status: TaskStatus.pending,
  lastStatus: TaskStatus.pending,
  estimatedMinutes: 15,
);

void main() {
  final locator = GetIt.instance;

  tearDown(() async {
    await locator.reset();
  });

  test('status is not emitted until the update is persisted', () async {
    final authBloc = _FakeAppAuthBloc(
      AppAuthState.authenticated(
        const UserEntity(uid: 'user-1', isEmailVerified: true),
      ),
    );
    final repository = _FakeTaskRepository();
    locator.registerSingleton<AppAuthBloc>(authBloc);

    final bloc = TaskBloc(
      LoadTaskUseCase(repository),
      AddTaskUseCase(repository),
      UpdateTaskUseCase(repository),
      DeleteTaskUseCase(repository),
    );

    addTearDown(() async {
      await bloc.close();
      await authBloc.dispose();
      await repository.dispose();
    });

    final task = _task();
    repository.taskStream.add([task]);

    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        data: (tasks) => tasks.any((item) => item.id == task.id),
        orElse: () => false,
      ),
    );

    bloc.add(
      const TaskEvent.updateStatus(
        taskId: 'task-1',
        status: TaskStatus.completed,
      ),
    );

    // Let the event handler reach the pending persistence future.
    await Future<void>.delayed(Duration.zero);
    expect(repository.lastUpdatedTask?.status, TaskStatus.completed);
    expect(
      bloc.state.maybeWhen(
        data: (tasks) => tasks.single.status,
        orElse: () => null,
      ),
      TaskStatus.pending,
    );

    repository.updateGate.complete();

    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        data: (tasks) => tasks.single.status == TaskStatus.completed,
        orElse: () => false,
      ),
    );

    expect(
      bloc.state.maybeWhen(
        data: (tasks) => tasks.single.status,
        orElse: () => null,
      ),
      TaskStatus.completed,
    );
  });

  test('load without an authenticated user emits an error', () async {
    final authBloc = _FakeAppAuthBloc(
      AppAuthState.unauthenticated(form: AuthFormModel.initial()),
    );
    final repository = _FakeTaskRepository();
    locator.registerSingleton<AppAuthBloc>(authBloc);

    final bloc = TaskBloc(
      LoadTaskUseCase(repository),
      AddTaskUseCase(repository),
      UpdateTaskUseCase(repository),
      DeleteTaskUseCase(repository),
    );

    addTearDown(() async {
      await bloc.close();
      await authBloc.dispose();
      await repository.dispose();
    });

    bloc.add(const TaskEvent.load());

    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        error: (message) => message == 'User not authenticated',
        orElse: () => false,
      ),
    );
    expect(
      bloc.state.maybeWhen(
        error: (message) => message,
        orElse: () => null,
      ),
      'User not authenticated',
    );
  });
}
