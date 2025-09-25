import 'package:flutter/material.dart';

class AppColors {
  // Gradient background colors
  static const Color bgGradientStart = Color(0xFF1a1a2e);
  static const Color bgGradientEnd = Color(0xFF16213e);

  // Glass morphism colors
  static final Color glassBackground = Colors.white.withOpacity(0.08);
  static final Color borderWhite20 = Colors.white.withOpacity(0.2);

  // Text colors
  static const Color textPrimary = Colors.white;
  static final Color textSecondary = Colors.white.withOpacity(0.7);
  static final Color textCaption = Colors.white.withOpacity(0.5);

  // Accent colors for habits
  static const List<Color> habitColors = [
    Color(0xFF6366f1), // Indigo
    Color(0xFF8b5cf6), // Violet
    Color(0xFF06b6d4), // Cyan
    Color(0xFF10b981), // Emerald
    Color(0xFFf59e0b), // Amber
    Color(0xFFef4444), // Red
    Color(0xFFec4899), // Pink
  ];

  // Success and progress colors
  static const Color success = Color(0xFF10b981);
  static const Color warning = Color(0xFFf59e0b);
  static const Color error = Color(0xFFef4444);

  // Progress bar colors
  static final Color progressBackground = Colors.white.withOpacity(0.1);
  static const Color progressFill = Color(0xFF06b6d4);
}
