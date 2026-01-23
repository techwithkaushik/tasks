import 'package:flutter_test/flutter_test.dart';
import 'package:tasks/src/features/task_add/presentation/bloc/task_add_bloc.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/presentation/bloc/task_bloc.dart';

// Mock TaskBloc that provides a specific state
class _MockTaskBloc {
  TaskState _state;
  _MockTaskBloc({required TaskState initialState}) : _state = initialState;

  TaskState get state => _state;
  void setState(TaskState state) => _state = state;

  void add(TaskEvent event) {}
  Future<void> close() async {}
}

// Wrapper to make mock compatible with TaskAddBloc
class _TaskBlocWrapper implements TaskBloc {
  final _MockTaskBloc _mock;

  _TaskBlocWrapper(_MockTaskBloc mock) : _mock = mock;

  @override
  TaskState get state => _mock.state;

  @override
  Stream<TaskState> get stream => Stream.empty();

  @override
  Future<void> close() => _mock.close();

  @override
  void add(TaskEvent event) => _mock.add(event);

  @override
  bool get isClosed => false;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('TaskAddBloc - Real-time Validation & Duplicate Detection', () {
    test('emits titleError when title is empty', () async {
      final mockTaskBloc = _TaskBlocWrapper(
        _MockTaskBloc(initialState: TaskState.data(tasks: [])),
      );
      final taskAddBloc = TaskAddBloc(taskBloc: mockTaskBloc);

      taskAddBloc.add(TaskAddTitleChanged(''));
      await Future.delayed(Duration(milliseconds: 50));

      expect(taskAddBloc.state.titleError, 'Title is required');
      expect(taskAddBloc.state.title, '');

      taskAddBloc.close();
    });

    test('clears titleError when title is not empty', () async {
      final mockTaskBloc = _TaskBlocWrapper(
        _MockTaskBloc(initialState: TaskState.data(tasks: [])),
      );
      final taskAddBloc = TaskAddBloc(taskBloc: mockTaskBloc);

      taskAddBloc.add(TaskAddTitleChanged('New Task'));
      await Future.delayed(Duration(milliseconds: 50));

      expect(taskAddBloc.state.titleError, null);
      expect(taskAddBloc.state.title, 'New Task');

      taskAddBloc.close();
    });

    test('detects duplicate title (case-insensitive)', () async {
      final existingTask = Task(
        id: '1',
        userId: 'user123',
        title: 'Existing Task',
        description: '',
        type: TaskType.single,
        priority: TaskPriority.medium,
        status: TaskStatus.pending,
        lastStatus: TaskStatus.pending,
        createdAt: DateTime.now(),
        estimatedMinutes: 30,
      );

      final mockTaskBloc = _TaskBlocWrapper(
        _MockTaskBloc(initialState: TaskState.data(tasks: [existingTask])),
      );
      final taskAddBloc = TaskAddBloc(taskBloc: mockTaskBloc);

      // Test with exact case match
      taskAddBloc.add(TaskAddTitleChanged('Existing Task'));
      await Future.delayed(Duration(milliseconds: 50));
      expect(taskAddBloc.state.isDuplicate, true);
      expect(taskAddBloc.state.title, 'Existing Task');

      // Test with different case
      taskAddBloc.add(TaskAddTitleChanged('existing task'));
      await Future.delayed(Duration(milliseconds: 50));
      expect(taskAddBloc.state.isDuplicate, true);
      expect(taskAddBloc.state.title, 'existing task');

      // Test with different title
      taskAddBloc.add(TaskAddTitleChanged('New Task'));
      await Future.delayed(Duration(milliseconds: 50));
      expect(taskAddBloc.state.isDuplicate, false);
      expect(taskAddBloc.state.title, 'New Task');

      taskAddBloc.close();
    });

    test('prevents submission when title is empty', () async {
      final mockTaskBloc = _TaskBlocWrapper(
        _MockTaskBloc(initialState: TaskState.data(tasks: [])),
      );
      final taskAddBloc = TaskAddBloc(taskBloc: mockTaskBloc);

      taskAddBloc.add(TaskAddTitleChanged(''));
      await Future.delayed(Duration(milliseconds: 50));

      taskAddBloc.add(TaskAddSubmitted());
      await Future.delayed(Duration(milliseconds: 100));

      expect(taskAddBloc.state.error, 'Title is required');
      expect(taskAddBloc.state.isSuccess, false);

      taskAddBloc.close();
    });

    test('prevents submission when title is duplicate', () async {
      final existingTask = Task(
        id: '1',
        userId: 'user123',
        title: 'Duplicate Task',
        description: '',
        type: TaskType.single,
        priority: TaskPriority.medium,
        status: TaskStatus.pending,
        lastStatus: TaskStatus.pending,
        createdAt: DateTime.now(),
        estimatedMinutes: 30,
      );

      final mockTaskBloc = _TaskBlocWrapper(
        _MockTaskBloc(initialState: TaskState.data(tasks: [existingTask])),
      );
      final taskAddBloc = TaskAddBloc(taskBloc: mockTaskBloc);

      taskAddBloc.add(TaskAddTitleChanged('duplicate task'));
      await Future.delayed(Duration(milliseconds: 50));

      taskAddBloc.add(TaskAddSubmitted());
      await Future.delayed(Duration(milliseconds: 100));

      expect(taskAddBloc.state.error, 'A task with this title already exists');
      expect(taskAddBloc.state.isSuccess, false);

      taskAddBloc.close();
    });

    test('resets form to initial state', () async {
      final mockTaskBloc = _TaskBlocWrapper(
        _MockTaskBloc(initialState: TaskState.data(tasks: [])),
      );
      final taskAddBloc = TaskAddBloc(taskBloc: mockTaskBloc);

      // Modify form
      taskAddBloc.add(TaskAddTitleChanged('Some Title'));
      await Future.delayed(Duration(milliseconds: 50));

      taskAddBloc.add(TaskAddDescriptionChanged('Some Description'));
      await Future.delayed(Duration(milliseconds: 50));

      expect(taskAddBloc.state.title, 'Some Title');
      expect(taskAddBloc.state.description, 'Some Description');

      // Reset
      taskAddBloc.add(TaskAddReset());
      await Future.delayed(Duration(milliseconds: 50));

      expect(taskAddBloc.state.title, '');
      expect(taskAddBloc.state.description, '');
      expect(taskAddBloc.state.isDuplicate, false);
      expect(taskAddBloc.state.titleError, null);

      taskAddBloc.close();
    });
  });
}
