import 'dart:ui';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tasks/core/constants/global_constant.dart';

class LanguageCubit extends HydratedCubit<Locale?> {
  LanguageCubit() : super(null);

  void setLocale(Locale? locale) => emit(locale);

  Locale? get resolvedLocale {
    if (state == null) return null;
    return state;
  }

  @override
  Locale? fromJson(Map<String, dynamic> json) {
    final code = json[GlobalConstant.languageCode] as String?;
    if (code == null) return null;

    final countryCode = json[GlobalConstant.countryCode] as String?;
    return Locale(code, countryCode);
  }

  @override
  Map<String, dynamic>? toJson(Locale? state) {
    if (state == null) return null;

    return {
      GlobalConstant.languageCode: state.languageCode,
      GlobalConstant.countryCode: state.countryCode,
    };
  }
}
