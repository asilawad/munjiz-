import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../widgets/app_brand_header.dart';
import '../widgets/category_chips.dart';
import '../widgets/content_width_box.dart';
import '../widgets/daily_progress_card.dart';
import '../widgets/day_strip.dart';
import '../widgets/filter_pills.dart';
import '../widgets/gradient_background.dart';
import '../widgets/loading_view.dart';
import '../widgets/search_field.dart';
import '../widgets/state_message_view.dart';
import '../widgets/task_sections_list.dart';

/// Screen 1 - home: day strip, filters, search, progress and grouped tasks.
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        floatingActionButton: FloatingActionButton(
          onPressed: controller.addTask,
          child: const Icon(Icons.add_rounded, size: AppDimensions.iconLg),
        ),
        body: SafeArea(
          child: ContentWidthBox(
            child: Obx(() {
              if (controller.isLoading.value) return const LoadingView();
              final String? error = controller.errorMessage.value;
              if (error != null) {
                return StateMessageView(
                  icon: Icons.wifi_off_rounded,
                  iconColor: AppColors.danger,
                  title: AppStrings.errorTitle,
                  message: error,
                  actionLabel: AppStrings.retry,
                  onAction: controller.load,
                );
              }
              return CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: AppDimensions.screenPadding,
                          child: AppBrandHeader(),
                        ),
                        const DayStrip(),
                        const SizedBox(height: AppDimensions.spaceMd),
                        Padding(
                          padding: AppDimensions.horizontalPadding,
                          child: SearchField(
                            onChanged: controller.onSearchChanged,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceSm),
                        const FilterPills(),
                        const SizedBox(height: AppDimensions.spaceMd),
                        const CategoryChips(),
                        const SizedBox(height: AppDimensions.spaceMd),
                        const Padding(
                          padding: AppDimensions.horizontalPadding,
                          child: DailyProgressCard(),
                        ),
                        const SizedBox(height: AppDimensions.spaceSm),
                      ],
                    ),
                  ),
                  const TaskSectionsList(),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
