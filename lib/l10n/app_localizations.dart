import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// about the app
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Button label to add a new task
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Title or action text for adding a new task
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTask;

  /// Application title shown in app bar and launcher
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get appTitle;

  /// Button label to cancel the current action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Prompt to select application language
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguage;

  /// Task status indicating completion
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Label for task description or content field
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// Label indicating task creation date or status
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// Toggle label to enable dark mode manually
  ///
  /// In en, this message translates to:
  /// **'Enable dark theme'**
  String get darkMode;

  /// Explanation text for dark mode toggle
  ///
  /// In en, this message translates to:
  /// **'Switch to dark theme manually'**
  String get darkModeDescriptionEnabled;

  /// Explanation text for dark mode toggle
  ///
  /// In en, this message translates to:
  /// **'Disable Follow system theme to enable dark theme manually'**
  String get darkModeDescriptionDisabled;

  /// Toggle label for dynamic system colors
  ///
  /// In en, this message translates to:
  /// **'Dynamic color'**
  String get dynamicColor;

  /// Explanation text for dynamic color option
  ///
  /// In en, this message translates to:
  /// **'Use wallpaper-based system colors'**
  String get dynamicColorDescription;

  /// Language option for English
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Generic error title or label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Toggle label to follow system theme
  ///
  /// In en, this message translates to:
  /// **'Follow system theme'**
  String get followSystemTheme;

  /// Explanation text for system theme option
  ///
  /// In en, this message translates to:
  /// **'Automatically match system dark mode'**
  String get followSystemThemeDescription;

  /// Language option for Hindi
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// Label for language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Explanation text for language selection
  ///
  /// In en, this message translates to:
  /// **'Choose app language'**
  String get languageDescription;

  /// Empty state message when no tasks exist
  ///
  /// In en, this message translates to:
  /// **'No tasks added yet.'**
  String get noTaskAdded;

  /// Empty state message when no tasks are completed
  ///
  /// In en, this message translates to:
  /// **'No tasks completed yet.'**
  String get noTaskCompleted;

  /// Task status indicating pending state
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Title of the settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Label for task status field
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Language option to follow system default
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// Label for task title field
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// welcome note for signin
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// create account for tasks app
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// signin account
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signin;

  /// signup account
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signup;

  /// forgot password of account
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPassword;

  /// email account
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// password for account
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// dont have an account
  ///
  /// In en, this message translates to:
  /// **'Dont have an account? '**
  String get dontHaveAnAccount;

  /// already have an account
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAnAccount;

  /// confirm password
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// Password reset email sent
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get passwordResetEmailSent;

  /// Invalid email
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// Min 6 characters
  ///
  /// In en, this message translates to:
  /// **'Min 6 characters'**
  String get min6characters;

  /// Passwords do not match
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
