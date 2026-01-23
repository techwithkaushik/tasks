/// Main application widget that sets up the global configuration and providers.
///
/// This widget:
/// - Provides BLoCs and Cubits to the entire app via MultiBlocProvider
/// - Configures dynamic color theming
/// - Sets up localization (i18n) support
/// - Manages theme mode (light/dark/system)
/// - Routes to AppAuthPage for authentication handling
library;

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tasks/src/core/constants/language.dart';
import 'package:tasks/src/features/settings/presentation/cubit/dynamic_color_cubit.dart';
import 'package:tasks/src/features/settings/presentation/cubit/language_cubit.dart';
import 'package:tasks/src/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:tasks/l10n/app_localizations.dart';
import 'package:tasks/src/core/theme_data.dart';
import 'package:tasks/service_locator.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/presentation/pages/auth_page.dart';
import 'package:tasks/src/features/tasks/presentation/bloc/task_bloc.dart';

/// Root application widget
///
/// Provides global configuration including theme, language, and BLoC instances
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      /// Provides all global BLoCs and Cubits
      providers: [
        BlocProvider.value(
          value: sl<AppAuthBloc>(),
        ), // Authentication state management
        BlocProvider(
          create: (_) => DynamicColorCubit(),
        ), // Dynamic color theming
        BlocProvider(create: (_) => ThemeCubit()), // Theme mode management
        BlocProvider(create: (_) => LanguageCubit()), // Language/localization
        BlocProvider(
          create: (_) => sl<TaskBloc>(),
        ), // Task list state management
      ],
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          return BlocSelector<ThemeCubit, ThemeMode, ThemeMode>(
            selector: (state) => state,
            builder: (_, themeMode) {
              return BlocSelector<DynamicColorCubit, bool, bool>(
                selector: (state) => state,
                builder: (_, useDynamic) {
                  return BlocSelector<LanguageCubit, Locale?, Locale?>(
                    selector: (state) => state,
                    builder: (_, locale) {
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        onGenerateTitle: (context) {
                          return AppLocalizations.of(context).appTitle;
                        },
                        locale: locale,
                        supportedLocales: Language.values
                            .map((lang) => lang.locale)
                            .toList(),
                        localizationsDelegates: const [
                          AppLocalizations.delegate,
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                        ],
                        theme: themeData(
                          useDynamic: useDynamic,
                          colorScheme: lightDynamic,
                          brightness: Brightness.light,
                        ),
                        darkTheme: themeData(
                          useDynamic: useDynamic,
                          colorScheme: darkDynamic,
                          brightness: Brightness.dark,
                        ),
                        themeMode: themeMode,
                        home: AppAuthPage(),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
