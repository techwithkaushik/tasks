/// Cubit for managing application theme settings
///
/// Handles theme persistence and switching between:
/// - System default theme
/// - Light theme
/// - Dark theme
/// - Pure dark mode (black background)
///
/// The theme preference is automatically persisted to device storage using HydratedCubit
library;

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tasks/src/core/constants/global_constant.dart';

/// Manages theme mode and persistence
///
/// State: ThemeMode (system, light, dark)
///
/// Persisted values:
/// - Current theme mode
/// - User's manual theme preference
/// - Pure dark mode setting
class ThemeCubit extends HydratedCubit<ThemeMode> {
  /// Stores the user's manual theme preference (light/dark)
  /// Used when switching between system and manual mode
  ThemeMode _userTheme = ThemeMode.light;

  /// Whether to use pure black in dark mode instead of gray tones
  bool _usePureDarkMode = false;

  ThemeCubit() : super(ThemeMode.system);

  /// Enables or disables following the system theme
  ///
  /// When enabled:
  /// - App uses device's theme preference (light/dark)
  /// - User's manual theme setting is saved
  ///
  /// When disabled:
  /// - App returns to the previously selected manual theme
  void setSystemMode(bool enabled) {
    if (enabled) {
      // Save current manual theme before switching to system
      if (state != ThemeMode.system) {
        _userTheme = state;
      }
      emit(ThemeMode.system);
    } else {
      // Switch back to saved manual theme
      emit(_userTheme);
    }
  }

  /// Toggles between light and dark theme (manual mode only)
  ///
  /// Only works if not following system theme
  /// Updates both current theme and saved preference
  void setDarkMode(bool enabled) {
    final newTheme = enabled ? ThemeMode.dark : ThemeMode.light;

    // Save as user preference
    _userTheme = newTheme;

    // Only emit if not in system mode
    if (state == ThemeMode.system) return;

    emit(newTheme);
  }

  /// Gets the current pure dark mode setting
  bool get usePureDarkMode => _usePureDarkMode;

  /// Toggles pure dark mode (pure black vs gray in dark theme)
  void setPureDarkMode(bool enabled) {
    _usePureDarkMode = enabled;
    emit(state);
  }

  /// Restores theme state from persistent storage
  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    final theme = json[GlobalConstant.themeMode];
    final userTheme = json[GlobalConstant.userTheme];
    final pureDarkMode = json['pureDarkMode'] as bool?;

    _userTheme = _parseTheme(userTheme) ?? ThemeMode.light;
    _usePureDarkMode = pureDarkMode ?? false;
    return _parseTheme(theme) ?? ThemeMode.system;
  }

  /// Persists theme state to storage
  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {
      GlobalConstant.themeMode: state.toString(),
      GlobalConstant.userTheme: _userTheme.toString(),
      'pureDarkMode': _usePureDarkMode,
    };
  }

  /// Parses string representation to ThemeMode enum
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
