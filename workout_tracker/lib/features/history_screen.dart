import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/extensions.dart';
import '../data/providers/workout_providers.dart';
import '../data/models/workout_program.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(programListProvider);
    final cs = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تاریخچه'),
      ),
      body: programsAsync.when(
        data: (programs) {
          if (programs.isEmpty) {
            return _emptyState(context, cs);
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'برنامه‌های اخیر',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...programs.map((p) => _ProgramHistoryCard(
                    program: p,
                    cs: cs,
                  )),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _errorState(context, cs, error),
      ),
    );
  }

  Widget _emptyState(BuildContext context, ColorScheme cs) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80,
              color: cs.primary.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text(
            'هنوز تمرینی ثبت نشده',
            style: context.textTheme.titleMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'بعد از اولین تمرینت، تاریخچه اینجا نمایش داده می‌شه',
            style: context.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _errorState(BuildContext context, ColorScheme cs, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: cs.error),
            const SizedBox(height: 16),
            Text(
              'خطا در بارگذاری تاریخچه',
              style: context.textTheme.titleMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgramHistoryCard extends StatelessWidget {
  final WorkoutProgram program;
  final ColorScheme cs;

  const _ProgramHistoryCard({
    required this.program,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final totalExercises =
        program.days.fold(0, (int s, d) => s + d.exercises.length);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: cs.primaryContainer,
          child: Icon(Icons.fitness_center, color: cs.onPrimaryContainer),
        ),
        title: Text(
          program.name,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${program.days.length} روز • $totalExercises حرکت',
          style: context.textTheme.bodySmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
        children: [
          ...program.days.map((day) => _DayHistoryTile(
                dayName: day.dayName,
                exerciseCount: day.exercises.length,
                cs: cs,
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Text(
              'ساخته شده در ${program.createdAt.toFormattedDate()}',
              style: context.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayHistoryTile extends StatelessWidget {
  final String dayName;
  final int exerciseCount;
  final ColorScheme cs;

  const _DayHistoryTile({
    required this.dayName,
    required this.exerciseCount,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(Icons.today, size: 18, color: cs.primary),
      title: Text(dayName, style: context.textTheme.bodyMedium),
      trailing: Text(
        '$exerciseCount تمرین',
        style: context.textTheme.bodySmall?.copyWith(
          color: cs.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
