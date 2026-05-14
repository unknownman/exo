import 'package:flutter/material.dart';
import '../core/extensions.dart';
import '../data/models/exercise.dart';
import '../data/models/exercise_type.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final int completedSets;
  final VoidCallback onStartSet;
  final VoidCallback onViewMedia;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.completedSets,
    required this.onStartSet,
    required this.onViewMedia,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final allSetsComplete = completedSets >= exercise.sets;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: allSetsComplete
                      ? Colors.green.withValues(alpha: 0.2)
                      : cs.primaryContainer,
                  child: Icon(
                    allSetsComplete ? Icons.check : Icons.fitness_center,
                    size: 16,
                    color: allSetsComplete ? Colors.green : cs.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (exercise.equipment != null && exercise.equipment!.isNotEmpty)
                        Text(
                          exercise.equipment!,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                    ],
                  ),
                ),
                if (exercise.imageUrl != null || exercise.videoUrl != null)
                  GestureDetector(
                    onTap: onViewMedia,
                    child: _MediaThumbnail(exercise: exercise, cs: cs),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                _chip(
                  context,
                  Icons.repeat,
                  '${exercise.sets} ست × ${exercise.type == ExerciseType.reps ? '${exercise.reps ?? "-"} تکرار' : '${exercise.durationSeconds ?? 0}ث'}',
                ),
                _chip(context, Icons.hourglass_bottom, _formatRest(exercise.restSeconds)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ...List.generate(exercise.sets, (i) {
                  final done = i < completedSets;
                  return Container(
                    width: 24,
                    height: 6,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: done ? Colors.green : cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
                const Spacer(),
                Text(
                  '$completedSets/${exercise.sets} ست',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  onPressed: onStartSet,
                  icon: Icon(
                    allSetsComplete
                        ? Icons.check_circle
                        : completedSets > 0
                            ? Icons.play_arrow
                            : Icons.fitness_center,
                    size: 18,
                  ),
                  label: Text(
                    allSetsComplete
                        ? 'کامل شد'
                        : completedSets > 0
                            ? 'ادامه'
                            : 'شروع ست',
                    style: const TextStyle(fontSize: 13),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: Size.zero,
                    visualDensity: VisualDensity.compact,
                    backgroundColor:
                        allSetsComplete ? Colors.green.withValues(alpha: 0.15) : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, IconData icon, String label) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: cs.primary),
          const SizedBox(width: 4),
          Text(label, style: context.textTheme.labelSmall?.copyWith(color: cs.onSurface)),
        ],
      ),
    );
  }

  String _formatRest(int seconds) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    if (min > 0) {
      return '$min:${sec.toString().padLeft(2, '0')} استراحت';
    }
    return '$sec ث استراحت';
  }
}

class _MediaThumbnail extends StatelessWidget {
  final Exercise exercise;
  final ColorScheme cs;

  const _MediaThumbnail({required this.exercise, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        image: exercise.imageUrl != null
            ? DecorationImage(
                image: NetworkImage(exercise.imageUrl!),
                fit: BoxFit.cover,
                onError: (_, _) {},
              )
            : null,
      ),
      child: exercise.videoUrl != null
          ? Icon(Icons.play_circle_fill, color: Colors.white.withValues(alpha: 0.9), size: 28)
          : null,
    );
  }
}
