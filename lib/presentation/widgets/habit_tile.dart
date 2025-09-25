import 'package:flutter/material.dart';
import 'package:taller_supabase/core/constants/app_colors.dart';
import 'package:taller_supabase/core/constants/app_text_styles.dart';
import 'package:taller_supabase/domain/entities/habit.dart';
import 'package:taller_supabase/presentation/widgets/glass_container.dart';
import 'package:taller_supabase/presentation/widgets/progress_bar.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggleToday;
  final VoidCallback onDelete;

  const HabitTile({
    super.key,
    required this.habit,
    required this.onToggleToday,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(habit.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.glassBackground,
            title: const Text('Eliminar hábito', style: AppTextStyles.titleMd),
            content: Text(
              '¿Estás seguro de que quieres eliminar "${habit.name}"?',
              style: AppTextStyles.bodyMd,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: const Text('Eliminar'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: AppColors.error,
          size: 28,
        ),
      ),
      child: GlassContainer(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with habit name and color indicator
            Row(
              children: [
                if (habit.color != null) ...[
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse(habit.color!.replaceFirst('#', '0xFF')),
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.borderWhite20,
                        width: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    habit.name,
                    style: AppTextStyles.titleSm,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Streak chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.success.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Racha: ${habit.streak}',
                        style: AppTextStyles.captionSm.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('🔥', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Progress bar
            ProgressBar(progress: habit.weekProgress),

            const SizedBox(height: 16),

            // Today button
            Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton(
                      onPressed: onToggleToday,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: habit.doneToday
                            ? AppColors.success
                            : AppColors.glassBackground,
                        foregroundColor: habit.doneToday
                            ? Colors.white
                            : AppColors.textSecondary,
                        side: BorderSide(
                          color: habit.doneToday
                              ? AppColors.success
                              : AppColors.borderWhite20,
                        ),
                        elevation: habit.doneToday ? 4 : 0,
                        shadowColor: habit.doneToday
                            ? AppColors.success.withOpacity(0.3)
                            : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            habit.doneToday
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            habit.doneToday
                                ? 'Completado hoy'
                                : 'Marcar como hecho',
                            style: AppTextStyles.button.copyWith(
                              color: habit.doneToday
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
