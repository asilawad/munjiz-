import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../core/constants/app_config.dart';
import '../../core/constants/app_durations.dart';
import '../../core/constants/app_quotes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_extensions.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';

/// Local notifications: a morning and an evening reminder for the next days,
/// each with a motivational quote and the number of remaining tasks.
///
/// Reminders are scheduled on the device, so they work fully offline. They are
/// rebuilt whenever tasks change and whenever the app returns to the screen,
/// so the remaining-task count stays accurate.
class NotificationService extends GetxService with WidgetsBindingObserver {
  NotificationService(this._repository);

  final TaskRepository _repository;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final Completer<void> _startup = Completer<void>();
  bool _ready = false;

  /// Completes once startup ends, including the permission prompt.
  Future<void> get startup => _startup.future;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    AppConfig.notificationChannelId,
    AppStrings.notificationChannelName,
    description: AppStrings.notificationChannelDescription,
    importance: Importance.high,
  );

  @override
  void onReady() {
    super.onReady();
    start();
  }

  Future<void> start() async {
    try {
      tz_data.initializeTimeZones();
      await _plugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings(AppConfig.notificationIcon),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);
      await _requestPermission();
      _ready = true;
      WidgetsBinding.instance.addObserver(this);
      debounce<List<TaskModel>>(
        _repository.tasks,
        (List<TaskModel> _) => reschedule(),
        time: AppDurations.notificationDebounce,
      );
      await reschedule();
    } catch (_) {
      _ready = false;
    } finally {
      if (!_startup.isCompleted) _startup.complete();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) reschedule();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  Future<void> _requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// Shows a notification immediately (used for FCM messages in foreground).
  Future<void> showNow({required String title, required String body}) async {
    if (!_ready) return;
    final int reminderCount =
        AppConfig.notificationDays * AppConfig.notificationSlotsPerDay;
    final int id =
        reminderCount +
        DateTime.now().millisecondsSinceEpoch %
            (AppConfig.maxNotificationId - reminderCount);
    await _plugin.show(id, title, body, _details(body));
  }

  /// Cancels and rebuilds the upcoming reminders.
  Future<void> reschedule() async {
    if (!_ready) return;
    // Not cancelAll(): that would also dismiss displayed push notifications.
    final int reminderCount =
        AppConfig.notificationDays * AppConfig.notificationSlotsPerDay;
    for (int id = 0; id < reminderCount; id++) {
      await _plugin.cancel(id);
    }
    final DateTime now = DateTime.now();
    final DateTime today = now.dateOnly;
    final List<String> quotes = AppQuotes.all;

    for (int offset = 0; offset < AppConfig.notificationDays; offset++) {
      final DateTime date = DateTime(today.year, today.month, today.day + offset);
      final int epochDay = date.difference(DateTime(date.year)).inDays;
      final String remaining = _remainingText(date, today);

      for (int slot = 0; slot < AppConfig.notificationSlotsPerDay; slot++) {
        final bool morning = slot == AppConfig.morningSlot;
        final DateTime when = DateTime(
          date.year,
          date.month,
          date.day,
          morning ? AppConfig.morningHour : AppConfig.eveningHour,
        );
        if (!when.isAfter(now)) continue;

        final String quote =
            quotes[(epochDay * AppConfig.notificationSlotsPerDay + slot) %
                quotes.length];
        final String body = '$remaining${AppStrings.notifLineSeparator}$quote';
        await _plugin.zonedSchedule(
          offset * AppConfig.notificationSlotsPerDay + slot,
          morning ? AppStrings.notifMorningTitle : AppStrings.notifEveningTitle,
          body,
          tz.TZDateTime.from(when, tz.UTC),
          _details(body),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    }
  }

  String _remainingText(DateTime date, DateTime today) {
    final bool isToday = date == today;
    final int remaining = _repository.tasks.where((TaskModel t) {
      if (t.isDoneOn(date)) return false;
      final bool overdue =
          isToday &&
          !t.isRoutine &&
          t.dueDate != null &&
          t.dueDate!.dateOnly.isBefore(date);
      return t.occursOn(date) || overdue;
    }).length;
    return remaining == 0
        ? AppStrings.notifAllDone
        : AppStrings.notifRemaining(remaining);
  }

  NotificationDetails _details(String body) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(body),
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }
}
