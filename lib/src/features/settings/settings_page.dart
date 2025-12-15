import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/l10n/app_localizations.dart';
import 'package:tasks/l10n/app_localizations_en.dart';
import 'package:tasks/l10n/app_localizations_hi.dart';
import 'package:tasks/src/features/settings/views/cubit/dynamic_color_cubit.dart';
import 'package:tasks/src/features/settings/views/cubit/language_cubit.dart';
import 'package:tasks/src/features/settings/settings_page_widgets.dart';
import 'views/cubit/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  final String title;
  const SettingsPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
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
                        ? l.darkModeDescriptionDisabled
                        : l.darkModeDescriptionEnabled,
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
              return AppSettingsTile(
                icon: Icons.translate,
                title: l.language,
                description: _languageLabel(lang, l),
                onTap: () => _showLanguageDialog(context, lang),
              );
            },
          ),
        ],
      ),
    );
  }
}

void _showLanguageDialog(BuildContext context, String currentLang) {
  Map<String, String> supportedLanguages = {
    'system': AppLocalizations.of(context).systemDefault,
    'en': AppLocalizationsEn().english,
    'hi': AppLocalizationsHi().hindi,
  };
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          AppLocalizations.of(context).chooseLanguage,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            shrinkWrap: true,
            children: supportedLanguages.entries.map((entry) {
              final code = entry.key;
              final label = entry.value;
              final selected = code == currentLang;

              return ListTile(
                title: Text(label),
                trailing: selected
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  context.read<LanguageCubit>().setLanguage(code);
                  Navigator.of(dialogContext).pop();
                },
              );
            }).toList(),
          ),
        ),
      );
    },
  );
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
