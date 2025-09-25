import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taller_supabase/core/constants/app_colors.dart';
import 'package:taller_supabase/core/constants/app_text_styles.dart';
import 'package:taller_supabase/presentation/controllers/habit_controller.dart';
import 'package:taller_supabase/presentation/widgets/glass_container.dart';

class HabitFormPage extends StatefulWidget {
  const HabitFormPage({super.key});

  @override
  State<HabitFormPage> createState() => _HabitFormPageState();
}

class _HabitFormPageState extends State<HabitFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedColor;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              _buildHeader(),

              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildNameField(),
                        const SizedBox(height: 32),
                        _buildColorSelector(),
                        const SizedBox(height: 40),
                        _buildSaveButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return GlassContainer(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text('Nuevo hábito', style: AppTextStyles.titleMd),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nombre del hábito', style: AppTextStyles.titleSm),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nameController,
            style: AppTextStyles.bodyMd,
            decoration: const InputDecoration(
              hintText: 'Ej: Leer 20 minutos',
              prefixIcon: Icon(
                Icons.track_changes,
                color: Color(0xB3FFFFFF), // AppColors.textSecondary equivalent
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor ingresa un nombre para el hábito';
              }
              if (value.trim().length < 3) {
                return 'El nombre debe tener al menos 3 caracteres';
              }
              return null;
            },
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submitForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSelector() {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Color del hábito', style: AppTextStyles.titleSm),
          const SizedBox(height: 8),
          Text(
            'Opcional - elige un color para identificar tu hábito',
            style: AppTextStyles.bodySm,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: AppColors.habitColors.map((color) {
              final String colorHex = color.value
                  .toRadixString(16)
                  .padLeft(8, '0');
              final String colorString = '#${colorHex.substring(2)}';
              final bool isSelected = _selectedColor == colorString;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = isSelected ? null : colorString;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.borderWhite20,
                      width: isSelected ? 3 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 24)
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return GlassContainer(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submitForm,
          child: _isSubmitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Crear hábito'),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    print('🔍 DEBUG: _submitForm called');
    print('🔍 DEBUG: Form validation: ${_formKey.currentState?.validate()}');
    print('🔍 DEBUG: Is submitting: $_isSubmitting');
    print('🔍 DEBUG: Name: "${_nameController.text.trim()}"');
    print('🔍 DEBUG: Selected color: $_selectedColor');

    // Validate form first
    if (!_formKey.currentState!.validate()) {
      print('❌ DEBUG: Form validation failed');
      Get.snackbar(
        'Error de validación',
        'Por favor completa todos los campos requeridos correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (_isSubmitting) {
      print('❌ DEBUG: Already submitting, ignoring');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    print('🚀 DEBUG: Starting habit creation...');

    try {
      final HabitController controller = Get.find<HabitController>();
      print('✅ DEBUG: Controller found');

      await controller.addHabit(_nameController.text.trim(), _selectedColor);
      print('✅ DEBUG: Habit created successfully');

      // Regresar al menú principal después de crear el hábito exitosamente
      Get.back();
    } catch (e) {
      print('❌ DEBUG: Error creating habit: $e');
      // Show additional error info for debugging
      Get.snackbar(
        'Error',
        'Error al crear hábito: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
      print('🏁 DEBUG: Form submission completed');
    }
  }
}
