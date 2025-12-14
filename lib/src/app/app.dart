import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tasks/l10n/app_localizations.dart';
import 'package:tasks/src/bloc/navigation/nav_cubit.dart';
import 'package:tasks/src/bloc/settings/language_cubit.dart';
import 'package:tasks/src/bloc/task/task_bloc.dart';
import 'package:tasks/src/bloc/task_type/task_type_cubit.dart';
import 'package:tasks/src/bloc/settings/dynamic_color.dart';
import 'package:tasks/src/bloc/settings/theme_cubit.dart';
import 'package:tasks/src/features/home/home_page.dart';
import 'package:tasks/src/models/task.dart';
import 'package:tasks/src/presentation/widgets/theme_data.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Task>('tasks');
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
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (themeContext, themeMode) {
          return BlocBuilder<DynamicColorCubit, bool>(
            builder: (dynamicContext, useDynamic) {
              return DynamicColorBuilder(
                builder: (lightDynamic, darkDynamic) {
                  return BlocBuilder<LanguageCubit, String>(
                    builder: (languageContext, languageState) {
                      return MaterialApp(
                        onGenerateTitle: (context) {
                          return AppLocalizations.of(context)!.appTitle;
                        },
                        locale: languageContext
                            .read<LanguageCubit>()
                            .resolveLocale(),
                        supportedLocales: [Locale("en"), Locale("hi")],
                        localizationsDelegates: [
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
