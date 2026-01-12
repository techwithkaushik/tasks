import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/domain/repositories/task_repository.dart';

class LoadTaskUseCase {
  final TaskRepository repo;
  LoadTaskUseCase(this.repo);

  Stream<List<Task>> call(String userId) => repo.loadTasks(userId);
}
