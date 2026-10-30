import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/notification_services.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({
    super.key,
  });

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {

  bool notificationsEnabled = true;
  bool headsUpEnabled = true;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // ============================================================
  // LOAD SETTINGS
  // ============================================================

  Future<void> _loadSettings() async {
    final enabled =
        await NotificationService
            .areNotificationsEnabled();

    final headsUp =
        await NotificationService
            .isHeadsUpEnabled();

    if (!mounted) return;

    setState(() {
      notificationsEnabled = enabled;
      headsUpEnabled = headsUp;
      isLoading = false;
    });
  }

  // ============================================================
  // TOGGLE NOTIFICATIONS
  // ============================================================

  Future<void> _toggleNotifications(
    bool value,
  ) async {
    setState(() {
      notificationsEnabled = value;
    });

    await NotificationService
        .setNotificationsEnabled(value);

    if (!value) {
      await NotificationService
          .cancelAllScheduledNotifications();

      return;
    }

    await NotificationService.initialize();
    await NotificationService.requestPermission();

    final weeklyPlan =
        await DatabaseService.getWeeklyPlan();

    await NotificationService
        .scheduleWeeklyPlanNotifications(
      weeklyPlan,
    );
  }

  // ============================================================
  // TOGGLE HEADS-UP
  // ============================================================

  Future<void> _toggleHeadsUp(
    bool value,
  ) async {
    setState(() {
      headsUpEnabled = value;
    });

    await NotificationService
        .setHeadsUpEnabled(value);

    if (!notificationsEnabled) {
      return;
    }

    final weeklyPlan =
        await DatabaseService.getWeeklyPlan();

    await NotificationService
        .scheduleWeeklyPlanNotifications(
      weeklyPlan,
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification Settings',
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ======================================================
          // MAIN NOTIFICATIONS
          // ======================================================

          Card(
            child: SwitchListTile(
              secondary: Icon(
                Icons.notifications_active,
                color: Theme.of(context).colorScheme.primary,
              ),

              title: const Text(
                'Workout Notifications',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: const Text(
                'Receive reminders for your scheduled workouts.',
              ),

              value: notificationsEnabled,

              onChanged: _toggleNotifications,
            ),
          ),

          const SizedBox(height: 12),

          // ======================================================
          // HEADS-UP
          // ======================================================

          Card(
            child: SwitchListTile(
              secondary: Icon(
                Icons.alarm,
                color: Theme.of(context).colorScheme.primary,
              ),

              title: const Text(
                '5-Minute Heads-Up',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: const Text(
                'Get a reminder 5 minutes before your workout.',
              ),

              value: headsUpEnabled,

              onChanged:
                  notificationsEnabled
                      ? _toggleHeadsUp
                      : null,
            ),
          ),

          const SizedBox(height: 25),

          // ======================================================
          // INFORMATION
          // ======================================================

          Card(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest,

            child: const Padding(
              padding: EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [
                      Icon(Icons.info_outline),

                      SizedBox(width: 8),

                      Text(
                        'How it works',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  Text(
                    'When enabled, Stryve will remind you about '
                    'your scheduled workouts.',

                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    'If the 5-minute heads-up is enabled, '
                    'you will receive an additional reminder '
                    '5 minutes before the scheduled workout.',

                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}