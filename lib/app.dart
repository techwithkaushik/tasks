import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tasks/bloc/navigation/nav_cubit.dart';
import 'package:tasks/bloc/task/task_bloc.dart';
import 'package:tasks/bloc/task_type/task_type_cubit.dart';
import 'package:tasks/bloc/theme/dynamic_color.dart';
import 'package:tasks/bloc/theme/theme_cubit.dart';
import 'package:tasks/models/task.dart';
import 'package:tasks/presentation/pages/task_completed/task_completed_page.dart';
import 'package:tasks/presentation/widgets/animated_badge.dart';
import 'package:tasks/presentation/widgets/theme_data.dart';

import 'presentation/pages/settings/settings_page.dart';

import 'presentation/pages/task/task_page.dart';

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
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<DynamicColorCubit, bool>(
            builder: (context, useDynamic) {
              return DynamicColorBuilder(
                builder: (lightDynamic, darkDynamic) {
                  return MaterialApp(
                    title: "Tasks",
                    theme: themeData(
                      useDynamic,
                      lightDynamic!,
                      Brightness.light,
                    ),
                    darkTheme: themeData(
                      useDynamic,
                      darkDynamic!,
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
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavCubit, int>(
      builder: (context, navIndex) {
        final titles = ["Tasks", "Completed", "Settings", "About"];

        final getPages = [
          TaskPage(titles[navIndex]),
          TaskCompletedPage(titles[navIndex]),
          SettingsPage(titles[navIndex]),
          AboutPage(titles[navIndex]),
        ];
        return PopScope(
          canPop: navIndex == 0,
          onPopInvokedWithResult: (didPop, result) {
            context.read<NavCubit>().back();
          },
          child: Scaffold(
            body: IndexedStack(index: navIndex, children: getPages),
            bottomNavigationBar: NavigationBar(
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              selectedIndex: navIndex,
              destinations: [
                _navigationDestination(Icons.list, titles[0], false),
                _navigationDestination(Icons.check_circle, titles[1], true),
                _navigationDestination(Icons.settings, titles[2]),
                _navigationDestination(Icons.info, titles[3]),
              ],
              onDestinationSelected: (value) =>
                  context.read<NavCubit>().setIndex(value),
            ),
          ),
        );
      },
    );
  }

  NavigationDestination _navigationDestination(
    IconData icon,
    String title, [
    bool? isCompleted,
  ]) {
    return NavigationDestination(
      icon: isCompleted == null
          ? Icon(icon)
          : BlocBuilder<TaskBloc, TaskState>(
              buildWhen: (previous, current) =>
                  current is TaskLoaded || previous is TaskLoaded,
              builder: (context, state) {
                int count = state is TaskLoaded
                    ? state.tasks
                          .where((task) => task.isCompleted == isCompleted)
                          .length
                    : 0;
                return AnimatedBadge(
                  color: isCompleted ? Colors.green[900]! : Colors.red[900]!,
                  icon: icon,
                  count: count,
                );
              },
            ),
      label: title,
    );
  }
}

class AboutPage extends StatelessWidget {
  final String title;
  const AboutPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
