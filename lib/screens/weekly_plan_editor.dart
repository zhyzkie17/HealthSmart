import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../exercise_data.dart';
import '../services/notification_services.dart';

class WeeklyPlanEditor extends StatefulWidget {
  const WeeklyPlanEditor({super.key});

  @override
  State<WeeklyPlanEditor> createState() => _WeeklyPlanEditorState();
}

class _WeeklyPlanEditorState extends State<WeeklyPlanEditor> {
  // ============================================================
  // WEEKLY PLAN DATA
  // ============================================================

  final Map<String, List<String>> selectedExercises = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  final Map<String, bool> selectedRestDays = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

  final Map<String, TimeOfDay?> selectedTimes = {
    'Monday': null,
    'Tuesday': null,
    'Wednesday': null,
    'Thursday': null,
    'Friday': null,
    'Saturday': null,
    'Sunday': null,
  };

  // ============================================================
  // USER PROFILE
  // ============================================================

  String userGoal = 'General Fitness';
  String userFocus = 'Strength';
  String userActivityLevel = 'Moderately Active';

  bool profileLoaded = false;

  // ============================================================
  // BODY PARTS
  // ============================================================

  final List<String> bodyParts = [
    'Chest',
    'Back',
    'Shoulders',
    'Arms',
    'Legs',
    'Abs',
    'Full Body',
  ];

  // Selected body part for each day.
  final Map<String, String?> selectedBodyParts = {
    'Monday': null,
    'Tuesday': null,
    'Wednesday': null,
    'Thursday': null,
    'Friday': null,
    'Saturday': null,
    'Sunday': null,
  };

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadExistingWeeklyPlan();
  }

  // ============================================================
  // LOAD PROFILE
  // ============================================================

  Future<void> _loadUserProfile() async {
    final user = await DatabaseService.getUser();

    if (!mounted) return;

    if (user != null) {
      setState(() {
        userGoal = user['goal']?.toString() ?? 'General Fitness';
        userFocus = user['focus']?.toString() ?? 'Strength';
        userActivityLevel =
            user['activityLevel']?.toString() ?? 'Moderately Active';

        profileLoaded = true;
      });
    } else {
      setState(() {
        profileLoaded = true;
      });
    }
  }

  Future<void> _loadExistingWeeklyPlan() async {
  final weeklyPlan =
    await DatabaseService.getWeeklyPlan();
  print('SAVE PLAN: Retrieved weekly plan');
  print('SAVE PLAN: Weekly plan count = ${weeklyPlan.length}');
  print('SAVE PLAN: Weekly plan data = $weeklyPlan');

  if (!mounted) return;

  setState(() {
    // Clear current selections first
    for (final day in selectedExercises.keys) {
      selectedExercises[day]!.clear();
      selectedRestDays[day] = false;
      selectedTimes[day] = null;
      selectedBodyParts[day] = null;
    }

    // Load saved data
    for (final workout in weeklyPlan) {
      final day = workout['day']?.toString();

      if (day == null || !selectedExercises.containsKey(day)) {
        continue;
      }

      final isRest = workout['isRest'] == 1;

      // ---------------------------------------------
      // REST DAY
      // ---------------------------------------------
      if (isRest) {
        selectedRestDays[day] = true;
        continue;
      }

      // ---------------------------------------------
      // EXERCISE
      // ---------------------------------------------
      final exerciseName = workout['workout']?.toString();

      if (exerciseName != null &&
          exerciseName.isNotEmpty &&
          !selectedExercises[day]!.contains(exerciseName)) {
        selectedExercises[day]!.add(exerciseName);
      }

      // ---------------------------------------------
      // WORKOUT TIME
      // ---------------------------------------------
      final hour = workout['hour'];
      final minute = workout['minute'];

      if (hour != null && minute != null) {
        selectedTimes[day] = TimeOfDay(
          hour: hour as int,
          minute: minute as int,
        );
      }

      // ---------------------------------------------
      // FIND BODY PART
      // ---------------------------------------------
      if (exerciseName != null) {
        final exercise = exercises.cast<Exercise?>().firstWhere(
          (item) => item?.name == exerciseName,
          orElse: () => null,
        );

        if (exercise != null) {
          selectedBodyParts[day] = exercise.bodyPart;
        }
      }
    }
  });
}

  // ============================================================
  // DIFFICULTY FILTER
  // ============================================================

  List<String> _allowedDifficulties() {
    final activity = userActivityLevel.toLowerCase().trim();

    // Sedentary users only receive beginner exercises.
    if (activity == 'sedentary') {
      return ['Beginner'];
    }

    // Lightly active users can receive beginner/intermediate.
    if (activity == 'lightly active') {
      return [
        'Beginner',
        'Intermediate',
      ];
    }

    // Moderately active users can receive beginner/intermediate.
    if (activity == 'moderately active') {
      return [
        'Beginner',
        'Intermediate',
      ];
    }

    // Very active users can receive all levels.
    if (activity == 'very active') {
      return [
        'Beginner',
        'Intermediate',
        'Advanced',
      ];
    }

    return ['Beginner'];
  }

  // ============================================================
  // GET EXERCISES FOR BODY PART
  // ============================================================

  List<Exercise> _getAvailableExercises(String bodyPart) {
  final allowedDifficulties = _allowedDifficulties();

  return exercises.where((exercise) {
    // ---------------------------------------------
    // BODY PART
    // ---------------------------------------------
    final matchesBodyPart =
        exercise.bodyPart.toLowerCase() ==
        bodyPart.toLowerCase();

    // ---------------------------------------------
    // FITNESS FOCUS
    // ---------------------------------------------
    final matchesFocus = exercise.trainingFocuses.any(
      (focus) =>
          focus.toLowerCase() ==
          userFocus.toLowerCase(),
    );

    // ---------------------------------------------
    // MAIN FITNESS GOAL
    // ---------------------------------------------
    final matchesGoal = exercise.goals.any(
      (goal) =>
          goal.toLowerCase() ==
          userGoal.toLowerCase(),
    );

    // ---------------------------------------------
    // ACTIVITY LEVEL / DIFFICULTY
    // ---------------------------------------------
    final matchesDifficulty =
        allowedDifficulties.contains(
      exercise.difficulty,
    );

    return matchesBodyPart &&
        matchesFocus &&
        matchesGoal &&
        matchesDifficulty;
  }).toList();
}

