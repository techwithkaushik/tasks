import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tasks/core/constants/language.dart';
import 'package:tasks/core/constants/global_constant.dart';
import 'package:tasks/core/features/home/home_page.dart';
import 'package:tasks/core/features/home/nav_cubit.dart';
import 'package:tasks/core/features/settings/presentation/cubit/dynamic_color_cubit.dart';
import 'package:tasks/core/features/settings/presentation/cubit/language_cubit.dart';
import 'package:tasks/core/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:tasks/core/features/tasks/data/models/task.dart';
import 'package:tasks/core/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:tasks/core/features/tasks/presentation/cubit/task_type_cubit.dart';
import 'package:tasks/l10n/app_localizations.dart';
import 'package:tasks/core/theme_data.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Task>(GlobalConstant.tasksBox);
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (_) => TaskBloc(box)..add(LoadTasksEvent()),
        ),
        BlocProvider<NavCubit>(create: (_) => NavCubit()),
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<DynamicColorCubit>(create: (_) => DynamicColorCubit()),
        BlocProvider<TaskTypeCubit>(create: (_) => TaskTypeCubit()),
        BlocProvider<LanguageCubit>(create: (_) => LanguageCubit()),
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
                          useDynamic,
                          lightDynamic,
                          Brightness.light,
                        ),
                        darkTheme: themeData(
                          useDynamic,
                          darkDynamic,
                          Brightness.dark,
                        ),
                        themeMode: themeMode,
                        home: const HomePage(),
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
