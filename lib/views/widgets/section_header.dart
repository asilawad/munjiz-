import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_durations.dart';
import '../../core/constants/app_sizes.dart';
import '../../data/models/task_section.dart';

/// Collapsible section title with a task count.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.section,
    required this.count,
    required this.isCollapsed,
    required this.onTap,
  });

  final TaskSection section;
  final int count;
  final bool isCollapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: AppDimensions.borderRadiusMd,
      child: Padding(
        padding: AppDimensions.sectionHeaderPadding,
        child: Row(
          children: <Widget>[
            AnimatedRotation(
              turns: isCollapsed ? 0 : AppDimensions.sectionChevronTurns,
              duration: AppDurations.sectionToggle,
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceXxs),
            Text(
              section.label,
              style: text.titleMedium?.copyWith(color: section.color),
            ),
            const Spacer(),
            Container(
              width: AppDimensions.countBadgeSize,
              height: AppDimensions.countBadgeSize,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
              ),
              child: Text('$count', style: text.labelSmall),
            ),
            const SizedBox(width: AppDimensions.spaceXs),
            Icon(section.icon, color: section.color, size: AppDimensions.iconSm),
          ],
        ),
      ),
    );
  }
}
