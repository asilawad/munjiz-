import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constants/app_strings.dart';
import '../core/utils/app_snackbar.dart';
import '../core/utils/date_extensions.dart';
import '../data/models/task_category.dart';
import '../data/models/task_model.dart';
import '../data/repositories/task_repository.dart';

/// Add / edit task form (one dual-purpose screen).
class TaskFormController extends GetxController {
  TaskFormController(this._repository);

  final TaskRepository _repository;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController customCategoryController =
      TextEditingController();

  final Rx<TaskCategory> category = TaskCategory.personal.obs;
  final Rxn<DateTime> dueDate = Rxn<DateTime>();
  final RxBool isRoutine = false.obs;
  final RxBool isDaily = true.obs;
  final RxSet<int> routineDays = <int>{}.obs;

  TaskModel? _editing;

  bool get isEditing => _editing != null;

  @override
  void onInit() {
    super.onInit();
    final String? id = Get.arguments as String?;
    _editing = id == null ? null : _repository.byId(id);
    final TaskModel? task = _editing;
    if (task == null) {
      dueDate.value = DateTime.now().dateOnly;
      return;
    }
    titleController.text = task.title;
    descriptionController.text = task.description;
    customCategoryController.text = task.customCategory;
    category.value = task.category;
    dueDate.value = task.dueDate;
    isRoutine.value = task.isRoutine;
    isDaily.value = task.routineDays.isEmpty;
    routineDays.assignAll(task.routineDays);
  }

  void selectCategory(TaskCategory value) => category.value = value;

  void setDueDate(DateTime? value) => dueDate.value = value;

  void setRoutine(bool value) => isRoutine.value = value;

  void selectDaily() {
    routineDays.clear();
    isDaily.value = true;
  }

  /// Toggling a specific day leaves "daily"; clearing all days returns to it.
  void toggleDay(int weekday) {
    if (!routineDays.remove(weekday)) routineDays.add(weekday);
    isDaily.value = routineDays.isEmpty;
  }

  Future<void> save() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final TaskModel? base = _editing;
    final bool custom = category.value == TaskCategory.other;

    final TaskModel task = TaskModel(
      id: base?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      category: category.value,
      customCategory: custom ? customCategoryController.text.trim() : '',
      dueDate: dueDate.value,
      isRoutine: isRoutine.value,
      routineDays: isRoutine.value && !isDaily.value
          ? (routineDays.toList()..sort())
          : const <int>[],
      isPinned: base?.isPinned ?? false,
      isCompleted: base?.isCompleted ?? false,
      completedDates: base?.completedDates ?? const <String>[],
      createdAt: base?.createdAt ?? DateTime.now(),
    );

    await _repository.save(task);
    Get.back<void>();
    AppSnackbar.info(isEditing ? AppStrings.taskUpdated : AppStrings.taskAdded);
  }

  void cancel() => Get.back<void>();

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    customCategoryController.dispose();
    super.onClose();
  }
}
