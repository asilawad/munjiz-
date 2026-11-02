/// Date-only helpers used by the task logic.
extension DateOnlyX on DateTime {
  /// Same day at 00:00 (local).
  DateTime get dateOnly => DateTime(year, month, day);

  /// Stable storage key, e.g. `2026-10-30`.
  String get dayKey =>
      '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
