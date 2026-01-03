import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tasks/src/features/tasks/data/models/task.dart';

class TaskTypeCubit extends Cubit<TaskType> {
  TaskTypeCubit() : super(TaskType.daily);
  void setTaskType(TaskType taskType) {
    emit(taskType);
  }
}
