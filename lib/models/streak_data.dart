class StreakData {
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastPerfectDay;

  const StreakData({
    required this.currentStreak,
    required this.bestStreak,
    this.lastPerfectDay,
  });

  StreakData copyWith({
    int? currentStreak,
    int? bestStreak,
    DateTime? lastPerfectDay,
  }) {
    return StreakData(
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastPerfectDay: lastPerfectDay ?? this.lastPerfectDay,
    );
  }
}
