import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exo/models/exercise.dart';
import 'package:exo/providers/active_workout_provider.dart';
import 'package:exo/providers/workout_provider.dart';

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  final int dayId;
  final String dayName;

  const ActiveWorkoutScreen({
    super.key,
    required this.dayId,
    required this.dayName,
  });

  @override
  ConsumerState<ActiveWorkoutScreen> createState() =>
      _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initWorkout();
      });
    }
  }

  void _initWorkout() {
    final workoutStateAsync = ref.read(workoutNotifierProvider);
    final workoutState = workoutStateAsync.valueOrNull;
    if (workoutState == null) return;
    final day = workoutState.getDayById(widget.dayId);
    if (day != null) {
      ref.read(activeWorkoutNotifierProvider.notifier).startWorkout(day);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasDay = ref.watch(
      activeWorkoutNotifierProvider.select((s) => s.hasDay),
    );
    final currentExercise = ref.watch(
      activeWorkoutNotifierProvider.select((s) => s.currentExercise),
    );
    final hasError = ref.watch(
      activeWorkoutNotifierProvider.select((s) => s.hasError),
    );
    final errorMessage = ref.watch(
      activeWorkoutNotifierProvider.select((s) => s.errorMessage),
    );
    final isAllDone = ref.watch(
      activeWorkoutNotifierProvider.select((s) => s.isAllDone),
    );

    if (!hasDay && currentExercise == null) {
      if (hasError) {
        return _buildErrorView(errorMessage!);
      }
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (isAllDone) {
      return _buildDoneView();
    }

    return _buildWorkoutView();
  }

  Widget _buildErrorView(String message) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.dayName)),
        body: Center(
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
        ),
      ),
    );
  }

  Widget _buildDoneView() {
    final provider = ref.read(activeWorkoutNotifierProvider.notifier);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.dayName)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.celebration, size: 80, color: Colors.green),
                const SizedBox(height: 24),
                const Text(
                  'آفرین! تمرین با موفقیت انجام شد',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'تمرین ${widget.dayName} ثبت شد',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 48),
                ElevatedButton.icon(
                  onPressed: () async {
                    final dayId = ref.read(activeWorkoutNotifierProvider).dayId;
                    final navigator = Navigator.of(context);
                    if (dayId != null) {
                      await ref
                          .read(workoutNotifierProvider.notifier)
                          .completeDay(dayId);
                    }
                    provider.finishWorkout();
                    navigator.popUntil((route) => route.isFirst);
                  },
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
        ),
      ),
    );
  }

  Widget _buildWorkoutView() {
    final state = ref.watch(activeWorkoutNotifierProvider);
    final provider = ref.read(activeWorkoutNotifierProvider.notifier);
    final exercise = state.currentExercise;

    if (exercise == null) return const SizedBox.shrink();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.dayName),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _showExitDialog(provider),
          ),
        ),
        body: Container(
          color: state.isResting ? Colors.blue.shade50 : null,
          child: Column(
            children: [
              if (state.isResting) _buildRestBanner(state, provider),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _buildExerciseCard(state, provider, exercise),
                ),
              ),
              _buildBottomControls(state, provider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestBanner(
    ActiveWorkoutState state,
    ActiveWorkoutNotifier provider,
  ) {
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
              'زمان استراحت',
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

  Widget _buildExerciseCard(
    ActiveWorkoutState state,
    ActiveWorkoutNotifier provider,
    Exercise exercise,
  ) {
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
        _buildProgressIndicator(state),
        const SizedBox(height: 32),
        if (exercise.isTimeBased)
          _buildTimerSection(state, provider)
        else
          _buildRepsSection(provider),
      ],
    );
  }

  Widget _buildProgressIndicator(ActiveWorkoutState state) {
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
            value: '${state.currentSet}/${state.currentExercise?.sets ?? 0}',
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          _buildProgressItem(
            icon: Icons.replay,
            label: 'تمرین',
            value: '${state.currentExerciseIndex + 1}/${state.totalExercises}',
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

  Widget _buildTimerSection(
    ActiveWorkoutState state,
    ActiveWorkoutNotifier provider,
  ) {
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

  Widget _buildRepsSection(ActiveWorkoutNotifier provider) {
    final exercise = ref.read(activeWorkoutNotifierProvider).currentExercise;
    if (exercise == null) return const SizedBox.shrink();

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
    ActiveWorkoutState state,
    ActiveWorkoutNotifier provider,
  ) {
    final hasNextExercise =
        state.currentExerciseIndex + 1 < state.totalExercises;

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

  void _showExitDialog(ActiveWorkoutNotifier provider) {
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
              provider.cancelWorkout();
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
