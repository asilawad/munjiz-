import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_durations.dart';
import '../../core/constants/app_sizes.dart';
import '../../data/models/task_category.dart';

/// Circular category icon with a label; filled when selected.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final TaskCategory category;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: AppDimensions.categoryChipWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedContainer(
              duration: AppDurations.chipSelection,
              width: AppDimensions.categoryCircleSize,
              height: AppDimensions.categoryCircleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? category.color : category.softColor,
                border: Border.all(
                  color: isSelected ? category.color : AppColors.transparent,
                  width: AppDimensions.borderWidthSelected,
                ),
              ),
              child: Icon(
                category.icon,
                color: isSelected ? AppColors.onPrimary : category.color,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceXxs),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
