import 'package:flutter/material.dart';
import '../services/notification_services.dart';
import '../services/schedule_service.dart';

class WorkoutScheduleScreen extends StatefulWidget {
  const WorkoutScheduleScreen({super.key});

  @override
  State<WorkoutScheduleScreen> createState() =>
      _WorkoutScheduleScreenState();
}

class _WorkoutScheduleScreenState
    extends State<WorkoutScheduleScreen> {
  bool remindersEnabled = true;

  TimeOfDay workoutTime = const TimeOfDay(
    hour: 17,
    minute: 0,
  );

  

  List<bool> get selectedDays => ScheduleService.selectedDays;
  
Future<void> _selectTime() async {
  final TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: workoutTime,
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(1.0),
        ),
        child: child!,
      );
    },
  );

  if (selectedTime != null) {
    setState(() {
      workoutTime = selectedTime;
    });
  }
}



 
  Future<void> _saveSchedule() async {
  final selected = <int>[];

  // Find the selected workout days.
  for (int i = 0; i < selectedDays.length; i++) {
    if (selectedDays[i]) {
      selected.add(i + 1);
    }
  }

  // Make sure at least one day is selected.
  if (selected.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Please select at least one workout day.',
        ),
      ),
    );
    return;
  }

  try {
    // Initialize notifications.
    await NotificationService.initialize();

    // Request notification/exact alarm permissions if needed.
    await NotificationService.requestPermission();

    // Remove previous workout reminders.
    await NotificationService.cancelAllScheduledNotifications();

    // Check whether reminders are enabled.
    if (!remindersEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Workout reminders are disabled.'),
        ),
      );
      return;
    }

    // Schedule a notification for every selected day.
    for (int i = 0; i < selectedDays.length; i++) {
      if (selectedDays[i]) {
        await NotificationService.scheduleWorkoutNotification(
          id: i + 1,
          hour: workoutTime.hour,
          minute: workoutTime.minute,
          weekday: i + 1,
        );
      }
    }

    // Check what Android currently has scheduled.
    await NotificationService.printPendingNotifications();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Schedule saved for ${selected.length} day(s) at '
          '${workoutTime.format(context)}.',
        ),
      ),
    );
  } catch (e, stackTrace) {
  print('===== NOTIFICATION ERROR =====');
  print(e);
  print(stackTrace);
  print('==============================');

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Could not schedule notifications: $e',
      ),
    ),
  );
}
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Schedule'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const Icon(
            Icons.calendar_month,
            size: 70,
            color: Color(0xFF43A047),
          ),

          const SizedBox(height: 15),

          const Text(
            'Workout Schedule',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: Color(0xFF173B32),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Choose when you want Stryve to remind you about your workouts.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 25),

          Card(
            child: SwitchListTile(
              title: const Text(
                'Workout Reminders',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                remindersEnabled
                    ? 'Reminders are enabled'
                    : 'Reminders are disabled',
              ),
              value: remindersEnabled,
              onChanged: (value) {
                setState(() {
                  remindersEnabled = value;
                });
              },
            ),
          ),

          const SizedBox(height: 15),

          Card(
            child: ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text(
                'Workout Time',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                workoutTime.format(context),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: remindersEnabled ? _selectTime : null,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Workout Days',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF173B32),
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: Column(
              children: List.generate(
                ScheduleService.days.length,
                (index) {
                  return CheckboxListTile(
                    title: Text(ScheduleService.days[index]),
                    value: selectedDays[index],
                    onChanged: remindersEnabled
                        ? (value) {
                            setState(() {
                              selectedDays[index] =
                                  value ?? false;
                            });
                          }
                        : null,
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              onPressed: _saveSchedule,
              icon: const Icon(Icons.save),
              label: const Text(
                'Save Schedule',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

