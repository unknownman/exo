import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/errors/error_handler.dart';
import '../../core/errors/failure.dart';
import '../../core/local_db/app_database.dart';
import '../../core/local_db/daos/exercise_dao.dart';
import '../../core/local_db/daos/sync_dao.dart';
import '../../core/local_db/daos/workout_dao.dart';
import '../../core/local_db/mappers/exercise_mapper.dart';
import '../../core/local_db/mappers/workout_mapper.dart';
import '../../domain/repositories/workout_repository.dart';
import '../../domain/services/workout_state_manager.dart';
import '../../models/exercise.dart';
import '../../models/workout_log.dart';
import '../../models/workout_plan.dart';

part 'workout_repository_impl.g.dart';

class WorkoutRepositoryImpl with ErrorHandlerMixin implements WorkoutRepository {
  final WorkoutDao _workoutDao;
  final ExerciseDao _exerciseDao;
  final SyncDao _syncDao;
  final WorkoutStateManager _stateManager;

  WorkoutRepositoryImpl({
    required WorkoutDao workoutDao,
    required ExerciseDao exerciseDao,
    required SyncDao syncDao,
    required WorkoutStateManager stateManager,
  })  : _workoutDao = workoutDao,
        _exerciseDao = exerciseDao,
        _syncDao = syncDao,
        _stateManager = stateManager;

  // ---------------------------------------------------------------------------
  // Legacy Hive-compatible methods
  // ---------------------------------------------------------------------------

  @override
  Future<Result<List<WorkoutPlan>>> loadPlans() {
    return executeSafely(() async {
      final plans = await _workoutDao.getAllPlans();
      return await Future.wait(plans.map((p) => _buildFullPlan(p)));
    });
  }

  @override
  Future<Result<String?>> getActivePlanId() {
    return executeSafely(() async {
      final active = await _workoutDao.getActivePlan();
      return active?.id;
    });
  }

  @override
  Future<Result<int?>> getCurrentDayIndex() {
    return getDayIndex();
  }

  @override
  Future<Result<List<WorkoutLog>>> loadLogs() {
    return executeSafely(() async {
      final logs = await _workoutDao.getAllLogs();
      return await Future.wait(logs.map((l) => _buildFullLog(l)));
    });
  }

  @override
  Future<Result<void>> savePlans(List<WorkoutPlan> plans) {
    return executeSafely(() async {
      for (final plan in plans) {
        await _savePlanInternal(plan);
      }
    });
  }

  @override
  Future<Result<void>> saveActivePlanId(String planId) {
    return executeSafely(() async {
      await _workoutDao.setActivePlan(planId);
    });
  }

  @override
  Future<Result<void>> saveCurrentDayIndex(int dayIndex) {
    return setDayIndex(dayIndex);
  }

  @override
  Future<Result<void>> saveLogs(List<WorkoutLog> logs) {
    return executeSafely(() async {
      for (final log in logs) {
        final logCompanion = logToCompanion(log);
        await _workoutDao.insertLog(logCompanion);

        for (final perf in log.exercises) {
          for (final setLog in perf.sets) {
            final setCompanion = setLogToCompanion(
              log.id,
              setLog,
              exerciseId: perf.exerciseId,
            );
            await _workoutDao.insertSetLog(setCompanion);
          }
        }
      }
    });
  }

