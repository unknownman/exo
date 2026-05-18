export '../data/models/states/active_workout_state.dart';

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/workout_plan.dart';
import '../data/models/states/active_workout_state.dart';
import '../core/utils/logger.dart';
import '../core/utils/persian_digits.dart';
import 'workout_provider.dart';
import 'tts_provider.dart';
import 'music_provider.dart';
import 'storage_providers.dart';

part 'active_workout_provider.g.dart';

@Riverpod(keepAlive: true)
class ActiveWorkoutNotifier extends _$ActiveWorkoutNotifier {
  Timer? _timer;
  DateTime? _workoutStartTime;
  bool _midwayAnnounced = false;
  AppLifecycleListener? _lifecycleListener;
  DateTime? _lastBackgroundTime;

  @override
  ActiveWorkoutState build() {
    _lifecycleListener = AppLifecycleListener(
      onStateChange: _onLifecycleStateChange,
    );
    ref.onDispose(() {
      _lifecycleListener?.dispose();
      _stopTimer();
    });
    _restoreActiveWorkoutSnapshot();
    return ActiveWorkoutState.initial();
  }

  void _onLifecycleStateChange(AppLifecycleState appState) {
    if (appState == AppLifecycleState.paused || appState == AppLifecycleState.inactive) {
      _lastBackgroundTime = DateTime.now();
      _persistActiveWorkout();
    } else if (appState == AppLifecycleState.resumed) {
      if (_lastBackgroundTime != null) {
        final elapsed = DateTime.now().difference(_lastBackgroundTime!).inSeconds;
        _lastBackgroundTime = null;
        if (state.isResting && _timer != null && _timer!.isActive) {
          final newRemaining = state.remainingRestSeconds - elapsed;
          state = state.copyWith(remainingRestSeconds: newRemaining > 0 ? newRemaining : 0);
          if (newRemaining <= 0) {
            _stopTimer();
            _onRestEnd();
          }
        } else if (state.isTimedExerciseRunning && _timer != null && _timer!.isActive) {
          final newRemaining = state.remainingWorkoutSeconds - elapsed;
          state = state.copyWith(remainingWorkoutSeconds: newRemaining > 0 ? newRemaining : 0);
          if (newRemaining <= 0) {
            _stopTimer();
            _onTimedExerciseComplete();
          }
        }
      }
    }
  }

  void _restoreActiveWorkoutSnapshot() {
    try {
      final box = ref.read(snapshotBoxProvider);
      if (box.isNotEmpty) {
        final dayId = box.get('dayId') as String?;
        final currentExerciseIndex = box.get('currentExerciseIndex') as int?;
        final currentSet = box.get('currentSet') as int?;
        final remainingRestSeconds = box.get('remainingRestSeconds') as int?;
        final workoutStartTimeMs = box.get('workoutStartTime') as int?;
        
        if (dayId != null) {
          final workoutState = ref.read(workoutNotifierProvider).valueOrNull;
          if (workoutState != null) {
            final day = workoutState.getDayById(dayId);
              if (day != null) {
              _workoutStartTime = workoutStartTimeMs != null ? DateTime.fromMillisecondsSinceEpoch(workoutStartTimeMs) : null;
              state = state.copyWith(
                dayId: day.id,
                dayName: day.name,
                exercises: day.exercises,
                currentExerciseIndex: currentExerciseIndex ?? 0,
                currentSet: currentSet ?? 1,
                remainingRestSeconds: remainingRestSeconds ?? 0,
                isResting: (remainingRestSeconds ?? 0) > 0,
                isTimedExerciseRunning: false,
                isAllDone: false,
                clearError: true,
                snapshotRestoredMessage: 'تمرین ناتمام شما بازیابی شد.',
              );
              if ((remainingRestSeconds ?? 0) > 0) {
                _startRestTimer(remainingRestSeconds!);
              }
            }
          }
        }
      }
    } catch (e, st) {
      AppLogger.logError(e, st);
    }
  }

