import 'package:get/get.dart';

import '../../bindings/home_binding.dart';
import '../../bindings/task_detail_binding.dart';
import '../../bindings/task_form_binding.dart';
import '../../core/constants/app_durations.dart';
import '../../views/ui/home_view.dart';
import '../../views/ui/task_detail_view.dart';
import '../../views/ui/task_form_view.dart';
import 'app_routes.dart';

/// Connects each route to its screen, binding and transition.
abstract final class AppPages {
  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.home,
      page: HomeView.new,
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: AppDurations.pageTransition,
      curve: AppCurves.entrance,
    ),
    GetPage<dynamic>(
      name: AppRoutes.taskDetail,
      page: TaskDetailView.new,
      binding: TaskDetailBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: AppDurations.pageTransition,
      curve: AppCurves.entrance,
    ),
    GetPage<dynamic>(
      name: AppRoutes.taskForm,
      page: TaskFormView.new,
      binding: TaskFormBinding(),
      transition: Transition.downToUp,
      transitionDuration: AppDurations.pageTransition,
      curve: AppCurves.entrance,
    ),
  ];
}
