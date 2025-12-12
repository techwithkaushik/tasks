import 'package:flutter/material.dart';
import 'settings_page_content.dart';

class SettingsPage extends StatelessWidget {
  final String title;
  const SettingsPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsPageContent(title);
  }
}
