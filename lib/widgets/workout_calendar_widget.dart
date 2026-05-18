import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/persian_digits.dart';

class WorkoutCalendarWidget extends StatelessWidget {
  final Map<DateTime, int> workoutDays;
  final int workoutsThisWeek;

  const WorkoutCalendarWidget({
    super.key,
    required this.workoutDays,
    required this.workoutsThisWeek,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_month, size: 20, color: AppTheme.tealPrimary),
                const SizedBox(width: 8),
                Text(
                  AppStrings.consistencyCalendar,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.tealPrimary.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${workoutsThisWeek.toPersian()} ${AppStrings.workoutsInWeek}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.tealPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCalendarGrid(),
            const SizedBox(height: 12),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = endOfMonth.day;
    final startWeekday = startOfMonth.weekday;

    final dayNames = ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'];
    final maxSets = workoutDays.values.isEmpty
        ? 1
        : workoutDays.values.reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: dayNames.map((name) {
            return SizedBox(
              width: 32,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 0,
          runSpacing: 4,
          children: List.generate(42, (index) {
            final day = index - startWeekday + 1;
            if (day < 1 || day > daysInMonth) {
              return const SizedBox(width: 32, height: 32);
            }

            final date = DateTime(now.year, now.month, day);
            final sets = workoutDays[date] ?? 0;
            final isToday = day == now.day;
            final intensity = sets > 0 ? (sets / maxSets).clamp(0.1, 1.0) : 0.0;

            return Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.symmetric(horizontal: 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: sets > 0
                    ? AppTheme.tealPrimary.withAlpha((intensity * 200).toInt() + 55)
                    : null,
                shape: BoxShape.circle,
                border: isToday
                    ? Border.all(color: AppTheme.tealDark, width: 2)
                    : null,
              ),
              child: Text(
                day.toPersian(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  color: sets > 0 ? Colors.white : Colors.grey.shade600,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(Colors.grey.shade200, 'بدون تمرین'),
        const SizedBox(width: 8),
        _legendItem(AppTheme.tealPrimary.withAlpha(80), 'کم'),
        const SizedBox(width: 8),
        _legendItem(AppTheme.tealPrimary.withAlpha(150), 'متوسط'),
        const SizedBox(width: 8),
        _legendItem(AppTheme.tealPrimary, 'زیاد'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
