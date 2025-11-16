import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tasks/controllers/auth_controller.dart';
import 'package:tasks/routes/route_names.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

Future<void> main() async {
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
      title: 'Tasks',
      theme: ThemeData(useMaterial3: true),
      initialRoute: RouteNames.getInitial(),
      getPages: RouteNames.routes,
    );
  }
}
