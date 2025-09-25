import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taller_supabase/data/repositories/habit_repository_impl.dart';
import 'package:taller_supabase/domain/entities/habit.dart';
import 'package:taller_supabase/domain/repositories/habit_repository.dart';
import 'package:taller_supabase/domain/services/habit_metrics.dart';

class HabitController extends GetxController {
  final HabitRepository _repository = HabitRepositoryImpl();

  final RxList<Habit> habits = <Habit>[].obs;
  final RxBool isLoading = false.obs;
  StreamSubscription<void>? _logsSubscription;

  @override
  void onInit() {
    super.onInit();
    _subscribeToLogs();
    // Load data after UI is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSilently();
    });
  }

  @override
  void onClose() {
    _logsSubscription?.cancel();
    if (_repository is HabitRepositoryImpl) {
      _repository.dispose();
    }
    super.onClose();
  }

  Future<void> loadSilently() async {
    try {
      isLoading.value = true;

      // Fetch base habits (without derived properties)
      final baseHabits = await _repository.fetchHabitsBase();

      // Calculate derived properties for each habit
      final List<Habit> enrichedHabits = [];
      final DateTime today = DateTime.now();

      for (final habit in baseHabits) {
        // Fetch logs for this habit (last 7 days for week progress)
        final logs = await _repository.fetchLogs(habit.id, daysBack: 7);

        // Extract done dates
        final List<DateTime> doneDays = logs
            .where((log) => log.done)
            .map((log) => log.date)
            .toList();

        // Calculate derived properties
        final int streak = HabitMetrics.computeStreak(doneDays, today);
        final double weekProgress = HabitMetrics.computeWeekProgress(
          doneDays,
          today,
        );
        final bool doneToday = HabitMetrics.isDoneToday(doneDays, today);

        // Create enriched habit
        final enrichedHabit = habit.copyWith(
          streak: streak,
          weekProgress: weekProgress,
          doneToday: doneToday,
        );

        enrichedHabits.add(enrichedHabit);
      }

      habits.value = enrichedHabits;
    } catch (e) {
      // Silent loading - no snackbars during initialization
      print('⚠️ Error loading habits silently: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> load() async {
    try {
      isLoading.value = true;

      // Fetch base habits (without derived properties)
      final baseHabits = await _repository.fetchHabitsBase();

      // Calculate derived properties for each habit
      final List<Habit> enrichedHabits = [];
      final DateTime today = DateTime.now();

      for (final habit in baseHabits) {
        // Fetch logs for this habit (last 7 days for week progress)
        final logs = await _repository.fetchLogs(habit.id, daysBack: 7);

        // Extract done dates
        final List<DateTime> doneDays = logs
            .where((log) => log.done)
            .map((log) => log.date)
            .toList();

        // Calculate derived properties
        final int streak = HabitMetrics.computeStreak(doneDays, today);
        final double weekProgress = HabitMetrics.computeWeekProgress(
          doneDays,
          today,
        );
        final bool doneToday = HabitMetrics.isDoneToday(doneDays, today);

        // Create enriched habit
        final enrichedHabit = habit.copyWith(
          streak: streak,
          weekProgress: weekProgress,
          doneToday: doneToday,
        );

        enrichedHabits.add(enrichedHabit);
      }

      habits.value = enrichedHabits;
    } catch (e) {
      if (e.toString().contains('Usuario no autenticado')) {
        Get.snackbar(
          'Autenticación requerida',
          'Habilita "Anonymous sign-in" en tu proyecto de Supabase para usar la app',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Error',
          'No se pudieron cargar los hábitos: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addHabit(String name, String? color) async {
    print(
      '🔍 DEBUG CONTROLLER: addHabit called with name: "$name", color: $color',
    );

    try {
      print('🔍 DEBUG CONTROLLER: Calling repository.createHabit...');
      await _repository.createHabit(name: name, color: color);
      print('✅ DEBUG CONTROLLER: Repository.createHabit successful');

      print('🔍 DEBUG CONTROLLER: Reloading habits...');
      await load(); // Reload all habits
      print('✅ DEBUG CONTROLLER: Habits reloaded successfully');

      // Mostrar mensaje de éxito
      Get.snackbar(
        'Éxito',
        'Hábito "$name" creado correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      print('✅ DEBUG CONTROLLER: Success snackbar shown');
    } catch (e) {
      print('❌ DEBUG CONTROLLER: Error in addHabit: $e');
      print('❌ DEBUG CONTROLLER: Error type: ${e.runtimeType}');
      print('❌ DEBUG CONTROLLER: Error toString: ${e.toString()}');

      if (e.toString().contains('Usuario no autenticado')) {
        print('🔍 DEBUG CONTROLLER: Authentication error detected');
        Get.snackbar(
          'Autenticación requerida',
          'Habilita "Anonymous sign-in" en tu proyecto de Supabase para crear hábitos',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        print('🔍 DEBUG CONTROLLER: Generic error detected');
        Get.snackbar(
          'Error',
          'No se pudo crear el hábito: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
      // Re-throw the error so the form can handle it
      rethrow;
    }
  }

  Future<void> deleteHabit(String id) async {
    try {
      await _repository.deleteHabit(id);
      await load(); // Reload all habits

      Get.snackbar(
        'Éxito',
        'Hábito eliminado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      if (e.toString().contains('Usuario no autenticado')) {
        Get.snackbar(
          'Autenticación requerida',
          'Habilita "Anonymous sign-in" en tu proyecto de Supabase para eliminar hábitos',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Error',
          'No se pudo eliminar el hábito: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> toggleToday(Habit habit) async {
    try {
      await _repository.toggleToday(habit.id);

      // Update only this habit's derived properties
      await _updateSingleHabit(habit.id);

      final String message = habit.doneToday
          ? 'Hábito desmarcado para hoy'
          : 'Hábito marcado como completado para hoy';

      Get.snackbar(
        'Éxito',
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      if (e.toString().contains('Usuario no autenticado')) {
        Get.snackbar(
          'Autenticación requerida',
          'Habilita "Anonymous sign-in" en tu proyecto de Supabase para actualizar hábitos',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Error',
          'No se pudo actualizar el hábito: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> _updateSingleHabit(String habitId) async {
    try {
      // Find the habit in current list
      final int habitIndex = habits.indexWhere((h) => h.id == habitId);
      if (habitIndex == -1) return;

      final Habit currentHabit = habits[habitIndex];

      // Fetch updated logs for this habit
      final logs = await _repository.fetchLogs(habitId, daysBack: 7);
      final DateTime today = DateTime.now();

      // Extract done dates
      final List<DateTime> doneDays = logs
          .where((log) => log.done)
          .map((log) => log.date)
          .toList();

      // Calculate derived properties
      final int streak = HabitMetrics.computeStreak(doneDays, today);
      final double weekProgress = HabitMetrics.computeWeekProgress(
        doneDays,
        today,
      );
      final bool doneToday = HabitMetrics.isDoneToday(doneDays, today);

      // Update the habit in the list
      final List<Habit> updatedHabits = List.from(habits);
      updatedHabits[habitIndex] = currentHabit.copyWith(
        streak: streak,
        weekProgress: weekProgress,
        doneToday: doneToday,
      );

      habits.value = updatedHabits;
    } catch (e) {
      // If single update fails, reload all
      await load();
    }
  }

  void _subscribeToLogs() {
    _logsSubscription = _repository.subscribeLogs().listen((_) {
      // Reload habits when logs change (from other devices/sessions)
      loadSilently();
    });
  }
}
