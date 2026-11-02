import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/task_form_controller.dart';
import '../../core/constants/app_config.dart';
import '../../core/constants/app_durations.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../data/models/task_category.dart';
import 'category_chip.dart';

/// Category picker; "Other" reveals a field for a custom category name.
class CategorySelector extends GetView<TaskFormController> {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final TaskCategory selected = controller.category.value;
      return Column(
        children: <Widget>[
          Wrap(
            spacing: AppDimensions.spaceXs,
            runSpacing: AppDimensions.spaceSm,
            children: <Widget>[
              for (final TaskCategory c in TaskCategory.values)
                CategoryChip(
                  category: c,
                  label: c.label,
                  isSelected: c == selected,
                  onTap: () => controller.selectCategory(c),
                ),
            ],
          ),
          AnimatedSize(
            duration: AppDurations.chipSelection,
            curve: AppCurves.entrance,
            child: selected == TaskCategory.other
                ? Padding(
                    padding: const EdgeInsets.only(top: AppDimensions.spaceSm),
                    child: TextFormField(
                      controller: controller.customCategoryController,
                      maxLength: AppConfig.customCategoryMaxLength,
                      validator: Validators.required,
                      decoration: const InputDecoration(
                        hintText: AppStrings.customCategoryHint,
                        counterText: '',
                      ),
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      );
    });
  }
}
