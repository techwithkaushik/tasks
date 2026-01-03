import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasks/app.dart';
import 'package:tasks/firebase_options.dart';
import 'package:tasks/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupServiceLocator();
  final appDocumentDir = await getApplicationDocumentsDirectory();

  await Hive.initFlutter(appDocumentDir.path);
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(appDocumentDir.path),
  );

  runApp(const App());
}
