class HabitMetrics {
  /// Compute current streak from a list of done days
  /// Returns consecutive days from today backwards
  static int computeStreak(List<DateTime> doneDays, DateTime today) {
    if (doneDays.isEmpty) return 0;

    // Normalize today to date only (00:00:00)
    final normalizedToday = DateTime(today.year, today.month, today.day);

    // Normalize and sort done days in descending order (most recent first)
    final normalizedDoneDays =
        doneDays
            .map((day) => DateTime(day.year, day.month, day.day))
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime currentDay = normalizedToday;

    // Count consecutive days from today backwards
    for (final doneDay in normalizedDoneDays) {
      if (doneDay.isAtSameMomentAs(currentDay)) {
        streak++;
        currentDay = currentDay.subtract(const Duration(days: 1));
      } else if (doneDay.isBefore(currentDay)) {
        // Gap found, stop counting
        break;
      }
    }

    return streak;
  }

  /// Compute week progress (proportion of last 7 days completed)
  /// Returns value between 0.0 and 1.0
  static double computeWeekProgress(List<DateTime> doneDays, DateTime today) {
    // Normalize today to date only
    final normalizedToday = DateTime(today.year, today.month, today.day);

    // Create week window: [today-6, today] (7 days total)
    final weekStart = normalizedToday.subtract(const Duration(days: 6));

    // Normalize done days
    final normalizedDoneDays = doneDays
        .map((day) => DateTime(day.year, day.month, day.day))
        .toSet();

    // Count done days in the week window
    int doneDaysInWeek = 0;
    for (int i = 0; i < 7; i++) {
      final dayToCheck = weekStart.add(Duration(days: i));
      if (normalizedDoneDays.contains(dayToCheck)) {
        doneDaysInWeek++;
      }
    }

    return doneDaysInWeek / 7.0;
  }

  /// Check if habit is done today
  static bool isDoneToday(List<DateTime> doneDays, DateTime today) {
    // Normalize today to date only
    final normalizedToday = DateTime(today.year, today.month, today.day);

    // Check if today is in the done days list
    return doneDays.any((day) {
      final normalizedDay = DateTime(day.year, day.month, day.day);
      return normalizedDay.isAtSameMomentAs(normalizedToday);
    });
  }
}
