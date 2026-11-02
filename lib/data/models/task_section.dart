import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

/// Groups shown on the home screen, in display order.
enum TaskSection {
  pinned(AppStrings.sectionPinned, Icons.push_pin_rounded, AppColors.primary),
  overdue(
    AppStrings.sectionOverdue,
    Icons.schedule_rounded,
    AppColors.danger,
  ),
  today(
    AppStrings.sectionToday,
    Icons.star_rounded,
    AppColors.categoryImportant,
  ),
  day(AppStrings.sectionDay, Icons.today_rounded, AppColors.primary),
  upcoming(AppStrings.sectionUpcoming, Icons.event_rounded, AppColors.cyan),
  noDate(
    AppStrings.sectionNoDate,
    Icons.inbox_rounded,
    AppColors.textSecondary,
  ),
  completed(
    AppStrings.sectionCompleted,
    Icons.check_circle_rounded,
    AppColors.success,
  );

  const TaskSection(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;
}
