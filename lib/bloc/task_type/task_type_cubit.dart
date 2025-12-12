import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tasks/models/task.dart';

class TaskTypeCubit extends Cubit<TaskType> {
  TaskTypeCubit() : super(TaskType.daily);
  void setTaskType(TaskType taskType) {
    emit(taskType);
  }
}
