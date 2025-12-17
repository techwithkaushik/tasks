import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tasks/core/constants/global_constant.dart';

class DynamicColorCubit extends HydratedCubit<bool> {
  DynamicColorCubit() : super(false);

  void setDynamicColor(bool value) => emit(value);

  @override
  bool? fromJson(Map<String, dynamic> json) {
    return json[GlobalConstant.dynamicColor];
  }

  @override
  Map<String, dynamic>? toJson(bool useDynamic) {
    return {GlobalConstant.dynamicColor: useDynamic};
  }
}
