import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../exercise_data.dart';
import 'workout_setup_screen.dart';
import '../services/navigation_control.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> motivationalMessages = [
    'You’ve got this! Give today’s workout your best. 💪',
    'One workout at a time. Keep moving! 🔥',
    'Your effort today builds a stronger tomorrow. 💪',
    'Stay focused, stay strong, and enjoy your workout! 🚀',
    'Every rep counts. Keep going! ⭐',
    'Believe in yourself and start moving! 🏃',
    'You don’t need to be perfect. Just keep improving! 🌟',
    'Turn your energy into progress today! ⚡',
    'Let’s make today’s workout count! 💪',
    'Small steps lead to big progress. Keep it up! 🔥',
  ];

  late String motivationalMessage;
  bool _setupPopupShowing = false;

  @override
  void initState() {
    super.initState();

    motivationalMessage =
        motivationalMessages[
          DateTime.now().millisecondsSinceEpoch %
              motivationalMessages.length
        ];
      
        WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSetupStatus();
    });
  }

  Future<List<Map<String, dynamic>>> _getTodayWorkout() async {
    final weeklyPlan = await DatabaseService.getWeeklyPlan();

    final today = DateTime.now();

    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    final todayName = days[today.weekday - 1];

    return weeklyPlan.where((plan) {
      return plan['day'] == todayName;
    }).toList();
  }

  Exercise? _findExercise(String name) {
    for (final exercise in exercises) {
      if (exercise.name == name) {
        return exercise;
      }
    }

    return null;
  }

    Future<void> _checkSetupStatus() async {
    if (_setupPopupShowing) {
      return;
    }

    final status = await DatabaseService.getSetupStatus();

    if (!mounted) {
      return;
    }

    final profileCompleted =
        status['profileCompleted'] == 1;

    final scheduleCompleted =
        status['scheduleCompleted'] == 1;

    final congratulationsShown =
        status['congratulationsShown'] == 1;

    if (!profileCompleted) {
      await _showProfileSetupPopup();
      return;
    }

    if (!scheduleCompleted) {
      await _showScheduleSetupPopup();
      return;
    }

    if (!congratulationsShown) {
      await _showCongratulationsPopup();
    }
  }

  Future<void> _showProfileSetupPopup() async {
    if (_setupPopupShowing) {
      return;
    }

    _setupPopupShowing = true;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Complete Your Profile',
          ),
          content: const Text(
            'Before you start using Stryve, '
            'let’s set up your personal fitness information.',
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                  NavigationController.startProfileSetup();
              },
              child: const Text(
                'SET UP PROFILE',
              ),
            ),
          ],
        );
      },
    );

    _setupPopupShowing = false;
  }

    Future<void> _showScheduleSetupPopup() async {
    if (_setupPopupShowing) {
      return;
    }

    _setupPopupShowing = true;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Up Your Schedule'),
          content: const Text(
            'Your profile is ready. Now let’s create your weekly workout schedule.',
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                NavigationController.goToSchedule();
              },
              child: const Text('SET UP SCHEDULE'),
            ),
          ],
        );
      },
    );

    _setupPopupShowing = false;
  }

  Future<void> _showCongratulationsPopup() async {
    if (_setupPopupShowing) {
      return;
    }

    _setupPopupShowing = true;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('You’re All Set! 🎉'),
          content: const Text(
            'Your Stryve profile and workout schedule are ready. You can now start your fitness journey.',
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('LET’S GO'),
            ),
          ],
        );
      },
    );

    _setupPopupShowing = false;

    await DatabaseService.setCongratulationsShown(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final accentColor = colors.primary;

    // Today's Workout now follows the selected accent color.
    final cardColor = colors.primaryContainer;

    final secondarySurface = theme.brightness == Brightness.dark
        ? const Color(0xFF242728)
        : const Color(0xFFEFF3F0);

    final secondaryText = colors.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stryve',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 12),

            Text(
              'Good day! 👋',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Ready to move and feel great today?',
              style: TextStyle(
                fontSize: 16,
                color: secondaryText,
              ),
            ),

            const SizedBox(height: 25),

            // ======================================================
            // TODAY'S WORKOUT
            // ======================================================

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(22),  

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: theme.brightness == Brightness.dark ? 0.25 : 0.10,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // WORKOUT ICON
                  Icon(
                    Icons.fitness_center,
                    color: colors.onPrimary,
                    size: 35,
                  ),

                  const SizedBox(height: 15),

                  // TITLE
                  Text(
                    "Today's Workout",
                    style: TextStyle(
                      color: colors.onPrimary,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _getTodayWorkout(),

                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Row(
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.onPrimary,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Text(
                              "Loading today's workout...",
                              style: TextStyle(
                                color: colors.onPrimary,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        );
                      }

                      if (snapshot.hasError) {
                        return Text(
                          "Unable to load today's workout.",
                          style: TextStyle(
                            color: colors.onPrimary,
                            fontSize: 15,
                          ),
                        );
                      }

                      final workouts = snapshot.data ?? [];

                      if (workouts.isEmpty) {
                        return Row(
                          children: [
                            Icon(
                              Icons.hotel,
                              color: colors.onPrimary,
                              size: 22,
                            ),

                            const SizedBox(width: 10),

                            Text(
                              'Today is a rest day.',
                              style: TextStyle(
                                color: colors.onPrimary,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Today's Exercises:",
                            style: TextStyle(
                              color: colors.onPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          ...workouts.map(
                            (workout) {
                              final exerciseName =
                                  workout['workout'] as String;

                              final exercise =
                                  _findExercise(exerciseName);

                              if (exercise == null) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),

                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.fitness_center,
                                        color: colors.onPrimary,
                                        size: 20,
                                      ),

                                      const SizedBox(width: 10),

                                      Expanded(
                                        child: Text(
                                          exerciseName,
                                          style: TextStyle(
                                            color: colors.onPrimary,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return InkWell(
                                borderRadius: BorderRadius.circular(12),

                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          WorkoutSetupScreen(
                                        exercise: exercise,
                                      ),
                                    ),
                                  );
                                },

                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 4,
                                  ),

                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.fitness_center,
                                        color: colors.onPrimary,
                                        size: 20,
                                      ),

                                      const SizedBox(width: 10),

                                      Expanded(
                                        child: Text(
                                          exerciseName,
                                          style: TextStyle(
                                            color: colors.onPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: colors.onPrimary,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ======================================================
            // MOTIVATIONAL MESSAGE
            // ======================================================

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: secondarySurface,

                borderRadius: BorderRadius.circular(20),

                border: Border.all(
                  color: colors.outlineVariant,
                ),
              ),

              child: Row(
                children: [
                  Icon(
                    Icons.wb_sunny,
                    color: accentColor,
                    size: 35,
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Text(
                      motivationalMessage,
                      style: TextStyle(
                        fontSize: 15,
                        color: colors.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}