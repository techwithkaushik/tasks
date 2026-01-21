import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/src/features/settings/presentation/cubit/dynamic_color_cubit.dart';
import 'package:tasks/src/features/settings/presentation/cubit/language_cubit.dart';
import 'package:tasks/src/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:tasks/src/features/settings/presentation/settings_page_utils.dart';
import 'package:tasks/src/features/settings/presentation/settings_page_widgets.dart';
import 'package:tasks/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        children: [
          BlocBuilder<ThemeCubit, (ThemeMode, bool)>(
            builder: (_, themeCubitData) {
              return AppSettingsTile(
                icon: Icons.contrast,
                title: l.followSystemTheme,
                description: l.followSystemThemeDescription,
                value: themeCubitData.$1 == ThemeMode.system,
                onChanged: (value) =>
                    context.read<ThemeCubit>().setSystemMode(value),
              );
            },
          ),
          SizedBox(height: 5),
          BlocBuilder<ThemeCubit, (ThemeMode, bool)>(
            builder: (_, themeCubitData) {
              final isSystemMode = themeCubitData.$1 == ThemeMode.system;
              return AppSettingsTile(
                icon: Icons.dark_mode,
                title: l.darkMode,
                description: isSystemMode
                    ? l.darkModeDescriptionDisabled
                    : l.darkModeDescriptionEnabled,
                value: themeCubitData.$1 == ThemeMode.dark,
                onChanged: isSystemMode
                    ? null
                    : (value) => context.read<ThemeCubit>().setDarkMode(value),
              );
            },
          ),
          SizedBox(height: 5),
          BlocBuilder<ThemeCubit, (ThemeMode, bool)>(
            builder: (_, themeCubitData) {
              final isEffectiveDark = context
                  .read<ThemeCubit>()
                  .isEffectiveDark;
              final isPureDark = themeCubitData.$2;
              return AppSettingsTile(
                icon: Icons.display_settings,
                title: "Pure Black Dark",
                description: "Use AMOLED pure black theme",
                value: isPureDark,
                onChanged: !isEffectiveDark
                    ? null
                    : (v) => context.read<ThemeCubit>().setPureBlack(v),
              );
            },
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
            builder: (_, locale) {
              return AppSettingsTile(
                icon: Icons.translate,
                title: l.language,
                description: languageLabel(locale, l),
                onTap: () => showLanguageSheet(context, l),
              );
            },
          ),
        ],
      ),
    );
  }
}
