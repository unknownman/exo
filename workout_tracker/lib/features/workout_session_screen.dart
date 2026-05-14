import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/providers/workout_providers.dart';
import '../data/models/exercise.dart';
import '../data/models/exercise_type.dart';
import '../data/models/exercise_history.dart';
import '../data/models/daily_log.dart';
import '../widgets/exercise_card.dart';
import '../widgets/day_progress_header.dart';
import '../widgets/set_timer_widget.dart';
import '../widgets/rest_timer_bottom_sheet.dart';
import '../widgets/exercise_media_preview.dart';

class WorkoutSessionScreen extends ConsumerStatefulWidget {
  final String programId;
  final String dayId;

  const WorkoutSessionScreen({
    super.key,
    required this.programId,
    required this.dayId,
  });

  @override
  ConsumerState<WorkoutSessionScreen> createState() =>
      _WorkoutSessionScreenState();
}

class _ExerciseState {
  int completedSets;
  String? notes;

  _ExerciseState({this.completedSets = 0, this.notes});

  bool get isComplete => completedSets > 0;
}

class _WorkoutSessionScreenState extends ConsumerState<WorkoutSessionScreen> {
  final _exerciseStates = <String, _ExerciseState>{};
  bool _isCompletingDay = false;

  int _completedSetCount(Exercise exercise) {
    final state = _exerciseStates[exercise.id];
    return state?.completedSets ?? 0;
  }

  bool _isExerciseComplete(Exercise exercise) {
    return _completedSetCount(exercise) >= exercise.sets;
  }

  bool get _allExercisesComplete {
    final programAsync = ref.watch(programDetailProvider(widget.programId));
    final program = programAsync.valueOrNull;
    if (program == null) return false;
    final day = program.days.where((d) => d.id == widget.dayId).firstOrNull;
    if (day == null) return false;
    return day.exercises.every(_isExerciseComplete);
  }

  Future<void> _startSet(Exercise exercise) async {
    final existing = _exerciseStates[exercise.id];
    final completedCount = existing?.completedSets ?? 0;

    final result = await Navigator.of(context).push<ExerciseResult>(
      MaterialPageRoute(
        builder: (_) => ExerciseExecutionScreen(
          exercise: exercise,
          completedSetsCount: completedCount,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _exerciseStates[exercise.id] = _ExerciseState(
          completedSets: result.completedCount,
          notes: result.notes,
        );
      });
      _autoSaveProgress(exercise, result.completedCount);
    }
  }

  Future<void> _autoSaveProgress(Exercise exercise, int completedCount) async {
    try {
      final repo = ref.read(workoutRepositoryProvider);
      final programAsync = ref.read(programDetailProvider(widget.programId));
      final program = programAsync.valueOrNull;
      if (program == null) return;
      final day = program.days.where((d) => d.id == widget.dayId).firstOrNull;
      if (day == null) return;

      final history = ExerciseHistory(
        exerciseId: exercise.id,
        completedSets: List.generate(completedCount, (i) => i + 1),
        completed: completedCount >= exercise.sets,
        date: DateTime.now(),
      );
      await repo.logExercise(widget.programId, widget.dayId, history);
      ref.invalidate(workoutProgressProvider(widget.programId));
    } catch (_) {}
  }

