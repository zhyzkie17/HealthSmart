import 'package:flutter/material.dart';
import '../services/database_service.dart';
import 'weekly_plan_editor.dart';
import '../exercise_data.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int selectedView = 0;

  DateTime selectedMonth = DateTime.now();
  int selectedYear = DateTime.now().year;

  List<Map<String, dynamic>> workoutHistory = [];
  bool isLoadingHistory = true;

  List<Map<String, dynamic>> weeklySchedule = [];
  bool isLoadingWeeklyPlan = true;

  final List<String> views = [
    'Weekly',
    'Monthly',
    'Yearly',
  ];

  @override
  void initState() {
    super.initState();

    loadWeeklyPlan();
    loadWorkoutHistory();
  }

  // ============================================================
  // LOAD WEEKLY PLAN
  // ============================================================

  Future<void> loadWeeklyPlan() async {
    final result = await DatabaseService.getWeeklyPlan();

    if (!mounted) return;

    setState(() {
      weeklySchedule = result;
      isLoadingWeeklyPlan = false;
    });
  }

  // ============================================================
  // GROUP WEEKLY SCHEDULE
  // ============================================================

  Map<String, List<Map<String, dynamic>>> get groupedWeeklySchedule {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final workout in weeklySchedule) {
      final day = workout['day'].toString();

      grouped.putIfAbsent(day, () => []);
      grouped[day]!.add(workout);
    }

    return grouped;
  }

  // ============================================================
  // LOAD WORKOUT HISTORY
  // ============================================================

  Future<void> loadWorkoutHistory() async {
    final result = await DatabaseService.getWorkoutHistory();

    if (!mounted) return;

    setState(() {
      workoutHistory = result;
      isLoadingHistory = false;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workout Schedule',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================================================
            // TITLE
            // ======================================================

            Text(
              'Your Fitness Plan',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Choose a timeframe to view your plan.',
              style: TextStyle(
                fontSize: 16,
                color: colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 20),

            // ======================================================
            // VIEW SELECTOR
            // ======================================================

            SizedBox(
              width: double.infinity,

              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment<int>(
                    value: 0,
                    label: Text('Weekly'),
                    icon: Icon(Icons.view_week),
                  ),
                  ButtonSegment<int>(
                    value: 1,
                    label: Text('Monthly'),
                    icon: Icon(Icons.calendar_month),
                  ),
                  ButtonSegment<int>(
                    value: 2,
                    label: Text('Yearly'),
                    icon: Icon(Icons.date_range),
                  ),
                ],

                selected: {selectedView},

                onSelectionChanged: (Set<int> selection) {
                  setState(() {
                    selectedView = selection.first;
                  });
                },
              ),
            ),

            const SizedBox(height: 25),

            // ======================================================
            // SELECTED VIEW
            // ======================================================

            if (selectedView == 0)
              _buildWeeklyView(),

            if (selectedView == 1)
              _buildMonthlyView(),

            if (selectedView == 2)
              _buildYearlyView(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // GET BODY PART
  // ============================================================

  String _getBodyPart(String exerciseName) {
    final exercise = exercises.firstWhere(
      (exercise) => exercise.name == exerciseName,
      orElse: () => Exercise(
        name: exerciseName,
        bodyPart: 'Unknown',
        trainingFocuses: [],
        goals: [],
        suitableActivityLevels: [],
        difficulty: 'Unknown',
        equipment: 'Unknown',
      ),
    );

    return exercise.bodyPart;
  }

  // ============================================================
  // WEEKLY VIEW
  // ============================================================

  Widget _buildWeeklyView() {
    final colors = Theme.of(context).colorScheme;

    if (isLoadingWeeklyPlan) {
      return Center(
        child: CircularProgressIndicator(
          color: colors.primary,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Plan',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),

        const SizedBox(height: 10),

        // ========================================================
        // EDIT BUTTON
        // ========================================================

        SizedBox(
          width: double.infinity,

          child: ElevatedButton.icon(
            onPressed: () async {
              final workoutUpdated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const WeeklyPlanEditor(),
                ),
              );

              if (!mounted) return;

              if (workoutUpdated == true) {
                final result =
                    await DatabaseService.getWorkoutHistory();

                if (!mounted) return;

                setState(() {
                  workoutHistory = result;
                });
              }

              await loadWeeklyPlan();
            },

            icon: const Icon(Icons.edit),

            label: const Text(
              'Edit Weekly Plan',
            ),
          ),
        ),

        const SizedBox(height: 15),

        // ========================================================
        // EMPTY PLAN
        // ========================================================

        if (weeklySchedule.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Center(
                child: Text(
                  'No weekly workout plan has been created yet.',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 17,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          )

        // ========================================================
        // WEEKLY CARDS
        // ========================================================

        else
          ...groupedWeeklySchedule.entries.map(
            (entry) {
              final dayName = entry.key;
              final workouts = entry.value;
              final firstWorkout = workouts.first;

              final combinedDay = {
                ...firstWorkout,
                'day': dayName,
              };

              return _buildScheduleCard(
                day: combinedDay,
                workouts: workouts,
                title: dayName,
                icon: _getWorkoutIcon(
                  firstWorkout['workout'],
                ),
                isRest: workouts.every(
                  (workout) => workout['isRest'] == 1,
                ),
              );
            },
          ),

        const SizedBox(height: 20),
      ],
    );
  }

  // ============================================================
  // MONTHLY VIEW
  // ============================================================

  Widget _buildMonthlyView() {
    final colors = Theme.of(context).colorScheme;

    if (isLoadingHistory) {
      return Center(
        child: CircularProgressIndicator(
          color: colors.primary,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Progress',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),

        const SizedBox(height: 15),

        _buildCalendar(),

        const SizedBox(height: 20),

        Text(
          'Workout History',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),

        const SizedBox(height: 10),

        _buildMonthlyHistory(),

        const SizedBox(height: 20),
      ],
    );
  }

  // ============================================================
  // MONTHLY HISTORY
  // ============================================================

  Widget _buildMonthlyHistory() {
    final colors = Theme.of(context).colorScheme;

    final monthlyWorkouts = workoutHistory.where((workout) {
      final dateString = workout['date'];

      if (dateString == null) {
        return false;
      }

      final date =
          DateTime.tryParse(dateString.toString());

      if (date == null) {
        return false;
      }

      return date.year == selectedMonth.year &&
          date.month == selectedMonth.month &&
          workout['completed'] == 1;
    }).toList();

    if (monthlyWorkouts.isEmpty) {
      return Text(
        'No workouts completed this month yet.',
        style: TextStyle(
          color: colors.onSurfaceVariant,
        ),
      );
    }

    return Column(
      children: monthlyWorkouts.map(
        (workout) {
          final date = DateTime.tryParse(
            workout['date'].toString(),
          );

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    colors.primary.withValues(alpha: 0.12),

                child: Icon(
                  Icons.check_circle,
                  color: colors.primary,
                ),
              ),

              title: Text(
                workout['workout']?.toString() ??
                    'Workout',

                style: TextStyle(
                  color: colors.onSurface,
                ),
              ),

              subtitle: Text(
                date == null
                    ? ''
                    : '${_monthName(date.month)} ${date.day}',

                style: TextStyle(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  // ============================================================
  // CALENDAR
  // ============================================================

  Widget _buildCalendar() {
    final colors = Theme.of(context).colorScheme;

    final firstDay = DateTime(
      selectedMonth.year,
      selectedMonth.month,
      1,
    );

    final daysInMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month + 1,
      0,
    ).day;

    final startingWeekday = firstDay.weekday;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          children: [
            // ======================================================
            // MONTH HEADER
            // ======================================================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedMonth = DateTime(
                        selectedMonth.year,
                        selectedMonth.month - 1,
                      );
                    });
                  },

                  icon: Icon(
                    Icons.chevron_left,
                    color: colors.primary,
                  ),
                ),

                Text(
                  '${_monthName(selectedMonth.month)} '
                  '${selectedMonth.year}',

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),

                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedMonth = DateTime(
                        selectedMonth.year,
                        selectedMonth.month + 1,
                      );
                    });
                  },

                  icon: Icon(
                    Icons.chevron_right,
                    color: colors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ======================================================
            // DAY HEADERS
            // ======================================================

            Row(
              children: const [
                _DayHeader('Mon'),
                _DayHeader('Tue'),
                _DayHeader('Wed'),
                _DayHeader('Thu'),
                _DayHeader('Fri'),
                _DayHeader('Sat'),
                _DayHeader('Sun'),
              ],
            ),

            const SizedBox(height: 5),

            // ======================================================
            // CALENDAR DAYS
            // ======================================================

            GridView.builder(
              shrinkWrap: true,

              physics:
                  const NeverScrollableScrollPhysics(),

              itemCount:
                  startingWeekday - 1 +
                      daysInMonth,

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),

              itemBuilder: (context, index) {
                if (index < startingWeekday - 1) {
                  return const SizedBox();
                }

                final day =
                    index - startingWeekday + 2;

                final completed =
                    _isWorkoutCompleted(day);

                return GestureDetector(
                  onTap: completed
                      ? () => _showDayWorkouts(day)
                      : null,

                  child: Container(
                    margin: const EdgeInsets.all(3),

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: completed
                          ? colors.primary.withValues(alpha: 0.12)
                          : null,
                    ),

                    child: Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [
                          Text(
                            '$day',

                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  colors.onSurface,
                            ),
                          ),

                          if (completed)
                            Icon(
                              Icons.check,
                              size: 16,
                              color: colors.primary,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // YEARLY VIEW
  // ============================================================

  Widget _buildYearlyView() {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        // ========================================================
        // YEAR SELECTOR
        // ========================================================

        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  selectedYear--;
                });
              },

              icon: Icon(
                Icons.chevron_left,
                color: colors.primary,
              ),
            ),

            Text(
              '$selectedYear',

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),

            IconButton(
              onPressed: () {
                setState(() {
                  selectedYear++;
                });
              },

              icon: Icon(
                Icons.chevron_right,
                color: colors.primary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        Text(
          'Yearly Progress',

          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Your workout activity by body part.',

          style: TextStyle(
            fontSize: 15,
            color: colors.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 20),

        _buildBodyPartProgress(
          'Chest',
          Icons.fitness_center,
        ),

        _buildBodyPartProgress(
          'Back',
          Icons.fitness_center,
        ),

        _buildBodyPartProgress(
          'Shoulders',
          Icons.fitness_center,
        ),

        _buildBodyPartProgress(
          'Arms',
          Icons.fitness_center,
        ),

        _buildBodyPartProgress(
          'Legs',
          Icons.directions_run,
        ),

        _buildBodyPartProgress(
          'Core',
          Icons.accessibility_new,
        ),

        _buildBodyPartProgress(
          'Full Body',
          Icons.directions_run,
        ),

        _buildBodyPartProgress(
          'Cardio',
          Icons.directions_run,
        ),

        _buildBodyPartProgress(
          'Flexibility',
          Icons.self_improvement,
        ),
      ],
    );
  }

  // ============================================================
  // BODY PART PROGRESS
  // ============================================================

  Widget _buildBodyPartProgress(
    String bodyPart,
    IconData icon,
  ) {
    final colors = Theme.of(context).colorScheme;

    final count = workoutHistory.where((workout) {
      final dateString = workout['date'];

      if (dateString == null) {
        return false;
      }

      final date =
          DateTime.tryParse(dateString.toString());

      if (date == null) {
        return false;
      }

      return workout['bodyPart'] == bodyPart &&
          workout['completed'] == 1 &&
          date.year == selectedYear;
    }).length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  colors.primary.withValues(alpha: 0.12),

              child: Icon(
                icon,
                color: colors.primary,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    bodyPart,

                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '$count completed workout'
                    '${count == 1 ? '' : 's'}',

                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SCHEDULE CARD
  // ============================================================

  Widget _buildScheduleCard({
    required Map<String, dynamic> day,
    required List<Map<String, dynamic>> workouts,
    required String title,
    required IconData icon,
    required bool isRest,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            CircleAvatar(
              backgroundColor:
                  colors.primary.withValues(alpha: 0.12),

              child: Icon(
                icon,
                color: colors.primary,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),

                  if (isRest)
                    Text(
                      'Rest Day',

                      style: TextStyle(
                        fontSize: 15,
                        color:
                            colors.onSurfaceVariant,
                      ),
                    )

                  else ...[
                    Text(
                      _getWorkoutSubtitle(
                        day,
                        workouts,
                      ),

                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: colors.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...workouts.map(
                      (workout) {
                        final workoutName =
                            workout['workout']
                                .toString();

                        final completed =
                            _alreadyCompletedToday(
                          workoutName,
                        );

                        return Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 8,
                          ),

                          child: Row(
                            children: [
                              Icon(
                                Icons.fitness_center,
                                size: 18,
                                color: colors.primary,
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: Text(
                                  workoutName,

                                  style: TextStyle(
                                    fontSize: 15,
                                    color:
                                        colors.onSurface,
                                  ),
                                ),
                              ),

                              if (completed)
                                Icon(
                                  Icons.check_circle,
                                  color:
                                      colors.primary,
                                )

                              else
                                IconButton(
                                  icon: Icon(
                                    Icons
                                        .check_circle_outline,
                                    color:
                                        colors.primary,
                                  ),

                                  onPressed: () async {
                                    await DatabaseService
                                        .saveWorkoutHistory(
                                      date: DateTime.now()
                                          .toIso8601String(),

                                      workout:
                                          workoutName,

                                      bodyPart:
                                          _getBodyPart(
                                        workoutName,
                                      ),

                                      completed: true,
                                    );

                                    final result =
                                        await DatabaseService
                                            .getWorkoutHistory();

                                    if (!mounted) return;

                                    setState(() {
                                      workoutHistory =
                                          result;
                                    });

                                    ScaffoldMessenger
                                        .of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '$workoutName completed!',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // WORKOUT ICON
  // ============================================================

  IconData _getWorkoutIcon(String workout) {
    switch (workout) {
      case 'Chest':
        return Icons.fitness_center;

      case 'Arms':
        return Icons.accessibility_new;

      case 'Legs':
        return Icons.directions_run;

      case 'Back':
        return Icons.back_hand;

      case 'Shoulders':
        return Icons.accessibility;

      default:
        return Icons.help_outline;
    }
  }

  // ============================================================
  // WORKOUT SUBTITLE
  // ============================================================

  String _getWorkoutSubtitle(
    Map<String, dynamic> day,
    List<Map<String, dynamic>> workouts,
  ) {
    if (day['isRest'] == 1) {
      return 'Rest Day';
    }

    if (workouts.isEmpty) {
      return '';
    }

    final int hour =
        (workouts.first['hour'] as num?)?.toInt() ?? 0;

    final int minute =
        (workouts.first['minute'] as num?)?.toInt() ?? 0;

    final time = TimeOfDay(
      hour: hour,
      minute: minute,
    );

    return 'Workout Time • ${time.format(context)}';
  }

  // ============================================================
  // MONTH NAME
  // ============================================================

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  // ============================================================
  // CHECK WORKOUT COMPLETION
  // ============================================================

  bool _isWorkoutCompleted(int day) {
    return workoutHistory.any((workout) {
      final dateString = workout['date'];

      if (dateString == null) {
        return false;
      }

      final date =
          DateTime.tryParse(dateString.toString());

      if (date == null) {
        return false;
      }

      return date.year == selectedMonth.year &&
          date.month == selectedMonth.month &&
          date.day == day &&
          workout['completed'] == 1;
    });
  }

  // ============================================================
  // SHOW DAY WORKOUTS
  // ============================================================

  void _showDayWorkouts(int day) {
    final colors = Theme.of(context).colorScheme;

    final workouts = workoutHistory.where((workout) {
      final dateString = workout['date'];

      if (dateString == null) {
        return false;
      }

      final date =
          DateTime.tryParse(dateString.toString());

      if (date == null) {
        return false;
      }

      return date.year == selectedMonth.year &&
          date.month == selectedMonth.month &&
          date.day == day &&
          workout['completed'] == 1;
    }).toList();

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: Text(
            '${_monthName(selectedMonth.month)} $day',
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: workouts.map(
              (workout) {
                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8),

                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Icon(
                        Icons.check,
                        size: 20,
                        color: colors.primary,
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          workout['workout']
                              .toString(),

                          style: TextStyle(
                            fontSize: 16,
                            color:
                                colors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // CHECK IF COMPLETED TODAY
  // ============================================================

  bool _alreadyCompletedToday(String workout) {
    final now = DateTime.now();

    return workoutHistory.any((history) {
      final dateString = history['date'];

      if (dateString == null) {
        return false;
      }

      final date =
          DateTime.tryParse(dateString.toString());

      if (date == null) {
        return false;
      }

      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day &&
          history['workout'] == workout &&
          history['completed'] == 1;
    });
  }
}

// ================================================================
// DAY HEADER
// ================================================================

class _DayHeader extends StatelessWidget {
  final String text;

  const _DayHeader(this.text);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: Center(
        child: Text(
          text,

          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}