import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../core/constants/app_sizes.dart';
import '../../data/models/category_option.dart';
import 'category_chip.dart';

/// Home category filter row (built-in + user-defined "Other" names).
class CategoryChips extends GetView<HomeController> {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<CategoryOption> options = controller.categoryOptions;
      final String? selected = controller.categoryKey.value;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: AppDimensions.horizontalPadding,
        child: Row(
          children: <Widget>[
            for (final CategoryOption option in options)
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  end: AppDimensions.spaceXs,
                ),
                child: CategoryChip(
                  category: option.category,
                  label: option.label,
                  isSelected: option.key == selected,
                  onTap: () => controller.toggleCategory(option.key),
                ),
              ),
          ],
        ),
      );
    });
  }
}
