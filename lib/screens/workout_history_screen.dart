import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exo/providers/workout_provider.dart';
import 'package:exo/models/workout_log.dart';
import 'package:exo/core/theme/app_theme.dart';
import 'package:exo/screens/shell_screen.dart';

class WorkoutHistoryScreen extends ConsumerWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(workoutNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('تاریخچه تمرینات')),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطا: $e')),
        data: (state) {
          final logs = state.workoutLogs;

          if (logs.isEmpty) {
            return _buildEmptyState(context, ref);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return _WorkoutLogCard(log: log);
            },
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
              'هنوز تمرینی ثبت نشده',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'پس از اتمام اولین تمرین، تاریخچه‌ات اینجا نمایش داده می‌شود.',
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
              label: const Text('شروع اولین تمرین'),
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

class _WorkoutLogCard extends StatelessWidget {
  final WorkoutLog log;

  const _WorkoutLogCard({required this.log});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                        label: '${log.exerciseCount} تمرین',
                      ),
                      const SizedBox(width: 12),
                      _InfoChip(
                        icon: Icons.repeat,
                        label: '${log.totalSets} ست',
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
                  '${log.totalDurationMinutes}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w200,
                    color: AppTheme.tealPrimary,
                    height: 1.1,
                  ),
                ),
                Text(
                  'دقیقه',
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
                        'انجام شد',
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
