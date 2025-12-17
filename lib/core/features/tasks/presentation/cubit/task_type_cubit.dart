import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tasks/core/features/tasks/data/models/task.dart';

class TaskTypeCubit extends Cubit<TaskType> {
  TaskTypeCubit() : super(TaskType.daily);
  void setTaskType(TaskType taskType) {
    emit(taskType);
  }
}
