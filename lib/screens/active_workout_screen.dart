import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exo/models/exercise.dart';
import 'package:exo/models/exercise_media.dart';
import 'package:exo/providers/active_workout_provider.dart';
import 'package:exo/providers/workout_provider.dart';
import 'package:exo/core/theme/app_theme.dart';
import 'package:exo/widgets/tts_toggle_button.dart';
import 'package:exo/widgets/exercise_media_widget.dart';
import 'package:exo/screens/rest_screen.dart';

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  final String dayId;

  const ActiveWorkoutScreen({super.key, required this.dayId});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() =>
      _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  bool _initialized = false;
  bool _showDescription = false;
  bool _isRestOpen = false;

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
    workoutStateAsync.when(
      data: (workoutState) {
        final day = workoutState.getDayById(widget.dayId);
        if (day != null) {
          ref.read(activeWorkoutNotifierProvider.notifier).startWorkout(day);
        }
      },
      loading: () {
        // Data still loading — retry after a short delay
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) _initWorkout();
        });
      },
      error: (_, _) {
        // Provider errored — nothing to start
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(
      activeWorkoutNotifierProvider.select((s) => s.isResting),
      (_, isResting) {
        if (isResting) {
          _isRestOpen = true;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const RestScreen(),
              fullscreenDialog: true,
            ),
          );
        } else if (_isRestOpen) {
          _isRestOpen = false;
          Navigator.of(context).pop();
        }
      },
    );

    final activeState = ref.watch(activeWorkoutNotifierProvider);
    final dayName = activeState.dayName ?? 'تمرین';

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
      return _buildDoneView(dayName);
    }

    return _buildWorkoutView(dayName);
  }

  Widget _buildErrorView(String message) {
    return Scaffold(
      appBar: AppBar(title: const Text('خطا')),
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
    );
  }

  Widget _buildDoneView(String dayName) {
    final provider = ref.read(activeWorkoutNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(dayName)),
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
                'تمرین $dayName ثبت شد',
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
    );
  }

  Widget _buildWorkoutView(String dayName) {
    final activeState = ref.watch(activeWorkoutNotifierProvider);
    final provider = ref.read(activeWorkoutNotifierProvider.notifier);
    final exercise = activeState.currentExercise;

    if (exercise == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: Text(dayName),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitDialog(provider),
        ),
        actions: const [TTSToggleButton()],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildExerciseCard(activeState, provider, exercise),
            ),
          ),
          _buildBottomControls(activeState, provider),
        ],
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

  Widget _buildExerciseCard(
    ActiveWorkoutState state,
    ActiveWorkoutNotifier provider,
    Exercise exercise,
  ) {
    return Column(
      children: [
        if (exercise.media.type != ExerciseMediaType.none)
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: double.infinity,
              height: 220,
              color: AppTheme.tealPrimary.withAlpha(8),
              child: ExerciseMediaWidget(
                media: exercise.media,
                width: double.infinity,
                height: 220,
                fit: BoxFit.contain,
              ),
            ),
          )
        else ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.tealPrimary.withAlpha(15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getEquipmentIcon(exercise.equipment),
              size: 56,
              color: AppTheme.tealPrimary,
            ),
          ),
        ],
        const SizedBox(height: 16),
        Text(
          exercise.name,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            exercise.equipment,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ),
        if (exercise.description.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildDescriptionSection(exercise.description),
        ],
        const SizedBox(height: 24),
        _buildProgressIndicator(state),
        const SizedBox(height: 24),
        if (exercise.isTimeBased)
          _buildTimerSection(state, provider)
        else
          _buildRepsSection(state, provider),
      ],
    );
  }

  Widget _buildDescriptionSection(String description) {
    return Column(
      children: [
        TextButton.icon(
          onPressed: () => setState(() => _showDescription = !_showDescription),
          icon: Icon(
            _showDescription ? Icons.expand_less : Icons.expand_more,
            size: 20,
          ),
          label: Text(
            _showDescription ? 'بستن توضیحات' : 'نحوه اجرا',
            style: const TextStyle(fontSize: 14),
          ),
        ),
        if (_showDescription)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
                height: 1.6,
              ),
              textAlign: TextAlign.right,
            ),
          ),
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
            state.isTimedExerciseRunning ? Icons.pause : Icons.play_arrow,
          ),
          label: Text(state.isTimedExerciseRunning ? 'توقف' : 'شروع'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildRepsSection(
    ActiveWorkoutState state,
    ActiveWorkoutNotifier provider,
  ) {
    final exercise = state.currentExercise;
    if (exercise == null) return const SizedBox.shrink();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          decoration: BoxDecoration(
            color: AppTheme.tealPrimary.withAlpha(25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                '${exercise.repsOrDuration}',
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.w200,
                  color: AppTheme.tealPrimary,
                ),
              ),
              Text(
                exercise.isTimeBased ? 'ثانیه' : 'تکرار',
                style: TextStyle(fontSize: 20, color: AppTheme.tealDark),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () => provider.finishSet(),
            icon: const Icon(Icons.check_circle, size: 28),
            label: const Text(
              'پایان ست',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.tealPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
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
    final isSkippingExercise = state.currentSet > 1 || state.isResting;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            TextButton.icon(
              onPressed: isSkippingExercise ? provider.skipExercise : null,
              icon: const Icon(Icons.skip_next),
              label: Text(isSkippingExercise ? 'رد کردن تمرین' : 'رد کردن'),
            ),
            const Spacer(),
            if (hasNextExercise)
              TextButton.icon(
                onPressed: provider.nextExercise,
                icon: const Icon(Icons.fast_forward),
                label: const Text('تمرین بعدی'),
              ),
          ],
        ),
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
