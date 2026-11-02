import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// White rounded surface with a soft blue shadow; optionally tappable.
class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = AppDimensions.cardPadding,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDimensions.borderRadiusLg,
        boxShadow: AppDimensions.cardShadow,
      ),
      child: Material(
        color: AppColors.transparent,
        borderRadius: AppDimensions.borderRadiusLg,
        child: InkWell(
          borderRadius: AppDimensions.borderRadiusLg,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
