import 'package:flutter/material.dart';

ThemeData themeData({
  required bool useDynamic,
  required ColorScheme? colorScheme,
  required Brightness brightness,
}) {
  Color dynamicColor = Colors.blue;
  if (colorScheme != null) {
    dynamicColor = colorScheme.primary;
  }

  Color seedColor = useDynamic ? dynamicColor : Colors.teal;

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: seedColor,
    ),
  );
}
