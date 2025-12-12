import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../models/task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final Box<Task> taskBox;
  TaskBloc(this.taskBox) : super(const TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletion);
    on<ToggleTaskFavoriteEvent>(_onToggleTaskFavorite);
    on<ClearErrorEvent>(_onClearError);
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      emit(TaskLoading(tasks: state.tasks));
      await Future.delayed(const Duration(seconds: 2));
      final tasks = taskBox.values.toList();
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(error: e.toString(), tasks: state.tasks));
    }
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    try {
      final newTask = event.task;
      await taskBox.put(newTask.id, newTask);
      final updatedTasks = List<Task>.from(state.tasks)..add(newTask);
      emit(TaskLoaded(tasks: updatedTasks));
    } catch (e) {
      emit(TaskError(error: e.toString(), tasks: state.tasks));
    }
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final updatedTask = event.task;
      await taskBox.put(updatedTask.id, updatedTask);
      final updatedTasks = state.tasks.map((task) {
        return task.id == updatedTask.id ? updatedTask : task;
      }).toList();
      emit(TaskLoaded(tasks: updatedTasks));
    } catch (e) {
      emit(TaskError(error: e.toString(), tasks: state.tasks));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await taskBox.delete(event.taskId);
      final updatedTasks = state.tasks
          .where((task) => task.id != event.taskId)
          .toList();
      emit(TaskLoaded(tasks: updatedTasks));
    } catch (e) {
      emit(TaskError(error: e.toString(), tasks: state.tasks));
    }
  }

  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletionEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final task = state.tasks.firstWhere((t) => t.id == event.taskId);
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await taskBox.put(updatedTask.id, updatedTask);
      final updatedTasks = state.tasks.map((t) {
        return t.id == updatedTask.id ? updatedTask : t;
      }).toList();
      emit(TaskLoaded(tasks: updatedTasks));
    } catch (e) {
      emit(TaskError(error: e.toString(), tasks: state.tasks));
    }
  }

  Future<void> _onToggleTaskFavorite(
    ToggleTaskFavoriteEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final task = state.tasks.firstWhere((t) => t.id == event.taskId);
      final updatedTask = task.copyWith(isFavorite: !task.isFavorite);
      await taskBox.put(updatedTask.id, updatedTask);
      final updatedTasks = state.tasks.map((t) {
        return t.id == updatedTask.id ? updatedTask : t;
      }).toList();
      emit(TaskLoaded(tasks: updatedTasks));
    } catch (e) {
      emit(TaskError(error: e.toString(), tasks: state.tasks));
    }
  }

  Future<void> _onClearError(
    ClearErrorEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoaded(tasks: state.tasks));
  }
}
