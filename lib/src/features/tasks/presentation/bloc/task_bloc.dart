import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/src/features/tasks/domain/entities/task.state_machine.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/domain/usecases/add_task_use_case.dart';
import 'package:tasks/src/features/tasks/domain/usecases/delete_task_use_case.dart';
import 'package:tasks/src/features/tasks/domain/usecases/update_task_use_case.dart';
import 'package:tasks/src/features/tasks/domain/usecases/watch_task_use_case.dart';
part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final WatchTaskUseCase watchTaskUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  StreamSubscription? _sub;

  TaskBloc(
    this.watchTaskUseCase,
    this.addTaskUseCase,
    this.updateTaskUseCase,
    this.deleteTaskUseCase,
  ) : super(TaskLoading()) {
    on<StartTaskStream>(_onStart);
    on<TasksUpdated>(_onUpdated);
    on<AddTaskEvent>(_onAdd);
    on<UpdateTaskEvent>(_onUpdate);
    on<DeleteTaskEvent>(_onDelete);
  }

  void _onStart(_, emit) {
    _sub?.cancel();
    _sub = watchTaskUseCase().listen(
      (tasks) => add(TasksUpdated(tasks)),
      onError: (e) => emit(TaskFailure(e.toString())),
    );
  }

  void _onUpdated(TasksUpdated e, emit) => emit(TaskLoaded(e.tasks));

  Future<void> _onAdd(AddTaskEvent e, _) => addTaskUseCase(e.task);

  Future<void> _onUpdate(UpdateTaskEvent e, _) async {
    final updated = TaskStateMachine.transition(e.task, e.to);
    await updateTaskUseCase(updated);
  }

  Future<void> _onDelete(DeleteTaskEvent e, _) => deleteTaskUseCase(e.id);

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}

class FocusCubit extends Cubit<Task?> {
  FocusCubit() : super(null);

  void select(List<Task> tasks) {
    emit(
      tasks.firstWhere(
        (t) => t.status == TaskStatus.pending,
        orElse: () => tasks.first,
      ),
    );
  }
}

class PlanningCubit extends Cubit<Map<DateTime, List<Task>>> {
  PlanningCubit() : super({});

  void plan(List<Task> tasks) {
    final map = <DateTime, List<Task>>{};
    for (final t in tasks) {
      final key = t.dueDate ?? DateTime(2100);
      map.putIfAbsent(key, () => []).add(t);
    }
    emit(map);
  }
}

class ReviewCubit extends Cubit<int> {
  ReviewCubit() : super(0);

  void analyze(List<Task> tasks) {
    emit(tasks.where((t) => t.status == TaskStatus.completed).length);
  }
}
