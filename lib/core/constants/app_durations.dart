import 'package:flutter/animation.dart';

/// Central animation timing. Every Duration used in the app lives here.
abstract final class AppDurations {
  static const Duration pageTransition = Duration(milliseconds: 300);

  /// Pause after tapping the checkbox before the task slides away (~0.5s).
  static const Duration completeDelay = Duration(milliseconds: 500);

  /// Slide/fade-out of a completed task before it moves to "Completed".
  static const Duration slideOut = Duration(milliseconds: 250);

  static const Duration chipSelection = Duration(milliseconds: 200);
  static const Duration sectionToggle = Duration(milliseconds: 200);
  static const Duration searchDebounce = Duration(milliseconds: 300);
  static const Duration progress = Duration(milliseconds: 400);
  static const Duration snackbar = Duration(seconds: 4);
  static const Duration confetti = Duration(seconds: 3);

  /// Waits for task changes to settle before rescheduling notifications.
  static const Duration notificationDebounce = Duration(seconds: 2);
}

/// Central animation curves.
abstract final class AppCurves {
  static const Curve standard = Curves.easeInOut;
  static const Curve entrance = Curves.easeOutCubic;
}
