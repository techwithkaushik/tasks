import 'package:flutter/material.dart';

ThemeData themeData({
  required bool useDynamic,
  required ColorScheme? colorScheme,
  required Brightness brightness,
}) {
  Color dynamicColor = colorScheme?.primary ?? Colors.blue;
  Color seedColor = useDynamic ? dynamicColor : Colors.teal;

  final baseScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
  );

  return ThemeData(
    colorScheme: baseScheme,
    brightness: brightness,
    useMaterial3: true,
  );
}
