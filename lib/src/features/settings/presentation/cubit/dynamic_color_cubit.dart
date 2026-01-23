/// Cubit for managing dynamic color theming
///
/// Enables or disables Material You dynamic color theming which uses wallpaper colors
/// Available on Android 12+ and iOS 16+
///
/// When enabled: App colors are derived from the device's wallpaper and system palette
/// When disabled: App uses the default color scheme
///
/// The setting is automatically persisted to device storage using HydratedCubit
library;

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tasks/src/core/constants/global_constant.dart';

/// Manages dynamic/Material You color settings
///
/// State: bool (true = enabled, false = disabled)
/// Default: true (enabled)
///
/// Persisted values:
/// - Whether dynamic color is enabled
class DynamicColorCubit extends HydratedCubit<bool> {
  /// Creates the cubit with dynamic color enabled by default
  DynamicColorCubit() : super(true);

  /// Enables or disables dynamic color theming
  ///
  /// Parameters:
  /// - `value`: true to use wallpaper-based colors, false for default colors
  ///
  /// Note: Effect only visible on Android 12+ and iOS 16+
  /// On older versions, the default color scheme is always used
  void setDynamicColor(bool value) => emit(value);

  /// Restores dynamic color setting from persistent storage
  @override
  bool? fromJson(Map<String, dynamic> json) {
    return json[GlobalConstant.dynamicColor];
  }

  /// Persists dynamic color setting to storage
  @override
  Map<String, dynamic>? toJson(bool useDynamic) {
    return {GlobalConstant.dynamicColor: useDynamic};
  }
}
