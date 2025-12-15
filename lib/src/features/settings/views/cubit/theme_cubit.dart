import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  /// Stores user preference when NOT using system
  ThemeMode _userTheme = ThemeMode.light;

  ThemeCubit() : super(ThemeMode.system);

  /// Toggle system theme
  void setSystemMode(bool enabled) {
    if (enabled) {
      // Save current user preference before switching to system
      if (state != ThemeMode.system) {
        _userTheme = state;
      }
      emit(ThemeMode.system);
    } else {
      // Restore user preference
      emit(_userTheme);
    }
  }

  /// Toggle dark mode manually
  void setDarkMode(bool enabled) {
    final newTheme = enabled ? ThemeMode.dark : ThemeMode.light;

    _userTheme = newTheme;

    // If currently following system, keep system mode
    if (state == ThemeMode.system) return;

    emit(newTheme);
  }

  // ──────────────────────────────
  // Hydration
  // ──────────────────────────────

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    final theme = json['themeMode'];
    final userTheme = json['userTheme'];

    _userTheme = _parseTheme(userTheme) ?? ThemeMode.light;
    return _parseTheme(theme) ?? ThemeMode.system;
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {'themeMode': state.toString(), 'userTheme': _userTheme.toString()};
  }

  ThemeMode? _parseTheme(String? value) {
    switch (value) {
      case 'ThemeMode.system':
        return ThemeMode.system;
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
    }
    return null;
  }
}
