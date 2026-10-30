import 'package:flutter/material.dart';

class WorkoutSettingsScreen extends StatefulWidget {
  const WorkoutSettingsScreen({super.key});

  @override
  State<WorkoutSettingsScreen> createState() =>
      _WorkoutSettingsScreenState();
}

class _WorkoutSettingsScreenState
    extends State<WorkoutSettingsScreen> {
  // ============================================================
  // GENERAL WORKOUT DEFAULTS
  // ============================================================

  int defaultSets = 3;
  int defaultRepetitions = 12;
  int defaultRestTime = 60;

  // ============================================================
  // WORKOUT BEHAVIOR
  // ============================================================

  int countdownSeconds = 3;

  bool keepScreenAwake = true;
  bool autoAdvance = true;
  bool autoStartNextExercise = true;
  bool autoStartRestTimer = true;
  bool showCompletionConfirmation = false;
  bool allowExerciseSkip = true;
  bool showExerciseInstructions = true;
  bool showExerciseProgress = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workout Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          // ======================================================
          // GENERAL WORKOUT
          // ======================================================

          Text(
            'General Workout',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Set your preferred defaults for new workouts. '
            'You can still change sets, repetitions, and rest time '
            'in Workout Setup before starting an exercise.',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 15,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 15),

          Card(
            child: Column(
              children: [

                // DEFAULT SETS
                _buildNumberSetting(
                  icon: Icons.repeat,
                  title: 'Default Sets',
                  description:
                      'Starting number of sets for exercises.',
                  value: defaultSets,
                  min: 1,
                  max: 20,
                  onChanged: (value) {
                    setState(() {
                      defaultSets = value;
                    });
                  },
                ),

                Divider(
                  height: 1,
                  color: colors.outlineVariant,
                ),

                // DEFAULT REPETITIONS
                _buildNumberSetting(
                  icon: Icons.format_list_numbered,
                  title: 'Default Repetitions',
                  description:
                      'Starting number of repetitions per set.',
                  value: defaultRepetitions,
                  min: 1,
                  max: 100,
                  onChanged: (value) {
                    setState(() {
                      defaultRepetitions = value;
                    });
                  },
                ),

                Divider(
                  height: 1,
                  color: colors.outlineVariant,
                ),

                // DEFAULT REST
                _buildNumberSetting(
                  icon: Icons.timer_outlined,
                  title: 'Default Rest Time',
                  description:
                      'Starting rest time between sets.',
                  value: defaultRestTime,
                  min: 0,
                  max: 600,
                  step: 5,
                  suffix: ' sec',
                  onChanged: (value) {
                    setState(() {
                      defaultRestTime = value;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // ======================================================
          // WORKOUT BEHAVIOR
          // ======================================================

          Text(
            'Workout Behavior',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Control how Stryve behaves while you are performing '
            'a workout.',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 15,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 15),

          Card(
            child: Column(
              children: [

                // ==================================================
                // COUNTDOWN
                // ==================================================

                _buildNumberSetting(
                  icon: Icons.timer_3_outlined,
                  title: 'Workout Countdown',
                  description:
                      'Countdown before the workout begins.',
                  value: countdownSeconds,
                  min: 0,
                  max: 10,
                  suffix: ' sec',
                  onChanged: (value) {
                    setState(() {
                      countdownSeconds = value;
                    });
                  },
                ),

                Divider(
                  height: 1,
                  color: colors.outlineVariant,
                ),

                // ==================================================
                // KEEP SCREEN AWAKE
                // ==================================================

                SwitchListTile(
                  value: keepScreenAwake,
                  onChanged: (value) {
                    setState(() {
                      keepScreenAwake = value;
                    });
                  },
                  secondary: Icon(
                    Icons.screen_lock_portrait_outlined,
                    color: colors.primary,
                  ),
                  title: Text(
                    'Keep Screen Awake',
                    style: TextStyle(
                      color: colors.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    'Keep the screen on while performing a workout.',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),

                Divider(
                  height: 1,
                  color: colors.outlineVariant,
                ),

                // ==================================================
                // AUTO-ADVANCE
                // ==================================================

                SwitchListTile(
                  value: autoAdvance,
                  onChanged: (value) {
                    setState(() {
                      autoAdvance = value;
                    });
                  },
                  secondary: Icon(
                    Icons.skip_next,
                    color: colors.primary,
                  ),
                  title: Text(
                    'Auto-Advance',
                    style: TextStyle(
                      color: colors.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    'Automatically move to the next exercise '
                    'when the current exercise is completed.',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),

                Divider(
                  height: 1,
                  color: colors.outlineVariant,
                ),

                // ==================================================
                // AUTO-START NEXT EXERCISE
                // ==================================================

                SwitchListTile(
                  value: autoStartNextExercise,
                  onChanged: (value) {
                    setState(() {
                      autoStartNextExercise = value;
                    });
                  },
                  secondary: Icon(
                    Icons.play_arrow_outlined,
                    color: colors.primary,
                  ),
                  title: Text(
                    'Auto-Start Next Exercise',
                    style: TextStyle(
                      color: colors.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    'Automatically begin the next exercise '
                    'after moving forward.',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),

                Divider(
                  height: 1,
                  color: colors.outlineVariant,
                ),

                // ==================================================
                // AUTO-START REST TIMER
                // ==================================================

                SwitchListTile(
                  value: autoStartRestTimer,
                  onChanged: (value) {
                    setState(() {
                      autoStartRestTimer = value;
                    });
                  },
                  secondary: Icon(
                    Icons.timer,
                    color: colors.primary,
                  ),
                  title: Text(
                    'Auto-Start Rest Timer',
                    style: TextStyle(
                      color: colors.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    'Automatically begin the rest timer after '
                    'completing a set.',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),

                Divider(
                  height: 1,
                  color: colors.outlineVariant,
                ),

                // ==================================================
                // COMPLETION CONFIRMATION
                // ==================================================

                SwitchListTile(
                  value: showCompletionConfirmation,
                  onChanged: (value) {
                    setState(() {
                      showCompletionConfirmation = value;
                    });
                  },
                  secondary: Icon(
                    Icons.check_circle_outline,
                    color: colors.primary,
                  ),
                  title: Text(
                    'Completion Confirmation',
                    style: TextStyle(
                      color: colors.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    'Ask for confirmation before moving forward '
                    'after completing an exercise.',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),

                Divider(
                  height: 1,
                  color: colors.outlineVariant,
                ),

                // ==================================================
                // ALLOW EXERCISE SKIP
                // ==================================================

                SwitchListTile(
                  value: allowExerciseSkip,
                  onChanged: (value) {
                    setState(() {
                      allowExerciseSkip = value;
                    });
                  },
                  secondary: Icon(
                    Icons.skip_next_outlined,
                    color: colors.primary,
                  ),
                  title: Text(
                    'Allow Exercise Skip',
                    style: TextStyle(
                      color: colors.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    'Allow an exercise to be skipped during a workout.',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),

                Divider(
                  height: 1,
                  color: colors.outlineVariant,
                ),

                // ==================================================
                // SHOW EXERCISE INSTRUCTIONS
                // ==================================================

                SwitchListTile(
                  value: showExerciseInstructions,
                  onChanged: (value) {
                    setState(() {
                      showExerciseInstructions = value;
                    });
                  },
                  secondary: Icon(
                    Icons.menu_book_outlined,
                    color: colors.primary,
                  ),
                  title: Text(
                    'Show Exercise Instructions',
                    style: TextStyle(
                      color: colors.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    'Show exercise instructions during the workout.',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),

                Divider(
                  height: 1,
                  color: colors.outlineVariant,
                ),

                // ==================================================
                // SHOW EXERCISE PROGRESS
                // ==================================================

                SwitchListTile(
                  value: showExerciseProgress,
                  onChanged: (value) {
                    setState(() {
                      showExerciseProgress = value;
                    });
                  },
                  secondary: Icon(
                    Icons.bar_chart_outlined,
                    color: colors.primary,
                  ),
                  title: Text(
                    'Show Exercise Progress',
                    style: TextStyle(
                      color: colors.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    'Show your current exercise and workout progress.',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // ======================================================
          // IMPORTANT NOTE
          // ======================================================

          Card(
            color: colors.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: colors.primary,
                    size: 26,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      'These settings control your general workout '
                      'experience and provide default values. You can '
                      'still change sets, repetitions, and rest time '
                      'in Workout Setup before starting an exercise. '
                      'Sound and vibration settings are managed '
                      'separately in Notification Settings.',
                      style: TextStyle(
                        color: colors.onPrimaryContainer,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ============================================================
  // NUMBER SETTING
  // ============================================================

  Widget _buildNumberSetting({
    required IconData icon,
    required String title,
    required String description,
    required int value,
    required int min,
    required int max,
    int step = 1,
    String suffix = '',
    required ValueChanged<int> onChanged,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: colors.primary,
            size: 28,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  description,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              IconButton(
                onPressed: value > min
                    ? () => onChanged(
                          (value - step).clamp(min, max),
                        )
                    : null,
                icon: const Icon(Icons.remove),
              ),

              Text(
                '$value$suffix',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),

              IconButton(
                onPressed: value < max
                    ? () => onChanged(
                          (value + step).clamp(min, max),
                        )
                    : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}