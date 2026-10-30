import 'package:flutter/material.dart';
import '../services/ai/ai_services.dart';

class AITestScreen extends StatefulWidget {
  const AITestScreen({super.key});

  @override
  State<AITestScreen> createState() => _AITestScreenState();
}

class _AITestScreenState extends State<AITestScreen> {
  final AIService aiService = AIService();

  String result = 'Press the button to test the AI prompt.';

  Future<void> testExerciseRecommendation() async {
    final response = await aiService.getExerciseRecommendation(
      goal: 'Maintain',
      focus: 'Strength',
      activityLevel: 'Moderately Active',
    );

    setState(() {
      result = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: testExerciseRecommendation,
              child: const Text('Test Exercise Recommendation'),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Text(result),
              ),
            ),
          ],
        ),
      ),
    );
  }
}