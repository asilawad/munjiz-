import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';

/// Logo + Arabic / English app name at the top of the home screen.
class AppBrandHeader extends StatelessWidget {
  const AppBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Row(
      children: <Widget>[
        Image.asset(
          AppAssets.appIcon,
          width: AppDimensions.logoSize,
          height: AppDimensions.logoSize,
        ),
        const SizedBox(width: AppDimensions.spaceSm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppStrings.appName,
              style: text.titleLarge?.copyWith(color: AppColors.primary),
            ),
            Text(AppStrings.appNameEn, style: text.bodySmall),
          ],
        ),
      ],
    );
  }
}
