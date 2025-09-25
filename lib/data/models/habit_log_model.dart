import 'package:taller_supabase/domain/entities/habit_log.dart';

class HabitLogModel {
  final int id;
  final String habitId;
  final String userId;
  final DateTime date;
  final bool done;

  const HabitLogModel({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.date,
    required this.done,
  });

  factory HabitLogModel.fromMap(Map<String, dynamic> map) {
    return HabitLogModel(
      id: map['id'] as int,
      habitId: map['habit_id'] as String,
      userId: map['user_id'] as String,
      date: DateTime.parse(map['date'] as String),
      done: map['done'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habit_id': habitId,
      'user_id': userId,
      'date': date.toIso8601String().split('T')[0], // Solo fecha YYYY-MM-DD
      'done': done,
    };
  }

  HabitLog toEntity() {
    return HabitLog(
      id: id,
      habitId: habitId,
      userId: userId,
      date: date,
      done: done,
    );
  }

  factory HabitLogModel.fromEntity(HabitLog habitLog) {
    return HabitLogModel(
      id: habitLog.id,
      habitId: habitLog.habitId,
      userId: habitLog.userId,
      date: habitLog.date,
      done: habitLog.done,
    );
  }

  HabitLogModel copyWith({
    int? id,
    String? habitId,
    String? userId,
    DateTime? date,
    bool? done,
  }) {
    return HabitLogModel(
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
    return other is HabitLogModel &&
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
    return 'HabitLogModel(id: $id, habitId: $habitId, userId: $userId, '
        'date: $date, done: $done)';
  }
}
