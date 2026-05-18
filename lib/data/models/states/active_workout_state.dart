import 'package:flutter/foundation.dart';
import '../../../models/exercise.dart';

@immutable
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
  final String? snapshotRestoredMessage;

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
    this.snapshotRestoredMessage,
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
    String? snapshotRestoredMessage,
    bool clearError = false,
    bool clearDay = false,
    bool clearNextSnapshot = false,
    bool clearSnapshotMessage = false,
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
      snapshotRestoredMessage: clearSnapshotMessage
          ? null
          : (snapshotRestoredMessage ?? this.snapshotRestoredMessage),
    );
  }
}
