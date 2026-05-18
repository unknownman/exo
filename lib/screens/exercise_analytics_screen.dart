import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/analytics_provider.dart';
import '../domain/services/analytics_service.dart';
import '../models/personal_record.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/persian_digits.dart';

class ExerciseAnalyticsScreen extends ConsumerWidget {
  final String exerciseId;
  final String exerciseName;

  const ExerciseAnalyticsScreen({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.read(analyticsNotifierProvider.notifier)
        .getExerciseAnalytics(exerciseId);

    return Scaffold(
      appBar: AppBar(title: Text(exerciseName)),
      body: analytics.hasData
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PRCard(record: analytics.bestRecord),
                  const SizedBox(height: 24),
                  _SectionTitle(title: AppStrings.progressTrend),
                  const SizedBox(height: 16),
                  _WeightChart(points: analytics.weightProgress),
                  const SizedBox(height: 32),
                  _SectionTitle(title: AppStrings.volumeProgress),
                  const SizedBox(height: 16),
                  _VolumeChart(points: analytics.volumeProgress),
                  const SizedBox(height: 32),
                  _Estimated1RMCard(estimated: analytics.currentEstimated1RM),
                  const SizedBox(height: 16),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.noDataForChart,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _PRCard extends StatelessWidget {
  final PersonalRecord? record;
  const _PRCard({required this.record});

  @override
  Widget build(BuildContext context) {
    if (record == null) return const SizedBox.shrink();

    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  AppStrings.personalRecord,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _PRStat(
                  label: AppStrings.bestEstimated1RM,
                  value: '${record!.best1RM.toStringAsFixed(1).toPersianDigits()} ${AppStrings.kg}',
                ),
                const SizedBox(width: 24),
                _PRStat(
                  label: AppStrings.maxWeight,
                  value: '${record!.bestWeight.toStringAsFixed(1).toPersianDigits()} ${AppStrings.kg}',
                ),
                const SizedBox(width: 24),
                _PRStat(
                  label: AppStrings.reps,
                  value: record!.bestReps.toPersian(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _formatDate(record!.date),
              style: TextStyle(
                color: Colors.white.withAlpha(180),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'امروز';
    if (diff.inDays == 1) return 'دیروز';
    if (diff.inDays < 7) return '${diff.inDays.toPersian()} روز پیش';
    return '${date.year}/${date.month}/${date.day}';
  }
}

class _PRStat extends StatelessWidget {
  final String label;
  final String value;
  const _PRStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withAlpha(200),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _Estimated1RMCard extends StatelessWidget {
  final double estimated;
  const _Estimated1RMCard({required this.estimated});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.calculate, color: AppTheme.tealPrimary, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.estimated1RM,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  '${estimated.toStringAsFixed(1).toPersianDigits()} ${AppStrings.kg}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.tealPrimary,
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

class _WeightChart extends StatelessWidget {
  final List<ExerciseDataPoint> points;
  const _WeightChart({required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.weightProgress,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _calculateInterval(points),
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(0).toPersianDigits(),
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= points.length) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _shortDate(points[idx].date),
                              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: points.asMap().entries.map((e) =>
                        FlSpot(e.key.toDouble(), e.value.value)
                      ).toList(),
                      isCurved: true,
                      color: AppTheme.tealPrimary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: AppTheme.tealPrimary,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.tealPrimary.withAlpha(30),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final idx = spot.spotIndex;
                          final dateStr = idx < points.length
                              ? _shortDate(points[idx].date)
                              : '';
                          return LineTooltipItem(
                            '$dateStr\n${spot.y.toStringAsFixed(1).toPersianDigits()} ${AppStrings.kg}',
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateInterval(List<ExerciseDataPoint> pts) {
    if (pts.isEmpty) return 10;
    final maxVal = pts.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    if (maxVal <= 10) return 2;
    if (maxVal <= 50) return 10;
    if (maxVal <= 100) return 20;
    return (maxVal / 5).ceilToDouble();
  }

  String _shortDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'امروز';
    if (diff.inDays == 1) return 'دیروز';
    return '${date.month}/${date.day}';
  }
}

class _VolumeChart extends StatelessWidget {
  final List<ExerciseDataPoint> points;
  const _VolumeChart({required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.volumeProgress,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _calculateInterval(points),
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(0).toPersianDigits(),
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= points.length) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _shortDate(points[idx].date),
                              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: points.asMap().entries.map((e) =>
                        FlSpot(e.key.toDouble(), e.value.value)
                      ).toList(),
                      isCurved: true,
                      color: AppTheme.cyanAccent.withAlpha(200),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: AppTheme.cyanAccent,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.cyanAccent.withAlpha(25),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final idx = spot.spotIndex;
                          final dateStr = idx < points.length
                              ? _shortDate(points[idx].date)
                              : '';
                          return LineTooltipItem(
                            '$dateStr\n${spot.y.toStringAsFixed(0).toPersianDigits()} ${AppStrings.kg}',
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateInterval(List<ExerciseDataPoint> pts) {
    if (pts.isEmpty) return 100;
    final maxVal = pts.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    if (maxVal <= 100) return 20;
    if (maxVal <= 500) return 100;
    if (maxVal <= 2000) return 500;
    return (maxVal / 5).ceilToDouble();
  }

  String _shortDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'امروز';
    if (diff.inDays == 1) return 'دیروز';
    return '${date.month}/${date.day}';
  }
}
