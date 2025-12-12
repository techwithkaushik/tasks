import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void setSystemMode(bool systemMode) {
    if (systemMode) {
      emit(ThemeMode.system);
    } else {
      emit(ThemeMode.light);
    }
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    final themeMode = json["themeMode"];
    switch (themeMode) {
      case 'ThemeMode.system':
        return ThemeMode.system;
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
    }
    return ThemeMode.system;
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode themeMode) {
    return {'themeMode': themeMode.toString()};
  }
}
