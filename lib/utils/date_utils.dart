class DateUtilsExt {
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  static bool isPast(DateTime date) {
    final today = startOfDay(DateTime.now());
    final checkDate = startOfDay(date);
    return checkDate.isBefore(today);
  }

  static bool isFuture(DateTime date) {
    final today = startOfDay(DateTime.now());
    final checkDate = startOfDay(date);
    return checkDate.isAfter(today);
  }

  static List<DateTime> getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    
    final days = <DateTime>[];
    for (int i = 0; i <= lastDay.day - 1; i++) {
      days.add(firstDay.add(Duration(days: i)));
    }
    
    return days;
  }

  static String getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  static String getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}
