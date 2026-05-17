import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/exercise.dart';
import '../models/workout_plan.dart';
import 'tts_provider.dart';
import 'music_provider.dart';

part 'active_workout_provider.g.dart';

@riverpod
class ActiveWorkoutNotifier extends _$ActiveWorkoutNotifier {
  Timer? _timer;
  DateTime? _workoutStartTime;
  bool _midwayAnnounced = false;

  @override
  ActiveWorkoutState build() {
    ref.onDispose(() {
      _stopTimer();
    });
    return ActiveWorkoutState.initial();
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
    } catch (_) {}
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

  void finishWorkout() {
    _stopTimer();
    ref.read(musicProviderProvider.notifier).stop();
    state = ActiveWorkoutState.initial();
  }

  void cancelWorkout() {
    _stopTimer();
    ref.read(musicProviderProvider.notifier).stop();
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

  int getWorkoutDurationMinutes() {
    if (_workoutStartTime == null) return 0;
    return DateTime.now().difference(_workoutStartTime!).inMinutes;
  }
}

class ActiveWorkoutState {
  final String? dayId;
  final String? dayName;
  final List<Exercise> exercises;
  final int currentExerciseIndex;
  final int currentSet;
  final bool isResting;
  final bool isTimedExerciseRunning;
  final int remainingWorkoutSeconds;
  final int remainingRestSeconds;
  final int totalRestSeconds;
  final bool isAllDone;
  final bool isLoading;
  final String? errorMessage;
  final Exercise? nextExerciseSnapshot;
  final int? nextSetNumber;

  const ActiveWorkoutState({
    this.dayId,
    this.dayName,
    this.exercises = const [],
    this.currentExerciseIndex = 0,
    this.currentSet = 1,
    this.isResting = false,
    this.isTimedExerciseRunning = false,
    this.remainingWorkoutSeconds = 0,
    this.remainingRestSeconds = 0,
    this.totalRestSeconds = 0,
    this.isAllDone = false,
    this.isLoading = false,
    this.errorMessage,
    this.nextExerciseSnapshot,
    this.nextSetNumber,
  });

  factory ActiveWorkoutState.initial() => const ActiveWorkoutState();

  bool get hasDay => dayId != null;
  bool get hasError => errorMessage != null;
  bool get canSkip => isResting || isTimedExerciseRunning;

  Exercise? get currentExercise {
    if (exercises.isEmpty) return null;
    return currentExerciseIndex < exercises.length
        ? exercises[currentExerciseIndex]
        : null;
  }

  int get totalExercises => exercises.length;
  int get totalSets => exercises.fold(0, (sum, e) => sum + e.sets);

  ActiveWorkoutState copyWith({
    String? dayId,
    String? dayName,
    List<Exercise>? exercises,
    int? currentExerciseIndex,
    int? currentSet,
    bool? isResting,
    bool? isTimedExerciseRunning,
    int? remainingWorkoutSeconds,
    int? remainingRestSeconds,
    int? totalRestSeconds,
    bool? isAllDone,
    bool? isLoading,
    String? errorMessage,
    Exercise? nextExerciseSnapshot,
    int? nextSetNumber,
    bool clearError = false,
    bool clearDay = false,
    bool clearNextSnapshot = false,
  }) {
    return ActiveWorkoutState(
      dayId: clearDay ? null : (dayId ?? this.dayId),
      dayName: clearDay ? null : (dayName ?? this.dayName),
      exercises: exercises ?? this.exercises,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      currentSet: currentSet ?? this.currentSet,
      isResting: isResting ?? this.isResting,
      isTimedExerciseRunning:
          isTimedExerciseRunning ?? this.isTimedExerciseRunning,
      remainingWorkoutSeconds:
          remainingWorkoutSeconds ?? this.remainingWorkoutSeconds,
      remainingRestSeconds: remainingRestSeconds ?? this.remainingRestSeconds,
      totalRestSeconds: totalRestSeconds ?? this.totalRestSeconds,
      isAllDone: isAllDone ?? this.isAllDone,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      nextExerciseSnapshot: clearNextSnapshot
          ? null
          : (nextExerciseSnapshot ?? this.nextExerciseSnapshot),
      nextSetNumber: clearNextSnapshot
          ? null
          : (nextSetNumber ?? this.nextSetNumber),
    );
  }
}

String formatWorkoutTime(int seconds) {
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final secs = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$secs';
}
