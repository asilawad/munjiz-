import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/task_form_controller.dart';
import '../../core/constants/app_config.dart';
import '../../core/constants/app_durations.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import 'filter_pill.dart';
import 'soft_card.dart';
import 'weekday_circle.dart';

/// Routine switch with "Daily" and specific weekdays.
class RoutinePicker extends GetView<TaskFormController> {
  const RoutinePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Obx(() {
      final bool enabled = controller.isRoutine.value;
      final bool daily = controller.isDaily.value;
      final Set<int> days = controller.routineDays.toSet();
      return SoftCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(AppStrings.routine, style: text.titleMedium),
                const Spacer(),
                Switch(value: enabled, onChanged: controller.setRoutine),
              ],
            ),
            AnimatedSize(
              duration: AppDurations.chipSelection,
              curve: AppCurves.entrance,
              child: enabled
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: AppDimensions.spaceSm),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: FilterPill(
                            label: AppStrings.daily,
                            isSelected: daily,
                            onTap: controller.selectDaily,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceSm),
                        Text(AppStrings.specificDays, style: text.bodySmall),
                        const SizedBox(height: AppDimensions.spaceXs),
                        Wrap(
                          spacing: AppDimensions.spaceXs,
                          runSpacing: AppDimensions.spaceXs,
                          children: <Widget>[
                            for (final int weekday in AppConfig.weekOrder)
                              WeekdayCircle(
                                label: AppStrings.weekdayNarrow[weekday - 1],
                                isSelected: days.contains(weekday),
                                onTap: () => controller.toggleDay(weekday),
                              ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      );
    });
  }
}
