import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app_database.dart';

part 'workout_dao.g.dart';

class WorkoutDao {
  final AppDatabase _db;

  WorkoutDao(this._db);

  // ---------------------------------------------------------------------------
  // Plan operations
  // ---------------------------------------------------------------------------

  Future<WorkoutPlanData?> getPlan(String id) {
    return (_db.select(_db.workoutPlans)..where((p) => p.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<WorkoutPlanData>> getAllPlans() {
    return _db.select(_db.workoutPlans).get();
  }

  Future<void> insertPlan(WorkoutPlansCompanion companion) {
    return _db.into(_db.workoutPlans).insert(companion);
  }

  Future<void> upsertPlan(WorkoutPlansCompanion companion) {
    return _db.into(_db.workoutPlans).insertOnConflictUpdate(companion);
  }

  Future<void> updatePlanPartial(
    String id,
    WorkoutPlansCompanion companion,
  ) {
    return (_db.update(_db.workoutPlans)..where((p) => p.id.equals(id)))
        .write(companion);
  }

  Future<void> deletePlan(String id) {
    return (_db.delete(_db.workoutPlans)..where((p) => p.id.equals(id))).go();
  }

  // ---------------------------------------------------------------------------
  // Day operations
  // ---------------------------------------------------------------------------

  Future<List<WorkoutDayData>> getDaysByPlan(String planId) {
    return (_db.select(_db.workoutDays)
          ..where((d) => d.planId.equals(planId))
          ..orderBy([(d) => OrderingTerm(expression: d.orderIndex)]))
        .get();
  }

  Future<void> insertDay(WorkoutDaysCompanion companion) {
    return _db.into(_db.workoutDays).insert(companion);
  }

  Future<void> deleteDaysByPlan(String planId) async {
    final days = await getDaysByPlan(planId);
    for (final day in days) {
      await (_db.delete(_db.workoutDayExercises)
            ..where((e) => e.dayId.equals(day.id)))
          .go();
    }
    await (_db.delete(_db.workoutDays)..where((d) => d.planId.equals(planId)))
        .go();
  }

  // ---------------------------------------------------------------------------
  // Day exercise operations
  // ---------------------------------------------------------------------------

  Future<List<WorkoutDayExerciseData>> getExercisesByDay(String dayId) {
    return (_db.select(_db.workoutDayExercises)
          ..where((e) => e.dayId.equals(dayId))
          ..orderBy([(e) => OrderingTerm(expression: e.orderIndex)]))
        .get();
  }

  Future<void> insertDayExercise(WorkoutDayExercisesCompanion companion) {
    return _db.into(_db.workoutDayExercises).insert(companion);
  }

  Future<void> deleteExercisesByDay(String dayId) {
    return (_db.delete(_db.workoutDayExercises)
          ..where((e) => e.dayId.equals(dayId)))
        .go();
  }

  // ---------------------------------------------------------------------------
  // Complex plan transaction
  // ---------------------------------------------------------------------------

  Future<void> saveFullPlan({
    required WorkoutPlansCompanion plan,
    required List<WorkoutDaysCompanion> days,
    required List<List<WorkoutDayExercisesCompanion>> dayExercises,
  }) async {
    await _db.transaction(() async {
      await _db.into(_db.workoutPlans).insertOnConflictUpdate(plan);

      final planId = plan.id.value;
      final existingDays = await getDaysByPlan(planId);

      for (final day in existingDays) {
        await (_db.delete(_db.workoutDayExercises)
              ..where((e) => e.dayId.equals(day.id)))
            .go();
      }
      await (_db.delete(_db.workoutDays)
            ..where((d) => d.planId.equals(planId)))
          .go();

      for (var i = 0; i < days.length; i++) {
        await _db.into(_db.workoutDays).insert(days[i]);
        if (i < dayExercises.length) {
          for (final ex in dayExercises[i]) {
            await _db.into(_db.workoutDayExercises).insert(ex);
          }
        }
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Log operations
  // ---------------------------------------------------------------------------

  Future<WorkoutLogData?> getLog(String id) {
    return (_db.select(_db.workoutLogs)..where((l) => l.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<WorkoutLogData>> getAllLogs() {
    return (_db.select(_db.workoutLogs)
          ..orderBy([(l) => OrderingTerm(expression: l.completedAt, mode: OrderingMode.desc)]))
        .get();
  }

  Future<void> insertLog(WorkoutLogsCompanion companion) {
    return _db.into(_db.workoutLogs).insert(companion);
  }

  Future<void> updateLogPartial(String id, WorkoutLogsCompanion companion) {
    return (_db.update(_db.workoutLogs)..where((l) => l.id.equals(id)))
        .write(companion);
  }

  Future<void> deleteLog(String id) {
    return (_db.delete(_db.workoutLogs)..where((l) => l.id.equals(id))).go();
  }

  // ---------------------------------------------------------------------------
  // Set log operations
  // ---------------------------------------------------------------------------

  Future<List<SetLogData>> getSetsByLog(String logId) {
    return (_db.select(_db.setLogs)..where((s) => s.logId.equals(logId)))
        .get();
  }

  Future<void> insertSetLog(SetLogsCompanion companion) {
    return _db.into(_db.setLogs).insert(companion);
  }

  Future<void> deleteSetsByLog(String logId) {
    return (_db.delete(_db.setLogs)..where((s) => s.logId.equals(logId))).go();
  }

  // ---------------------------------------------------------------------------
  // Complex log transaction
  // ---------------------------------------------------------------------------

  Future<void> saveFullLog({
    required WorkoutLogsCompanion log,
    required List<SetLogsCompanion> sets,
  }) async {
    await _db.transaction(() async {
      await _db.into(_db.workoutLogs).insert(log);

      for (final setLog in sets) {
        await _db.into(_db.setLogs).insert(setLog);
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Active plan
  // ---------------------------------------------------------------------------

  Future<WorkoutPlanData?> getActivePlan() {
    return (_db.select(_db.workoutPlans)..where((p) => p.isActive.equals(true)))
        .getSingleOrNull();
  }

  Future<void> deactivateAllPlans() async {
    final plans = await getAllPlans();
    for (final plan in plans) {
      if (plan.isActive) {
        await (_db.update(_db.workoutPlans)
              ..where((p) => p.id.equals(plan.id)))
            .write(const WorkoutPlansCompanion(isActive: Value(false)));
      }
    }
  }

  Future<void> setActivePlan(String planId) async {
    await _db.transaction(() async {
      await deactivateAllPlans();
      await (_db.update(_db.workoutPlans)..where((p) => p.id.equals(planId)))
          .write(const WorkoutPlansCompanion(isActive: Value(true)));
    });
  }
}

@Riverpod(keepAlive: true)
WorkoutDao workoutDao(WorkoutDaoRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return WorkoutDao(db);
}
