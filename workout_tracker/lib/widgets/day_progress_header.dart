import 'package:flutter/material.dart';
import '../core/extensions.dart';

class DayProgressHeader extends StatelessWidget {
  final String dayName;
  final int completedExercises;
  final int totalExercises;

  const DayProgressHeader({
    super.key,
    required this.dayName,
    required this.completedExercises,
    required this.totalExercises,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.fitness_center, size: 20, color: cs.primary),
              const SizedBox(width: 8),
              Text(
                dayName,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: totalExercises > 0 ? completedExercises / totalExercises : 0,
              minHeight: 8,
              backgroundColor: cs.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$completedExercises از $totalExercises تمرین کامل شد',
            style: context.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
