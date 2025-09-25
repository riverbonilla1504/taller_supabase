import 'package:flutter/material.dart';
import 'package:taller_supabase/core/constants/app_colors.dart';
import 'package:taller_supabase/core/constants/app_text_styles.dart';

class ProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double height;
  final BorderRadius? borderRadius;
  final bool showPercentage;

  const ProgressBar({
    super.key,
    required this.progress,
    this.height = 8.0,
    this.borderRadius,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return Row(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: height,
                decoration: BoxDecoration(
                  color: AppColors.progressBackground,
                  borderRadius:
                      borderRadius ?? BorderRadius.circular(height / 2),
                ),
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                      height: height,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.progressFill, Color(0xFF8b5cf6)],
                        ),
                        borderRadius:
                            borderRadius ?? BorderRadius.circular(height / 2),
                        boxShadow: progress > 0
                            ? [
                                BoxShadow(
                                  color: AppColors.progressFill.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (showPercentage) ...[
          const SizedBox(width: 12),
          Text('$percentage%', style: AppTextStyles.captionSm),
        ],
      ],
    );
  }
}
