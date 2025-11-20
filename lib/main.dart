import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tasks/controllers/auth_controller.dart';
import 'package:tasks/routes/route_names.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:tasks/services/app_keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blue),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      title: 'Tasks',
      // Attach global scaffold messenger key so SnackBars can be shown
      // from anywhere (controllers/services) and be visible in release mode.
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      initialRoute: RouteNames.getInitial(),
      getPages: RouteNames.routes,
    );
  }
}
