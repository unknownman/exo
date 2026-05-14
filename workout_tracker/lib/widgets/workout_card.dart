import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/extensions.dart';
import '../data/models/workout_program.dart';

class ProgramCard extends StatelessWidget {
  final WorkoutProgram program;

  const ProgramCard({super.key, required this.program});

  int get _totalExercises =>
      program.days.fold(0, (sum, d) => sum + d.exercises.length);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go('/programs/${program.id}'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.name,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_view_week,
                          size: 14,
                          color: context.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${program.days.length} روز',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.fitness_center,
                          size: 14,
                          color: context.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$_totalExercises حرکت',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      program.createdAt.toFormattedDate(),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left),
            ],
          ),
        ),
      ),
    );
  }
}