  Future<void> _completeDay() async {
    if (!_allExercisesComplete) return;
    setState(() => _isCompletingDay = true);
    try {
      final repo = ref.read(workoutRepositoryProvider);
      final programAsync = ref.read(programDetailProvider(widget.programId));
      final program = programAsync.valueOrNull;
      if (program == null) throw Exception('برنامه یافت نشد');

      final day =
          program.days.where((d) => d.id == widget.dayId).firstOrNull;
      if (day == null) throw Exception('روز یافت نشد');

      await repo.completeDay(widget.programId, day.order);

      final completedExercises = <ExerciseHistory>[];
      for (final ex in day.exercises) {
        final state = _exerciseStates[ex.id];
        if (state != null && state.completedSets > 0) {
          completedExercises.add(ExerciseHistory(
            exerciseId: ex.id,
            completedSets: List.generate(state.completedSets, (i) => i + 1),
            completed: state.completedSets >= ex.sets,
            date: DateTime.now(),
          ));
        }
      }

      if (completedExercises.isNotEmpty) {
        await repo.saveDailyLog(DailyLog(
          programId: widget.programId,
          dayId: widget.dayId,
          completedExercises: completedExercises,
        ));
      }

      ref.invalidate(programListProvider);
      ref.invalidate(programDetailProvider(widget.programId));
      ref.invalidate(workoutProgressProvider(widget.programId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('روز با موفقیت به اتمام رسید!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isCompletingDay = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final programAsync = ref.watch(programDetailProvider(widget.programId));

    return Scaffold(
      appBar: AppBar(
        title: Text(programAsync.valueOrNull?.days
                .where((d) => d.id == widget.dayId)
                .firstOrNull
                ?.dayName ?? 'تمرین'),
      ),
      body: programAsync.when(
        data: (program) {
          if (program == null) return const Center(child: Text('برنامه یافت نشد'));
          final day =
              program.days.where((d) => d.id == widget.dayId).firstOrNull;
          if (day == null) return const Center(child: Text('روز یافت نشد'));

          final totalExercises = day.exercises.length;
          final completedExercisesCount =
              day.exercises.where(_isExerciseComplete).length;

          return Column(
            children: [
              DayProgressHeader(
                dayName: day.dayName,
                completedExercises: completedExercisesCount,
                totalExercises: totalExercises,
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: day.exercises.length + 1,
                  itemBuilder: (context, index) {
                    if (index == day.exercises.length) {
                      return const SizedBox(height: 80);
                    }
                    final exercise = day.exercises[index];
                    final completedSets = _completedSetCount(exercise);
                    return ExerciseCard(
                      exercise: exercise,
                      completedSets: completedSets,
                      onStartSet: () => _startSet(exercise),
                      onViewMedia: () => ExerciseMediaPreview.show(
                        context,
                        imageUrl: exercise.imageUrl,
                        videoUrl: exercise.videoUrl,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('خطا: $error')),
      ),
      floatingActionButton: programAsync.valueOrNull != null &&
              _allExercisesComplete
          ? Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 64,
                child: FilledButton.icon(
                  onPressed: _isCompletingDay ? null : _completeDay,
                  icon: _isCompletingDay
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_circle),
                  label: const Text('اتمام روز'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ExerciseResult {
  final int completedCount;
  final String? notes;

  ExerciseResult({required this.completedCount, this.notes});
}

class ExerciseExecutionScreen extends StatefulWidget {
  final Exercise exercise;
  final int completedSetsCount;

  const ExerciseExecutionScreen({
    super.key,
    required this.exercise,
    required this.completedSetsCount,
  });

  @override
  State<ExerciseExecutionScreen> createState() =>
      _ExerciseExecutionScreenState();
}

enum _ExecPhase { ready, exercising, rest, allComplete }

class _ExerciseExecutionScreenState extends State<ExerciseExecutionScreen> {
  late int _currentSet;
  late List<bool> _setCompleted;
  _ExecPhase _phase = _ExecPhase.ready;
  final _notesController = TextEditingController();
  bool _timerRunning = false;

  Exercise get _exercise => widget.exercise;
  bool get _isTimed => _exercise.type == ExerciseType.timed;

  @override
  void initState() {
    super.initState();
    _currentSet = widget.completedSetsCount;
    _setCompleted =
        List.generate(_exercise.sets, (i) => i < widget.completedSetsCount);
    if (_currentSet >= _exercise.sets) {
      _phase = _ExecPhase.allComplete;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _startSet() {
    setState(() {
      _phase = _ExecPhase.exercising;
      _timerRunning = _isTimed;
    });
  }

  void _onTimedComplete() {
    if (!mounted) return;
    setState(() => _timerRunning = false);
    _completeSet();
  }

  void _completeSet() {
    setState(() {
      _setCompleted[_currentSet] = true;
    });

    if (_currentSet + 1 >= _exercise.sets) {
      _finishExercise();
      return;
    }

    _startRest();
  }

  Future<void> _startRest() async {
    setState(() {
      _phase = _ExecPhase.rest;
      _currentSet++;
    });

    final skipped = await showRestTimerBottomSheet(
      context,
      restSeconds: _exercise.restSeconds,
    );

    if (!mounted) return;

    if (skipped) {
      _nextSet();
    } else {
      _nextSet();
    }
  }

  void _nextSet() {
    setState(() => _phase = _ExecPhase.ready);
  }

  void _finishExercise() {
    setState(() => _phase = _ExecPhase.allComplete);
  }

  void _done() {
    final completedCount = _setCompleted.where((c) => c).length;
    final notes = _notesController.text.trim();
    Navigator.of(context).pop(ExerciseResult(
      completedCount: completedCount,
      notes: notes.isNotEmpty ? notes : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_exercise.name),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _done(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              if (_phase != _ExecPhase.allComplete) ...[
                _SetProgressBar(
                  totalSets: _exercise.sets,
                  setCompleted: _setCompleted,
                  currentSet: _currentSet,
                ),
                const SizedBox(height: 32),
                Expanded(child: _buildPhaseContent(cs)),
              ] else
                Expanded(child: _buildCompleteView(cs)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseContent(ColorScheme cs) {
    switch (_phase) {
      case _ExecPhase.ready:
        return _buildReadyPhase(cs);
      case _ExecPhase.exercising:
        return _buildExercisingPhase(cs);
      case _ExecPhase.rest:
        return const SizedBox.shrink();
      case _ExecPhase.allComplete:
        return _buildCompleteView(cs);
    }
  }

  Widget _buildReadyPhase(ColorScheme cs) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: cs.primaryContainer,
          child: Icon(
            _isTimed ? Icons.timer : Icons.fitness_center,
            size: 40,
            color: cs.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'ست ${_currentSet + 1} از ${_exercise.sets}',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          _isTimed
              ? '${_exercise.durationSeconds ?? 0} ثانیه تمرین'
              : '${_exercise.reps ?? 0} تکرار',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.icon(
            onPressed: _startSet,
            icon: const Icon(Icons.play_arrow, size: 28),
            label: Text(
              _isTimed ? 'شروع تمرین' : 'شروع ست',
              style: const TextStyle(fontSize: 18),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: cs.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExercisingPhase(ColorScheme cs) {
    if (_isTimed) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ست ${_currentSet + 1} از ${_exercise.sets}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
          ),
          const SizedBox(height: 24),
          SetTimerWidget(
            durationSeconds: _exercise.durationSeconds ?? 0,
            isRunning: _timerRunning,
            onComplete: _onTimedComplete,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() => _timerRunning = false);
                _completeSet();
              },
              icon: const Icon(Icons.skip_next),
              label: const Text('رد کردن'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ست ${_currentSet + 1} از ${_exercise.sets}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
        ),
        const SizedBox(height: 16),
        CircleAvatar(
          radius: 52,
          backgroundColor: cs.primaryContainer,
          child: Text(
            '${_exercise.reps ?? 0}',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onPrimaryContainer,
                ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'تکرار',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.icon(
            onPressed: _completeSet,
            icon: const Icon(Icons.check, size: 28),
            label: const Text('ست تمام شد', style: TextStyle(fontSize: 18)),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompleteView(ColorScheme cs) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, size: 80, color: Colors.green.shade400),
        const SizedBox(height: 16),
        Text(
          'تمرین کامل شد!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade600,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_setCompleted.where((c) => c).length} از ${_exercise.sets} ست انجام شد',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: 'یادداشت (اختیاری)',
              hintText: 'مثال: وزن استفاده شده، سختی تمرین، ...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.notes),
            ),
            maxLines: 3,
            textDirection: TextDirection.rtl,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton.icon(
            onPressed: _done,
            icon: const Icon(Icons.arrow_back),
            label: const Text('برگشت به تمرینات', style: TextStyle(fontSize: 16)),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SetProgressBar extends StatelessWidget {
  final int totalSets;
  final List<bool> setCompleted;
  final int currentSet;

  const _SetProgressBar({
    required this.totalSets,
    required this.setCompleted,
    required this.currentSet,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalSets, (i) {
            final isActive = i == currentSet;
            final isDone = i < setCompleted.length && setCompleted[i];
            return Container(
              margin: EdgeInsets.only(left: i < totalSets - 1 ? 8 : 0),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isActive ? 40 : 32,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDone
                          ? Colors.green
                          : isActive
                              ? cs.primary
                              : cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ست ${i + 1}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isActive
                          ? cs.primary
                          : cs.onSurface.withValues(alpha: 0.4),
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
