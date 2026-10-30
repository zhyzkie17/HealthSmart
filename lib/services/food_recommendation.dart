class FoodRecommendation {
  /// Calculates BMI from the user's height and weight.
  ///
  /// The BMI value is provided as context to the AI.
  /// For users under 18, BMI should not be interpreted
  /// using adult BMI categories.

  static double calculateBMI({
    required double height,
    required double weight,
  }) {
    if (height <= 0 || weight <= 0) {
      throw ArgumentError(
        'Height and weight must be greater than zero.',
      );
    }

    final double heightInMeters = height / 100;

    final double bmi =
        weight / (heightInMeters * heightInMeters);

    return double.parse(
      bmi.toStringAsFixed(1),
    );
  }
}