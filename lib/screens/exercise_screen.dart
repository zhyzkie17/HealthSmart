import 'package:flutter/material.dart';
import '../exercise_data.dart';
import 'exercise_detail_screen.dart';
import '../services/database_service.dart';
import '../services/AI/ai_services.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final AIService aiService = AIService();

  // ============================================================
  // USER PROFILE DATA
  // ============================================================

  String selectedGoal = 'General Fitness';
  String selectedTrainingFocus = 'Strength';
  String selectedActivityLevel = 'Moderately Active';

  // ============================================================
  // SCREEN SELECTION
  // ============================================================

  String selectedBodyPart = 'Full Body';

  bool isLoadingProfile = true;
  bool isLoadingAI = false;

  String? aiRecommendation;

  // ============================================================
  // BODY PARTS
  // ============================================================

  final List<String> bodyParts = [
    'Full Body',
    'Chest',
    'Arms',
    'Legs',
    'Back',
    'Shoulders',
    'Abs',
  ];

  // ============================================================
  // TRAINING FOCUS
  // ============================================================

  final List<String> availableTrainingFocuses = [
    'Strength',
    'Flexibility',
    'Endurance',
  ];

  // ============================================================
  // LOAD USER PROFILE
  // ============================================================

  Future<void> loadUserProfile() async {
    final user = await DatabaseService.getUser();

    if (!mounted) return;

    if (user == null) {
      setState(() {
        isLoadingProfile = false;
      });
      return;
    }

    setState(() {
      selectedGoal =
          user['goal']?.toString() ?? 'General Fitness';

      selectedTrainingFocus =
          user['focus']?.toString() ?? 'Strength';

      selectedActivityLevel =
          user['activityLevel']?.toString() ??
              'Moderately Active';

      isLoadingProfile = false;
    });
  }

  // ============================================================
  // GET FILTERED EXERCISES
  // ============================================================

  List<Exercise> get recommendedExercises {
    return exercises.where((exercise) {
      final matchesBodyPart =
          exercise.bodyPart.toLowerCase() ==
              selectedBodyPart.toLowerCase();

      final matchesFocus = exercise.trainingFocuses.any(
        (focus) =>
            focus.toLowerCase() ==
            selectedTrainingFocus.toLowerCase(),
      );

      return matchesBodyPart && matchesFocus;
    }).toList();
  }

  // ============================================================
  // GROUP EXERCISES BY DIFFICULTY
  // ============================================================

  List<Exercise> get beginnerExercises {
    return recommendedExercises
        .where(
          (exercise) =>
              exercise.difficulty == 'Beginner',
        )
        .toList();
  }

  List<Exercise> get intermediateExercises {
    return recommendedExercises
        .where(
          (exercise) =>
              exercise.difficulty == 'Intermediate',
        )
        .toList();
  }

  List<Exercise> get advancedExercises {
    return recommendedExercises
        .where(
          (exercise) =>
              exercise.difficulty == 'Advanced',
        )
        .toList();
  }

  // ============================================================
  // AI RECOMMENDATION
  // ============================================================

  Future<void> generateAIRecommendation() async {
    setState(() {
      isLoadingAI = true;
      aiRecommendation = null;
    });

    try {
      final result =
          await aiService.getExerciseRecommendation(
        goal: selectedGoal,
        focus: selectedTrainingFocus,
        activityLevel: selectedActivityLevel,
      );

      if (!mounted) return;

      setState(() {
        aiRecommendation = result;
        isLoadingAI = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        aiRecommendation =
            'Unable to get an AI recommendation right now.';
        isLoadingAI = false;
      });

      debugPrint(
        'AI recommendation error: $e',
      );
    }
  }

  // ============================================================
  // INITIALIZE
  // ============================================================

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // ==========================================================
    // IMPORTANT:
    //
    // colors.primary = user's selected accent color
    //
    // We use it ONLY for icons and buttons.
    //
    // Backgrounds, cards and text continue using the theme.
    // ==========================================================

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exercise Recommendations',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoadingProfile
          ? Center(
              child: CircularProgressIndicator(
                color: colors.primary,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  // ==================================================
                  // USER PROFILE
                  // ==================================================

                  const SizedBox(height: 10),

                  Text(
                    'Your Fitness Profile',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(16),

                      child: Column(
                        children: [
                          // MAIN GOAL
                          ListTile(
                            contentPadding:
                                EdgeInsets.zero,

                            leading: CircleAvatar(
                              backgroundColor:
                                  colors.primary
                                      .withValues(alpha: 0.12),

                              child: Icon(
                                Icons.flag,
                                color: colors.primary,
                              ),
                            ),

                            title: Text(
                              'Main Goal',
                              style: TextStyle(
                                color:
                                    colors.onSurface,
                              ),
                            ),

                            subtitle: Text(
                              selectedGoal,
                              style: TextStyle(
                                color:
                                    colors.onSurfaceVariant,
                              ),
                            ),
                          ),

                          // FITNESS FOCUS
                          ListTile(
                            contentPadding:
                                EdgeInsets.zero,

                            leading: CircleAvatar(
                              backgroundColor:
                                  colors.primary
                                      .withValues(alpha: 0.12),

                              child: Icon(
                                Icons.fitness_center,
                                color: colors.primary,
                              ),
                            ),

                            title: Text(
                              'Fitness Focus',
                              style: TextStyle(
                                color:
                                    colors.onSurface,
                              ),
                            ),

                            subtitle: Text(
                              selectedTrainingFocus,
                              style: TextStyle(
                                color:
                                    colors.onSurfaceVariant,
                              ),
                            ),
                          ),

                          // ACTIVITY LEVEL
                          ListTile(
                            contentPadding:
                                EdgeInsets.zero,

                            leading: CircleAvatar(
                              backgroundColor:
                                  colors.primary
                                      .withValues(alpha: 0.12),

                              child: Icon(
                                Icons.directions_run,
                                color: colors.primary,
                              ),
                            ),

                            title: Text(
                              'Activity Level',
                              style: TextStyle(
                                color:
                                    colors.onSurface,
                              ),
                            ),

                            subtitle: Text(
                              selectedActivityLevel,
                              style: TextStyle(
                                color:
                                    colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ==================================================
                  // BODY PART
                  // ==================================================

                  const SizedBox(height: 25),

                  Text(
                    'Choose Body Part',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    initialValue:
                        selectedBodyPart,

                    decoration: InputDecoration(
                      border:
                          const OutlineInputBorder(),

                      labelText: 'Body Part',

                      labelStyle: TextStyle(
                        color:
                            colors.onSurfaceVariant,
                      ),

                      prefixIcon: Icon(
                        Icons.accessibility_new,
                        color: colors.primary,
                      ),

                      focusedBorder:
                          OutlineInputBorder(
                        borderSide: BorderSide(
                          color: colors.primary,
                          width: 2,
                        ),
                      ),
                    ),

                    items: bodyParts.map(
                      (part) {
                        return DropdownMenuItem(
                          value: part,
                          child: Text(part),
                        );
                      },
                    ).toList(),

                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        selectedBodyPart = value;
                      });
                    },
                  ),

                  // ==================================================
                  // RESULT COUNT
                  // ==================================================

                  const SizedBox(height: 25),

                  Text(
                    '${recommendedExercises.length} exercises available',

                    style: TextStyle(
                      fontSize: 16,
                      color: colors.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // BEGINNER
                  // ==================================================

                  _buildDifficultySection(
                    title: 'Beginner',
                    exercises:
                        beginnerExercises,
                  ),

                  // ==================================================
                  // INTERMEDIATE
                  // ==================================================

                  _buildDifficultySection(
                    title: 'Intermediate',
                    exercises:
                        intermediateExercises,
                  ),

                  // ==================================================
                  // ADVANCED
                  // ==================================================

                  _buildDifficultySection(
                    title: 'Advanced',
                    exercises:
                        advancedExercises,
                  ),

                  // ==================================================
                  // NO RESULTS
                  // ==================================================

                  if (recommendedExercises.isEmpty)
                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(20),

                        child: Text(
                          'No exercises found for this combination yet.',

                          style: TextStyle(
                            fontSize: 16,
                            color:
                                colors.onSurface,
                          ),
                        ),
                      ),
                    ),

                  // ==================================================
                  // AI BUTTON
                  // ==================================================

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: isLoadingAI
                          ? null
                          : generateAIRecommendation,

                      icon: isLoadingAI
                          ? SizedBox(
                              width: 18,
                              height: 18,

                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color:
                                    colors.onPrimary,
                              ),
                            )
                          : Icon(
                              Icons.auto_awesome,
                              color:
                                  colors.onPrimary,
                            ),

                      label: Text(
                        isLoadingAI
                            ? 'Getting AI Recommendation...'
                            : 'Ask Stryve AI',

                        style: TextStyle(
                          color:
                              colors.onPrimary,
                        ),
                      ),

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            colors.primary,

                        foregroundColor:
                            colors.onPrimary,

                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 15,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // AI RESULT
                  // ==================================================

                  if (aiRecommendation != null) ...[
                    const SizedBox(height: 15),

                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(16),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  color:
                                      colors.primary,
                                ),

                                const SizedBox(width: 8),

                                Text(
                                  'Stryve AI',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.bold,
                                    color:
                                        colors.onSurface,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            Text(
                              aiRecommendation!,

                              style: TextStyle(
                                fontSize: 15,
                                color:
                                    colors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  // ============================================================
  // DIFFICULTY SECTION
  // ============================================================

  Widget _buildDifficultySection({
    required String title,
    required List<Exercise> exercises,
  }) {
    final colors =
        Theme.of(context).colorScheme;

    if (exercises.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        const SizedBox(height: 15),

        Text(
          title,

          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),

        const SizedBox(height: 10),

        ...exercises.map(
          (exercise) {
            return Card(
              margin:
                  const EdgeInsets.only(
                bottom: 10,
              ),

              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      colors.primary
                          .withValues(alpha: 0.12),

                  child: Icon(
                    Icons.fitness_center,
                    color: colors.primary,
                  ),
                ),

                title: Text(
                  exercise.name,

                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),

                subtitle: Text(
                  'Difficulty: ${exercise.difficulty}\n'
                  'Equipment: ${exercise.equipment}',

                  style: TextStyle(
                    color:
                        colors.onSurfaceVariant,
                  ),
                ),

                isThreeLine: true,

                trailing: Icon(
                  Icons.chevron_right,
                  color: colors.primary,
                ),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ExerciseDetailScreen(
                        exercise: exercise,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}