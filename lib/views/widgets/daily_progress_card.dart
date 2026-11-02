import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_durations.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import 'soft_card.dart';

/// "3 of 5 tasks today" with an animated progress bar.
class DailyProgressCard extends GetView<HomeController> {
  const DailyProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Obx(() {
      final int total = controller.todayTotal;
      final int done = controller.todayDone;
      final double ratio = total == 0 ? 0 : done / total;
      return SoftCard(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(
                  Icons.track_changes_rounded,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppDimensions.spaceXs),
                Text(AppStrings.todayProgressTitle, style: text.bodyLarge),
                const Spacer(),
                Text(
                  total == 0
                      ? AppStrings.noTasksToday
                      : AppStrings.progressOf(done, total),
                  style: text.labelMedium?.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(end: ratio),
              duration: AppDurations.progress,
              curve: AppCurves.standard,
              builder: (BuildContext _, double value, Widget? child) =>
                  LinearProgressIndicator(
                    value: value,
                    minHeight: AppDimensions.progressBarHeight,
                    borderRadius: AppDimensions.borderRadiusPill,
                    backgroundColor: AppColors.surfaceTint,
                    color: AppColors.cyan,
                  ),
            ),
          ],
        ),
      );
    });
  }
}
