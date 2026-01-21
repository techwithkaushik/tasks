import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tasks/src/core/constants/global_constant.dart';

class ThemeCubit extends HydratedCubit<(ThemeMode, bool)>
    with WidgetsBindingObserver {
  ThemeMode _userTheme = ThemeMode.light;
  bool _pureBlack = false;
  bool _pureBlackMemory = false;

  ThemeCubit() : super((ThemeMode.system, false)) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  @override
  void didChangePlatformBrightness() {
    final mode = state.$1;
    if (mode == ThemeMode.system) {
      final oldEffective = state.$2;
      final newEffectiveDark = _isEffectiveDark();
      if (!newEffectiveDark && oldEffective) {
        _pureBlack = false;
      } else {
        _pureBlack = _pureBlackMemory;
      }
    }
    emit((mode, _pureBlack));
    super.didChangePlatformBrightness();
  }

  void setSystemMode(bool enabled) {
    if (enabled) {
      if (state.$1 != ThemeMode.system) {
        _userTheme = state.$1;
      }
      emit((ThemeMode.system, state.$2));
    } else {
      emit((_userTheme, state.$2));
    }
  }

  void setDarkMode(bool enabled) {
    final newTheme = enabled ? ThemeMode.dark : ThemeMode.light;
    _userTheme = newTheme;

    if (state.$1 == ThemeMode.system) return;
    emit((newTheme, state.$2));
  }

  void setPureBlack(bool enabled) {
    if (_isEffectiveDark()) {
      _pureBlack = enabled;
      _pureBlackMemory = enabled;
      emit((state.$1, _pureBlack));
    }
  }

  bool _isEffectiveDark() {
    if (state.$1 == ThemeMode.dark) return true;
    if (state.$1 == ThemeMode.light) return false;

    final platformBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return platformBrightness == Brightness.dark;
  }

  bool get isEffectiveDark => _isEffectiveDark();

  @override
  (ThemeMode, bool)? fromJson(Map<String, dynamic> json) {
    final theme = json[GlobalConstant.themeMode];
    final userTheme = json[GlobalConstant.userTheme];

    _userTheme = _parseTheme(userTheme) ?? ThemeMode.light;
    _pureBlack = json['pureBlack'] ?? false;
    _pureBlackMemory = json['pureBlackMemory'] ?? false;
    return (_parseTheme(theme) ?? ThemeMode.system, _pureBlack);
  }

  @override
  Map<String, dynamic>? toJson((ThemeMode, bool) state) {
    return {
      GlobalConstant.themeMode: state.toString(),
      GlobalConstant.userTheme: _userTheme.toString(),
      'pureBlack': _pureBlack,
      'pureBlackMemory': _pureBlackMemory,
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
