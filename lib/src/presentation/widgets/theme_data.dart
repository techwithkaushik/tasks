import 'package:flutter/material.dart';

ThemeData themeData(
  bool useDynamic,
  ColorScheme? dynamicScheme,
  Brightness brightness,
) {
  Color dynamicColor = dynamicScheme == null
      ? Colors.blue
      : dynamicScheme.primary;
  return ThemeData(
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: useDynamic ? dynamicColor : Colors.teal,
    ),
    useMaterial3: true,
  );
}
