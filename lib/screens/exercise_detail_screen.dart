import 'package:flutter/material.dart';
import '../exercise_data.dart';
import 'workout_setup_screen.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ==================================================
            // EXERCISE ICON
            // ==================================================

            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.fitness_center,
                  size: 60,
                  color: colors.primary,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // EXERCISE NAME
            // ==================================================

            Text(
              exercise.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // INFORMATION
            // ==================================================

            _infoCard(
              context,
              Icons.accessibility_new,
              'Target Body Part',
              exercise.bodyPart,
            ),

            _infoCard(
              context,
              Icons.speed,
              'Difficulty',
              exercise.difficulty,
            ),

            _infoCard(
              context,
              Icons.fitness_center,
              'Equipment',
              exercise.equipment,
            ),

            const SizedBox(height: 20),

            // ==================================================
            // WORKOUT RECOMMENDATION
            // ==================================================

            Text(
              'Recommended Workout',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: colors.outlineVariant,
                ),
              ),
              child: Column(
                children: [

                  Text(
                    '3 Sets',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '10 - 12 Repetitions',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colors.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Rest 60 - 90 seconds between sets',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // START WORKOUT
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutSetupScreen(
                        exercise: exercise,
                      ),
                    ),
                  );
                },
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
  // INFORMATION CARD
  // ============================================================

  Widget _infoCard(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          icon,
          color: colors.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            color: colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}