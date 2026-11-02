import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import 'app_button.dart';

/// Shared layout for empty, no-results and error states.
class StateMessageView extends StatelessWidget {
  const StateMessageView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.iconColor = AppColors.primary,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: AppDimensions.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: AppDimensions.stateIconCircle,
              height: AppDimensions.stateIconCircle,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withValues(alpha: AppDimensions.softAlpha),
              ),
              child: Icon(icon, size: AppDimensions.iconHero, color: iconColor),
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            Text(title, style: text.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: AppDimensions.spaceXs),
            Text(message, style: text.bodyMedium, textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...<Widget>[
              const SizedBox(height: AppDimensions.spaceLg),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                style: AppButtonStyle.accent,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
