import 'package:flutter/material.dart';
import 'package:tasks/l10n/app_localizations.dart';
import 'package:tasks/src/features/about/about_page.dart';
import 'package:tasks/src/features/recycle_bin/recycle_bin_page.dart';
import 'package:tasks/src/features/tasks/presentation/pages/task_calendar_page.dart';
import 'package:tasks/src/features/settings/presentation/settings_page.dart';

Widget sideDrawer(BuildContext context) {
  final l = AppLocalizations.of(context);

  return Drawer(
    child: SafeArea(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.surfaceContainerLow,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.task_alt_rounded,
                    size: 32, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 8),
                  Text(l.appTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    )),
                  Text('Plan clearly. Finish confidently.',
                    style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_rounded),
            title: const Text('Task calendar'),
            subtitle: const Text('Browse tasks by due date'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TaskCalendarPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(l.settingsTitle),
            subtitle: const Text('Theme and language'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline_rounded),
            title: Text("Recycle Bin"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const RecycleBinPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: Text(l.about),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => AboutPage(l.about)));
            },
          ),
        ],
      ),
    ),
  );
}
