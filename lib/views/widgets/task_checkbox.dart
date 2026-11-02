import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_durations.dart';
import '../../core/constants/app_sizes.dart';

/// Rounded checkbox that fills with blue and shows a check instantly.
class TaskCheckbox extends StatelessWidget {
  const TaskCheckbox({super.key, required this.isChecked, required this.onTap});

  final bool isChecked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.checkboxHitPadding),
        child: AnimatedContainer(
          duration: AppDurations.chipSelection,
          curve: AppCurves.entrance,
          width: AppDimensions.checkboxSize,
          height: AppDimensions.checkboxSize,
          decoration: BoxDecoration(
            color: isChecked ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.checkboxRadius),
            border: Border.all(
              color: isChecked ? AppColors.primary : AppColors.border,
              width: AppDimensions.borderWidthSelected,
            ),
          ),
          child: AnimatedScale(
            scale: isChecked ? 1 : 0,
            duration: AppDurations.chipSelection,
            curve: AppCurves.entrance,
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.onPrimary,
              size: AppDimensions.iconSm,
            ),
          ),
        ),
      ),
    );
  }
}
