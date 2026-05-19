import '../../core/errors/failure.dart';
import '../../models/workout_log.dart';
import '../../models/workout_plan.dart';

abstract class WorkoutRepository {
  // Legacy Hive-compatible methods
  Future<Result<List<WorkoutPlan>>> loadPlans();
  Future<Result<String?>> getActivePlanId();
  Future<Result<int?>> getCurrentDayIndex();
  Future<Result<List<WorkoutLog>>> loadLogs();
  Future<Result<void>> savePlans(List<WorkoutPlan> plans);
  Future<Result<void>> saveActivePlanId(String planId);
  Future<Result<void>> saveCurrentDayIndex(int dayIndex);
  Future<Result<void>> saveLogs(List<WorkoutLog> logs);
  Future<Result<void>> clearAll();

  // Drift-based methods
  Future<Result<WorkoutPlan?>> getPlanById(String planId);
  Future<Result<WorkoutPlan?>> getActivePlan();
  Future<Result<void>> savePlan(WorkoutPlan plan);
  Future<Result<void>> deletePlan(String planId);
  Future<Result<int?>> getDayIndex();
  Future<Result<void>> setDayIndex(int index);
  Future<Result<void>> completeDay({
    required String dayId,
    required WorkoutLog log,
    required List<SetLog> sets,
  });
}
