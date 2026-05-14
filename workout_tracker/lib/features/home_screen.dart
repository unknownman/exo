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
    final cs = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('ردیاب تمرین'),
        centerTitle: true,
      ),
      body: stateAsync.when(
        data: (state) {
          if (state == null || state.progress == null) {
            return _EmptyState(cs: cs);
          }
          if (state.progress!.isComplete) {
            return _ProgramCompleteState(cs: cs, state: state);
          }
          return _ActiveState(cs: cs, state: state);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => _ErrorState(cs: cs, error: error),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ColorScheme cs;
  const _EmptyState({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center_outlined,
              size: 80,
              color: cs.primary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'برنامه فعالی وجود ندارد',
              style: context.textTheme.titleMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'یک برنامه انتخاب کن یا برنامه جدید بساز',
              style: context.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.4),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go('/programs'),
              icon: const Icon(Icons.fitness_center),
              label: const Text('مشاهده برنامه‌ها'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final ColorScheme cs;
  final Object error;
  const _ErrorState({required this.cs, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: cs.error),
            const SizedBox(height: 16),
            Text(
              'خطا در بارگذاری',
              style: context.textTheme.titleMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              style: context.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.4),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgramCompleteState extends StatelessWidget {
  final ColorScheme cs;
  final CurrentWorkoutState state;
  const _ProgramCompleteState({required this.cs, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(Icons.emoji_events, size: 64, color: Colors.amber),
                const SizedBox(height: 16),
                Text(
                  'تبریک!',
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'برنامه "${state.program.name}" با موفقیت کامل شد',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () => context.go('/history'),
                  icon: const Icon(Icons.history),
                  label: const Text('مشاهده تاریخچه'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActiveState extends StatelessWidget {
  final ColorScheme cs;
  final CurrentWorkoutState state;
  const _ActiveState({required this.cs, required this.state});

  @override
  Widget build(BuildContext context) {
    final program = state.program;
    final progress = state.progress!;
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
                    Icon(Icons.fitness_center, color: cs.primary),
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress.progressPercent,
                    minHeight: 8,
                    backgroundColor: cs.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${progress.completedDayIndices.length} از ${progress.totalDays} روز',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    Text(
                      '${(progress.progressPercent * 100).toInt()}%',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (currentDay != null) ...[
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
                      Icon(Icons.today, size: 20, color: cs.primary),
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
                  ...currentDay.exercises.map(
                    (e) => _exerciseMiniTile(context, e),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => context.go(
                      '/workout/${program.id}/${currentDay.id}',
                    ),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('شروع تمرین امروز'),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        if (!progress.isComplete)
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
        ? '${e.sets}×${e.reps ?? "--"}'
        : '${e.sets}×${e.durationSeconds ?? "--"}ث';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(Icons.fiber_manual_record,
              size: 8, color: context.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(e.name, style: context.textTheme.bodyMedium)),
          Text(detail, style: context.textTheme.bodySmall),
        ],
      ),
    );
  }
}
