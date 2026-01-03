import 'package:tasks/src/features/tasks/domain/repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository repo;
  DeleteTaskUseCase(this.repo);

  Future<void> call(String id) => repo.deleteTask(id);
}
