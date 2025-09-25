import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static late SupabaseClient _client;

  static SupabaseClient get client => _client;

  static Future<void> initialize() async {
    try {
      // Try multiple methods to load environment variables
      bool envLoaded = false;

      // Method 1: Standard dotenv load
      try {
        await dotenv.load(fileName: ".env");
        envLoaded = true;
        print('✅ Environment loaded using standard method');
      } catch (e) {
        print('⚠️ Standard env loading failed: $e');
      }

      // Method 2: Try loading from assets if first method failed
      if (!envLoaded) {
        try {
          await dotenv.load();
          envLoaded = true;
          print('✅ Environment loaded using assets method');
        } catch (e) {
          print('⚠️ Assets env loading failed: $e');
        }
      }

      if (!envLoaded) {
        throw Exception(
          'No se pudo cargar el archivo .env. Verifica que existe y está en la carpeta assets del pubspec.yaml',
        );
      }

      // Debug: Print loaded env variables
      print(
        '🔍 Environment variables loaded. Available keys: ${dotenv.env.keys.toList()}',
      );

      final supabaseUrl = dotenv.env['SUPABASE_URL']?.trim();
      final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']?.trim();

      // More detailed error message
      if (supabaseUrl == null || supabaseUrl.isEmpty) {
        throw Exception(
          '❌ SUPABASE_URL not found or empty in .env file.\n'
          'Tu archivo .env debe contener:\n'
          'SUPABASE_URL=https://tu-proyecto.supabase.co\n'
          'SUPABASE_ANON_KEY=tu-clave-aqui\n\n'
          'Verifica que no hay espacios extras y que el archivo termina con una línea vacía.',
        );
      }

      if (supabaseAnonKey == null || supabaseAnonKey.isEmpty) {
        throw Exception(
          '❌ SUPABASE_ANON_KEY not found or empty in .env file.\n'
          'Tu archivo .env debe contener:\n'
          'SUPABASE_URL=https://tu-proyecto.supabase.co\n'
          'SUPABASE_ANON_KEY=tu-clave-aqui\n\n'
          'Verifica que no hay espacios extras y que el archivo termina con una línea vacía.',
        );
      }

      print('🌐 Supabase URL found: ${supabaseUrl.substring(0, 25)}...');
      print('🔑 Supabase Key found: ${supabaseAnonKey.substring(0, 25)}...');

      // Initialize Supabase
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: true, // Set to true for development debugging
      );

      _client = Supabase.instance.client;
      print('🎉 Supabase initialized successfully!');
    } catch (e) {
      print('💥 Error initializing Supabase: $e');
      rethrow;
    }
  }

  // Helper method to check if user is authenticated
  static bool get isAuthenticated => _client.auth.currentUser != null;

  // Helper method to get current user
  static User? get currentUser => _client.auth.currentUser;
}
