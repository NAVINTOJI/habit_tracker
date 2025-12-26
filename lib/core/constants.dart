/// Application-wide constants
class AppConstants {
  AppConstants._();
  
  // Database keys
  static const String hiveBoxDays = 'days';
  static const String hiveBoxSettings = 'settings';
  
  // Default tasks
  static const List<String> defaultTasks = [
    'Wake up early (before 6 AM)',
    'Morning workout (30+ min)',
    'Healthy breakfast',
    'Study/Work focus (4+ hours)',
    'No junk food',
    'Evening exercise',
    'Read (30+ min)',
    'Sleep before 11 PM',
  ];
  
  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Debounce durations
  static const Duration debounceDelay = Duration(milliseconds: 300);
  static const Duration toggleDebounce = Duration(milliseconds: 100);
}
