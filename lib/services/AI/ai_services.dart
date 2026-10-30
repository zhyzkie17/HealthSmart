import 'ai_prompts.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AIService {
  static const int dailyRequestLimit = 50;

  final model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3.6-flash',
    systemInstruction: Content.system(
      AIPrompt.buildSystemPrompt(),
    ),
  );

  // ============================================================
  // AI REQUEST LIMITER
  // ============================================================

  Future<String> _generateAIResponse({
    required String prompt,
    required String fallbackMessage,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final today = DateTime.now();
    final todayKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final savedDate = prefs.getString('ai_request_date');
    int requestCount = prefs.getInt('ai_request_count') ?? 0;

    // Reset the counter when a new day begins.
    if (savedDate != todayKey) {
      requestCount = 0;

      await prefs.setString('ai_request_date', todayKey);
      await prefs.setInt('ai_request_count', 0);
    }

    // Stop the request before contacting Gemini.
    if (requestCount >= dailyRequestLimit) {
      return 'You have reached today\'s AI request limit. '
          'Please try again tomorrow.';
    }

    // Count this request before sending it to Gemini.
    requestCount++;

    await prefs.setInt('ai_request_count', requestCount);

    try {
      final response = await model.generateContent([
        Content.text(prompt),
      ]);

      return response.text ?? fallbackMessage;
    } catch (e) {
      print('AI REQUEST ERROR: $e');

      return fallbackMessage;
    }
  }

  // ============================================================
  // APP INFORMATION
  // ============================================================

  Future<String> getHowStryveWorks() async {
    final prompt = AIPrompt.buildHowStryveWorksPrompt();

    return await _generateAIResponse(
      prompt: prompt,
      fallbackMessage: 'Unable to explain how Stryve works.',
    );
  }

  Future<String> getAboutStryve() async {
    final prompt = AIPrompt.buildAboutStryvePrompt();

    return await _generateAIResponse(
      prompt: prompt,
      fallbackMessage: 'Unable to provide information about Stryve.',
    );
  }

  Future<String> getWorkoutSettingsHelp() async {
    final prompt = AIPrompt.buildWorkoutSettingsHelpPrompt();

    return await _generateAIResponse(
      prompt: prompt,
      fallbackMessage: 'Unable to explain workout settings.',
    );
  }

  Future<String> getAIHelp() async {
    final prompt = AIPrompt.buildAIHelpPrompt();

    return await _generateAIResponse(
      prompt: prompt,
      fallbackMessage: 'Unable to explain the AI Assistant.',
    );
  }

  Future<String> getProfileHelp() async {
    final prompt = AIPrompt.buildProfileHelpPrompt();

    return await _generateAIResponse(
      prompt: prompt,
      fallbackMessage: 'Unable to explain profile personalization.',
    );
  }

  Future<String> getWorkoutSetupHelp() async {
    final prompt = AIPrompt.buildWorkoutSetupHelpPrompt();

    return await _generateAIResponse(
      prompt: prompt,
      fallbackMessage: 'Unable to explain Workout Setup.',
    );
  }

  // ============================================================
  // EXERCISE RECOMMENDATION
  // ============================================================

  Future<String> getExerciseRecommendation({
    required String goal,
    required String focus,
    required String activityLevel,
  }) async {
    final prompt = AIPrompt.buildExerciseRecommendationPrompt(
      goal: goal,
      focus: focus,
      activityLevel: activityLevel,
    );

    return await _generateAIResponse(
      prompt: prompt,
      fallbackMessage: 'No exercise recommendation was generated.',
    );
  }

  // ============================================================
  // FOOD RECOMMENDATION
  // ============================================================

  Future<String> getFoodRecommendation({
    required int age,
    required double height,
    required double weight,
    required double bmi,
    required String goal,
    required String focus,
    required String activityLevel,
  }) async {
    final prompt = AIPrompt.buildFoodRecommendationPrompt(
      age: age,
      height: height,
      weight: weight,
      bmi: bmi,
      goal: goal,
      focus: focus,
      activityLevel: activityLevel,
    );

    return await _generateAIResponse(
      prompt: prompt,
      fallbackMessage: 'No food recommendation was generated.',
    );
  }

  // ============================================================
  // EXERCISE EXPLANATION
  // ============================================================

  Future<String> getExerciseExplanation({
    required String exerciseName,
  }) async {
    final prompt = AIPrompt.buildExerciseExplanationPrompt(
      exerciseName: exerciseName,
    );

    return await _generateAIResponse(
      prompt: prompt,
      fallbackMessage: 'No exercise explanation was generated.',
    );
  }

  // ============================================================
  // RECOVERY GUIDANCE
  // ============================================================

  Future<String> getRecoveryGuidance({
    required String description,
  }) async {
    final prompt = AIPrompt.buildRecoveryGuidancePrompt(
      description: description,
    );

    return await _generateAIResponse(
      prompt: prompt,
      fallbackMessage: 'No recovery guidance was generated.',
    );
  }

  // ============================================================
  // PROGRESS GUIDANCE
  // ============================================================

  Future<String> getProgressGuidance({
    required String progressData,
  }) async {
    final prompt = AIPrompt.buildProgressGuidancePrompt(
      progressData: progressData,
    );

    return await _generateAIResponse(
      prompt: prompt,
      fallbackMessage: 'No progress guidance was generated.',
    );
  }

  // ============================================================
  // AI CHAT
  // ============================================================

  Future<String> getChatResponse({
    required String question,
    Map<String, dynamic>? userProfile,
  }) async {
    final prompt = '''
User Fitness Question:

$question

Answer the user's question as Stryve's AI fitness coach.

Stay within Stryve's fitness scope:
- Exercise
- Fitness goals
- General nutrition and food guidance
- Workout guidance
- Recovery
- Exercise explanations
- Workout progress

Give a clear and beginner-friendly answer.

Do not diagnose medical conditions.
Do not recommend dangerous or extreme exercise.
Do not encourage extreme dieting or restrictive eating.

If the user describes serious pain, injury, or concerning symptoms,
recommend seeking help from a qualified healthcare professional.
''';

    final stopwatch = Stopwatch()..start();

    final result = await _generateAIResponse(
      prompt: prompt,
      fallbackMessage: 'No response from Stryve AI.',
    );

    stopwatch.stop();

    print(
      'AI RESPONSE TIME: ${stopwatch.elapsedMilliseconds} ms',
    );

    return result;
  }

  // ============================================================
  // TESTING
  // ============================================================

  Future<void> testExercisePrompt() async {
    final result = await getExerciseRecommendation(
      goal: 'Maintain',
      focus: 'Strength',
      activityLevel: 'Moderately Active',
    );

    print(result);
  }

  Future<void> testAppPrompts() async {
    print('===== HOW STRYVE WORKS =====');
    print(await getHowStryveWorks());

    print('===== ABOUT STRYVE =====');
    print(await getAboutStryve());

    print('===== WORKOUT SETTINGS =====');
    print(await getWorkoutSettingsHelp());

    print('===== AI HELP =====');
    print(await getAIHelp());

    print('===== PROFILE HELP =====');
    print(await getProfileHelp());

    print('===== WORKOUT SETUP =====');
    print(await getWorkoutSetupHelp());
  }
}