import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../core/constants/app_sizes.dart';
import '../../data/models/task_filter.dart';
import 'filter_pill.dart';

/// Row: All / Today / Routine / Pinned.
class FilterPills extends GetView<HomeController> {
  const FilterPills({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.pillHeight,
      child: Obx(() {
        final TaskFilter current = controller.filter.value;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: AppDimensions.horizontalPadding,
          itemCount: TaskFilter.values.length,
          separatorBuilder: (BuildContext _, int index) =>
              const SizedBox(width: AppDimensions.spaceXs),
          itemBuilder: (BuildContext _, int index) {
            final TaskFilter item = TaskFilter.values[index];
            return FilterPill(
              label: item.label,
              isSelected: item == current,
              onTap: () => controller.setFilter(item),
            );
          },
        );
      }),
    );
  }
}
