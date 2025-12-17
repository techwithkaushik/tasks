import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tasks/core/constants/global_constant.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeMode _userTheme = ThemeMode.light;

  ThemeCubit() : super(ThemeMode.system);

  void setSystemMode(bool enabled) {
    if (enabled) {
      if (state != ThemeMode.system) {
        _userTheme = state;
      }
      emit(ThemeMode.system);
    } else {
      emit(_userTheme);
    }
  }

  void setDarkMode(bool enabled) {
    final newTheme = enabled ? ThemeMode.dark : ThemeMode.light;

    _userTheme = newTheme;

    if (state == ThemeMode.system) return;

    emit(newTheme);
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    final theme = json[GlobalConstant.themeMode];
    final userTheme = json[GlobalConstant.userTheme];

    _userTheme = _parseTheme(userTheme) ?? ThemeMode.light;
    return _parseTheme(theme) ?? ThemeMode.system;
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {
      GlobalConstant.themeMode: state.toString(),
      GlobalConstant.userTheme: _userTheme.toString(),
    };
  }

  ThemeMode? _parseTheme(String? value) {
    switch (value) {
      case GlobalConstant.themeModeSystem:
        return ThemeMode.system;
      case GlobalConstant.themeModeLight:
        return ThemeMode.light;
      case GlobalConstant.themeModeDark:
        return ThemeMode.dark;
    }
    return null;
  }
}
