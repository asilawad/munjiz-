import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/task_model.dart';
import '../../data/models/task_section.dart';
import 'section_header.dart';
import 'state_message_view.dart';
import 'task_tile.dart';

/// Sliver with the grouped tasks (or an empty / no-results state).
class TaskSectionsList extends GetView<HomeController> {
  const TaskSectionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Observables are read here (inside Obx) so the list rebuilds on change.
      final Map<TaskSection, List<TaskModel>> sections = controller.sections;
      final Set<TaskSection> collapsed = controller.collapsedSections.toSet();
      final Set<String> checking = controller.checkingIds.toSet();
      final Set<String> leaving = controller.leavingIds.toSet();
      final DateTime day = controller.referenceDay;
      final DateTime today = controller.today;
      final bool noTasksAtAll = controller.tasks.isEmpty;

      if (sections.isEmpty) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: noTasksAtAll
              ? StateMessageView(
                  icon: Icons.task_alt_rounded,
                  title: AppStrings.emptyTitle,
                  message: AppStrings.emptyMessage,
                  actionLabel: AppStrings.addTask,
                  onAction: controller.addTask,
                )
              : const StateMessageView(
                  icon: Icons.search_off_rounded,
                  iconColor: AppColors.textSecondary,
                  title: AppStrings.noResultsTitle,
                  message: AppStrings.noResultsMessage,
                ),
        );
      }

      return SliverPadding(
        padding: AppDimensions.listPadding,
        sliver: SliverList.list(
          children: <Widget>[
            for (final MapEntry<TaskSection, List<TaskModel>> entry
                in sections.entries) ...<Widget>[
              SectionHeader(
                section: entry.key,
                count: entry.value.length,
                isCollapsed: collapsed.contains(entry.key),
                onTap: () => controller.toggleSection(entry.key),
              ),
              if (!collapsed.contains(entry.key))
                for (final TaskModel task in entry.value)
                  TaskTile(
                    key: ValueKey<String>(task.id),
                    task: task,
                    today: today,
                    isChecked: checking.contains(task.id) || task.isDoneOn(day),
                    isLeaving: leaving.contains(task.id),
                    onToggle: () => controller.onCheckTap(task),
                    onTap: () => controller.openTask(task),
                  ),
            ],
          ],
        ),
      );
    });
  }
}
