class Habit {
  final String id;
  final String userId;
  final String name;
  final String? color;
  final DateTime createdAt;

  // Derived properties (not from DB)
  final int streak;
  final double weekProgress; // 0.0 to 1.0
  final bool doneToday;

  const Habit({
    required this.id,
    required this.userId,
    required this.name,
    this.color,
    required this.createdAt,
    this.streak = 0,
    this.weekProgress = 0.0,
    this.doneToday = false,
  });

  Habit copyWith({
    String? id,
    String? userId,
    String? name,
    String? color,
    DateTime? createdAt,
    int? streak,
    double? weekProgress,
    bool? doneToday,
  }) {
    return Habit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      streak: streak ?? this.streak,
      weekProgress: weekProgress ?? this.weekProgress,
      doneToday: doneToday ?? this.doneToday,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Habit &&
        other.id == id &&
        other.userId == userId &&
        other.name == name &&
        other.color == color &&
        other.createdAt == createdAt &&
        other.streak == streak &&
        other.weekProgress == weekProgress &&
        other.doneToday == doneToday;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      name,
      color,
      createdAt,
      streak,
      weekProgress,
      doneToday,
    );
  }

  @override
  String toString() {
    return 'Habit(id: $id, userId: $userId, name: $name, color: $color, '
        'createdAt: $createdAt, streak: $streak, weekProgress: $weekProgress, '
        'doneToday: $doneToday)';
  }
}
