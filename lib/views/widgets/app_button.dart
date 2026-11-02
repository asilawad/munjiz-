import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

enum AppButtonStyle { primary, accent, outlined, danger, destructive }

/// The only button used in the app; [style] picks the colors.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = AppButtonStyle.primary,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final (Color background, Color foreground, Color border) = switch (style) {
      AppButtonStyle.primary => (
        AppColors.primary,
        AppColors.onPrimary,
        AppColors.primary,
      ),
      AppButtonStyle.accent => (
        AppColors.accent,
        AppColors.onAccent,
        AppColors.accent,
      ),
      AppButtonStyle.outlined => (
        AppColors.surface,
        AppColors.primary,
        AppColors.primary,
      ),
      AppButtonStyle.danger => (
        AppColors.dangerSoft,
        AppColors.danger,
        AppColors.dangerSoft,
      ),
      AppButtonStyle.destructive => (
        AppColors.danger,
        AppColors.onPrimary,
        AppColors.danger,
      ),
    };

    return SizedBox(
      height: AppDimensions.buttonHeight,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          elevation: AppDimensions.elevationNone,
          padding: AppDimensions.horizontalPadding,
          textStyle: Theme.of(context).textTheme.labelLarge,
          side: BorderSide(
            color: border,
            width: AppDimensions.borderWidthSelected,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusLg,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(icon, size: AppDimensions.iconSm),
              const SizedBox(width: AppDimensions.spaceXxs),
            ],
            Flexible(
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
