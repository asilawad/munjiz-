import 'package:flutter/widgets.dart';

/// Non-visual app configuration and business limits.
abstract final class AppConfig {
  static const Locale locale = Locale('ar');

  /// Maximum number of pinned tasks.
  static const int maxPinnedTasks = 3;

  /// Number of days shown in the home day strip (today + following days).
  static const int stripDays = 14;

  static const String tasksStorageKey = 'munjiz_tasks';
  static const String tombstonesStorageKey = 'munjiz_deleted_tasks';

  /// Prefix of the filter key used for user-defined "Other" categories.
  static const String customCategoryPrefix = 'other:';

  static const int datePickerYearsBack = 1;
  static const int datePickerYearsForward = 5;

  /// `DateTime.weekday` values (Mon=1 .. Sun=7) in Arabic week order.
  static const List<int> weekOrder = <int>[6, 7, 1, 2, 3, 4, 5];

  static const int titleMaxLength = 80;
  static const int descriptionMaxLength = 500;
  static const int customCategoryMaxLength = 20;
  static const int descriptionMinLines = 3;
  static const int descriptionMaxLines = 5;
  static const int taskTitleMaxLines = 2;
  static const int confettiParticles = 30;
  static const double confettiGravity = 0.25;

  // Notifications
  static const String notificationChannelId = 'munjiz_reminders';
  static const String notificationIcon = '@mipmap/ic_launcher';
  static const int notificationDays = 7;
  static const int morningHour = 9;
  static const int eveningHour = 20;
  static const int notificationSlotsPerDay = 2;
  static const int morningSlot = 0;
  static const int eveningSlot = 1;
  static const int maxNotificationId = 0x7fffffff;

  // Firebase
  static const String fcmTopic = 'daily_motivation';
  static const String usersCollection = 'users';
  static const String tasksCollection = 'tasks';
  static const String devicesCollection = 'devices';
}
