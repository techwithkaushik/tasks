import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/domain/repositories/task_repository.dart';

class AddTaskUseCase {
  final TaskRepository repo;
  AddTaskUseCase(this.repo);

  Future<void> call(Task task) => repo.addTask(task);
}
