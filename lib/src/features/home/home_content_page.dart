/// Main content area with bottom navigation
///
/// Displays:
/// - Dashboard page (tab 0)
/// - Tasks page (tab 1)
/// - Settings page (tab 2)
/// - About page (tab 3)
///
/// Uses NavCubit for tab management and back navigation
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/l10n/app_localizations.dart';
import 'package:tasks/src/features/about/about_page.dart';
import 'package:tasks/src/features/home/cubit/nav_cubit.dart';
import 'package:tasks/src/features/home/dashboard_page.dart';
import 'package:tasks/src/features/settings/presentation/settings_page.dart';
import 'package:tasks/src/features/tasks/presentation/pages/task_page.dart';

class HomeContentPage extends StatelessWidget {
  const HomeContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final pages = [
      const DashboardPage(),
      TaskPage(title: l.appTitle),
      const SettingsPage(),
      AboutPage(l.about),
    ];

    return BlocBuilder<NavCubit, int>(
      builder: (context, state) {
        return Scaffold(
          body: PopScope(
            canPop: state == 0,
            onPopInvokedWithResult: (didPop, result) {
              context.read<NavCubit>().back();
            },
            child: IndexedStack(index: state, children: pages),
          ),
          bottomNavigationBar: NavigationBar(
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            selectedIndex: context.read<NavCubit>().state,
            destinations: [
              _navigationDestination(Icons.dashboard_rounded, 'Dashboard'),
              _navigationDestination(Icons.checklist_rounded, 'Tasks'),
              _navigationDestination(Icons.settings_rounded, l.settingsTitle),
              _navigationDestination(Icons.info_outline_rounded, l.about),
            ],
            onDestinationSelected: (value) {
              return context.read<NavCubit>().setIndex(value);
            },
          ),
        );
      },
    );
  }

  NavigationDestination _navigationDestination(IconData icon, String title) {
    return NavigationDestination(icon: Icon(icon), label: title);
  }
}
