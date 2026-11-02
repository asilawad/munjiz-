import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_durations.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';

/// One day of the horizontal strip.
class DayCard extends StatelessWidget {
  const DayCard({
    super.key,
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final Color primaryText = isSelected
        ? AppColors.onPrimary
        : AppColors.textPrimary;
    final Color secondaryText = isSelected
        ? AppColors.onPrimaryMuted
        : AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.chipSelection,
        width: AppDimensions.dayCardWidth,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: AppDimensions.borderRadiusLg,
          border: Border.all(
            color: isToday && !isSelected
                ? AppColors.primary
                : AppColors.transparent,
          ),
          boxShadow: AppDimensions.cardShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppStrings.weekdayShort[date.weekday - 1],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.bodySmall?.copyWith(color: secondaryText),
            ),
            const SizedBox(height: AppDimensions.spaceXxs),
            Text(
              '${date.day}',
              style: text.titleMedium?.copyWith(color: primaryText),
            ),
          ],
        ),
      ),
    );
  }
}
