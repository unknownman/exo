import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/extensions.dart';
import '../data/providers/workout_providers.dart';
import '../data/models/exercise.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(currentWorkoutStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Tracker'),
      ),
      body: stateAsync.when(
        data: (state) {
          if (state == null) {
            return _emptyState(context);
          }
          return _activeState(context, ref, state);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => _emptyState(context),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center_outlined,
            size: 80,
            color: context.colorScheme.primary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'برنامه فعالی وجود ندارد',
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'یک برنامه انتخاب کن یا برنامه جدید بساز',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.go('/programs'),
            icon: const Icon(Icons.fitness_center),
            label: const Text('مشاهده برنامه‌ها'),
          ),
        ],
      ),
    );
  }

  Widget _activeState(
      BuildContext context, WidgetRef ref, CurrentWorkoutState state) {
    final program = state.program;
    final progress = state.progress;
    final currentDay = state.currentDay;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.fitness_center,
                      color: context.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        program.name,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (progress != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress.progressPercent,
                      minHeight: 8,
                      backgroundColor: context.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${progress.completedDayIndices.length} از ${progress.totalDays} روز',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
                if (progress != null && progress.isComplete) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '🎉 برنامه کامل شد!',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (currentDay != null && !(progress?.isComplete ?? false)) ...[
          const SizedBox(height: 24),
          Text(
            'تمرین امروز',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.today,
                        size: 20,
                        color: context.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currentDay.dayName,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...currentDay.exercises.map((e) => _exerciseMiniTile(context, e)),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () =>
                        context.go('/workout/${currentDay.id}'),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('شروع تمرین امروز'),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        if (progress != null && !progress.isComplete)
          OutlinedButton.icon(
            onPressed: () => context.go('/programs'),
            icon: const Icon(Icons.list_alt),
            label: const Text('مشاهده همه روزها'),
          ),
      ],
    );
  }

  Widget _exerciseMiniTile(BuildContext context, Exercise e) {
    final detail = e.type.index == 0
        ? '${e.sets}×${e.reps ?? "—"}'
        : '${e.sets}×${e.durationSeconds ?? "—"}ث';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(Icons.fiber_manual_record, size: 8, color: context.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(e.name, style: context.textTheme.bodyMedium)),
          Text(detail, style: context.textTheme.bodySmall),
        ],
      ),
    );
  }
}
