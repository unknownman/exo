import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../models/exercise.dart';
import '../../../models/exercise_media.dart';
import '../../../models/workout_log.dart';
import '../../../models/workout_plan.dart';
import '../app_database.dart';
import 'exercise_mapper.dart';

final _uuid = const Uuid();

// ---------------------------------------------------------------------------
// WorkoutPlan mapper
// ---------------------------------------------------------------------------

WorkoutPlan planFromData({
  required WorkoutPlanData plan,
  required List<WorkoutDayData> days,
  required List<List<WorkoutDayExerciseData>> dayExercises,
}) {
  final mappedDays = <WorkoutDay>[];
  for (var i = 0; i < days.length; i++) {
    final day = days[i];
    final exercises = i < dayExercises.length
        ? dayExercises[i].map(_dayExerciseToDomain).toList()
        : <Exercise>[];
    mappedDays.add(WorkoutDay(
      id: day.id,
      name: day.name,
      orderIndex: day.orderIndex,
      exercises: exercises,
    ));
  }

  return WorkoutPlan(
    id: plan.id,
    name: plan.name,
    description: plan.description,
    days: mappedDays,
    createdAt: plan.createdAt,
    updatedAt: plan.updatedAt,
    isActive: plan.isActive,
    isSynced: plan.isSynced,
  );
}

WorkoutPlanData planToData(WorkoutPlan domain) {
  return WorkoutPlanData(
    id: domain.id,
    name: domain.name,
    description: domain.description,
    createdAt: domain.createdAt,
    updatedAt: domain.updatedAt,
    isActive: domain.isActive,
    isSynced: domain.isSynced,
  );
}

WorkoutPlansCompanion planToCompanion(WorkoutPlan domain) {
  return WorkoutPlansCompanion(
    id: Value(domain.id),
    name: Value(domain.name),
    description: Value(domain.description),
    createdAt: Value(domain.createdAt),
    updatedAt: Value(domain.updatedAt),
    isActive: Value(domain.isActive),
    isSynced: Value(domain.isSynced),
  );
}

// ---------------------------------------------------------------------------
// WorkoutDay mapper
// ---------------------------------------------------------------------------

WorkoutDayData dayToData(String planId, WorkoutDay domain) {
  return WorkoutDayData(
    id: domain.id,
    planId: planId,
    name: domain.name,
    orderIndex: domain.orderIndex,
  );
}

WorkoutDaysCompanion dayToCompanion(String planId, WorkoutDay domain) {
  return WorkoutDaysCompanion(
    id: Value(domain.id),
    planId: Value(planId),
    name: Value(domain.name),
    orderIndex: Value(domain.orderIndex),
  );
}

// ---------------------------------------------------------------------------
// WorkoutDayExercise mapper
// ---------------------------------------------------------------------------

WorkoutDayExerciseData dayExerciseToData(
    String dayId, Exercise domain, int orderIndex) {
  return WorkoutDayExerciseData(
    id: _uuid.v4(),
    dayId: dayId,
    exerciseId: domain.id,
    sets: domain.sets,
    repsOrDuration: domain.repsOrDuration,
    isTimeBased: domain.isTimeBased,
    restTime: domain.restTime,
    orderIndex: orderIndex,
  );
}

WorkoutDayExercisesCompanion dayExerciseToCompanion(
    String dayId, Exercise domain, int orderIndex) {
  return WorkoutDayExercisesCompanion(
    id: Value(_uuid.v4()),
    dayId: Value(dayId),
    exerciseId: Value(domain.id),
    sets: Value(domain.sets),
    repsOrDuration: Value(domain.repsOrDuration),
    isTimeBased: Value(domain.isTimeBased),
    restTime: Value(domain.restTime),
    orderIndex: Value(orderIndex),
  );
}

Exercise dayExerciseLinkToDomain(
  WorkoutDayExerciseData link,
  ExerciseData exercise,
) {
  return exerciseWithOverrides(
    exercise,
    link.sets,
    link.repsOrDuration,
    link.isTimeBased,
    link.restTime,
  );
}

Exercise _dayExerciseToDomain(WorkoutDayExerciseData link) {
  return Exercise(
    id: link.exerciseId,
    name: '',
    description: '',
    coachCues: '',
    sets: link.sets,
    repsOrDuration: link.repsOrDuration,
    isTimeBased: link.isTimeBased,
    restTime: link.restTime,
    equipment: '',
    media: const ExerciseMedia.empty(),
    targetMuscles: [],
    isCustom: false,
  );
}

// ---------------------------------------------------------------------------
// WorkoutLog mapper
// ---------------------------------------------------------------------------

WorkoutLog logFromData({
  required WorkoutLogData log,
  required List<SetLogData> setData,
}) {
  final perfMap = <String, List<SetLogData>>{};
  for (final s in setData) {
    perfMap.putIfAbsent(s.exerciseId, () => []).add(s);
  }

  final exercises = perfMap.entries.map((entry) {
    final sets = entry.value;
    return ExercisePerformance(
      exerciseId: entry.key,
      exerciseName: '',
      sets: sets.map((s) => SetLog(
        setNumber: s.setNumber,
        reps: s.reps,
        weight: s.weight,
        isCompleted: s.isCompleted,
      )).toList(),
    );
  }).toList();

  return WorkoutLog(
    id: log.id,
    dayId: log.dayId,
    dayName: log.dayName,
    completedAt: log.completedAt,
    exerciseCount: perfMap.length,
    totalSets: setData.where((s) => s.isCompleted).length,
    totalDurationMinutes: log.durationMinutes,
    exercises: exercises,
  );
}

WorkoutLogData logToData(WorkoutLog domain) {
  return WorkoutLogData(
    id: domain.id,
    dayId: domain.dayId,
    dayName: domain.dayName,
    completedAt: domain.completedAt,
    durationMinutes: domain.totalDurationMinutes,
    isSynced: false,
  );
}

WorkoutLogsCompanion logToCompanion(WorkoutLog domain) {
  return WorkoutLogsCompanion(
    id: Value(domain.id),
    dayId: Value(domain.dayId),
    dayName: Value(domain.dayName),
    completedAt: Value(domain.completedAt),
    durationMinutes: Value(domain.totalDurationMinutes),
    isSynced: Value(false),
  );
}

SetLogsCompanion setLogToCompanion(
    String logId, SetLog domain, {required String exerciseId}) {
  return SetLogsCompanion(
    id: Value(_uuid.v4()),
    logId: Value(logId),
    exerciseId: Value(exerciseId),
    setNumber: Value(domain.setNumber),
    weight: Value(domain.weight),
    reps: Value(domain.reps),
    isCompleted: Value(domain.isCompleted),
  );
}
