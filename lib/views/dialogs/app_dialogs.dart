import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../core/constants/app_strings.dart';
import '../widgets/app_button.dart';
import '../widgets/app_dialog.dart';
import '../widgets/celebration_dialog.dart';

/// Opens the app's dialogs; controllers call these instead of building UI.
abstract final class AppDialogs {
  /// Returns true when the user confirms deleting.
  static Future<bool> confirmDelete() async {
    final bool? result = await Get.dialog<bool>(
      AppDialog(
        icon: Icons.delete_rounded,
        iconColor: AppColors.danger,
        title: AppStrings.deleteTitle,
        message: AppStrings.deleteMessage,
        primaryLabel: AppStrings.delete,
        primaryStyle: AppButtonStyle.destructive,
        onPrimary: () => Get.back<bool>(result: true),
        secondaryLabel: AppStrings.cancel,
        onSecondary: () => Get.back<bool>(result: false),
      ),
    );
    return result ?? false;
  }

  /// Friendly message when the 4th task is pinned.
  static Future<void> showPinLimit() async {
    await Get.dialog<void>(
      AppDialog(
        icon: Icons.push_pin_rounded,
        iconColor: AppColors.primary,
        title: AppStrings.pinLimitTitle(AppConfig.maxPinnedTasks),
        message: AppStrings.pinLimitMessage,
        primaryLabel: AppStrings.ok,
        onPrimary: () => Get.back<void>(),
      ),
    );
  }

  /// Confetti + success card for finishing all of today's tasks.
  static Future<void> showCelebration() async {
    await Get.dialog<void>(const CelebrationDialog());
  }
}
