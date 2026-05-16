import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/exercise.dart';
import '../models/workout_day.dart';

part 'active_workout_provider.g.dart';

@riverpod
class ActiveWorkoutNotifier extends _$ActiveWorkoutNotifier {
  Timer? _timer;

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

    state = state.copyWith(
      dayId: day.id,
      dayName: day.dayName,
      exercises: day.exercises,
      currentExerciseIndex: 0,
      currentSet: 1,
      isResting: false,
      isAllDone: false,
      clearError: true,
    );

    _resetWorkoutTimer();
  }

  void toggleTimer() {
    final exercise = state.currentExercise;
    if (exercise == null || !exercise.isTimeBased) return;

    if (state.isWorkoutTimerRunning) {
      _stopTimer();
      state = state.copyWith(isWorkoutTimerRunning: false);
    } else {
      _startWorkoutTimer();
    }
  }

  void finishSet() {
    _stopTimer();

    final exercise = state.currentExercise;
    if (exercise == null) return;

    if (state.currentSet < exercise.sets) {
      state = state.copyWith(currentSet: state.currentSet + 1);
      _resetWorkoutTimer();
    } else {
      nextExercise();
    }
  }

  void skipRest() {
    _stopTimer();
    _onRestEnd();
  }

  void nextExercise() {
    final exercises = state.exercises;

    if (exercises.isEmpty) {
      _completeWorkout();
      return;
    }

    final nextIndex = state.currentExerciseIndex + 1;
    if (nextIndex < exercises.length) {
      state = state.copyWith(
        currentExerciseIndex: nextIndex,
        currentSet: 1,
        isResting: false,
      );
      _resetWorkoutTimer();
    } else {
      _completeWorkout();
    }
  }

  void finishWorkout() {
    state = ActiveWorkoutState.initial();
  }

  void cancelWorkout() {
    _stopTimer();
    state = ActiveWorkoutState.initial();
  }

  void _resetWorkoutTimer() {
    final exercise = state.currentExercise;
    if (exercise == null || !exercise.isTimeBased) return;

    state = state.copyWith(
      remainingWorkoutSeconds: exercise.repsOrDuration,
      isWorkoutTimerRunning: false,
    );
  }

  void _startWorkoutTimer() {
    _stopTimer();

    state = state.copyWith(isWorkoutTimerRunning: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingWorkoutSeconds <= 0) {
        _stopTimer();
        _startRest();
        return;
      }

      state = state.copyWith(
        remainingWorkoutSeconds: state.remainingWorkoutSeconds - 1,
      );
    });
  }

  void _startRest() {
    final exercise = state.currentExercise;
    if (exercise == null) return;

    state = state.copyWith(
      isResting: true,
      isWorkoutTimerRunning: false,
      remainingRestSeconds: exercise.restTime,
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

  void _onRestEnd() {
    final exercise = state.currentExercise;
    if (exercise == null) {
      _completeWorkout();
      return;
    }

    state = state.copyWith(isResting: false);

    if (state.currentSet < exercise.sets) {
      state = state.copyWith(currentSet: state.currentSet + 1);
      _resetWorkoutTimer();
    } else {
      nextExercise();
    }
  }

  void _completeWorkout() {
    state = state.copyWith(isAllDone: true, isResting: false);
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}

class ActiveWorkoutState {
  final int? dayId;
  final String? dayName;
  final List<Exercise> exercises;
  final int currentExerciseIndex;
  final int currentSet;
  final bool isResting;
  final bool isWorkoutTimerRunning;
  final int remainingWorkoutSeconds;
  final int remainingRestSeconds;
  final bool isAllDone;
  final bool isLoading;
  final String? errorMessage;

  const ActiveWorkoutState({
    this.dayId,
    this.dayName,
    this.exercises = const [],
    this.currentExerciseIndex = 0,
    this.currentSet = 1,
    this.isResting = false,
    this.isWorkoutTimerRunning = false,
    this.remainingWorkoutSeconds = 0,
    this.remainingRestSeconds = 0,
    this.isAllDone = false,
    this.isLoading = false,
    this.errorMessage,
  });

  factory ActiveWorkoutState.initial() => const ActiveWorkoutState();

  bool get hasDay => dayId != null;

  bool get hasError => errorMessage != null;

  Exercise? get currentExercise {
    if (exercises.isEmpty) return null;
    final idx = currentExerciseIndex;
    return idx < exercises.length ? exercises[idx] : null;
  }

  int get totalExercises => exercises.length;

  ActiveWorkoutState copyWith({
    int? dayId,
    String? dayName,
    List<Exercise>? exercises,
    int? currentExerciseIndex,
    int? currentSet,
    bool? isResting,
    bool? isWorkoutTimerRunning,
    int? remainingWorkoutSeconds,
    int? remainingRestSeconds,
    bool? isAllDone,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool clearDay = false,
  }) {
    return ActiveWorkoutState(
      dayId: clearDay ? null : (dayId ?? this.dayId),
      dayName: clearDay ? null : (dayName ?? this.dayName),
      exercises: exercises ?? this.exercises,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      currentSet: currentSet ?? this.currentSet,
      isResting: isResting ?? this.isResting,
      isWorkoutTimerRunning:
          isWorkoutTimerRunning ?? this.isWorkoutTimerRunning,
      remainingWorkoutSeconds:
          remainingWorkoutSeconds ?? this.remainingWorkoutSeconds,
      remainingRestSeconds: remainingRestSeconds ?? this.remainingRestSeconds,
      isAllDone: isAllDone ?? this.isAllDone,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

String formatWorkoutTime(int seconds) {
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final secs = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$secs';
}
