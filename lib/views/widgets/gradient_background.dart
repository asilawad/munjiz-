import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Soft light gradient behind a screen. Wrap a transparent Scaffold with it.
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: child,
    );
  }
}
