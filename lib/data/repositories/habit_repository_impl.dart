import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taller_supabase/core/config/supabase_config.dart';
import 'package:taller_supabase/data/models/habit_model.dart';
import 'package:taller_supabase/data/models/habit_log_model.dart';
import 'package:taller_supabase/domain/entities/habit.dart';
import 'package:taller_supabase/domain/entities/habit_log.dart';
import 'package:taller_supabase/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  final SupabaseClient _client = SupabaseConfig.client;
  final StreamController<void> _logsStreamController =
      StreamController<void>.broadcast();

  @override
  Future<List<Habit>> fetchHabitsBase() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception(
          'Usuario no autenticado. Habilita "Anonymous sign-in" en Supabase.',
        );
      }

      final response = await _client
          .from('habits')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      final List<HabitModel> habitModels = response
          .map((json) => HabitModel.fromMap(json))
          .toList();

      return habitModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error fetching habits: $e');
    }
  }

  @override
  Future<String> createHabit({required String name, String? color}) async {
    print(
      '🔍 DEBUG REPOSITORY: createHabit called with name: "$name", color: $color',
    );

    try {
      final user = _client.auth.currentUser;
      print('🔍 DEBUG REPOSITORY: Current user: ${user?.id ?? "null"}');

      if (user == null) {
        print('❌ DEBUG REPOSITORY: No authenticated user');
        throw Exception(
          'Usuario no autenticado. Habilita "Anonymous sign-in" en Supabase.',
        );
      }

      print('🔍 DEBUG REPOSITORY: Inserting habit into database...');
      print(
        '🔍 DEBUG REPOSITORY: Data to insert: {user_id: ${user.id}, name: "$name", color: $color}',
      );

      final response = await _client
          .from('habits')
          .insert({'user_id': user.id, 'name': name, 'color': color})
          .select()
          .single();

      print(
        '✅ DEBUG REPOSITORY: Habit created successfully with ID: ${response['id']}',
      );
      return response['id'] as String;
    } catch (e) {
      print('❌ DEBUG REPOSITORY: Error creating habit: $e');
      print('❌ DEBUG REPOSITORY: Error type: ${e.runtimeType}');
      throw Exception('Error creating habit: $e');
    }
  }

  @override
  Future<void> deleteHabit(String habitId) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception(
          'Usuario no autenticado. Habilita "Anonymous sign-in" en Supabase.',
        );
      }

      await _client
          .from('habits')
          .delete()
          .eq('id', habitId)
          .eq('user_id', user.id);
    } catch (e) {
      throw Exception('Error deleting habit: $e');
    }
  }

  @override
  Future<List<HabitLog>> fetchLogs(String habitId, {int daysBack = 30}) async {
    try {
      final today = DateTime.now();
      final startDate = today.subtract(Duration(days: daysBack));
      final startDateStr = startDate.toIso8601String().split('T')[0];

      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception(
          'Usuario no autenticado. Habilita "Anonymous sign-in" en Supabase.',
        );
      }

      final response = await _client
          .from('habit_logs')
          .select()
          .eq('habit_id', habitId)
          .eq('user_id', user.id)
          .gte('date', startDateStr)
          .order('date', ascending: false);

      final List<HabitLogModel> logModels = response
          .map((json) => HabitLogModel.fromMap(json))
          .toList();

      return logModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error fetching logs: $e');
    }
  }

  @override
  Future<void> toggleToday(String habitId) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception(
          'Usuario no autenticado. Habilita "Anonymous sign-in" en Supabase.',
        );
      }

      final today = DateTime.now();
      final todayStr = today.toIso8601String().split('T')[0];

      // Check if log exists for today
      final existingLog = await _client
          .from('habit_logs')
          .select()
          .eq('habit_id', habitId)
          .eq('user_id', user.id)
          .eq('date', todayStr)
          .maybeSingle();

      if (existingLog != null) {
        // Delete existing log
        await _client
            .from('habit_logs')
            .delete()
            .eq('habit_id', habitId)
            .eq('user_id', user.id)
            .eq('date', todayStr);
      } else {
        // Create new log
        await _client.from('habit_logs').insert({
          'habit_id': habitId,
          'user_id': user.id,
          'date': todayStr,
          'done': true,
        });
      }

      // Emit change event
      _logsStreamController.add(null);
    } catch (e) {
      throw Exception('Error toggling today log: $e');
    }
  }

  @override
  Stream<void> subscribeLogs() {
    // Subscribe to real-time changes
    _client
        .channel('public:habit_logs')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'habit_logs',
          callback: (payload) {
            _logsStreamController.add(null);
          },
        )
        .subscribe();

    return _logsStreamController.stream;
  }

  void dispose() {
    _logsStreamController.close();
  }
}
