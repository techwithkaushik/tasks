import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/core/constants/language.dart';
import 'package:tasks/core/features/settings/presentation/cubit/dynamic_color_cubit.dart';
import 'package:tasks/core/features/settings/presentation/cubit/language_cubit.dart';
import 'package:tasks/core/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:tasks/core/features/settings/settings_page_widgets.dart';
import 'package:tasks/l10n/app_localizations.dart';

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
          BlocBuilder<LanguageCubit, Locale?>(
            builder: (context, locale) {
              return AppSettingsTile(
                icon: Icons.translate,
                title: l.language,
                description: _languageLabel(locale, l),
                onTap: () => _showLanguageDialog(context, locale),
              );
            },
          ),
        ],
      ),
    );
  }
}

void _showLanguageDialog(BuildContext context, Locale? currentLacale) {
  final l = AppLocalizations.of(context);
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
            children: [
              _languageTile(
                context,
                title: l.systemDefault,
                selected: currentLacale == null,
                onTap: () => context.read<LanguageCubit>().setLocale(null),
                dialogContext: dialogContext,
              ),
              _languageTile(
                context,
                title: l.english,
                selected: currentLacale?.languageCode == Language.en.code,
                onTap: () =>
                    context.read<LanguageCubit>().setLocale(Language.en.locale),
                dialogContext: dialogContext,
              ),
              _languageTile(
                context,
                title: l.systemDefault,
                selected: currentLacale?.languageCode == Language.hi.code,
                onTap: () =>
                    context.read<LanguageCubit>().setLocale(Language.hi.locale),
                dialogContext: dialogContext,
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _languageTile(
  BuildContext context, {
  required String title,
  required bool selected,
  required VoidCallback onTap,
  required BuildContext dialogContext,
}) {
  return ListTile(
    title: Text(title),
    trailing: selected
        ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
        : null,
    onTap: () {
      onTap();
      Navigator.of(dialogContext).pop();
    },
  );
}

String _languageLabel(Locale? locale, AppLocalizations l) {
  if (locale == null) return l.systemDefault;
  if (locale.languageCode == Language.en.code) {
    return l.english;
  } else if (locale.languageCode == Language.hi.code) {
    return l.hindi;
  } else {
    return l.systemDefault;
  }
}
