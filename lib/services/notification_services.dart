import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  // ============================================================
  // SETTINGS KEYS
  // ============================================================

  static const String notificationsEnabledKey =
      'notifications_enabled';

  static const String headsUpEnabledKey =
      'heads_up_notifications_enabled';

  // ============================================================
  // INITIALIZE
  // ============================================================

  static Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(
      tz.getLocation('Asia/Manila'),
    );

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings settings =
        InitializationSettings(
      android: androidSettings,
    );

    await notifications.initialize(
      settings: settings,
    );
  }

  // ============================================================
  // REQUEST PERMISSION
  // ============================================================

  static Future<void> requestPermission() async {
    final androidImplementation =
        notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation == null) {
      return;
    }

    final notificationAllowed =
        await androidImplementation
            .requestNotificationsPermission();

    print(
      'Notification permission: $notificationAllowed',
    );

    final exactAlarmAllowed =
        await androidImplementation
            .canScheduleExactNotifications();

    print(
      'Exact alarm permission: $exactAlarmAllowed',
    );

    if (exactAlarmAllowed == false) {
      await androidImplementation
          .requestExactAlarmsPermission();
    }
  }

  // ============================================================
  // GET SETTINGS
  // ============================================================

  static Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(
          notificationsEnabledKey,
        ) ??
        true;
  }

  static Future<bool> isHeadsUpEnabled() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(
          headsUpEnabledKey,
        ) ??
        true;
  }

  // ============================================================
  // SAVE SETTINGS
  // ============================================================

  static Future<void> setNotificationsEnabled(
    bool enabled,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      notificationsEnabledKey,
      enabled,
    );
  }

  static Future<void> setHeadsUpEnabled(
    bool enabled,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      headsUpEnabledKey,
      enabled,
    );
  }

  // ============================================================
  // WORKOUT NOTIFICATION
  // ============================================================

  static Future<void> scheduleWorkoutNotification({
    required int id,
    required int hour,
    required int minute,
    required int weekday,
    bool isHeadsUp = false,
  }) async {
    final notificationsEnabled =
        await areNotificationsEnabled();

    if (!notificationsEnabled) {
      return;
    }

    final headsUpEnabled =
        await isHeadsUpEnabled();

    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(
        const Duration(days: 1),
      );
    }

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(
        const Duration(days: 7),
      );
    }

    // ==========================================================
    // NOTIFICATION DETAILS
    // ==========================================================

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'Stryve_workout_channel',
      'Stryve Workout Reminders',
      channelDescription:
          'Reminders for scheduled Stryve workouts',
      importance: Importance.high,
      priority: Priority.high,
      vibrationPattern:
          Int64List.fromList([
        0,
        1000,
        500,
        2000,
      ]),
    );

    final NotificationDetails details =
        NotificationDetails(
      android: androidDetails,
    );

    // ==========================================================
    // 5-MINUTE HEADS-UP
    // ==========================================================

    if (headsUpEnabled) {
      final headsUpDate =
          scheduledDate.subtract(
        const Duration(minutes: 5),
      );

      // Only schedule it if it is still in the future.
      if (headsUpDate.isAfter(now)) {
        await notifications.zonedSchedule(
          id: id + 1000,
          title: 'Workout Coming Up! 💪',
          body:
              'Your scheduled workout starts in 5 minutes.',
          scheduledDate: headsUpDate,
          notificationDetails: details,
          androidScheduleMode:
              AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    }

    // ==========================================================
    // ACTUAL WORKOUT NOTIFICATION
    // ==========================================================

    await notifications.zonedSchedule(
      id: id,
      title: ' Stryve 💪',
      body: 'Time for your scheduled workout!',
      scheduledDate: scheduledDate,
      notificationDetails: details,
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle,
    );

    print(
      'Workout notification scheduled: $scheduledDate',
    );

    if (headsUpEnabled) {
      print(
        'Heads-up notification scheduled: '
        '${scheduledDate.subtract(const Duration(minutes: 5))}',
      );
    }
  }

  // ============================================================
  // SCHEDULE WEEKLY PLAN
  // ============================================================

      static Future<void> scheduleWeeklyPlanNotifications(
      List<Map<String, dynamic>> weeklyPlan,
    ) async {
      await cancelAllScheduledNotifications();

      final notificationsEnabled =
          await areNotificationsEnabled();

      if (!notificationsEnabled) {
        print('Notifications are disabled.');
        return;
      }

      final weekdayMap = {
        'Monday': DateTime.monday,
        'Tuesday': DateTime.tuesday,
        'Wednesday': DateTime.wednesday,
        'Thursday': DateTime.thursday,
        'Friday': DateTime.friday,
        'Saturday': DateTime.saturday,
        'Sunday': DateTime.sunday,
      };

      final Map<String, Map<String, dynamic>> dailyWorkouts = {};

      for (final workout in weeklyPlan) {
        final day = workout['day']?.toString();

        if (day == null) {
          continue;
        }

        if (workout['isRest'] == 1) {
          continue;
        }

        // Only one workout reminder pair per day.
        if (!dailyWorkouts.containsKey(day)) {
          dailyWorkouts[day] = workout;
        }
      }

      int notificationId = 100;

      for (final entry in dailyWorkouts.entries) {
        final day = entry.key;
        final workout = entry.value;

        final weekday = weekdayMap[day];

        if (weekday == null) {
          continue;
        }

        final hour = workout['hour'] as int? ?? 0;
        final minute = workout['minute'] as int? ?? 0;

        await scheduleWorkoutNotification(
          id: notificationId,
          hour: hour,
          minute: minute,
          weekday: weekday,
        );

        // Reserve two IDs for each day's notification pair.
        notificationId += 2;
      }

      await printPendingNotifications();
    }

  // ============================================================
  // CANCEL ALL
  // ============================================================

  static Future<void>
      cancelAllScheduledNotifications() async {
    await notifications.cancelAll();
  }

  // ============================================================
  // PRINT PENDING NOTIFICATIONS
  // ============================================================

  static Future<void> printPendingNotifications() async {
    final pending =
        await notifications.pendingNotificationRequests();

    print(
      '===== PENDING NOTIFICATIONS =====',
    );

    print(
      'Count: ${pending.length}',
    );

    for (final notification in pending) {
      print(
        'ID: ${notification.id} | '
        'Title: ${notification.title} | '
        'Body: ${notification.body}',
      );
    }

    print(
      '=================================',
    );
  }
}