import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/task_detail_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_extensions.dart';
import '../../data/models/task_model.dart';
import '../widgets/app_button.dart';
import '../widgets/content_width_box.dart';
import '../widgets/detail_row.dart';
import '../widgets/gradient_background.dart';
import '../widgets/soft_card.dart';
import '../widgets/state_message_view.dart';
import '../widgets/task_badge.dart';

/// Screen 3 - task details with pin / edit / delete actions.
class TaskDetailView extends GetView<TaskDetailController> {
  const TaskDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return GradientBackground(
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        appBar: AppBar(title: const Text(AppStrings.detailsTitle)),
        body: SafeArea(
          child: ContentWidthBox(
            child: Obx(() {
              final TaskModel? task = controller.task;
              if (task == null) {
                return const StateMessageView(
                  icon: Icons.search_off_rounded,
                  iconColor: AppColors.textSecondary,
                  title: AppStrings.taskNotFound,
                  message: AppStrings.noResultsMessage,
                );
              }
              final DateTime today = DateTime.now().dateOnly;
              final bool done = task.isDoneOn(today);
              final String repeat = task.isDaily
                  ? AppStrings.daily
                  : task.routineDays
                        .map((int d) => AppStrings.weekdayShort[d - 1])
                        .join(AppStrings.repeatSeparator);
              final String statusText = task.isRoutine
                  ? (done
                        ? AppStrings.statusDoneToday
                        : AppStrings.statusPendingToday)
                  : (done ? AppStrings.statusDone : AppStrings.statusPending);

              return ListView(
                padding: AppDimensions.screenPadding,
                children: <Widget>[
                  SoftCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(task.title, style: text.titleLarge),
                        const SizedBox(height: AppDimensions.spaceSm),
                        TaskBadge(
                          label: task.categoryLabel,
                          icon: task.category.icon,
                          color: task.category.color,
                          backgroundColor: task.category.softColor,
                        ),
                        if (task.description.isNotEmpty) ...<Widget>[
                          const SizedBox(height: AppDimensions.spaceMd),
                          Text(task.description, style: text.bodyLarge),
                        ],
                        const SizedBox(height: AppDimensions.spaceSm),
                        DetailRow(
                          icon: Icons.calendar_today_rounded,
                          label: AppStrings.rowDate,
                          value: task.dueDate == null
                              ? AppStrings.noDate
                              : DateFormat(
                                  AppStrings.dateFormat,
                                ).format(task.dueDate!),
                        ),
                        if (task.isRoutine)
                          DetailRow(
                            icon: Icons.repeat_rounded,
                            label: AppStrings.rowRepeat,
                            value: repeat,
                          ),
                        DetailRow(
                          icon: Icons.check_circle_outline_rounded,
                          label: AppStrings.rowStatus,
                          value: statusText,
                        ),
                        DetailRow(
                          icon: Icons.push_pin_outlined,
                          label: AppStrings.rowPin,
                          value: task.isPinned
                              ? AppStrings.pinned
                              : AppStrings.notPinned,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceLg),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: AppButton(
                          label: AppStrings.delete,
                          icon: Icons.delete_rounded,
                          style: AppButtonStyle.danger,
                          onPressed: () => controller.delete(task),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceXs),
                      Expanded(
                        child: AppButton(
                          label: AppStrings.edit,
                          icon: Icons.edit_rounded,
                          style: AppButtonStyle.outlined,
                          onPressed: () => controller.edit(task),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceXs),
                      Expanded(
                        child: AppButton(
                          label: task.isPinned
                              ? AppStrings.unpin
                              : AppStrings.pin,
                          icon: Icons.push_pin_rounded,
                          onPressed: () => controller.togglePin(task),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
