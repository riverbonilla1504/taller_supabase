import 'package:taller_supabase/domain/entities/habit.dart';

class HabitModel {
  final String id;
  final String userId;
  final String name;
  final String? color;
  final DateTime createdAt;

  const HabitModel({
    required this.id,
    required this.userId,
    required this.name,
    this.color,
    required this.createdAt,
  });

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String,
      color: map['color'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'color': color,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Habit toEntity() {
    return Habit(
      id: id,
      userId: userId,
      name: name,
      color: color,
      createdAt: createdAt,
      // Derived properties will be calculated separately
      streak: 0,
      weekProgress: 0.0,
      doneToday: false,
    );
  }

  factory HabitModel.fromEntity(Habit habit) {
    return HabitModel(
      id: habit.id,
      userId: habit.userId,
      name: habit.name,
      color: habit.color,
      createdAt: habit.createdAt,
    );
  }

  HabitModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? color,
    DateTime? createdAt,
  }) {
    return HabitModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HabitModel &&
        other.id == id &&
        other.userId == userId &&
        other.name == name &&
        other.color == color &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, userId, name, color, createdAt);
  }

  @override
  String toString() {
    return 'HabitModel(id: $id, userId: $userId, name: $name, '
        'color: $color, createdAt: $createdAt)';
  }
}