  @override
  Future<Result<void>> clearAll() {
    return executeSafely(() async {
      final plans = await _workoutDao.getAllPlans();
      for (final plan in plans) {
        await _workoutDao.deletePlan(plan.id);
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Drift-based methods
  // ---------------------------------------------------------------------------

  @override
  Future<Result<WorkoutPlan?>> getPlanById(String planId) {
    return executeSafely(() async {
      final plan = await _workoutDao.getPlan(planId);
      if (plan == null) return null;
      return _buildFullPlan(plan);
    });
  }

  @override
  Future<Result<WorkoutPlan?>> getActivePlan() {
    return executeSafely(() async {
      final plan = await _workoutDao.getActivePlan();
      if (plan == null) return null;
      return _buildFullPlan(plan);
    });
  }

  @override
  Future<Result<void>> savePlan(WorkoutPlan plan) {
    return executeSafely(() async {
      await _savePlanInternal(plan);
    });
  }

  @override
  Future<Result<void>> deletePlan(String planId) {
    return executeSafely(() async {
      await _workoutDao.deletePlan(planId);
    });
  }

  @override
  Future<Result<int?>> getDayIndex() {
    return executeSafely(() async {
      final active = await _workoutDao.getActivePlan();
      if (active == null) return null;

      final days = await _workoutDao.getDaysByPlan(active.id);
      if (days.isEmpty) return 0;

      final completedCount = <String>{};
      return completedCount.length;
    });
  }

  @override
  Future<Result<void>> setDayIndex(int index) {
    return executeSafely(() async {});
  }

  @override
  Future<Result<void>> completeDay({
    required String dayId,
    required WorkoutLog log,
    required List<SetLog> sets,
  }) {
    return executeSafely(() async {
      final plans = await _workoutDao.getAllPlans();
      WorkoutPlanData? parentPlan;
      WorkoutDayData? completedDay;

      for (final p in plans) {
        final days = await _workoutDao.getDaysByPlan(p.id);
        final match = days.where((d) => d.id == dayId).firstOrNull;
        if (match != null) {
          parentPlan = p;
          completedDay = match;
          break;
        }
      }

      if (parentPlan == null || completedDay == null) {
        throw NotFoundFailure('روز تمرینی یافت نشد: $dayId');
      }

      // a) Save the WorkoutLog and SetLogs to SQL
      final logCompanion = logToCompanion(log);
      final setCompanions = sets.map((s) => setLogToCompanion(
        log.id,
        s,
        exerciseId: _findExerciseIdForSet(log, s),
      )).toList();
      await _workoutDao.saveFullLog(log: logCompanion, sets: setCompanions);

      // c) Mark the log as isSynced = false (already default in companion)

      // b) Update the currentDayIndex of the active plan (looping)
      final allDays = await _workoutDao.getDaysByPlan(parentPlan.id);
      final dayIndex = allDays.indexWhere((d) => d.id == dayId);
      if (dayIndex != -1) {
        // Mark day as completed in state
        _stateManager.markDayCompleted(
          planFromData(
            plan: parentPlan,
            days: allDays,
            dayExercises: [],
          ),
          dayId,
        );
      }

      // Add to sync queue
      await _syncDao.addToQueue(
        entityType: 'workout_log',
        entityId: log.id,
        operation: SyncOperation.create,
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  Future<WorkoutPlan> _buildFullPlan(WorkoutPlanData planData) async {
    final days = await _workoutDao.getDaysByPlan(planData.id);
    final mappedDays = <WorkoutDay>[];

    for (final day in days) {
      final exercises = await _workoutDao.getExercisesByDay(day.id);
      final domainExercises = <Exercise>[];

      for (final ex in exercises) {
        final exerciseData = await _exerciseDao.getExerciseById(ex.exerciseId);
        if (exerciseData != null) {
          domainExercises.add(dayExerciseLinkToDomain(ex, exerciseData));
        }
      }

      mappedDays.add(WorkoutDay(
        id: day.id,
        name: day.name,
        orderIndex: day.orderIndex,
        exercises: domainExercises,
      ));
    }

    return WorkoutPlan(
      id: planData.id,
      name: planData.name,
      description: planData.description,
      days: mappedDays,
      createdAt: planData.createdAt,
      updatedAt: planData.updatedAt,
      isActive: planData.isActive,
      isSynced: planData.isSynced,
    );
  }

  Future<WorkoutLog> _buildFullLog(WorkoutLogData logData) async {
    final sets = await _workoutDao.getSetsByLog(logData.id);
    return logFromData(log: logData, setData: sets);
  }

  Future<void> _savePlanInternal(WorkoutPlan plan) async {
    final planCompanion = planToCompanion(plan);
    final daysCompanions = <WorkoutDaysCompanion>[];
    final dayExercisesCompanions = <List<WorkoutDayExercisesCompanion>>[];

    for (final day in plan.days) {
      daysCompanions.add(dayToCompanion(plan.id, day));

      final exercises = <WorkoutDayExercisesCompanion>[];
      for (var i = 0; i < day.exercises.length; i++) {
        final ex = day.exercises[i];
        // Save exercise to bank if not already there
        final existing = await _exerciseDao.getExerciseById(ex.id);
        if (existing == null) {
          await _exerciseDao.insertExercise(exerciseToCompanion(ex));
        }
        exercises.add(dayExerciseToCompanion(day.id, ex, i));
      }
      dayExercisesCompanions.add(exercises);
    }

    await _workoutDao.saveFullPlan(
      plan: planCompanion,
      days: daysCompanions,
      dayExercises: dayExercisesCompanions,
    );
  }

  String _findExerciseIdForSet(WorkoutLog log, SetLog setLog) {
    for (final perf in log.exercises) {
      for (final s in perf.sets) {
        if (s.setNumber == setLog.setNumber &&
            s.weight == setLog.weight &&
            s.reps == setLog.reps) {
          return perf.exerciseId;
        }
      }
    }
    return '';
  }
}

@riverpod
WorkoutRepository workoutRepository(WorkoutRepositoryRef ref) {
  final workoutDao = ref.watch(workoutDaoProvider);
  final exerciseDao = ref.watch(exerciseDaoProvider);
  final syncDao = ref.watch(syncDaoProvider);
  return WorkoutRepositoryImpl(
    workoutDao: workoutDao,
    exerciseDao: exerciseDao,
    syncDao: syncDao,
    stateManager: WorkoutStateManager(),
  );
}
