import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tasks/src/features/app_auth/domain/entities/user_entity.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_state.dart';
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
  final taskStream = StreamController<List<Task>>.broadcast();
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

  test('missing task IDs are ignored by status updates', () async {
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
        taskId: 'removed-task',
        status: TaskStatus.completed,
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(repository.lastUpdatedTask, isNull);
    expect(
      bloc.state.maybeWhen(
        data: (tasks) => tasks.single.status,
        orElse: () => null,
      ),
      TaskStatus.pending,
    );
  });

  test('failed status persistence does not publish the new status', () async {
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
    await Future<void>.delayed(Duration.zero);
    repository.updateGate.completeError(StateError('write failed'));
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(
      bloc.state.maybeWhen(
        data: (tasks) => tasks.single.status,
        orElse: () => null,
      ),
      TaskStatus.pending,
    );
  });


  test('does not update a task owned by another account', () async {
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

    repository.taskStream.add([_task()]);
    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        data: (tasks) => tasks.any((item) => item.id == 'task-1'),
        orElse: () => false,
      ),
    );

    bloc.add(
      TaskEvent.update(
        _task().copyWith(userId: 'user-2', title: 'Other account task'),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(repository.lastUpdatedTask, isNull);
  });

  test('in-flight status update cannot overwrite a switched account', () async {
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

    repository.taskStream.add([_task()]);
    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        data: (tasks) => tasks.any((item) => item.id == 'task-1'),
        orElse: () => false,
      ),
    );

    bloc.add(
      const TaskEvent.updateStatus(
        taskId: 'task-1',
        status: TaskStatus.completed,
      ),
    );
    await Future<void>.delayed(Duration.zero);
    expect(repository.lastUpdatedTask?.status, TaskStatus.completed);

    await authBloc.emitState(
      AppAuthState.authenticated(
        const UserEntity(uid: 'user-2', isEmailVerified: true),
      ),
    );
    repository.taskStream.add([
      _task().copyWith(
        id: 'task-2',
        userId: 'user-2',
        title: 'Account two task',
      ),
    ]);
    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        data: (tasks) => tasks.any((item) => item.id == 'task-2'),
        orElse: () => false,
      ),
    );

    repository.updateGate.complete();
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(
      bloc.state.maybeWhen(
        data: (tasks) => tasks.map((item) => item.id).toList(),
        orElse: () => <String>[],
      ),
      ['task-2'],
    );
    expect(
      bloc.state.maybeWhen(
        data: (tasks) => tasks.single.status,
        orElse: () => null,
      ),
      TaskStatus.pending,
    );
  });

}
