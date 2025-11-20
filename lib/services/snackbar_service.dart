import 'package:flutter/material.dart';
import 'package:tasks/services/app_keys.dart';

/// Simple Snackbar helper that uses the global [rootScaffoldMessengerKey].
/// Use this instead of calling UI-specific snack APIs from controllers so
/// snackbars appear reliably in all build modes (debug/profile/release).
class SnackbarService {
  static void show({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    bool isError = false,
  }) {
    final messenger = rootScaffoldMessengerKey.currentState;
    if (messenger == null) return;

    // remove current to avoid stacking many snackbars
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(message),
          ],
        ),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: isError ? Colors.redAccent : null,
      ),
    );
  }
}
