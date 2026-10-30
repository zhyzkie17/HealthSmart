import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class IOSNotificationService {
  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Manila'));

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      iOS: iosSettings,
    );

    await notifications.initialize(
      settings: settings,
    );
  }

  static Future<void> requestPermission() async {
    final iosImplementation =
        notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    await iosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> scheduleWorkoutNotification({
    required int id,
    required int hour,
    required int minute,
    required int weekday,
  }) async {
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

    const DarwinNotificationDetails iosDetails =
    DarwinNotificationDetails(
  presentAlert: true,
  presentBadge: true,
  presentSound: true,
);

const NotificationDetails details = NotificationDetails(
  iOS: iosDetails,
);

await notifications.zonedSchedule(
  id: id,
  title: 'Fit Journey 💪',
  body: 'Time for your scheduled workout!',
  scheduledDate: scheduledDate,
  notificationDetails: details,
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
);
}
}