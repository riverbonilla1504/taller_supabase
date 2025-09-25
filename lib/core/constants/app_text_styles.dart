import 'package:flutter/material.dart';
import 'package:taller_supabase/core/constants/app_colors.dart';

class AppTextStyles {
  // Large titles
  static const TextStyle titleLg = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  // Medium titles
  static const TextStyle titleMd = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  // Small titles
  static const TextStyle titleSm = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body medium
  static const TextStyle bodyMd = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // Body small
  static const TextStyle bodySm = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Color(0xB3FFFFFF), // AppColors.textSecondary equivalent
    height: 1.4,
  );

  // Caption small
  static const TextStyle captionSm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0x80FFFFFF), // AppColors.textCaption equivalent
    letterSpacing: 0.5,
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );
}
