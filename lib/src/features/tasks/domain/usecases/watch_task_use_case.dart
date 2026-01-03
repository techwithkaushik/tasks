import 'package:tasks/src/features/tasks/domain/entities/task_entity.dart';
import 'package:tasks/src/features/tasks/domain/repositories/task_repository.dart';

class WatchTaskUseCase {
  final TaskRepository repo;
  WatchTaskUseCase(this.repo);

  Stream<List<Task>> call() => repo.watchTasks();
}
