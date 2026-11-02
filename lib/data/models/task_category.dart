import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

/// Built-in task categories. [other] carries a user-defined name on the task.
enum TaskCategory {
  important(
    AppStrings.categoryImportant,
    Icons.star_rounded,
    AppColors.categoryImportant,
    AppColors.categoryImportantSoft,
  ),
  personal(
    AppStrings.categoryPersonal,
    Icons.person_rounded,
    AppColors.categoryPersonal,
    AppColors.categoryPersonalSoft,
  ),
  work(
    AppStrings.categoryWork,
    Icons.work_rounded,
    AppColors.categoryWork,
    AppColors.categoryWorkSoft,
  ),
  ideas(
    AppStrings.categoryIdeas,
    Icons.lightbulb_rounded,
    AppColors.categoryIdeas,
    AppColors.categoryIdeasSoft,
  ),
  other(
    AppStrings.categoryOther,
    Icons.more_horiz_rounded,
    AppColors.categoryOther,
    AppColors.categoryOtherSoft,
  );

  const TaskCategory(this.label, this.icon, this.color, this.softColor);

  final String label;
  final IconData icon;
  final Color color;
  final Color softColor;

  static TaskCategory fromName(String? name) => TaskCategory.values.firstWhere(
    (TaskCategory c) => c.name == name,
    orElse: () => TaskCategory.other,
  );
}
