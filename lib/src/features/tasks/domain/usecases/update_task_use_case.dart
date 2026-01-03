import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/domain/repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository repo;
  UpdateTaskUseCase(this.repo);

  Future<void> call(Task task) => repo.updateTask(task);
}
