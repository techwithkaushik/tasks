import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/l10n/app_localizations.dart';
import 'package:tasks/src/features/home/nav_cubit.dart';
import 'package:tasks/src/features/tasks/views/bloc/task_bloc.dart';
import 'package:tasks/src/features/about/about_page.dart';
import 'package:tasks/src/features/settings/settings_page.dart';
import 'package:tasks/src/features/tasks/task_page.dart';
import 'package:tasks/src/features/home/animated_badge.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return BlocBuilder<NavCubit, int>(
      builder: (context, navIndex) {
        final getPages = [
          TaskPage(title: l.title, isCompleted: false),
          TaskPage(title: l.completed, isCompleted: true),
          SettingsPage(l.settingsTitle),
          AboutPage(l.about),
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
                _navigationDestination(Icons.list, l.title, false),
                _navigationDestination(Icons.check_circle, l.completed, true),
                _navigationDestination(Icons.settings, l.settingsTitle),
                _navigationDestination(Icons.info, l.about),
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
