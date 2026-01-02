import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/service_locator.dart';
import 'package:tasks/src/features/app_auth/presentation/bloc/app_auth/app_auth_bloc.dart';
import 'package:tasks/src/features/app_auth/presentation/pages/auth_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          theme: themeData(
            context: context,
            useDynamic: true,
            colorScheme: lightDynamic,
            brightness: Brightness.light,
          ),
          darkTheme: themeData(
            context: context,
            useDynamic: true,
            colorScheme: darkDynamic,
            brightness: Brightness.dark,
          ),
          themeMode: ThemeMode.light,
          home: BlocProvider.value(
            value: sl<AppAuthBloc>(),
            child: AppAuthPage(),
          ),
        );
      },
    );
  }

  ThemeData themeData({
    required bool useDynamic,
    required ColorScheme? colorScheme,
    required Brightness brightness,
    required BuildContext context,
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
}
