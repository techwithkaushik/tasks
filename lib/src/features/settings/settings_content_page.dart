import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/src/features/settings/presentation/cubit/dynamic_color_cubit.dart';
import 'package:tasks/src/features/settings/presentation/cubit/language_cubit.dart';
import 'package:tasks/src/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:tasks/src/features/settings/settings_page_utils.dart';
import 'package:tasks/src/features/settings/settings_page_widgets.dart';
import 'package:tasks/l10n/app_localizations.dart';

class SettingsContentPage extends StatelessWidget {
  const SettingsContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (_, themeMode) {
          final isSystemMode = themeMode == ThemeMode.system;
          return ListView(
            children: [
              AppSettingsTile(
                icon: Icons.contrast,
                title: l.followSystemTheme,
                description: l.followSystemThemeDescription,
                value: isSystemMode,
                onChanged: (value) =>
                    context.read<ThemeCubit>().setSystemMode(value),
              ),
              SizedBox(height: 5),
              AppSettingsTile(
                icon: Icons.dark_mode,
                title: l.darkMode,
                description: isSystemMode
                    ? l.darkModeDescriptionDisabled
                    : l.darkModeDescriptionEnabled,
                value: themeMode == ThemeMode.dark,
                onChanged: isSystemMode
                    ? null
                    : (value) => context.read<ThemeCubit>().setDarkMode(value),
              ),
              SizedBox(height: 5),
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
                    description: languageLabel(locale, l),
                onTap: () => showLanguageSheet(context, l),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
