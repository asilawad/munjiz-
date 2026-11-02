import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../app/routes/app_routes.dart';
import '../core/constants/app_config.dart';
import '../core/constants/app_durations.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/app_snackbar.dart';
import '../core/utils/date_extensions.dart';
import '../data/models/category_option.dart';
import '../data/models/task_category.dart';
import '../data/models/task_filter.dart';
import '../data/models/task_model.dart';
import '../data/models/task_section.dart';
import '../data/repositories/task_repository.dart';
import '../views/dialogs/app_dialogs.dart';

/// State and logic of the home screen.
///
/// Note for views: observables must be read inside the `Obx` builder itself
/// (not inside lazy item builders) so the widget rebuilds on changes.
class HomeController extends GetxController {
  HomeController(this._repository);

  final TaskRepository _repository;

  final Rx<TaskFilter> filter = TaskFilter.all.obs;
  final RxnString categoryKey = RxnString();
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final RxString query = ''.obs;
  final RxString _rawQuery = ''.obs;
  final RxBool isLoading = true.obs;
  final RxnString errorMessage = RxnString();
  final RxSet<TaskSection> collapsedSections = <TaskSection>{
    TaskSection.completed,
  }.obs;

  /// Tasks whose checkbox was just tapped (shown checked, waiting to slide).
  final RxSet<String> checkingIds = <String>{}.obs;

  /// Tasks currently sliding out toward the "Completed" section.
  final RxSet<String> leavingIds = <String>{}.obs;

  RxList<TaskModel> get tasks => _repository.tasks;

  DateTime get today => DateTime.now().dateOnly;

  /// The day the list is showing (selected day, otherwise today).
  DateTime get referenceDay => selectedDate.value ?? today;

  List<DateTime> get days {
    final DateTime start = today;
    return List<DateTime>.generate(
      AppConfig.stripDays,
      (int i) => DateTime(start.year, start.month, start.day + i),
    );
  }

