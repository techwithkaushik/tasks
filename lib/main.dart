import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tasks/app.dart';
import 'package:tasks/firebase_options.dart';
import 'package:tasks/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupServiceLocator();
  runApp(const App());
}
