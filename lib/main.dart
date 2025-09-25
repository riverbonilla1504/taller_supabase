import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taller_supabase/core/config/supabase_config.dart';
import 'package:taller_supabase/core/theme/app_theme.dart';
import 'package:taller_supabase/presentation/controllers/habit_controller.dart';
import 'package:taller_supabase/presentation/pages/habits_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    print('🚀 Initializing HabitGlass app...');

    // Initialize Supabase
    print('📡 Loading Supabase configuration...');
    await SupabaseConfig.initialize();
    print('✅ Supabase configuration loaded successfully');

    // Check authentication and sign in anonymously if needed
    print('🔑 Checking authentication...');
    if (!SupabaseConfig.isAuthenticated) {
      print('🆔 Attempting anonymous sign-in...');
      try {
        await SupabaseConfig.client.auth.signInAnonymously();
        print('✅ Anonymous authentication successful');
      } catch (e) {
        print('⚠️ Anonymous authentication failed: $e');
        print(
          '💡 Para usar la app completamente, habilita "Anonymous sign-in" en Supabase Authentication > Settings',
        );
        print('🎯 Por ahora continuaremos sin autenticación (solo lectura)');
      }
    } else {
      print('✅ User already authenticated');
    }

    // Initialize dependency injection
    print('💉 Initializing dependencies...');
    _initializeDependencies();
    print('✅ Dependencies initialized');

    print('🎉 Starting HabitGlass app!');
    runApp(const HabitGlassApp());
  } catch (e, stackTrace) {
    // Show detailed error information
    print('❌ Error during initialization: $e');
    print('📍 Stack trace: $stackTrace');
    runApp(ErrorApp(error: e.toString()));
  }
}

void _initializeDependencies() {
  // Register controllers
  Get.put(HabitController());
}

class HabitGlassApp extends StatelessWidget {
  const HabitGlassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HabitGlass',
      theme: AppTheme.lightTheme,
      home: const HabitsPage(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({super.key, this.error = 'Error desconocido'});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitGlass - Error',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 24),
                  const Text(
                    'Error de configuración',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    error,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Pasos para solucionarlo:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '1. Verifica que existe el archivo .env en la raíz del proyecto\n'
                    '2. Asegúrate que contiene SUPABASE_URL y SUPABASE_ANON_KEY\n'
                    '3. No debe haber espacios extra o comillas\n'
                    '4. Ejecuta "flutter clean" y "flutter pub get"',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
