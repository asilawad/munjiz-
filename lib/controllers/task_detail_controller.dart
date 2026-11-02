import 'package:get/get.dart';

import '../app/routes/app_routes.dart';
import '../core/constants/app_config.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/app_snackbar.dart';
import '../data/models/task_model.dart';
import '../data/repositories/task_repository.dart';
import '../views/dialogs/app_dialogs.dart';

/// State and actions of the task details screen.
class TaskDetailController extends GetxController {
  TaskDetailController(this._repository);

  final TaskRepository _repository;

  late final String taskId = Get.arguments as String;

  /// Live task (read inside `Obx`); null once deleted.
  TaskModel? get task =>
      _repository.tasks.firstWhereOrNull((TaskModel t) => t.id == taskId);

  Future<void> togglePin(TaskModel task) async {
    final int pinnedCount = _repository.tasks
        .where((TaskModel t) => t.isPinned)
        .length;
    if (!task.isPinned && pinnedCount >= AppConfig.maxPinnedTasks) {
      await AppDialogs.showPinLimit();
      return;
    }
    await _repository.setPinned(task.id, pinned: !task.isPinned);
  }

  void edit(TaskModel task) =>
      Get.toNamed<void>(AppRoutes.taskForm, arguments: task.id);

  Future<void> delete(TaskModel task) async {
    final bool confirmed = await AppDialogs.confirmDelete();
    if (!confirmed) return;
    await _repository.delete(task.id);
    Get.back<void>();
    AppSnackbar.undo(
      message: AppStrings.taskDeleted,
      onUndo: () => _repository.save(task),
    );
  }
}