  @override
  void onInit() {
    super.onInit();
    debounce<String>(
      _rawQuery,
      (String value) => query.value = value.trim().toLowerCase(),
      time: AppDurations.searchDebounce,
    );
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await _repository.load();
    } catch (_) {
      errorMessage.value = AppStrings.loadError;
    }
    isLoading.value = false;
  }

  // ---------------------------------------------------------------------------
  // Derived data
  // ---------------------------------------------------------------------------

  int get todayTotal {
    final DateTime now = today;
    return tasks.where((TaskModel t) => t.occursOn(now)).length;
  }

  int get todayDone {
    final DateTime now = today;
    return tasks
        .where((TaskModel t) => t.occursOn(now) && t.isDoneOn(now))
        .length;
  }

  List<CategoryOption> get categoryOptions {
    final Set<String> customNames = tasks
        .where((TaskModel t) => t.hasCustomCategory)
        .map((TaskModel t) => t.customCategory)
        .toSet();
    return <CategoryOption>[
      for (final TaskCategory c in TaskCategory.values)
        if (c != TaskCategory.other)
          CategoryOption(key: c.name, label: c.label, category: c),
      if (customNames.isEmpty)
        CategoryOption(
          key: TaskCategory.other.name,
          label: TaskCategory.other.label,
          category: TaskCategory.other,
        )
      else
        for (final String name in customNames)
          CategoryOption(
            key: '${AppConfig.customCategoryPrefix}$name',
            label: name,
            category: TaskCategory.other,
          ),
    ];
  }

  /// Filtered tasks grouped by section (empty sections are omitted).
  Map<TaskSection, List<TaskModel>> get sections {
    final DateTime now = today;
    final DateTime? picked = selectedDate.value;
    final Map<TaskSection, List<TaskModel>> map =
        <TaskSection, List<TaskModel>>{
          for (final TaskSection s in TaskSection.values) s: <TaskModel>[],
        };

    for (final TaskModel t in tasks.where(_passesFilters)) {
      if (picked != null) {
        if (!t.occursOn(picked)) continue;
        final TaskSection target = t.isDoneOn(picked)
            ? TaskSection.completed
            : (t.isPinned ? TaskSection.pinned : TaskSection.day);
        map[target]!.add(t);
        continue;
      }
      map[_sectionFor(t, now)]!.add(t);
    }

    for (final List<TaskModel> list in map.values) {
      list.sort(_compareTasks);
    }
    map.removeWhere((TaskSection _, List<TaskModel> list) => list.isEmpty);
    return map;
  }

  TaskSection _sectionFor(TaskModel t, DateTime now) {
    if (t.isDoneOn(now)) return TaskSection.completed;
    if (t.isPinned) return TaskSection.pinned;
    if (t.isRoutine) {
      return t.occursOn(now) ? TaskSection.today : TaskSection.upcoming;
    }
    final DateTime? due = t.dueDate?.dateOnly;
    if (due == null) return TaskSection.noDate;
    if (due.isBefore(now)) return TaskSection.overdue;
    return due == now ? TaskSection.today : TaskSection.upcoming;
  }

  int _compareTasks(TaskModel a, TaskModel b) {
    final int byDate = (a.dueDate ?? a.createdAt).compareTo(
      b.dueDate ?? b.createdAt,
    );
    return byDate != 0 ? byDate : a.createdAt.compareTo(b.createdAt);
  }

  bool _passesFilters(TaskModel t) {
    final String q = query.value;
    if (q.isNotEmpty &&
        !t.title.toLowerCase().contains(q) &&
        !t.description.toLowerCase().contains(q)) {
      return false;
    }
    final String? key = categoryKey.value;
    if (key != null) {
      final bool matches = key == TaskCategory.other.name
          ? t.category == TaskCategory.other
          : t.categoryKey == key;
      if (!matches) return false;
    }
    return switch (filter.value) {
      TaskFilter.all => true,
      TaskFilter.today => t.occursOn(today),
      TaskFilter.routine => t.isRoutine,
      TaskFilter.pinned => t.isPinned,
    };
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  void setFilter(TaskFilter value) => filter.value = value;

  void toggleCategory(String key) =>
      categoryKey.value = categoryKey.value == key ? null : key;

  void onSearchChanged(String value) => _rawQuery.value = value;

  /// Tapping today (or the selected day again) returns to the grouped view.
  void selectDate(DateTime date) {
    final bool clear = date == today || selectedDate.value == date;
    selectedDate.value = clear ? null : date;
  }

  void toggleSection(TaskSection section) {
    if (!collapsedSections.remove(section)) collapsedSections.add(section);
  }

  void openTask(TaskModel task) =>
      Get.toNamed<void>(AppRoutes.taskDetail, arguments: task.id);

  void addTask() => Get.toNamed<void>(AppRoutes.taskForm);

  /// Checkbox flow: instant check + haptic -> ~0.5s -> slide away ->
  /// move to "Completed" -> snackbar with Undo -> celebration if all done.
  Future<void> onCheckTap(TaskModel task) async {
    final DateTime day = referenceDay;
    if (task.isDoneOn(day)) {
      await _repository.setDone(task.id, day, done: false);
      return;
    }
    if (checkingIds.contains(task.id)) return;

    HapticFeedback.lightImpact();
    checkingIds.add(task.id);
    await Future<void>.delayed(AppDurations.completeDelay);
    leavingIds.add(task.id);
    await Future<void>.delayed(AppDurations.slideOut);
    await _repository.setDone(task.id, day, done: true);
    checkingIds.remove(task.id);
    leavingIds.remove(task.id);

    AppSnackbar.completed(
      onUndo: () => _repository.setDone(task.id, day, done: false),
    );
    final bool allTodayDone = todayTotal > 0 && todayDone == todayTotal;
    if (allTodayDone && task.occursOn(today)) {
      HapticFeedback.mediumImpact();
      AppDialogs.showCelebration();
    }
  }
}
