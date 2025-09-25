import 'package:taller_supabase/domain/entities/habit.dart';
import 'package:taller_supabase/domain/entities/habit_log.dart';

abstract class HabitRepository {
  /// Fetch habits without derived properties (streak, weekProgress, doneToday)
  Future<List<Habit>> fetchHabitsBase();

  /// Create a new habit and return its ID
  Future<String> createHabit({required String name, String? color});

  /// Delete a habit by ID
  Future<void> deleteHabit(String habitId);

  /// Fetch logs for a specific habit
  Future<List<HabitLog>> fetchLogs(String habitId, {int daysBack = 30});

  /// Toggle today's log for a habit (upsert/delete)
  Future<void> toggleToday(String habitId);

  /// Subscribe to log changes for real-time updates
  Stream<void> subscribeLogs();
}
