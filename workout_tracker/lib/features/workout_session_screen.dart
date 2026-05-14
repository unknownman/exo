import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/extensions.dart';
import '../data/providers/workout_providers.dart';
import '../data/models/exercise.dart';

class WorkoutSessionScreen extends ConsumerWidget {
  final String dayId;

  const WorkoutSessionScreen({super.key, required this.dayId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(currentWorkoutStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تمرین'),
      ),
      body: stateAsync.when(
        data: (state) {
          if (state == null) return const Center(child: Text('برنامه فعالی وجود ندارد'));

          final day = state.program.days.where((d) => d.id == dayId).firstOrNull;
          if (day == null) return const Center(child: Text('روز مورد نظر یافت نشد'));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day.dayName,
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${day.exercises.length} حرکت',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...day.exercises.asMap().entries.map((entry) {
                final exercise = entry.value;
                final index = entry.key;
                return _ExerciseSessionCard(
                  index: index + 1,
                  exercise: exercise,
                );
              }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('خطا: $error')),
      ),
    );
  }
}

class _ExerciseSessionCard extends StatelessWidget {
  final int index;
  final Exercise exercise;

  const _ExerciseSessionCard({
    required this.index,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: context.colorScheme.primaryContainer,
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: context.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    exercise.name,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (exercise.equipment != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      exercise.equipment!,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _infoChip(context, Icons.repeat, '${exercise.sets} ست'),
                const SizedBox(width: 8),
                if (exercise.type.index == 0 && exercise.reps != null)
                  _infoChip(context, Icons.exposure, '${exercise.reps} تکرار'),
                if (exercise.type.index == 1 && exercise.durationSeconds != null)
                  _infoChip(context, Icons.timer, '${exercise.durationSeconds}ث'),
                const SizedBox(width: 8),
                _infoChip(context, Icons.hourglass_bottom, '${exercise.restSeconds}ث استراحت'),
              ],
            ),
            if (exercise.notes != null && exercise.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  exercise.notes!,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: context.colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
