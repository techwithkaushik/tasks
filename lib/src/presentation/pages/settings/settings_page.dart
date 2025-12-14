import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/l10n/app_localizations.dart';
import 'package:tasks/l10n/app_localizations_en.dart';
import 'package:tasks/l10n/app_localizations_hi.dart';
import 'package:tasks/src/bloc/settings/dynamic_color.dart';
import 'package:tasks/src/bloc/settings/language_cubit.dart';
import 'package:tasks/src/presentation/pages/settings/settings_page_widgets.dart';
import '../../../bloc/settings/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  final String title;
  const SettingsPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (_, themeMode) {
              final themeCubit = context.read<ThemeCubit>();
              final isSystemMode = themeMode == ThemeMode.system;
              return Column(
                children: [
                  AppSettingsTile(
                    icon: Icons.contrast,
                    title: l.followSystemTheme,
                    description: l.followSystemThemeDescription,
                    value: isSystemMode,
                    onChanged: (value) => themeCubit.setSystemMode(value),
                  ),
                  AppSettingsTile(
                    icon: Icons.dark_mode,
                    title: l.darkMode,
                    description: isSystemMode
                        ? l.darkModeDescription
                        : l.darkModeDescription,
                    value: themeMode == ThemeMode.dark,
                    onChanged: isSystemMode
                        ? null
                        : (value) => themeCubit.setDarkMode(value),
                  ),
                ],
              );
            },
          ),
          BlocBuilder<DynamicColorCubit, bool>(
            builder: (_, useDynamic) {
              return AppSettingsTile(
                icon: Icons.color_lens,
                title: l.dynamicColor,
                description: l.dynamicColorDescription,
                value: useDynamic,
                onChanged: (value) {
                  context.read<DynamicColorCubit>().setDynamicColor(value);
                },
              );
            },
          ),
          Divider(),
          BlocBuilder<LanguageCubit, String>(
            builder: (context, lang) {
              final langCubit = context.read<LanguageCubit>();
              return AppSettingsTile(
                icon: Icons.translate,
                title: l.language,
                description: _languageLabel(lang, l),
                onTap: () async {
                  final selected = await showMenu<String>(
                    initialValue: lang,
                    position: RelativeRect.fromLTRB(100, 300, 100, 0),
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    items: [
                      PopupMenuItem(
                        value: "system",
                        child: Text(
                          l.systemDefault,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      PopupMenuItem(
                        value: AppLocalizationsEn().localeName,
                        child: Text(
                          AppLocalizationsEn().english,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      PopupMenuItem(
                        value: AppLocalizationsHi().localeName,
                        child: Text(
                          AppLocalizationsHi().hindi,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  );
                  if (selected != null) {
                    langCubit.setLanguage(selected);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

String _languageLabel(String lang, AppLocalizations l) {
  switch (lang) {
    case "en":
      return l.english;
    case "hi":
      return l.hindi;
    default:
      return l.systemDefault;
  }
}
