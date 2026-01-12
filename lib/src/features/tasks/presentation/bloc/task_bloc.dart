import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/service_locator.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_state.dart';
import 'package:tasks/src/features/tasks/domain/entities/task.state_machine.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/domain/usecases/add_task_use_case.dart';
import 'package:tasks/src/features/tasks/domain/usecases/delete_task_use_case.dart';
import 'package:tasks/src/features/tasks/domain/usecases/update_task_use_case.dart';
import 'package:tasks/src/features/tasks/domain/usecases/load_task_use_case.dart';
part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final LoadTaskUseCase loadTaskUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  StreamSubscription? _sub;

  TaskBloc(
    this.loadTaskUseCase,
    this.addTaskUseCase,
    this.updateTaskUseCase,
    this.deleteTaskUseCase,
  ) : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoad);
    on<StopTasksEvent>(_onStop);
    on<AddTaskEvent>(_onAdd);
    on<UpdateTaskEvent>(_onUpdate);
    on<DeleteTaskEvent>(_onDelete);
  }

  FutureOr<void> _onLoad(LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    await _sub?.cancel();

    final user = sl<AppAuthBloc>().state;
    if (user is! AppAuthAuthenticated) {
      emit(TaskInitial());
      return;
    }
    await emit.forEach<List<Task>>(
      loadTaskUseCase(user.user.uid),
      onData: (tasks) =>
          tasks.isEmpty ? TaskEmpty() : TaskLoaded(List.of(tasks)),
      onError: (error, _) => TaskError(error.toString()),
    );
  }

  void _onStop(StopTasksEvent event, Emitter<TaskState> emit) async {
    _sub?.cancel();
    emit(TaskInitial());
  }

  FutureOr<void> _onAdd(AddTaskEvent event, Emitter<TaskState> emit) async {
    final authState = sl<AppAuthBloc>().state;
    if (authState is! AppAuthAuthenticated) return;

    await addTaskUseCase(event.task);
  }

  // Future<void> _onAdd(AddTaskEvent event, _) async {
  //   return addTaskUseCase(event.task);
  // }

  Future<void> _onUpdate(UpdateTaskEvent event, _) async {
    final updated = TaskStateMachine.transition(event.task, event.to);
    updateTaskUseCase(updated);
  }

  Future<void> _onDelete(DeleteTaskEvent event, _) async {
    deleteTaskUseCase(event.id);
  }

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