Map<String, List<Exercise>> _groupExercisesByDifficulty(
  List<Exercise> availableExercises,
) {
  return {
    'Beginner': availableExercises
        .where((exercise) => exercise.difficulty == 'Beginner')
        .toList(),

    'Intermediate': availableExercises
        .where((exercise) => exercise.difficulty == 'Intermediate')
        .toList(),

    'Advanced': availableExercises
        .where((exercise) => exercise.difficulty == 'Advanced')
        .toList(),
  };
}

  // ============================================================
  // BUILD UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (!profileLoaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Weekly Plan'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ==================================================
            // PROFILE INFORMATION
            // ==================================================

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Exercise Recommendations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Goal: $userGoal',
                    ),

                    Text(
                      'Focus: $userFocus',
                    ),

                    Text(
                      'Activity Level: $userActivityLevel',
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Exercises shown below are filtered according to your profile.',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ==================================================
            // DAYS
            // ==================================================

            ...selectedExercises.keys.map(
              (day) => _buildDaySelector(day),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveWeeklyPlan,
                icon: const Icon(Icons.save),
                label: const Text('Save Weekly Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DAY CARD
  // ============================================================

  Widget _buildDaySelector(String day) {
    final selected = selectedExercises[day] ?? [];

    final bodyPart = selectedBodyParts[day];

    final availableExercises =
        bodyPart == null
            ? <Exercise>[]
            : _getAvailableExercises(bodyPart);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // ==================================================
            // DAY NAME
            // ==================================================

            Text(
              day,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // ==================================================
            // REST DAY
            // ==================================================

            SwitchListTile(
              contentPadding: EdgeInsets.zero,

              title: const Text(
                'Rest Day',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: const Text(
                'No workout or notification for this day',
              ),

              value:
                  selectedRestDays[day] ?? false,

              onChanged: (value) {
                setState(() {
                  selectedRestDays[day] = value;

                  if (value) {
                    selectedExercises[day]!.clear();
                    selectedBodyParts[day] = null;
                    selectedTimes[day] = null;
                  }
                });
              },
            ),

            if (!(selectedRestDays[day] ?? false)) ...[
              const SizedBox(height: 10),

              // ==================================================
              // BODY PART
              // ==================================================

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Choose Body Part',
                  border: OutlineInputBorder(),
                ),

                initialValue: selectedBodyParts[day],

                items: bodyParts.map(
                  (bodyPart) {
                    return DropdownMenuItem<String>(
                      value: bodyPart,
                      child: Text(bodyPart),
                    );
                  },
                ).toList(),

                onChanged: (value) {
                  setState(() {
                    selectedBodyParts[day] = value;

                    // Clear previous exercises when body
                    // part changes.
                    selectedExercises[day]!.clear();
                  });
                },
              ),

              const SizedBox(height: 12),

              // ==================================================
              // EXERCISES
              // ==================================================

              if (bodyPart == null)
                const Text(
                  'Choose a body part to see available exercises.',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )
              else if (availableExercises.isEmpty)
                const Text(
                  'No exercises currently match your profile for this body part.',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )
              else
                _buildExerciseList(
                  day,
                  availableExercises,
                ),

              const SizedBox(height: 10),

              // ==================================================
              // SELECTED EXERCISES
              // ==================================================

              if (selected.isNotEmpty) ...[
                const Divider(),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Selected Exercises',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                ...selected.map(
                  (exercise) => ListTile(
                    contentPadding:
                        EdgeInsets.zero,

                    leading: const Icon(
                      Icons.check_circle,
                    ),

                    title: Text(exercise),

                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                      ),

                      onPressed: () {
                        setState(() {
                          selectedExercises[day]!
                              .remove(exercise);
                        });
                      },
                    ),
                  ),
                ),
              ],

              // ==================================================
              // WORKOUT TIME
              // ==================================================

              if (selected.isNotEmpty) ...[
                const SizedBox(height: 8),

                ListTile(
                  contentPadding:
                      EdgeInsets.zero,

                  leading: const Icon(
                    Icons.access_time,
                  ),

                  title: const Text(
                    'Workout Time',
                  ),

                  subtitle: Text(
                    selectedTimes[day] == null
                        ? 'Choose when you want to exercise'
                        : selectedTimes[day]!
                            .format(context),
                  ),

                  trailing: const Icon(
                    Icons.chevron_right,
                  ),

                  onTap: () async {
                    final selectedTime =
                        await showTimePicker(
                      context: context,
                      initialTime:
                          selectedTimes[day] ??
                              TimeOfDay.now(),
                    );

                    if (selectedTime != null) {
                      setState(() {
                        selectedTimes[day] =
                            selectedTime;
                      });
                    }
                  },
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseList(
  String day,
  List<Exercise> availableExercises,
) {
  final groupedExercises =
      _groupExercisesByDifficulty(
    availableExercises,
  );

  final selected =
      selectedExercises[day] ?? [];

  return Column(
    crossAxisAlignment:
        CrossAxisAlignment.start,
    children: [
      const Text(
        'Available Exercises',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),

      const SizedBox(height: 8),

      // ========================================================
      // BEGINNER
      // ========================================================

      if (groupedExercises['Beginner']!.isNotEmpty)
        _buildDifficultySection(
          day: day,
          difficulty: 'Beginner',
          exercises:
              groupedExercises['Beginner']!,
          selected: selected,
        ),

      // ========================================================
      // INTERMEDIATE
      // ========================================================

      if (groupedExercises['Intermediate']!.isNotEmpty)
        _buildDifficultySection(
          day: day,
          difficulty: 'Intermediate',
          exercises:
              groupedExercises['Intermediate']!,
          selected: selected,
        ),

      // ========================================================
      // ADVANCED
      // ========================================================

      if (groupedExercises['Advanced']!.isNotEmpty)
        _buildDifficultySection(
          day: day,
          difficulty: 'Advanced',
          exercises:
              groupedExercises['Advanced']!,
          selected: selected,
        ),
    ],
  );
}

Widget _buildDifficultySection({
  required String day,
  required String difficulty,
  required List<Exercise> exercises,
  required List<String> selected,
}) {
  return Column(
    crossAxisAlignment:
        CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 12),

      Text(
        difficulty,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 4),

      ...exercises.map(
        (exercise) {
          final isSelected =
              selected.contains(
            exercise.name,
          );

          return CheckboxListTile(
            contentPadding:
                EdgeInsets.zero,

            value: isSelected,

            title: Text(
              exercise.name,
            ),

            subtitle: Text(
              exercise.equipment,
            ),

            secondary: const Icon(
              Icons.fitness_center,
            ),

            onChanged: (value) {
              setState(() {
                if (value == true) {
                  if (!selected.contains(
                    exercise.name,
                  )) {
                    selectedExercises[day]!
                        .add(exercise.name);
                  }
                } else {
                  selectedExercises[day]!
                      .remove(exercise.name);
                }
              });
            },
          );
        },
      ),
    ],
  );
}

  // ============================================================
  // SAVE WEEKLY PLAN
  // ============================================================

    Future<void> _saveWeeklyPlan() async {
    print('SAVE PLAN: Button pressed');

    try {
      // ----------------------------------------------------------
      // INITIALIZE NOTIFICATIONS
      // ----------------------------------------------------------

      await NotificationService.initialize();

      print('SAVE PLAN: Notification initialized');

      await NotificationService.requestPermission();

      print('SAVE PLAN: Notification permission completed');

      // ----------------------------------------------------------
      // CLEAR OLD PLAN
      // ----------------------------------------------------------

      await DatabaseService.clearWeeklyPlan();

      print('SAVE PLAN: Existing weekly plan cleared');

      // ----------------------------------------------------------
      // SAVE NEW WEEKLY PLAN
      // ----------------------------------------------------------

      for (final day in selectedExercises.keys) {
        final isRestDay =
            selectedRestDays[day] ?? false;

        // --------------------------------------------------------
        // REST DAY
        // --------------------------------------------------------

        if (isRestDay) {
          await DatabaseService.saveWeeklyPlan(
            day: day,
            workout: 'Rest Day',
            isRest: true,
            hour: 0,
            minute: 0,
          );

          continue;
        }

        // --------------------------------------------------------
        // EXERCISES
        // --------------------------------------------------------

        final exercisesForDay =
            selectedExercises[day] ?? [];

        if (exercisesForDay.isEmpty) {
          continue;
        }

        // --------------------------------------------------------
        // WORKOUT TIME
        // --------------------------------------------------------

        final selectedTime =
            selectedTimes[day];

        if (selectedTime == null) {
          continue;
        }

        // --------------------------------------------------------
        // SAVE EACH EXERCISE
        // --------------------------------------------------------

        for (final exercise in exercisesForDay) {
          await DatabaseService.saveWeeklyPlan(
            day: day,
            workout: exercise,
            isRest: false,
            hour: selectedTime.hour,
            minute: selectedTime.minute,
          );
        }
      }

      print('SAVE PLAN: Weekly plan saved to database');

      // ----------------------------------------------------------
      // GET SAVED PLAN
      // ----------------------------------------------------------

      final weeklyPlan =
          await DatabaseService.getWeeklyPlan();

      print(
        'SAVE PLAN: Retrieved ${weeklyPlan.length} saved entries',
      );

      // ----------------------------------------------------------
      // SCHEDULE NOTIFICATIONS
      // ----------------------------------------------------------

      await NotificationService
          .scheduleWeeklyPlanNotifications(
        weeklyPlan,
      );

      print(
        'SAVE PLAN: Notification scheduling completed',
      );

      // ----------------------------------------------------------
      // MARK SCHEDULE AS COMPLETED
      // ----------------------------------------------------------

      if (weeklyPlan.isNotEmpty) {
        await DatabaseService.setScheduleCompleted(true);

        print(
          'SAVE PLAN: Schedule marked as completed',
        );
      }

      // ----------------------------------------------------------
      // SHOW SUCCESS
      // ----------------------------------------------------------

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Weekly plan saved!',
          ),
        ),
      );

      print('SAVE PLAN: Success message shown');

      // ----------------------------------------------------------
      // RETURN TO PREVIOUS SCREEN
      // ----------------------------------------------------------

      Navigator.pop(context);

      print('SAVE PLAN: Completed successfully');

    } catch (e, stackTrace) {
      print('SAVE PLAN: ERROR');
      print(e);
      print(stackTrace);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to save weekly plan: $e',
          ),
        ),
      );
    }
  }
}