  Future<void> _persistActiveWorkout() async {
    if (state.dayId == null) return;
    try {
      final box = ref.read(snapshotBoxProvider);
      await box.put('dayId', state.dayId!);
      await box.put('currentExerciseIndex', state.currentExerciseIndex);
      await box.put('currentSet', state.currentSet);
      await box.put('remainingRestSeconds', state.remainingRestSeconds);
      if (_workoutStartTime != null) {
        await box.put('workoutStartTime', _workoutStartTime!.millisecondsSinceEpoch);
      }
    } catch (e, st) {
      AppLogger.logError(e, st);
    }
  }

  void clearSnapshotMessage() {
    state = state.copyWith(clearSnapshotMessage: true);
  }

  Future<void> clearActiveWorkoutSnapshot() async {
    try {
      final box = ref.read(snapshotBoxProvider);
      await box.clear();
    } catch (e, st) {
      AppLogger.logError(e, st);
    }
  }

  void startWorkout(WorkoutDay day) {
    if (day.exercises.isEmpty) {
      state = state.copyWith(
        errorMessage: 'هیچ تمرینی برای این روز تعریف نشده است',
      );
      return;
    }

    _workoutStartTime = DateTime.now();

    state = state.copyWith(
      dayId: day.id,
      dayName: day.name,
      exercises: day.exercises,
      currentExerciseIndex: 0,
      currentSet: 1,
      isResting: false,
      isTimedExerciseRunning: false,
      isAllDone: false,
      clearError: true,
    );

    ref.read(tTSServiceProvider.notifier).announceExerciseStart(
      day.exercises.first.name,
    );

    // Attempt background music — don't block workout if it fails
    try {
      ref.read(musicProviderProvider.notifier).playSavedTrack();
    } catch (e, st) {
      AppLogger.logError(e, st);
    }
  }

  void toggleTimer() {
    if (state.isTimedExerciseRunning) {
      _stopTimer();
      state = state.copyWith(isTimedExerciseRunning: false);
    } else {
      _startTimedExercise();
    }
  }

  void finishSet() {
    HapticFeedback.mediumImpact();
    _stopTimer();
    final exercise = state.currentExercise;
    if (exercise == null) return;

    if (exercise.isTimeBased && state.isTimedExerciseRunning) {
      return;
    }

    if (state.currentSet < exercise.sets) {
      ref.read(tTSServiceProvider.notifier).announceSetComplete(
        state.currentSet,
        exercise.sets,
      );
      _populateRestSnapshots();
      state = state.copyWith(
        currentSet: state.currentSet + 1,
        isResting: true,
        isTimedExerciseRunning: false,
        remainingWorkoutSeconds: 0,
        remainingRestSeconds: exercise.restTime,
        totalRestSeconds: exercise.restTime,
      );
      _startRestTimer(exercise.restTime);
    } else {
      ref.read(tTSServiceProvider.notifier).announceSetComplete(
        state.currentSet,
        exercise.sets,
      );
      nextExercise();
    }
  }

  void addRestTime(int seconds) {
    if (!state.isResting) return;
    final newRemaining = state.remainingRestSeconds + seconds;
    state = state.copyWith(
      remainingRestSeconds: newRemaining,
      totalRestSeconds: state.totalRestSeconds + seconds,
    );
  }

  void skipRest() {
    _stopTimer();
    state = state.copyWith(
      isResting: false,
      remainingRestSeconds: 0,
      clearNextSnapshot: true,
    );
    _onRestEnd();
  }

  void skipExercise() {
    _stopTimer();
    final exercise = state.currentExercise;
    if (exercise == null) {
      _completeWorkout();
      return;
    }

    state = state.copyWith(
      isResting: false,
      isTimedExerciseRunning: false,
      remainingWorkoutSeconds: 0,
    );

    if (state.currentSet < exercise.sets) {
      state = state.copyWith(currentSet: exercise.sets);
      _startRestTimer(exercise.restTime);
    } else {
      _moveToNextExercise();
    }
  }

