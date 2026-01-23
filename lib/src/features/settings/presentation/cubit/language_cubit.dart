/// Cubit for managing application language and localization
///
/// Handles switching between supported languages and persisting the user's choice
/// Supports: English, Hindi, and system default
///
/// The language preference is automatically persisted to device storage using HydratedCubit
library;

import 'dart:ui';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tasks/src/core/constants/global_constant.dart';

/// Manages app language/locale settings
///
/// State: Locale? (null for system default, or specific locale for manual selection)
///
/// Persisted values:
/// - Language code (e.g., 'en', 'hi')
/// - Country code (optional)
class LanguageCubit extends HydratedCubit<Locale?> {
  /// Creates the cubit with null state (system default language)
  LanguageCubit() : super(null);

  /// Changes the app language
  ///
  /// Parameters:
  /// - `locale`: The new locale to use, or null for system default
  ///
  /// Example:
  /// ```dart
  /// setLocale(const Locale('en'));      // English
  /// setLocale(const Locale('hi'));      // Hindi
  /// setLocale(null);                     // System default
  /// ```
  void setLocale(Locale? locale) => emit(locale);

  /// Restores language preference from persistent storage
  @override
  Locale? fromJson(Map<String, dynamic> json) {
    final code = json[GlobalConstant.languageCode] as String?;
    if (code == null) return null;
    final countryCode = json[GlobalConstant.countryCode] as String?;
    return Locale(code, countryCode);
  }

  /// Persists language preference to storage
  @override
  Map<String, dynamic>? toJson(Locale? state) {
    return {
      GlobalConstant.languageCode: state?.languageCode,
      GlobalConstant.countryCode: state?.countryCode,
    };
  }
}
