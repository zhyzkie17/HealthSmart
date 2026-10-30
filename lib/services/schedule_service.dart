

class ScheduleService {
  static List<bool> selectedDays = [
    true,
    false,
    true,
    false,
    true,
    false,
    false,
  ];

  static const List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static bool isWorkoutDay(int weekday) {
    return selectedDays[weekday - 1];
  }

  static String getDayName(int weekday) {
    return days[weekday - 1];
  }
}