  void _moveToNextExercise() {
    final exercises = state.exercises;
    if (exercises.isEmpty) {
      _completeWorkout();
      return;
    }

    final previousExercise = state.currentExercise;
    if (previousExercise != null) {
      ref.read(tTSServiceProvider.notifier).announceExerciseComplete(
        previousExercise.name,
      );
    }

    final nextIndex = state.currentExerciseIndex + 1;
    if (nextIndex < exercises.length) {
      state = state.copyWith(
        currentExerciseIndex: nextIndex,
        currentSet: 1,
        isResting: false,
        isTimedExerciseRunning: false,
        remainingWorkoutSeconds: 0,
        clearNextSnapshot: true,
      );
      ref.read(tTSServiceProvider.notifier).announceNextExercise(
        exercises[nextIndex].name,
      );
    } else {
      _completeWorkout();
    }
  }

  void nextExercise() {
    _moveToNextExercise();
  }

  Future<void> finishWorkout() async {
    _stopTimer();
    await clearActiveWorkoutSnapshot();
    await ref.read(musicProviderProvider.notifier).stop();
    state = ActiveWorkoutState.initial();
  }

  Future<void> cancelWorkout() async {
    _stopTimer();
    await clearActiveWorkoutSnapshot();
    await ref.read(musicProviderProvider.notifier).stop();
    state = ActiveWorkoutState.initial();
  }

  void _startRestTimer(int seconds) {
    ref.read(tTSServiceProvider.notifier).announceRestStart(
      seconds,
      nextExerciseName: state.nextExerciseSnapshot?.name,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingRestSeconds <= 0) {
        _stopTimer();
        _onRestEnd();
        return;
      }
      if (state.remainingRestSeconds <= 3 && state.remainingRestSeconds > 0) {
        HapticFeedback.lightImpact();
      }
      state = state.copyWith(
        remainingRestSeconds: state.remainingRestSeconds - 1,
      );
    });
  }

  void _populateRestSnapshots() {
    final nextIndex = state.currentExerciseIndex;
    final nextSet = state.currentSet + 1;
    final exercises = state.exercises;
    if (nextIndex < exercises.length) {
      state = state.copyWith(
        nextExerciseSnapshot: exercises[nextIndex],
        nextSetNumber: nextSet,
      );
    }
  }

  void _onRestEnd() {
    state = state.copyWith(
      isResting: false,
      clearNextSnapshot: true,
    );
    final exercise = state.currentExercise;
    if (exercise == null) {
      _completeWorkout();
      return;
    }
    if (exercise.isTimeBased) {
      _startTimedExercise();
    }
  }

  void _startTimedExercise() {
    _stopTimer();
    final exercise = state.currentExercise;
    if (exercise == null || !exercise.isTimeBased) return;

    _midwayAnnounced = false;
    final halfPoint = (exercise.repsOrDuration ~/ 2);

    state = state.copyWith(
      isTimedExerciseRunning: true,
      remainingWorkoutSeconds: exercise.repsOrDuration,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingWorkoutSeconds <= 0) {
        _stopTimer();
        _onTimedExerciseComplete();
        return;
      }
      if (!_midwayAnnounced &&
          state.remainingWorkoutSeconds == halfPoint &&
          halfPoint > 0) {
        _midwayAnnounced = true;
        ref.read(tTSServiceProvider.notifier).announceMidway();
      }
      state = state.copyWith(
        remainingWorkoutSeconds: state.remainingWorkoutSeconds - 1,
      );
    });
  }

  void _onTimedExerciseComplete() {
    final exercise = state.currentExercise;
    if (exercise == null) {
      _completeWorkout();
      return;
    }

    state = state.copyWith(isTimedExerciseRunning: false);

    if (state.currentSet < exercise.sets) {
      state = state.copyWith(currentSet: state.currentSet + 1);
      _startRestTimer(exercise.restTime);
    } else {
      nextExercise();
    }
  }

  void _completeWorkout() {
    HapticFeedback.heavyImpact();
    state = state.copyWith(
      isAllDone: true,
      isResting: false,
      isTimedExerciseRunning: false,
      clearNextSnapshot: true,
    );
    ref.read(tTSServiceProvider.notifier).announceWorkoutComplete();
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}

String formatWorkoutTime(int seconds) {
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final secs = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$secs'.toPersianDigits();
}
