import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../core/constants/app_sizes.dart';
import 'day_card.dart';

/// Horizontal 14-day strip; today is highlighted.
class DayStrip extends GetView<HomeController> {
  const DayStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.dayStripHeight,
      child: Obx(() {
        final DateTime today = controller.today;
        final DateTime shown = controller.referenceDay;
        final List<DateTime> days = controller.days;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: AppDimensions.horizontalPadding,
          itemCount: days.length,
          separatorBuilder: (BuildContext _, int index) =>
              const SizedBox(width: AppDimensions.spaceXs),
          itemBuilder: (BuildContext _, int index) {
            final DateTime date = days[index];
            return DayCard(
              date: date,
              isSelected: date == shown,
              isToday: date == today,
              onTap: () => controller.selectDate(date),
            );
          },
        );
      }),
    );
  }
}
