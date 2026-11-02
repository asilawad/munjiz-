import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import 'app_button.dart';

/// Generic confirmation / info dialog (delete confirm, pin limit).
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.primaryStyle = AppButtonStyle.primary,
    this.secondaryLabel,
    this.onSecondary,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final AppButtonStyle primaryStyle;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Dialog(
      backgroundColor: AppColors.surface,
      surfaceTintColor: AppColors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusXl,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimensions.dialogMaxWidth),
        child: Padding(
          padding: AppDimensions.dialogPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: AppDimensions.dialogIconCircle,
                height: AppDimensions.dialogIconCircle,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColor.withValues(alpha: AppDimensions.softAlpha),
                ),
                child: Icon(icon, color: iconColor, size: AppDimensions.iconLg),
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              Text(title, style: text.titleMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppDimensions.spaceXs),
              Text(message, style: text.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppDimensions.spaceXl),
              Row(
                children: <Widget>[
                  Expanded(
                    child: AppButton(
                      label: primaryLabel,
                      style: primaryStyle,
                      onPressed: onPrimary,
                    ),
                  ),
                  if (secondaryLabel != null) ...<Widget>[
                    const SizedBox(width: AppDimensions.spaceSm),
                    Expanded(
                      child: AppButton(
                        label: secondaryLabel!,
                        style: AppButtonStyle.outlined,
                        onPressed: onSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
