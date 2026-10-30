import 'dart:async';
import 'package:flutter/material.dart';
import '../exercise_data.dart';
import 'workout_summary_screen.dart';

class WorkoutScreen extends StatefulWidget {
  final Exercise exercise;

  final int totalSets;
  final int targetReps;
  final int restSeconds;

  const WorkoutScreen({
    super.key,
    required this.exercise,
    required this.totalSets,
    required this.targetReps,
    required this.restSeconds,
  });

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int currentSet = 1;

  late int totalSets;
  late int targetReps;
  late int selectedRestSeconds;

  int restSeconds = 0;

  bool setCompleted = false;
  bool isResting = false;

  Timer? restTimer;

  @override
  void initState() {
    super.initState();

    totalSets = widget.totalSets;
    targetReps = widget.targetReps;
    selectedRestSeconds = widget.restSeconds;
    restSeconds = widget.restSeconds;
  }

  @override
  void dispose() {
    restTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final exercise = widget.exercise;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            const SizedBox(height: 20),

            // ==================================================
            // EXERCISE NAME
            // ==================================================

            Text(
              exercise.name,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              exercise.bodyPart,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 35),

            // ==================================================
            // REST TIMER
            // ==================================================

            if (isResting) _buildRestTimer(context),

            const SizedBox(height: 20),

            // ==================================================
            // ACTIVE SET
            // ==================================================

            if (!isResting) ...[
              Text(
                'Set $currentSet of $totalSets',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // TARGET REPS
              // ==================================================

              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: colors.primaryContainer,
                ),
                child: Column(
                  children: [

                    Text(
                      'Target',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colors.onPrimaryContainer,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '$targetReps',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),

                    Text(
                      'Repetitions',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const Spacer(),

            // ==================================================
            // COMPLETE SET BUTTON
            // ==================================================

            if (!isResting)
              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: setCompleted
                      ? null
                      : _completeSet,
                  icon: const Icon(Icons.check),
                  label: Text(
                    setCompleted
                        ? 'Set Completed'
                        : 'Complete Set',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 15),

            // ==================================================
            // EXIT WORKOUT
            // ==================================================

            TextButton(
              onPressed: () {
                restTimer?.cancel();
                Navigator.pop(context);
              },
              child: const Text('Exit Workout'),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // REST TIMER
  // ============================================================

  Widget _buildRestTimer(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [

        Icon(
          Icons.timer,
          size: 70,
          color: colors.primary,
        ),

        const SizedBox(height: 20),

        Text(
          'Rest Time',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),

        const SizedBox(height: 15),

        Text(
          '$restSeconds',
          style: theme.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.primary,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'seconds remaining',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 25),

        OutlinedButton(
          onPressed: _skipRest,
          child: const Text('Skip Rest'),
        ),
      ],
    );
  }

  // ============================================================
  // COMPLETE SET
  // ============================================================

  void _completeSet() {
    setState(() {
      setCompleted = true;
    });

    if (currentSet < totalSets) {
      _startRest();
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;

        _finishWorkout();
      });
    }
  }

  // ============================================================
  // START REST
  // ============================================================

  void _startRest() {
    setState(() {
      isResting = true;
      restSeconds = selectedRestSeconds;
    });

    restTimer?.cancel();

    restTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (restSeconds > 0) {
          setState(() {
            restSeconds--;
          });
        } else {
          timer.cancel();
          _finishRest();
        }
      },
    );
  }

  // ============================================================
  // FINISH REST
  // ============================================================

  void _finishRest() {
    setState(() {
      currentSet++;
      setCompleted = false;
      isResting = false;
    });
  }

  // ============================================================
  // SKIP REST
  // ============================================================

  void _skipRest() {
    restTimer?.cancel();
    _finishRest();
  }

  // ============================================================
  // FINISH WORKOUT
  // ============================================================

  void _finishWorkout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutSummaryScreen(
          exercise: widget.exercise,
          completedSets: totalSets,
          totalSets: totalSets,
        ),
      ),
    );
  }
}