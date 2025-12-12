import 'package:hydrated_bloc/hydrated_bloc.dart';

class DynamicColorCubit extends HydratedCubit<bool> {
  DynamicColorCubit() : super(false);

  void setDynamicColor(bool value) => emit(value);

  @override
  bool? fromJson(Map<String, dynamic> json) {
    return json['dynamicColor'];
  }

  @override
  Map<String, dynamic>? toJson(bool useDynamic) {
    return {'dynamicColor': useDynamic};
  }
}
