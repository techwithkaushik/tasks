import 'package:flutter/material.dart';

/// Global keys used across the app.
/// Attach the [rootScaffoldMessengerKey] to the top-level App (MaterialApp/GetMaterialApp)
/// so that snackbars can be shown reliably from controllers/services even when the
/// current BuildContext isn't available (fixes release-mode snackbar issues).
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
