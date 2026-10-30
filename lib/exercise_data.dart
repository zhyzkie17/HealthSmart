// ============================================================
// ============================================================
// EXERCISE MODEL
// ============================================================

class Exercise {
  final String name;
  final String bodyPart;
  final List<String> trainingFocuses;
  final List<String> goals;
  final List<String> suitableActivityLevels;
  final String difficulty;
  final String equipment;

  // 'reps' = Sets + Reps
  // 'time' = Sets + Duration
  final String measurementType;

  Exercise({
    required this.name,
    required this.bodyPart,
    required this.trainingFocuses,
    required this.goals,
    required this.suitableActivityLevels,
    required this.difficulty,
    required this.equipment,

    // Existing exercises automatically use reps.
    this.measurementType = 'reps',
  });
}

// ============================================================
// EXERCISE DATABASE
// ============================================================

final List<Exercise> exercises = [

  // ==========================================================
  // CHEST — BEGINNER
  // ==========================================================

  Exercise(
    name: 'Wall Push-Ups',
    bodyPart: 'Chest',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: ['Maintain', 'General Fitness', 'Body Recomposition'],
    suitableActivityLevels: [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'None',
  ),

  Exercise(
    name: 'Incline Push-Ups',
    bodyPart: 'Chest',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
      'Bulk',
      'Cut',
    ],
    suitableActivityLevels: [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'Bench or Elevated Surface',
  ),

  Exercise(
    name: 'Knee Push-Ups',
    bodyPart: 'Chest',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
      'Cut',
    ],
    suitableActivityLevels: [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'None',
  ),

  Exercise(
    name: 'Push-Ups',
    bodyPart: 'Chest',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
      'Bulk',
      'Cut',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'None',
  ),

  Exercise(
    name: 'Dumbbell Floor Press',
    bodyPart: 'Chest',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'Dumbbells',
  ),

  // ==========================================================
  // CHEST — INTERMEDIATE
  // ==========================================================

  Exercise(
    name: 'Dumbbell Chest Press',
    bodyPart: 'Chest',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Dumbbells',
  ),

  Exercise(
    name: 'Dumbbell Chest Fly',
    bodyPart: 'Chest',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Dumbbells',
  ),

  Exercise(
    name: 'Decline Push-Ups',
    bodyPart: 'Chest',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Bench or Elevated Surface',
  ),

  Exercise(
    name: 'Resistance Band Chest Press',
    bodyPart: 'Chest',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Resistance Band',
  ),

  Exercise(
    name: 'Resistance Band Chest Fly',
    bodyPart: 'Chest',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Resistance Band',
  ),

  // ==========================================================
  // CHEST — ADVANCED
  // ==========================================================

  Exercise(
    name: 'Diamond Push-Ups',
    bodyPart: 'Chest',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Very Active',
    ],
    difficulty: 'Advanced',
    equipment: 'None',
  ),

  Exercise(
    name: 'Archer Push-Ups',
    bodyPart: 'Chest',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Very Active',
    ],
    difficulty: 'Advanced',
    equipment: 'None',
  ),

  Exercise(
    name: 'Chest Dips',
    bodyPart: 'Chest',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Very Active',
    ],
    difficulty: 'Advanced',
    equipment: 'Dip Bars',
  ),

  // ==========================================================
  // BACK — BEGINNER
  // ==========================================================

  Exercise(
    name: 'Superman',
    bodyPart: 'Back',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
      'Cut',
    ],
    suitableActivityLevels: [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'None',
    measurementType: 'time'
  ),

  Exercise(
    name: 'Bird Dog',
    bodyPart: 'Back',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'None',
  ),

  Exercise(
    name: 'Resistance Band Row',
    bodyPart: 'Back',
    trainingFocuses: ['Strength'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
      'Bulk',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'Resistance Band',
  ),

  // ==========================================================
  // BACK — INTERMEDIATE
  // ==========================================================

  Exercise(
    name: 'Dumbbell Rows',
    bodyPart: 'Back',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Dumbbells',
  ),

  Exercise(
    name: 'Inverted Rows',
    bodyPart: 'Back',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Bar or Suspension Trainer',
  ),

  Exercise(
    name: 'Lat Pulldown',
    bodyPart: 'Back',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Cable Machine',
  ),

  Exercise(
    name: 'Seated Cable Row',
    bodyPart: 'Back',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Cable Machine',
  ),

  Exercise(
    name: 'Dumbbell Reverse Fly',
    bodyPart: 'Back',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Dumbbells',
  ),

  // ==========================================================
  // BACK — ADVANCED
  // ==========================================================

  Exercise(
    name: 'Pull-Ups',
    bodyPart: 'Back',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Very Active',
    ],
    difficulty: 'Advanced',
    equipment: 'Pull-Up Bar',
  ),

  Exercise(
    name: 'Chin-Ups',
    bodyPart: 'Back',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Very Active',
    ],
    difficulty: 'Advanced',
    equipment: 'Pull-Up Bar',
  ),

  Exercise(
    name: 'Single-Arm Dumbbell Row',
    bodyPart: 'Back',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Very Active',
    ],
    difficulty: 'Advanced',
    equipment: 'Dumbbell',
  ),

  // ==========================================================
  // SHOULDERS — BEGINNER
  // ==========================================================

  Exercise(
    name: 'Wall Shoulder Press',
    bodyPart: 'Shoulders',
    trainingFocuses: ['Strength'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'None',
  ),

  Exercise(
    name: 'Lateral Raises',
    bodyPart: 'Shoulders',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'Dumbbells',
  ),

  Exercise(
    name: 'Front Raises',
    bodyPart: 'Shoulders',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'Dumbbells',
  ),

  // ==========================================================
  // SHOULDERS — INTERMEDIATE
  // ==========================================================

  Exercise(
    name: 'Dumbbell Shoulder Press',
    bodyPart: 'Shoulders',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Dumbbells',
  ),

  Exercise(
    name: 'Arnold Press',
    bodyPart: 'Shoulders',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Dumbbells',
  ),

  Exercise(
    name: 'Resistance Band Shoulder Press',
    bodyPart: 'Shoulders',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Resistance Band',
  ),

  // ==========================================================
  // SHOULDERS — ADVANCED
  // ==========================================================

  Exercise(
    name: 'Pike Push-Ups',
    bodyPart: 'Shoulders',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Very Active',
    ],
    difficulty: 'Advanced',
    equipment: 'None',
  ),

  Exercise(
    name: 'Handstand Push-Ups',
    bodyPart: 'Shoulders',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Very Active',
    ],
    difficulty: 'Advanced',
    equipment: 'Wall',
  ),

  // ==========================================================
  // ARMS — BEGINNER
  // ==========================================================

  Exercise(
    name: 'Bicep Curls',
    bodyPart: 'Arms',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'Dumbbells',
  ),

  Exercise(
    name: 'Hammer Curls',
    bodyPart: 'Arms',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'Dumbbells',
  ),

  Exercise(
    name: 'Resistance Band Curls',
    bodyPart: 'Arms',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'Resistance Band',
  ),

  Exercise(
    name: 'Tricep Extensions',
    bodyPart: 'Arms',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'Dumbbell',
  ),

  // ==========================================================
  // ARMS — INTERMEDIATE
  // ==========================================================

  Exercise(
    name: 'Concentration Curls',
    bodyPart: 'Arms',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Dumbbell',
  ),

  Exercise(
    name: 'Tricep Dips',
    bodyPart: 'Arms',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
      'Bulk',
    ],
    suitableActivityLevels: [
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Chair or Bench',
  ),

  Exercise(
    name: 'Overhead Tricep Extension',
    bodyPart: 'Arms',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Dumbbell',
  ),

  Exercise(
    name: 'Close-Grip Push-Ups',
    bodyPart: 'Arms',
    trainingFocuses: ['Strength'],
    goals: [
      'Maintain',
      'Body Recomposition',
      'Bulk',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'None',
  ),

  // ==========================================================
  // ARMS — ADVANCED
  // ==========================================================

  Exercise(
    name: 'Weighted Dips',
    bodyPart: 'Arms',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Very Active',
    ],
    difficulty: 'Advanced',
    equipment: 'Dip Bars and Weight',
  ),

  Exercise(
    name: 'Chin-Up Curls',
    bodyPart: 'Arms',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Very Active',
    ],
    difficulty: 'Advanced',
    equipment: 'Pull-Up Bar',
  ),

  // ==========================================================
  // LEGS — BEGINNER
  // ==========================================================

  Exercise(
    name: 'Chair Squats',
    bodyPart: 'Legs',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
      'Cut',
    ],
    suitableActivityLevels: [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'Chair',
  ),

  Exercise(
    name: 'Bodyweight Squats',
    bodyPart: 'Legs',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
      'Bulk',
      'Cut',
    ],
    suitableActivityLevels: [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'None',
  ),

  Exercise(
    name: 'Glute Bridges',
    bodyPart: 'Legs',
    trainingFocuses: ['Strength'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
      'Bulk',
    ],
    suitableActivityLevels: [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'None',
  ),

  Exercise(
    name: 'Calf Raises',
    bodyPart: 'Legs',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
      'Bulk',
    ],
    suitableActivityLevels: [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'None',
  ),

  // ==========================================================
  // LEGS — INTERMEDIATE
  // ==========================================================

  Exercise(
    name: 'Lunges',
    bodyPart: 'Legs',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
      'Bulk',
      'Cut',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'None',
  ),

  Exercise(
    name: 'Goblet Squats',
    bodyPart: 'Legs',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Dumbbell',
  ),

  Exercise(
    name: 'Romanian Deadlifts',
    bodyPart: 'Legs',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Dumbbells',
  ),

  Exercise(
    name: 'Step-Ups',
    bodyPart: 'Legs',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
      'Cut',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Bench or Step',
  ),

  // ==========================================================
  // LEGS — ADVANCED
  // ==========================================================

  Exercise(
    name: 'Bulgarian Split Squats',
    bodyPart: 'Legs',
    trainingFocuses: ['Strength'],
    goals: [
      'Bulk',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Very Active',
    ],
    difficulty: 'Advanced',
    equipment: 'Bench',
  ),

  Exercise(
    name: 'Jump Squats',
    bodyPart: 'Legs',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'General Fitness',
      'Maintain',
      'Cut',
    ],
    suitableActivityLevels: [
      'Very Active',
    ],
    difficulty: 'Advanced',
    equipment: 'None',
  ),

  Exercise(
    name: 'Pistol Squats',
    bodyPart: 'Legs',
    trainingFocuses: ['Strength'],
    goals: [
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Very Active',
    ],
    difficulty: 'Advanced',
    equipment: 'None',
  ),

  // ==========================================================
  // ABS — BEGINNER
  // ==========================================================

  Exercise(
    name: 'Crunches',
    bodyPart: 'Abs',
    trainingFocuses: ['Endurance', 'Strength'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
      'Cut',
    ],
    suitableActivityLevels: [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'None',
  ),

  Exercise(
    name: 'Plank',
    bodyPart: 'Abs',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
      'Cut',
    ],
    suitableActivityLevels: [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'None',
    measurementType: 'time'
  ),

  Exercise(
    name: 'Dead Bug',
    bodyPart: 'Abs',
    trainingFocuses: ['Strength'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'None',
  ),

  Exercise(
    name: 'Bird Dog',
    bodyPart: 'Abs',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'None',
  ),

  // ==========================================================
  // ABS — INTERMEDIATE
  // ==========================================================

  Exercise(
    name: 'Mountain Climbers',
    bodyPart: 'Abs',
    trainingFocuses: ['Endurance', 'Strength'],
    goals: [
      'General Fitness',
      'Cut',
      'Maintain',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'None',
    measurementType: 'time'
  ),

  Exercise(
    name: 'Bicycle Crunches',
    bodyPart: 'Abs',
    trainingFocuses: ['Endurance', 'Strength'],
    goals: [
      'General Fitness',
      'Cut',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'None',
  ),

  Exercise(
    name: 'Reverse Crunches',
    bodyPart: 'Abs',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
      'Cut',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'None',
  ),

  Exercise(
    name: 'Leg Raises',
    bodyPart: 'Abs',
    trainingFocuses: ['Strength'],
    goals: [
      'Maintain',
      'Body Recomposition',
      'General Fitness',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'None',
  ),

  // ==========================================================
  // ABS — ADVANCED
  // ==========================================================

  Exercise(
    name: 'Hanging Knee Raises',
    bodyPart: 'Abs',
    trainingFocuses: ['Strength'],
    goals: [
      'Maintain',
      'Body Recomposition',
      'Bulk',
    ],
    suitableActivityLevels: [
      'Very Active',
    ],
    difficulty: 'Advanced',
    equipment: 'Pull-Up Bar',
  ),

  Exercise(
    name: 'Hanging Leg Raises',
    bodyPart: 'Abs',
    trainingFocuses: ['Strength'],
    goals: [
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Very Active',
    ],
    difficulty: 'Advanced',
    equipment: 'Pull-Up Bar',
  ),

  Exercise(
    name: 'V-Ups',
    bodyPart: 'Abs',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'Maintain',
      'Body Recomposition',
      'General Fitness',
    ],
    suitableActivityLevels: [
      'Very Active',
    ],
    difficulty: 'Advanced',
    equipment: 'None',
  ),

  // ==========================================================
  // FULL BODY — BEGINNER
  // ==========================================================

  Exercise(
    name: 'Marching in Place',
    bodyPart: 'Full Body',
    trainingFocuses: ['Endurance'],
    goals: [
      'General Fitness',
      'Maintain',
      'Cut',
    ],
    suitableActivityLevels: [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'None',
    measurementType: 'time'
  ),

  Exercise(
    name: 'Jumping Jacks',
    bodyPart: 'Full Body',
    trainingFocuses: ['Endurance'],
    goals: [
      'General Fitness',
      'Cut',
      'Maintain',
    ],
    suitableActivityLevels: [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'None',
    measurementType: 'time'
  ),

  Exercise(
    name: 'Bodyweight Squats',
    bodyPart: 'Full Body',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'Maintain',
      'General Fitness',
      'Body Recomposition',
      'Bulk',
      'Cut',
    ],
    suitableActivityLevels: [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Beginner',
    equipment: 'None',
  ),

  // ==========================================================
  // FULL BODY — INTERMEDIATE
  // ==========================================================

  Exercise(
    name: 'Bear Crawls',
    bodyPart: 'Full Body',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'General Fitness',
      'Maintain',
      'Body Recomposition',
      'Cut',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'None',
    measurementType: 'time'
  ),

  Exercise(
    name: 'Inchworms',
    bodyPart: 'Full Body',
    trainingFocuses: ['Strength', 'Flexibility'],
    goals: [
      'General Fitness',
      'Maintain',
      'Body Recomposition',
    ],
    suitableActivityLevels: [
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'None',
    measurementType: 'time'
  ),

  Exercise(
    name: 'Thrusters',
    bodyPart: 'Full Body',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'General Fitness',
      'Cut',
      'Bulk',
      'Maintain',
    ],
    suitableActivityLevels: [
      'Moderately Active',
      'Very Active',
    ],
    difficulty: 'Intermediate',
    equipment: 'Dumbbells',
  ),

  // ==========================================================
  // FULL BODY — ADVANCED
  // ==========================================================

  Exercise(
    name: 'Burpees',
    bodyPart: 'Full Body',
    trainingFocuses: ['Endurance', 'Strength'],
    goals: [
      'General Fitness',
      'Cut',
      'Maintain',
    ],
    suitableActivityLevels: [
      'Very Active',
    ],
    difficulty: 'Advanced',
    equipment: 'None',
    measurementType: 'time'
  ),

  Exercise(
    name: 'Mountain Climber Burpees',
    bodyPart: 'Full Body',
    trainingFocuses: ['Endurance'],
    goals: [
      'General Fitness',
      'Cut',
    ],
    suitableActivityLevels: [
      'Very Active',
    ],
    difficulty: 'Advanced',
    equipment: 'None',
    measurementType: 'time'
  ),

  Exercise(
    name: 'Dumbbell Devil Press',
    bodyPart: 'Full Body',
    trainingFocuses: ['Strength', 'Endurance'],
    goals: [
      'General Fitness',
      'Cut',
      'Bulk',
    ],
    suitableActivityLevels: [
      'Very Active',
    ],
    difficulty: 'Advanced',
    equipment: 'Dumbbells',
  ),
];