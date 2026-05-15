/// ActiveWorkoutScreen - صفحه تمرین فعال
/// نسخه: ۱.۰
/// تاریخ: ۱۴۰۴/۰۲/۲۵
/// توضیح: تمام منطق در ActiveWorkoutProvider است، این فقط UI است

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/exercise.dart';
import '../providers/workout_provider.dart';
import '../providers/active_workout_provider.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  final int dayId;
  final String dayName;

  const ActiveWorkoutScreen({
    super.key,
    required this.dayId,
    required this.dayName,
  });

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  late ActiveWorkoutProvider _activeProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final workoutProvider = context.read<WorkoutProvider>();
      _activeProvider = ActiveWorkoutProvider(workoutProvider);
      _activeProvider.startWorkout(widget.dayId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.dayName),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _showExitDialog(context),
          ),
        ),
        body: Consumer<ActiveWorkoutProvider>(
          builder: (context, provider, _) {
            if (!provider.state.hasDay && provider.currentExercise == null) {
              if (provider.state.hasError) {
                return _buildErrorView(provider.state.errorMessage!);
              }
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.state.isAllDone) {
              return _buildDoneView(provider);
            }

            return _buildWorkoutView(provider);
          },
        ),
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('بازگشت'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoneView(ActiveWorkoutProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.celebration, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              '🎉 آفرین! تمرین با موفقیت انجام شد',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'تمرین روز ${widget.dayName} ثبت شد',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () => provider.finishWorkout().then((_) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }),
              icon: const Icon(Icons.check),
              label: const Text('ثبت و بازگشت'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutView(ActiveWorkoutProvider provider) {
    final exercise = provider.currentExercise;
    if (exercise == null) return const SizedBox.shrink();

    final state = provider.state;

    return Container(
      color: state.isResting ? Colors.blue.shade50 : null,
      child: Column(
        children: [
          if (state.isResting) _buildRestBanner(provider),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildExerciseCard(provider, exercise),
            ),
          ),
          _buildBottomControls(provider, exercise),
        ],
      ),
    );
  }

  Widget _buildRestBanner(ActiveWorkoutProvider provider) {
    final state = provider.state;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Text(
              '⏰ زمان استراحت',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              formatWorkoutTime(state.remainingRestSeconds),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: provider.skipRest,
              child: const Text(
                'رد کردن استراحت',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(ActiveWorkoutProvider provider, Exercise exercise) {
    final state = provider.state;

    return Column(
      children: [
        Icon(
          _getEquipmentIcon(exercise.equipment),
          size: 64,
          color: Colors.blueGrey,
        ),
        const SizedBox(height: 16),
        Text(
          exercise.name,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'تجهیزات: ${exercise.equipment}',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 32),
        _buildProgressIndicator(provider),
        const SizedBox(height: 32),
        if (exercise.isTimeBased)
          _buildTimerSection(provider)
        else
          _buildRepsSection(provider),
      ],
    );
  }

  Widget _buildProgressIndicator(ActiveWorkoutProvider provider) {
    final state = provider.state;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildProgressItem(
            icon: Icons.fitness_center,
            label: 'ست',
            value: '${state.currentSet}/${provider.currentExercise?.sets ?? 0}',
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          _buildProgressItem(
            icon: Icons.replay,
            label: 'تمرین',
            value:
                '${state.currentExerciseIndex + 1}/${provider.totalExercises}',
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueGrey, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTimerSection(ActiveWorkoutProvider provider) {
    final state = provider.state;

    return Column(
      children: [
        Text(
          formatWorkoutTime(state.remainingWorkoutSeconds),
          style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w200),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: provider.toggleTimer,
          icon: Icon(
            state.isWorkoutTimerRunning ? Icons.pause : Icons.play_arrow,
          ),
          label: Text(state.isWorkoutTimerRunning ? 'توقف' : 'شروع'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildRepsSection(ActiveWorkoutProvider provider) {
    final exercise = provider.currentExercise!;

    return Column(
      children: [
        Text(
          '${exercise.repsOrDuration}',
          style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w200),
        ),
        Text(
          'تکرار',
          style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: provider.finishSet,
          icon: const Icon(Icons.check),
          label: const Text('پایان ست'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls(
    ActiveWorkoutProvider provider,
    Exercise exercise,
  ) {
    final state = provider.state;
    final hasNextExercise =
        state.currentExerciseIndex + 1 < provider.totalExercises;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (hasNextExercise) ...[
              TextButton.icon(
                onPressed: provider.nextExercise,
                icon: const Icon(Icons.skip_next),
                label: const Text('رد کردن'),
              ),
              const Spacer(),
            ],
          ],
        ),
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('خروج از تمرین'),
        content: const Text('آیا مطمئن هستید؟ پیشرفت تمرین ذخیره نمی‌شود.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              _activeProvider.cancelWorkout();
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('خروج'),
          ),
        ],
      ),
    );
  }

  IconData _getEquipmentIcon(String equipment) {
    switch (equipment) {
      case 'وزن بدن':
        return Icons.directions_run;
      case 'دمبل':
      case 'هالتر':
        return Icons.fitness_center;
      case 'کش ورزشی':
        return Icons.linear_scale;
      case 'دستگاه':
        return Icons.precision_manufacturing;
      default:
        return Icons.fitness_center;
    }
  }
}
