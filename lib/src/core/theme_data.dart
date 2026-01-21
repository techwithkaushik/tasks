import 'package:flutter/material.dart';

ThemeData themeData({
  required bool useDynamic,
  required ColorScheme? colorScheme,
  required Brightness brightness,
  required bool isPureDark,
}) {
  final dynamicColor = colorScheme?.primary ?? Colors.blue;
  final seedColor = useDynamic ? dynamicColor : Colors.teal;

  final baseScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
  );

  if (brightness == Brightness.dark && isPureDark) {
    const background = Colors.black;
    const surface = Color(0xFF0D0D0D);
    const surfaceElevated = Color(0xFF151515);
    const invertBackground = Colors.white;

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: baseScheme,

      scaffoldBackgroundColor: background,
      canvasColor: background,

      snackBarTheme: SnackBarThemeData(
        backgroundColor: background,
        contentTextStyle: TextStyle(color: invertBackground),
      ),

      drawerTheme: DrawerThemeData(backgroundColor: background),

      primaryIconTheme: IconThemeData(color: baseScheme.primary),

      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      cardColor: surface,
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        modalBackgroundColor: surface,
        elevation: 0,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: background,
        indicatorColor: surfaceElevated,
      ),

      tooltipTheme: const TooltipThemeData(
        decoration: BoxDecoration(
          color: Color(0xFF222222),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        textStyle: TextStyle(color: Colors.white),
      ),

      useMaterial3: true,
    );
  }

  return ThemeData(
    colorScheme: baseScheme,
    brightness: brightness,
    useMaterial3: true,
  );
}
