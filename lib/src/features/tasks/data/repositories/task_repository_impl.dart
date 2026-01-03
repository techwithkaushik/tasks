import 'package:tasks/src/features/tasks/data/datasources/task_firestore_datasource.dart';
import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskFirestoreDataSource ds;

  TaskRepositoryImpl(this.ds);

  @override
  Stream<List<Task>> watchTasks() => ds.watchTasks();

  @override
  Future<void> addTask(Task task) => ds.addTask(task);

  @override
  Future<void> updateTask(Task task) => ds.updateTask(task);

  @override
  Future<void> deleteTask(String taskId) => ds.deleteTask(taskId);
}
