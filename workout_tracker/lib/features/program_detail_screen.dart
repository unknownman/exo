import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/extensions.dart';
import '../data/providers/workout_providers.dart';
import '../data/models/exercise.dart';

class ProgramDetailScreen extends ConsumerWidget {
  final String programId;

  const ProgramDetailScreen({
    super.key,
    required this.programId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programAsync = ref.watch(programDetailProvider(programId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('جزئیات برنامه'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'ویرایش برنامه',
            onPressed: () => context.go('/edit-program/$programId'),
          ),
        ],
      ),
      body: programAsync.when(
        data: (program) {
          if (program == null) {
            return const Center(child: Text('برنامه یافت نشد'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                program.name,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${program.days.length} روز • ${program.days.fold(0, (int sum, d) => sum + d.exercises.length)} حرکت',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 24),
              ...program.days.map(
                (day) => _DaySection(programId: program.id, day: day),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('خطا: $error')),
      ),
    );
  }
}

class _DaySection extends StatelessWidget {
  final String programId;
  final dynamic day;

  const _DaySection({required this.programId, required this.day});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.today,
                  size: 18,
                  color: context.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  day.dayName,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () =>
                      context.go('/workout/$programId/${day.id}'),
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: const Text('شروع'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...day.exercises.asMap().entries.map((entry) {
              final exercise = entry.value as Exercise;
              final index = entry.key;
              return _ExerciseTile(
                index: index + 1,
                exercise: exercise,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final int index;
  final Exercise exercise;

  const _ExerciseTile({
    required this.index,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: context.colorScheme.primaryContainer,
            child: Text(
              '$index',
              style: TextStyle(
                color: context.colorScheme.onPrimaryContainer,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _exerciseDetail(exercise),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          if (exercise.equipment != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: context.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                exercise.equipment!,
                style: TextStyle(
                  fontSize: 11,
                  color: context.colorScheme.onTertiaryContainer,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _exerciseDetail(Exercise e) {
    final parts = <String>[];
    parts.add('${e.sets} ست');
    if (e.type.index == 0 && e.reps != null) {
      parts.add('${e.reps} تکرار');
    } else if (e.type.index == 1 && e.durationSeconds != null) {
      parts.add('${e.durationSeconds} ثانیه');
    }
    parts.add('${e.restSeconds}ث استراحت');
    return parts.join(' • ');
  }
}
