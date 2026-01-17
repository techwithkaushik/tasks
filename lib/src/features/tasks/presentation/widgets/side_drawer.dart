import 'package:flutter/material.dart';
import 'package:tasks/l10n/app_localizations.dart';
import 'package:tasks/src/features/about/about_page.dart';
import 'package:tasks/src/features/recycle_bin/recycle_bin_page.dart';

Widget sideDrawer(BuildContext context) {
  final l = AppLocalizations.of(context);

  return Drawer(
    child: SafeArea(
      child: ListView(
        children: [
          DrawerHeader(child: Text(l.appTitle, style: TextStyle(fontSize: 22))),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text("Recycle Bin"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const RecycleBinPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
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
