import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/database_service.dart';
import '../services/food_recommendation.dart';
import '../services/AI/ai_services.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final AIService _aiService = AIService();

  bool isLoading = true;

  String? foodRecommendation;
  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();

    loadFoodRecommendation();
  }

  // ============================================================
  // LOAD PROFILE AND ASK GEMINI FOR FOOD RECOMMENDATION
  // ============================================================

    Future<void> loadFoodRecommendation({
    bool forceRefresh = false,
  }) async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      // ============================================================
      // GET USER PROFILE
      // ============================================================

      final user = await DatabaseService.getUser();

      if (user == null) {
        if (!mounted) return;

        setState(() {
          userProfile = null;
          foodRecommendation = null;
          isLoading = false;
        });

        return;
      }

      // ============================================================
      // GET PROFILE INFORMATION
      // ============================================================

      final int age =
          (user['age'] as num).toInt();

      final double height =
          (user['height'] as num).toDouble();

      final double weight =
          (user['weight'] as num).toDouble();

      final String goal =
          user['goal']?.toString() ??
              'General Fitness';

      final String focus =
          user['focus']?.toString() ??
              'Strength';

      final String activityLevel =
          user['activityLevel']?.toString() ??
              'Moderately Active';

      // ============================================================
      // CREATE PROFILE KEY
      // ============================================================
      //
      // This lets us know whether the saved recommendation
      // still belongs to the current profile.
      //

      final String profileKey =
          '$age|$height|$weight|$goal|$focus|$activityLevel';

      final prefs =
          await SharedPreferences.getInstance();

      final savedProfileKey =
          prefs.getString('foodRecommendationProfile');

      final savedRecommendation =
          prefs.getString('foodRecommendation');

      // ============================================================
      // USE SAVED RECOMMENDATION
      // ============================================================
      //
      // If the profile has not changed and we already have
      // a recommendation, DO NOT call Gemini again.
      //

      if (!forceRefresh &&
          savedRecommendation != null &&
          savedProfileKey == profileKey) {
        if (!mounted) return;

        setState(() {
          userProfile = user;
          foodRecommendation = savedRecommendation;
          isLoading = false;
        });

        debugPrint(
          'FOOD AI: Using saved recommendation. No Gemini request used.',
        );

        return;
      }

      // ============================================================
      // CALCULATE BMI
      // ============================================================

      final double bmi =
          FoodRecommendation.calculateBMI(
        height: height,
        weight: weight,
      );

      // ============================================================
      // CALL GEMINI
      // ============================================================

      debugPrint(
        'FOOD AI: Sending new request to Gemini...',
      );

      final result =
          await _aiService.getFoodRecommendation(
        age: age,
        height: height,
        weight: weight,
        bmi: bmi,
        goal: goal,
        focus: focus,
        activityLevel: activityLevel,
      );

      // ============================================================
      // SAVE RESULT LOCALLY
      // ============================================================

      await prefs.setString(
        'foodRecommendation',
        result,
      );

      await prefs.setString(
        'foodRecommendationProfile',
        profileKey,
      );

      debugPrint(
        'FOOD AI: Recommendation saved locally.',
      );

      // ============================================================
      // UPDATE SCREEN
      // ============================================================

      if (!mounted) return;

      setState(() {
        userProfile = user;
        foodRecommendation = result;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(
        'FOOD AI ERROR: $e',
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;

        foodRecommendation =
            'Unable to generate a food recommendation right now.';
      });
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // The user's selected accent.
    //
    // IMPORTANT:
    // Accent is used for interactive elements and icons.
    // It does NOT control the background or cards.
    final accentColor = colors.primary;

    return Scaffold(
      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        title: Text(
          'Food Recommendation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            tooltip: 'Refresh recommendation',

            icon: Icon(
              Icons.refresh,
              color: accentColor,
            ),

            onPressed:isLoading
                  ? null 
                    : (){ 
                        loadFoodRecommendation (
                          forceRefresh: true,
                        );
                    }
          ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  CircularProgressIndicator(
                    color: accentColor,
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),

                    child: Text(
                      'Stryve AI is preparing your food recommendation...',
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : userProfile == null
              ? Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(24),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 60,
                          color: accentColor,
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'Please complete and save your profile first.',
                          textAlign: TextAlign.center,

                          style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 20),

                        ElevatedButton.icon(
                          onPressed:
                              loadFoodRecommendation,

                          icon: const Icon(
                            Icons.refresh,
                          ),

                          label: const Text(
                            'Try Again',
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView(
                  padding:
                      const EdgeInsets.all(16),

                  children: [
                    // ==================================================
                    // PROFILE CARD
                    // ==================================================

                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(18),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            // HEADER
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      accentColor.withValues(
                                    alpha: 0.12,
                                  ),

                                  child: Icon(
                                    Icons.person,
                                    color: accentColor,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Text(
                                    'Your Profile',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight:
                                          FontWeight.bold,
                                      color:
                                          colors.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            // AGE
                            _buildProfileRow(
                              context,
                              icon: Icons.cake_outlined,
                              label: 'Age',
                              value:
                                  '${userProfile!['age']}',
                            ),

                            const SizedBox(height: 12),

                            // HEIGHT
                            _buildProfileRow(
                              context,
                              icon:
                                  Icons.height,
                              label: 'Height',
                              value:
                                  '${userProfile!['height']} cm',
                            ),

                            const SizedBox(height: 12),

                            // WEIGHT
                            _buildProfileRow(
                              context,
                              icon:
                                  Icons.monitor_weight_outlined,
                              label: 'Weight',
                              value:
                                  '${userProfile!['weight']} kg',
                            ),

                            const SizedBox(height: 12),

                            // GOAL
                            _buildProfileRow(
                              context,
                              icon: Icons.flag_outlined,
                              label: 'Goal',
                              value:
                                  '${userProfile!['goal']}',
                            ),

                            const SizedBox(height: 12),

                            // FOCUS
                            _buildProfileRow(
                              context,
                              icon:
                                  Icons.fitness_center,
                              label: 'Focus',
                              value:
                                  '${userProfile!['focus']}',
                            ),

                            const SizedBox(height: 12),

                            // ACTIVITY LEVEL
                            _buildProfileRow(
                              context,
                              icon:
                                  Icons.directions_run,
                              label: 'Activity Level',
                              value:
                                  '${userProfile!['activityLevel']}',
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ==================================================
                    // AI RECOMMENDATION
                    // ==================================================

                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(18),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            // AI HEADER
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      accentColor.withValues(
                                    alpha: 0.12,
                                  ),

                                  child: Icon(
                                    Icons.auto_awesome,
                                    color: accentColor,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Text(
                                    'Stryve AI Recommendation',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight:
                                          FontWeight.bold,
                                      color:
                                          colors.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            // DIVIDER
                            Divider(
                              color:
                                  colors.outlineVariant,
                            ),

                            const SizedBox(height: 12),

                            // RECOMMENDATION
                            Text(
                              foodRecommendation ??
                                  'No recommendation available.',

                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color:
                                    colors.onSurface,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // REFRESH BUTTON
                            SizedBox(
                              width:
                                  double.infinity,

                              child:
                                  ElevatedButton.icon(
                                onPressed: isLoading
                                    ? null
                                    : loadFoodRecommendation,

                                icon: const Icon(
                                  Icons.refresh,
                                ),

                                label: const Text(
                                  'Generate New Recommendation',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==================================================
                    // INFORMATION NOTE
                    // ==================================================

                    Container(
                      padding:
                          const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: colors
                            .surfaceContainerHighest,

                        borderRadius:
                            BorderRadius.circular(14),

                        border: Border.all(
                          color:
                              colors.outlineVariant,
                        ),
                      ),

                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Icon(
                            Icons.info_outline,
                            color: accentColor,
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              'Food recommendations are generated based on your saved profile and fitness goals.',
                              style: TextStyle(
                                color:
                                    colors.onSurfaceVariant,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
    );
  }

  // ============================================================
  // PROFILE ROW
  // ============================================================

  Widget _buildProfileRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colors =
        Theme.of(context).colorScheme;

    final accentColor = colors.primary;

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.center,

      children: [
        Container(
          width: 38,
          height: 38,

          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),

          child: Icon(
            icon,
            size: 20,
            color: accentColor,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            label,

            style: TextStyle(
              color:
                  colors.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ),

        Flexible(
          child: Text(
            value,

            textAlign: TextAlign.end,

            style: TextStyle(
              color: colors.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}