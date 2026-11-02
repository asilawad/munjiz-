import '../../core/constants/app_strings.dart';

/// Primary pill filters of the home screen.
enum TaskFilter {
  all(AppStrings.filterAll),
  today(AppStrings.filterToday),
  routine(AppStrings.filterRoutine),
  pinned(AppStrings.filterPinned);

  const TaskFilter(this.label);

  final String label;
}
