import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';

/// Label above a form control.
class LabeledField extends StatelessWidget {
  const LabeledField({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: AppDimensions.spaceXs),
        child,
      ],
    );
  }
}
