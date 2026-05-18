import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:exo/providers/music_provider.dart';
import 'package:exo/providers/weight_provider.dart';
import 'package:exo/models/body_weight_record.dart';
import 'package:exo/core/theme/app_theme.dart';
import 'package:exo/core/constants/app_strings.dart';
import 'package:exo/core/utils/persian_digits.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _weightController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _quickAddWeight() {
    final weight = double.tryParse(_weightController.text);
    if (weight == null || weight <= 0) return;
    ref.read(weightNotifierProvider.notifier).addRecord(
      weight,
      note: _noteController.text.trim(),
    );
    _weightController.clear();
    _noteController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(AppStrings.weightLogSaved),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final musicState = ref.watch(musicProviderProvider);
    final weightState = ref.watch(weightNotifierProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.profileTitle)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildWeightSection(weightState),
            const SizedBox(height: 16),
            _buildMusicSection(musicState),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightSection(WeightState weightState) {
    final records = weightState.sortedByDate;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.monitor_weight, color: AppTheme.tealPrimary),
                const SizedBox(width: 8),
                const Text(
                  AppStrings.bodyWeightTracking,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: AppStrings.weightLabel,
                      hintText: AppStrings.weightInputHint,
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _quickAddWeight,
                  child: const Text(AppStrings.quickAdd),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: AppStrings.weightNoteHint,
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            if (records.isNotEmpty) ...[
              const SizedBox(height: 20),
              SizedBox(
                height: 180,
                child: _WeightChart(records: records),
              ),
              const SizedBox(height: 16),
              ...records.take(10).map((r) => _WeightRecordTile(
                record: r,
                onDelete: () => _confirmDelete(r),
              )),
            ] else ...[
              const SizedBox(height: 24),
              Center(
                child: Text(
                  AppStrings.weightLogEmpty,
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BodyWeightRecord record) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.weightLogDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(AppStrings.dismiss),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(weightNotifierProvider.notifier).deleteRecord(record.id);
              Navigator.of(ctx).pop();
            },
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicSection(MusicState musicState) {
    final provider = ref.read(musicProviderProvider.notifier);
    final trackName = provider.getSavedTrackName();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.music_note, color: AppTheme.tealPrimary),
                const SizedBox(width: 8),
                const Text(
                  AppStrings.backgroundMusic,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (trackName != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.audiotrack, size: 20, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        trackName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () => provider.clearBackgroundMusic(),
                      icon: const Icon(Icons.close, size: 18),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            OutlinedButton.icon(
              onPressed: () => provider.pickBackgroundMusic(),
              icon: const Icon(Icons.music_note_outlined),
              label: Text(
                trackName != null ? AppStrings.changeMusic : AppStrings.selectMusic,
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.supportedAudioFormats,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeightChart extends StatelessWidget {
  final List<BodyWeightRecord> records;
  const _WeightChart({required this.records});

  @override
  Widget build(BuildContext context) {
    final sorted = List.from(records)
      ..sort((a, b) => a.date.compareTo(b.date));

    if (sorted.length == 1) {
      final r = sorted.first;
      return Center(
        child: Text(
          '${r.weight.toStringAsFixed(1).toPersianDigits()} ${AppStrings.kg}',
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w200,
            color: AppTheme.tealPrimary,
          ),
        ),
      );
    }

    final weights = sorted.map((r) => r.weight).toList();
    final minY = weights.reduce((a, b) => a < b ? a : b) - 1;
    final maxY = weights.reduce((a, b) => a > b ? a : b) + 1;
    final range = maxY - minY;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: range > 10 ? 5 : 2,
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
                  value.toStringAsFixed(1).toPersianDigits(),
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: sorted.length > 6 ? (sorted.length / 5).ceilToDouble() : 1,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= sorted.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _shortDate(sorted[idx].date),
                    style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: sorted.asMap().entries.map((e) =>
              FlSpot(e.key.toDouble(), e.value.weight)
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
                final dateStr = idx < sorted.length
                    ? _shortDate(sorted[idx].date)
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
    );
  }

  String _shortDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return AppStrings.today;
    if (diff.inDays == 1) return 'دیروز';
    return '${date.month}/${date.day}';
  }
}

class _WeightRecordTile extends StatelessWidget {
  final BodyWeightRecord record;
  final VoidCallback onDelete;

  const _WeightRecordTile({required this.record, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(record.date);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${record.weight.toStringAsFixed(1).toPersianDigits()} ${AppStrings.kg}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (record.note.isNotEmpty)
                  Text(
                    record.note,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
              ],
            ),
          ),
          Text(
            dateStr,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 18, color: Colors.red.shade300),
            onPressed: onDelete,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return AppStrings.today;
    if (diff.inDays == 1) return 'دیروز';
    if (diff.inDays < 7) return '${diff.inDays.toPersian()} روز پیش';
    return '${date.year}/${date.month}/${date.day}';
  }
}
