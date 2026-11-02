import '../../core/constants/app_config.dart';
import '../../core/utils/date_extensions.dart';
import 'task_category.dart';

/// A task. Routine is a property: [isRoutine] with [routineDays] (empty = daily).
class TaskModel {
  const TaskModel({
    required this.id,
    required this.title,
    required this.category,
    required this.createdAt,
    this.description = '',
    this.customCategory = '',
    this.dueDate,
    this.isRoutine = false,
    this.routineDays = const <int>[],
    this.isPinned = false,
    this.isCompleted = false,
    this.completedDates = const <String>[],
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  final String id;
  final String title;
  final String description;
  final TaskCategory category;
  final String customCategory;

  /// Due date (date-only). For routines it is the start date.
  final DateTime? dueDate;
  final bool isRoutine;

  /// `DateTime.weekday` values; empty with [isRoutine] means every day.
  final List<int> routineDays;
  final bool isPinned;

  /// Completion flag of a one-off task.
  final bool isCompleted;

  /// Completed days (`yyyy-MM-dd`) of a routine task.
  final List<String> completedDates;
  final DateTime createdAt;

  /// Last modification (UTC); decides conflicts when syncing devices.
  final DateTime updatedAt;

  bool get isDaily => isRoutine && routineDays.isEmpty;

  bool get hasCustomCategory =>
      category == TaskCategory.other && customCategory.isNotEmpty;

  String get categoryLabel =>
      hasCustomCategory ? customCategory : category.label;

  String get categoryKey => hasCustomCategory
      ? '${AppConfig.customCategoryPrefix}$customCategory'
      : category.name;

  DateTime get startDate => (dueDate ?? createdAt).dateOnly;

  /// Whether the task is scheduled on [day].
  bool occursOn(DateTime day) {
    final DateTime d = day.dateOnly;
    if (!isRoutine) return dueDate != null && dueDate!.dateOnly == d;
    if (d.isBefore(startDate)) return false;
    return routineDays.isEmpty || routineDays.contains(d.weekday);
  }

  bool isDoneOn(DateTime day) =>
      isRoutine ? completedDates.contains(day.dayKey) : isCompleted;

  /// Returns a copy marked done / not done on [day].
  TaskModel withDone(DateTime day, {required bool done}) {
    if (!isRoutine) return copyWith(isCompleted: done);
    final List<String> dates = List<String>.of(completedDates)
      ..remove(day.dayKey);
    if (done) dates.add(day.dayKey);
    return copyWith(completedDates: dates);
  }

  TaskModel copyWith({
    String? title,
    String? description,
    TaskCategory? category,
    String? customCategory,
    DateTime? dueDate,
    bool clearDueDate = false,
    bool? isRoutine,
    List<int>? routineDays,
    bool? isPinned,
    bool? isCompleted,
    List<String>? completedDates,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      customCategory: customCategory ?? this.customCategory,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      isRoutine: isRoutine ?? this.isRoutine,
      routineDays: routineDays ?? this.routineDays,
      isPinned: isPinned ?? this.isPinned,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDates: completedDates ?? this.completedDates,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'title': title,
    'description': description,
    'category': category.name,
    'customCategory': customCategory,
    'dueDate': dueDate?.dayKey,
    'isRoutine': isRoutine,
    'routineDays': routineDays,
    'isPinned': isPinned,
    'isCompleted': isCompleted,
    'completedDates': completedDates,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final String? due = json['dueDate'] as String?;
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: (json['description'] as String?) ?? '',
      category: TaskCategory.fromName(json['category'] as String?),
      customCategory: (json['customCategory'] as String?) ?? '',
      dueDate: due == null ? null : DateTime.tryParse(due),
      isRoutine: (json['isRoutine'] as bool?) ?? false,
      routineDays: ((json['routineDays'] as List<dynamic>?) ?? <dynamic>[])
          .map((dynamic e) => e as int)
          .toList(),
      isPinned: (json['isPinned'] as bool?) ?? false,
      isCompleted: (json['isCompleted'] as bool?) ?? false,
      completedDates:
          ((json['completedDates'] as List<dynamic>?) ?? <dynamic>[])
              .map((dynamic e) => e as String)
              .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.tryParse((json['updatedAt'] as String?) ?? ''),
    );
  }
}
