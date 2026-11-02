import 'package:flutter/material.dart';

import '../../views/widgets/task_completed_snack.dart';
import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../constants/app_strings.dart';

/// Single place for snackbar feedback; works without a BuildContext.
/// Styling comes from `SnackBarTheme` in `AppTheme`.
abstract final class AppSnackbar {
  /// Must be passed to `GetMaterialApp(scaffoldMessengerKey: ...)`.
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// "Task completed!" message with an Undo action.
  static void completed({required VoidCallback onUndo}) {
    _show(content: const TaskCompletedSnack(), onUndo: onUndo);
  }

  /// Plain confirmation text.
  static void info(String message) {
    _show(content: Text(message));
  }

  /// Confirmation text with an Undo action.
  static void undo({required String message, required VoidCallback onUndo}) {
    _show(content: Text(message), onUndo: onUndo);
  }

  static void _show({required Widget content, VoidCallback? onUndo}) {
    final ScaffoldMessengerState? messenger = messengerKey.currentState;
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: content,
          duration: AppDurations.snackbar,
          action: onUndo == null
              ? null
              : SnackBarAction(
                  label: AppStrings.undo,
                  textColor: AppColors.accent,
                  onPressed: onUndo,
                ),
        ),
      );
  }
}
