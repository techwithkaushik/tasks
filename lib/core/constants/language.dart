import 'dart:ui';

enum Language { en, hi }

extension LanguageX on Language {
  /// ISO language code
  String get code => name;

  /// Locale for MaterialApp
  Locale get locale => Locale(code);

  /// Native language name (does NOT change with app language)
  String get nativeName {
    switch (this) {
      case Language.en:
        return 'English';
      case Language.hi:
        return 'हिन्दी';
    }
  }
}
