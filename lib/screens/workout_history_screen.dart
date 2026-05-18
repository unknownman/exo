import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exo/providers/workout_provider.dart';
import 'package:exo/providers/analytics_provider.dart';
import 'package:exo/models/workout_log.dart';
import 'package:exo/models/personal_record.dart';
import 'package:exo/domain/services/analytics_service.dart';
import 'package:exo/screens/exercise_analytics_screen.dart';
import 'package:exo/widgets/workout_calendar_widget.dart';
import 'package:exo/core/theme/app_theme.dart';
import 'package:exo/screens/shell_screen.dart';
import 'package:exo/core/constants/app_strings.dart';
import 'package:exo/core/utils/persian_digits.dart';

class WorkoutHistoryScreen extends ConsumerWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(workoutNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.workoutHistory)),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطا: $e')),
        data: (state) {
          final logs = state.workoutLogs;

          if (logs.isEmpty) {
            return _buildEmptyState(context, ref);
          }

          final service = AnalyticsService(logs);
          final weeklyFreq = service.workoutsThisWeek;
          final volumeChange = service.weeklyVolumeChangePercent;
          final workoutDays = service.workoutDaysMap;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _WeeklyInsightCards(
                weeklyFrequency: weeklyFreq,
                volumeChangePercent: volumeChange,
              ),
              const SizedBox(height: 12),
              WorkoutCalendarWidget(
                workoutDays: workoutDays,
                workoutsThisWeek: weeklyFreq,
              ),
              const SizedBox(height: 16),
              ...logs.map((log) => _WorkoutLogCard(log: log)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.tealPrimary.withAlpha(15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.fitness_center,
                size: 32,
                color: AppTheme.tealPrimary.withAlpha(150),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              AppStrings.noWorkoutLogged,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.historyEmptyHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(selectedTabProvider.notifier).state = 0;
              },
              icon: const Icon(Icons.play_arrow, size: 20),
              label: const Text(AppStrings.startFirstWorkout),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutLogCard extends ConsumerStatefulWidget {
  final WorkoutLog log;

  const _WorkoutLogCard({required this.log});

  @override
  ConsumerState<_WorkoutLogCard> createState() => _WorkoutLogCardState();
}

class _WorkoutLogCardState extends ConsumerState<_WorkoutLogCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final log = widget.log;
    final analytics = ref.watch(analyticsNotifierProvider);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.tealPrimary.withAlpha(20),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                log.formattedDate,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.tealPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (log.hasMedia)
                              Icon(
                                Icons.videocam,
                                size: 16,
                                color: Colors.grey.shade400,
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          log.dayName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _InfoChip(
                              icon: Icons.fitness_center,
                              label: '${log.exerciseCount.toPersian()} ${AppStrings.exercises}',
                            ),
                            const SizedBox(width: 12),
                            _InfoChip(
                              icon: Icons.repeat,
                              label: '${log.totalSets.toPersian()} ${AppStrings.set}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      Text(
                        log.totalDurationMinutes.toPersian(),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w200,
                          color: AppTheme.tealPrimary,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        AppStrings.minutes,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.tealPrimary.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check,
                              size: 12,
                              color: AppTheme.tealPrimary,
                            ),
                            SizedBox(width: 2),
                            Text(
                              AppStrings.completed,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.tealPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded && log.exercises.isNotEmpty)
            _buildExerciseDetails(log, analytics.bestLifts),
        ],
      ),
    );
  }

  Widget _buildExerciseDetails(WorkoutLog log, Map<String, PersonalRecord> bestLifts) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 4),
          ...log.exercises.map((perf) {
            final completedSets = perf.sets.where((s) => s.isCompleted).length;
            final best = bestLifts[perf.exerciseId];
            final isPR = best != null && perf.sets.any((s) =>
              s.isCompleted && s.weight > 0 && brzycki1RM(s.weight, s.reps) >= best.best1RM);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ExerciseAnalyticsScreen(
                      exerciseId: perf.exerciseId,
                      exerciseName: perf.exerciseName,
                    ),
                  ),
                ),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          perf.exerciseName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isPR)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.emoji_events, size: 12, color: Colors.amber.shade800),
                              const SizedBox(width: 2),
                              Text(
                                AppStrings.prBadge,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (perf.weightSummary.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            perf.weightSummary,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Text(
                        '${completedSets.toPersian()}/${perf.sets.length.toPersian()} ${AppStrings.set}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _WeeklyInsightCards extends StatelessWidget {
  final int weeklyFrequency;
  final double volumeChangePercent;

  const _WeeklyInsightCards({
    required this.weeklyFrequency,
    required this.volumeChangePercent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              const Icon(Icons.insights, size: 20, color: AppTheme.tealPrimary),
              const SizedBox(width: 8),
              Text(
                AppStrings.weeklySummary,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _InsightCard(
                icon: Icons.fitness_center,
                label: AppStrings.weeklyFrequency,
                value: weeklyFrequency.toPersian(),
                subtitle: AppStrings.workoutsInWeek,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InsightCard(
                icon: volumeChangePercent >= 0
                    ? Icons.trending_up
                    : Icons.trending_down,
                label: AppStrings.weeklyVolumeChange,
                value: '${volumeChangePercent.toStringAsFixed(0).toPersianDigits()}${AppStrings.percentSymbol}',
                subtitle: volumeChangePercent > 0
                    ? AppStrings.volumeUp
                    : volumeChangePercent < 0
                        ? AppStrings.volumeDown
                        : AppStrings.volumeSame,
                valueColor: volumeChangePercent > 0
                    ? Colors.green
                    : volumeChangePercent < 0
                        ? Colors.red
                        : Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color? valueColor;

  const _InsightCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22, color: valueColor ?? AppTheme.tealPrimary),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: valueColor ?? Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
