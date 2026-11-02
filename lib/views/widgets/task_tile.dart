import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_config.dart';
import '../../core/constants/app_durations.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/task_model.dart';
import 'soft_card.dart';
import 'task_badge.dart';
import 'task_checkbox.dart';

/// Task card: checkbox, title, category / routine / date badges, pin icon.
/// When [isLeaving] it slides down and fades out before moving to "Completed".
class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.today,
    required this.isChecked,
    required this.isLeaving,
    required this.onToggle,
    required this.onTap,
  });

  final TaskModel task;
  final DateTime today;
  final bool isChecked;
  final bool isLeaving;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final DateTime? due = task.dueDate;
    final bool isOverdue =
        due != null && !task.isRoutine && !isChecked && due.isBefore(today);

    return AnimatedSlide(
      offset: isLeaving ? AppDimensions.leavingSlide : Offset.zero,
      duration: AppDurations.slideOut,
      curve: AppCurves.standard,
      child: AnimatedOpacity(
        opacity: isLeaving ? 0 : 1,
        duration: AppDurations.slideOut,
        child: Padding(
          padding: AppDimensions.tileGap,
          child: SoftCard(
            onTap: onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TaskCheckbox(isChecked: isChecked, onTap: onToggle),
                const SizedBox(width: AppDimensions.spaceXs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              task.title,
                              maxLines: AppConfig.taskTitleMaxLines,
                              overflow: TextOverflow.ellipsis,
                              style: text.bodyLarge?.copyWith(
                                decoration: isChecked
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: isChecked
                                    ? AppColors.textHint
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (task.isPinned)
                            const Icon(
                              Icons.push_pin_rounded,
                              size: AppDimensions.iconSm,
                              color: AppColors.primary,
                            ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceXs),
                      Wrap(
                        spacing: AppDimensions.spaceXs,
                        runSpacing: AppDimensions.spaceXs,
                        children: <Widget>[
                          TaskBadge(
                            label: task.categoryLabel,
                            icon: task.category.icon,
                            color: task.category.color,
                            backgroundColor: task.category.softColor,
                          ),
                          if (task.isRoutine)
                            const TaskBadge(
                              label: AppStrings.routine,
                              icon: Icons.repeat_rounded,
                              color: AppColors.primary,
                              backgroundColor: AppColors.categoryPersonalSoft,
                            ),
                          if (due != null && !task.isRoutine)
                            TaskBadge(
                              label: DateFormat(AppStrings.dateFormat).format(due),
                              icon: isOverdue
                                  ? Icons.event_busy_rounded
                                  : Icons.event_rounded,
                              color: isOverdue
                                  ? AppColors.danger
                                  : AppColors.textSecondary,
                              backgroundColor: isOverdue
                                  ? AppColors.dangerSoft
                                  : AppColors.surfaceTint,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
