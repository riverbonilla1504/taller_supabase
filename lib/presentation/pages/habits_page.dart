import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taller_supabase/core/constants/app_colors.dart';
import 'package:taller_supabase/core/constants/app_text_styles.dart';
import 'package:taller_supabase/presentation/controllers/habit_controller.dart';
import 'package:taller_supabase/presentation/pages/habit_form_page.dart';
import 'package:taller_supabase/presentation/widgets/glass_container.dart';
import 'package:taller_supabase/presentation/widgets/habit_tile.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final HabitController controller = Get.find<HabitController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgGradientStart, AppColors.bgGradientEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              // Content
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF6366f1),
                      ),
                    );
                  }

                  if (controller.habits.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return _buildHabitsList(controller);
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const HabitFormPage()),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo hábito'),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return GlassContainer(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tus hábitos', style: AppTextStyles.titleLg),
                const SizedBox(height: 4),
                Text('Construye tu mejor versión', style: AppTextStyles.bodySm),
              ],
            ),
          ),
          // Avatar placeholder
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF6366f1).withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF6366f1).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(Icons.person, color: Color(0xFF6366f1), size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: GlassContainer(
        margin: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF6366f1).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.track_changes,
                color: Color(0xFF6366f1),
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Crea tu primer hábito',
              style: AppTextStyles.titleMd,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Los hábitos pequeños y consistentes\ncrean grandes transformaciones.',
              style: AppTextStyles.bodySm,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.to(() => const HabitFormPage()),
              icon: const Icon(Icons.add),
              label: const Text('Comenzar ahora'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitsList(HabitController controller) {
    return RefreshIndicator(
      onRefresh: controller.load,
      color: const Color(0xFF6366f1),
      backgroundColor: AppColors.glassBackground,
      child: ListView.builder(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 100, // Space for FAB
        ),
        itemCount: controller.habits.length,
        itemBuilder: (context, index) {
          final habit = controller.habits[index];
          return AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(milliseconds: 200 + (index * 50)),
            child: HabitTile(
              habit: habit,
              onToggleToday: () => controller.toggleToday(habit),
              onDelete: () => controller.deleteHabit(habit.id),
            ),
          );
        },
      ),
    );
  }
}
