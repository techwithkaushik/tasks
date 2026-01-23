/// Main entry point of the Tasks application.
///
/// This file initializes the app by:
/// - Setting up Flutter bindings
/// - Initializing Firebase
/// - Setting up service locator for dependency injection
/// - Configuring HydratedBloc storage for state persistence
/// - Running the main App widget
library;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasks/app.dart';
import 'package:tasks/firebase_options.dart';
import 'package:tasks/service_locator.dart';

/// Main function - entry point of the application
///
/// Performs initialization tasks before launching the app:
/// 1. Ensures Flutter bindings are initialized
/// 2. Initializes Firebase with platform-specific options
/// 3. Sets up dependency injection with service locator
/// 4. Configures HydratedBloc for persistent state storage
/// 5. Launches the main App widget
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupServiceLocator();
  final appDocumentDir = await getApplicationDocumentsDirectory();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(appDocumentDir.path),
  );

  runApp(const App());
}
