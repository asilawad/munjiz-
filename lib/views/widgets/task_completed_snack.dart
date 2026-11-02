import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';

/// Content of the "Task completed!" snackbar (Undo is the snackbar action).
class TaskCompletedSnack extends StatelessWidget {
  const TaskCompletedSnack({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Row(
      children: <Widget>[
        Container(
          width: AppDimensions.snackCheckSize,
          height: AppDimensions.snackCheckSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.success,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: AppColors.onPrimary,
            size: AppDimensions.iconSm,
          ),
        ),
        const SizedBox(width: AppDimensions.spaceSm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                AppStrings.taskCompleted,
                style: text.bodyLarge?.copyWith(color: AppColors.onPrimary),
              ),
              Text(
                AppStrings.taskCompletedEn,
                style: text.bodySmall?.copyWith(color: AppColors.onPrimaryMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
