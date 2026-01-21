import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/l10n/app_localizations.dart';
import 'package:tasks/src/core/constants/language.dart';
import 'package:tasks/src/features/settings/presentation/cubit/language_cubit.dart';

void showLanguageSheet(BuildContext context, AppLocalizations l) {
  showModalBottomSheet(
    showDragHandle: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<LanguageCubit, Locale?>(
          builder: (_, currentLocale) {
            final items = [
              _languageTile(
                context,
                title: l.systemDefault,
                selected: currentLocale == null,
                onTap: () {
                  context.read<LanguageCubit>().setLocale(null);
                  Navigator.pop(context);
                },
              ),
              _languageTile(
                context,
                title: Language.en.nativeName,
                selected: currentLocale?.languageCode == Language.en.code,
                onTap: () {
                  context.read<LanguageCubit>().setLocale(Language.en.locale);
                  Navigator.pop(context);
                },
              ),
              _languageTile(
                context,
                title: Language.hi.nativeName,
                selected: currentLocale?.languageCode == Language.hi.code,
                onTap: () {
                  context.read<LanguageCubit>().setLocale(Language.hi.locale);
                  Navigator.pop(context);
                },
              ),
              // add more languages here...
            ];

            return Column(
              children: [
                Text(
                  l.chooseLanguage,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) => items[i],
                  ),
                ),
              ],
            );
          },
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
}) {
  Color? selectedColor = selected
      ? Theme.of(context).colorScheme.primary
      : null;
  return ListTile(
    title: Text(
      title,

      style: TextStyle(
        color: selectedColor,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
    ),
    trailing: selected
        ? Icon(
            Icons.check,
            color: selected ? Theme.of(context).colorScheme.primary : null,
          )
        : null,
    onTap: onTap,
  );
}

String languageLabel(Locale? locale, AppLocalizations l) {
  if (locale == null) {
    return l.systemDefault;
  } else if (locale.languageCode == Language.en.code) {
    return l.english;
  } else if (locale.languageCode == Language.hi.code) {
    return l.hindi;
  } else {
    return l.systemDefault;
  }
}
