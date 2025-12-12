import 'package:flutter/material.dart';

ThemeData themeData(
  bool useDynamic,
  ColorScheme dynamicScheme,
  Brightness brightness,
) {
  return ThemeData(
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: useDynamic ? dynamicScheme.primary : Colors.teal,
    ),
    useMaterial3: true,
  );
}
