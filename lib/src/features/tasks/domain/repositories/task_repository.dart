import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Stream<List<Task>> watchTasks();

  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
}
