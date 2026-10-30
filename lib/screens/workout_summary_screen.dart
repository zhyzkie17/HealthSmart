import 'package:flutter/material.dart';
import '../exercise_data.dart';

class WorkoutSummaryScreen extends StatelessWidget {
  final Exercise exercise;
  final int completedSets;
  final int totalSets;

  const WorkoutSummaryScreen({
    super.key,
    required this.exercise,
    required this.completedSets,
    required this.totalSets,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Summary'),
        automaticallyImplyLeading: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            const SizedBox(height: 25),

            // Success Icon
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFE8F5E9),
                child: Icon(
                  Icons.check,
                  size: 60,
                  color: Color(0xFF43A047),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Workout Complete!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF173B32),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Great job! You finished your workout.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 35),

            // Exercise
            _summaryCard(
              icon: Icons.fitness_center,
              title: 'Exercise',
              value: exercise.name,
            ),

            // Body Part
            _summaryCard(
              icon: Icons.accessibility_new,
              title: 'Body Part',
              value: exercise.bodyPart,
            ),

            // Sets
            _summaryCard(
              icon: Icons.repeat,
              title: 'Sets Completed',
              value: '$completedSets / $totalSets',
            ),

            // Repetitions
            _summaryCard(
              icon: Icons.numbers,
              title: 'Target Repetitions',
              value: '10 - 12',
            ),

            const SizedBox(height: 25),

            // Done Button
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
                child: const Text(
                  'Done',
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

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
