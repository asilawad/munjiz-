import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';

/// Keeps content readable on tablets / web by capping its width.
class ContentWidthBox extends StatelessWidget {
  const ContentWidthBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimensions.contentMaxWidth),
        child: child,
      ),
    );
  }
}
