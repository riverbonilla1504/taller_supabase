class HabitLog {
  final int id;
  final String habitId;
  final String userId;
  final DateTime date; // Solo fecha (00:00:00)
  final bool done;

  const HabitLog({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.date,
    required this.done,
  });

  HabitLog copyWith({
    int? id,
    String? habitId,
    String? userId,
    DateTime? date,
    bool? done,
  }) {
    return HabitLog(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      done: done ?? this.done,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HabitLog &&
        other.id == id &&
        other.habitId == habitId &&
        other.userId == userId &&
        other.date == date &&
        other.done == done;
  }

  @override
  int get hashCode {
    return Object.hash(id, habitId, userId, date, done);
  }

  @override
  String toString() {
    return 'HabitLog(id: $id, habitId: $habitId, userId: $userId, '
        'date: $date, done: $done)';
  }
}
