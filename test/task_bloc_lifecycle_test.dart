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
  Object? addFailure;
  Object? updateFailure;
  Object? deleteFailure;
  int addCalls = 0;

  @override
  Stream<List<Task>> loadTasks(String userId) => taskStream.stream;

  @override
  Future<void> updateTask(Task task) {
    lastUpdatedTask = task;
    if (updateFailure != null) {
      return Future<void>.error(updateFailure!);
    }
    if (updateGate.isCompleted) return Future<void>.value();
    return updateGate.future;
  }

  @override
  Future<void> addTask(Task task) async {
    addCalls++;
    if (addFailure != null) throw addFailure!;
  }

  @override
  Future<void> deleteTask(String taskId) async {
    if (deleteFailure != null) throw deleteFailure!;
  }

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


  test('duplicate task titles are rejected by TaskBloc before persistence', () async {
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

    await Future<void>.delayed(const Duration(milliseconds: 10));
    repository.taskStream.add([_task()]);
    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        data: (tasks) => tasks.length == 1 && tasks.single.id == 'task-1',
        orElse: () => false,
      ),
    );

    bloc.add(TaskEvent.add(_task().copyWith(
      id: '',
      title: '  TEST   TASK ',
    )));

    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        effect: (message, _, _) => message.contains('already exists'),
        orElse: () => false,
      ),
    );

    expect(repository.addCalls, 0);
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
    await Future<void>.delayed(const Duration(milliseconds: 10));
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

    repository.taskStream.add([task.copyWith(title: 'Server-side edit')]);
    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        data: (tasks) => tasks.single.title == 'Server-side edit',
        orElse: () => false,
      ),
    );

    repository.updateGate.complete();

    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        data: (tasks) =>
            tasks.single.status == TaskStatus.completed &&
            tasks.single.title == 'Server-side edit',
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
    expect(
      bloc.state.maybeWhen(
        data: (tasks) => tasks.single.title,
        orElse: () => null,
      ),
      'Server-side edit',
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
    await Future<void>.delayed(const Duration(milliseconds: 10));
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
    await Future<void>.delayed(const Duration(milliseconds: 10));
    repository.taskStream.add([task]);
    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        data: (tasks) => tasks.any((item) => item.id == task.id),
        orElse: () => false,
      ),
    );
    final observedStates = <TaskState>[];
    final stateSubscription = bloc.stream.listen(observedStates.add);
    addTearDown(stateSubscription.cancel);

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
        effect: (message, _, _) => message.contains("No changes were applied"),
        orElse: () => false,
      ),
      isTrue,
    );
    expect(
      observedStates.where(
        (state) => state.maybeWhen(
          data: (tasks) => tasks.any((item) => item.status == TaskStatus.completed),
          orElse: () => false,
        ),
      ),
      isEmpty,
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

    await Future<void>.delayed(const Duration(milliseconds: 10));
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

    await Future<void>.delayed(const Duration(milliseconds: 10));
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
    await Future<void>.delayed(const Duration(milliseconds: 10));
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


  test('task stream recovers when a snapshot arrives after a network error', () async {
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

    await Future<void>.delayed(const Duration(milliseconds: 10));
    repository.taskStream.addError(StateError('network unavailable'));

    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        error: (_) => true,
        orElse: () => false,
      ),
    );

    repository.taskStream.add([_task()]);
    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        data: (tasks) => tasks.length == 1 && tasks.single.id == 'task-1',
        orElse: () => false,
      ),
    );

    expect(
      bloc.state.maybeWhen(data: (tasks) => tasks.single.title, orElse: () => null),
      'Test task',
    );
  });

  test('failed add, update, and delete writes do not change stream-backed data', () async {
    final authBloc = _FakeAppAuthBloc(
      AppAuthState.authenticated(
        const UserEntity(uid: 'user-1', isEmailVerified: true),
      ),
    );
    final repository = _FakeTaskRepository()
      ..addFailure = StateError('add failed')
      ..updateFailure = StateError('update failed')
      ..deleteFailure = StateError('delete failed');
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
    await Future<void>.delayed(const Duration(milliseconds: 10));
    repository.taskStream.add([task]);
    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        data: (tasks) => tasks.length == 1 && tasks.single.id == task.id,
        orElse: () => false,
      ),
    );
    final observedStates = <TaskState>[];
    final stateSubscription = bloc.stream.listen(observedStates.add);
    addTearDown(stateSubscription.cancel);

    bloc.add(TaskEvent.add(task.copyWith(id: 'task-2', title: 'Unsaved task')));
    bloc.add(TaskEvent.update(task.copyWith(title: 'Unsaved title')));
    bloc.add(const TaskEvent.delete('task-1'));
    await Future<void>.delayed(const Duration(milliseconds: 30));

    expect(
      bloc.state.maybeWhen(
        effect: (message, _, _) => message.contains("Couldn't"),
        orElse: () => false,
      ),
      isTrue,
    );
    expect(
      observedStates.where(
        (state) => state.maybeWhen(
          data: (tasks) => tasks.any(
            (item) => item.id == 'task-2' || item.title == 'Unsaved title',
          ),
          orElse: () => false,
        ),
      ),
      isEmpty,
    );
  });

  test('status updates still work after an undo snackbar effect', () async {
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

    await Future<void>.delayed(const Duration(milliseconds: 10));
    repository.taskStream.add([_task()]);
    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        data: (tasks) => tasks.length == 1,
        orElse: () => false,
      ),
    );
    bloc.add(const TaskEvent.updateStatus(
      taskId: 'task-1',
      status: TaskStatus.completed,
      showSnackBar: true,
    ));
    await Future<void>.delayed(Duration.zero);
    repository.updateGate.complete();
    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        effect: (message, _, _) => message.contains('Status changed'),
        orElse: () => false,
      ),
    );

    bloc.add(const TaskEvent.updateStatus(
      taskId: 'task-1',
      status: TaskStatus.pending,
    ));
    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        data: (tasks) => tasks.single.status == TaskStatus.pending,
        orElse: () => false,
      ),
    );
    expect(repository.lastUpdatedTask?.status, TaskStatus.pending);
  });

  test('cached tasks remain available after a transient stream error', () async {
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

    await Future<void>.delayed(const Duration(milliseconds: 10));
    repository.taskStream.add([_task()]);
    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        data: (tasks) => tasks.length == 1,
        orElse: () => false,
      ),
    );
    repository.taskStream.addError(StateError('temporary network loss'));
    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        effect: (message, _, _) => message.startsWith('Connection lost.'),
        orElse: () => false,
      ),
    );

    repository.taskStream.add([_task().copyWith(title: 'Recovered task')]);
    await bloc.stream.firstWhere(
      (state) => state.maybeWhen(
        data: (tasks) => tasks.single.title == 'Recovered task',
        orElse: () => false,
      ),
    );
  });


}
