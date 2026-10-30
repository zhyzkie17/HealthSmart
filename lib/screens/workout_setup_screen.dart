import 'package:flutter/material.dart';
import '../exercise_data.dart';
import 'work_out_screen.dart';

class WorkoutSetupScreen extends StatefulWidget {
  final Exercise exercise;

  const WorkoutSetupScreen({
    super.key,
    required this.exercise,
  });

  @override
  State<WorkoutSetupScreen> createState() => _WorkoutSetupScreenState();
}

class _WorkoutSetupScreenState extends State<WorkoutSetupScreen> {
  int totalSets = 3;
  int targetReps = 10;

  final TextEditingController restController =
      TextEditingController(text: '60');

  @override
  void dispose() {
    restController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Setup'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            const SizedBox(height: 20),

            // ==================================================
            // EXERCISE NAME
            // ==================================================

            Text(
              widget.exercise.name,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.exercise.bodyPart,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 35),

            // ==================================================
            // SETS
            // ==================================================

            _buildNumberSetting(
              context,
              title: 'Sets',
              value: totalSets,
              onDecrease: totalSets > 1
                  ? () {
                      setState(() {
                        totalSets--;
                      });
                    }
                  : null,
              onIncrease: () {
                setState(() {
                  totalSets++;
                });
              },
            ),

            const SizedBox(height: 20),

            // ==================================================
            // REPETITIONS
            // ==================================================

            _buildNumberSetting(
              context,
              title: 'Repetitions',
              value: targetReps,
              onDecrease: targetReps > 1
                  ? () {
                      setState(() {
                        targetReps--;
                      });
                    }
                  : null,
              onIncrease: () {
                setState(() {
                  targetReps++;
                });
              },
            ),

            const SizedBox(height: 25),

            // ==================================================
            // REST TIME
            // ==================================================

            Text(
              'Rest Time',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: restController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Rest time',
                hintText: 'Enter seconds',
                suffixText: 'seconds',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 35),

            // ==================================================
            // START WORKOUT
            // ==================================================

            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _startWorkout,
                icon: const Icon(Icons.play_arrow),
                label: const Text(
                  'Start Workout',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // NUMBER SETTING
  // ============================================================

    Widget _buildNumberSetting(
    BuildContext context, {
    required String title,
    required int value,
    required VoidCallback? onDecrease,
    required VoidCallback onIncrease,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),

          IconButton(
            onPressed: onDecrease,
            icon: Icon(
              Icons.remove_circle_outline,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          Text(
            '$value',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          IconButton(
            onPressed: onIncrease,
            icon: Icon(
              Icons.add_circle_outline,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // START WORKOUT
  // ============================================================

  void _startWorkout() {
    final restTime = int.tryParse(restController.text);

    if (restTime == null || restTime < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid rest time in seconds.',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutScreen(
          exercise: widget.exercise,
          totalSets: totalSets,
          targetReps: targetReps,
          restSeconds: restTime,
        ),
      ),
    );
  }
}