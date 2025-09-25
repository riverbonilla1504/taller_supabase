import 'package:flutter/material.dart';
import 'package:taller_supabase/core/constants/app_colors.dart';
import 'package:taller_supabase/core/constants/app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.transparent,

      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF6366f1),
        secondary: Color(0xFF8b5cf6),
        surface: Colors.transparent,
        background: Colors.transparent,
        error: AppColors.error,
      ),

      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleMd,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),

      // Text theme
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.titleLg,
        headlineMedium: AppTextStyles.titleMd,
        headlineSmall: AppTextStyles.titleSm,
        bodyLarge: AppTextStyles.bodyMd,
        bodyMedium: AppTextStyles.bodySm,
        bodySmall: AppTextStyles.captionSm,
        labelLarge: AppTextStyles.button,
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.glassBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.borderWhite20),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.borderWhite20),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF6366f1), width: 2),
        ),
        hintStyle: AppTextStyles.bodySm,
        labelStyle: AppTextStyles.bodySm,
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366f1),
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: AppTextStyles.button,
        ),
      ),

      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF6366f1),
        foregroundColor: AppColors.textPrimary,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.glassBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.borderWhite20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.glassBackground,
        labelStyle: AppTextStyles.captionSm,
        side: BorderSide(color: AppColors.borderWhite20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
