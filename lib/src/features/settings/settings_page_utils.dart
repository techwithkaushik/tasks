import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/l10n/app_localizations.dart';
import 'package:tasks/src/core/constants/language.dart';
import 'package:tasks/src/features/settings/presentation/cubit/language_cubit.dart';

void showLanguageDialog(
  BuildContext context,
  Locale? currentLocale,
  AppLocalizations l,
) {
  final mediaQuery = MediaQuery.of(context);
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l.chooseLanguage,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: SizedBox(
          height: mediaQuery.size.height,
          width: mediaQuery.size.width,
          child: ListView(
            shrinkWrap: true,
            children: [
              _languageTile(
                context,
                title: l.systemDefault,
                selected: currentLocale == null,
                onTap: () => context.read<LanguageCubit>().setLocale(null),
                dialogContext: dialogContext,
              ),
              _languageTile(
                context,
                title: Language.en.nativeName,
                selected: currentLocale?.languageCode == Language.en.code,
                onTap: () =>
                    context.read<LanguageCubit>().setLocale(Language.en.locale),
                dialogContext: dialogContext,
              ),
              _languageTile(
                context,
                title: Language.hi.nativeName,
                selected: currentLocale?.languageCode == Language.hi.code,
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
