import 'dart:ui';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class LanguageCubit extends HydratedCubit<String> {
  /// Stored value:
  ///   "system" → follow device language
  ///   "en"     → English
  ///   "hi"     → Hindi
  LanguageCubit() : super("system");

  void setLanguage(String code) => emit(code);

  /// Compute actual locale used by MaterialApp
  Locale resolveLocale() {
    if (state == "system") {
      final device = PlatformDispatcher.instance.locale;
      return Locale(device.languageCode);
    }
    return Locale(state);
  }

  @override
  String? fromJson(Map<String, dynamic> json) {
    return json["language"] as String? ?? "system";
  }

  @override
  Map<String, dynamic>? toJson(String state) {
    return {"language": state};
  }
}
