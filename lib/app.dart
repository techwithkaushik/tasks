import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tasks/src/core/constants/language.dart';
import 'package:tasks/src/features/home/cubit/nav_cubit.dart';

import 'package:tasks/src/features/settings/presentation/cubit/dynamic_color_cubit.dart';
import 'package:tasks/src/features/settings/presentation/cubit/language_cubit.dart';
import 'package:tasks/src/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:tasks/l10n/app_localizations.dart';
import 'package:tasks/src/core/theme_data.dart';
import 'package:tasks/service_locator.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/presentation/pages/auth_page.dart';
import 'package:tasks/src/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:tasks/src/features/tasks/presentation/cubit/task_type_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DynamicColorCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => LanguageCubit()),
        BlocProvider(create: (_) => NavCubit()),
        BlocProvider(create: (_) => sl<TaskBloc>()),
        BlocProvider(create: (_) => TaskTypeCubit()),
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
                        home: BlocProvider.value(
                          value: sl<AppAuthBloc>(),
                          child: AppAuthPage(),
                        ),
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
