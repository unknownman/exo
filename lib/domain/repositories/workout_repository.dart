import '../../core/errors/failure.dart';
import '../../models/workout_plan.dart';
import '../../models/workout_log.dart';

abstract class WorkoutRepository {
  Future<Result<List<WorkoutPlan>>> loadPlans();
  Future<Result<String?>> getActivePlanId();
  Future<Result<int?>> getCurrentDayIndex();
  Future<Result<List<WorkoutLog>>> loadLogs();
  Future<Result<void>> savePlans(List<WorkoutPlan> plans);
  Future<Result<void>> saveActivePlanId(String planId);
  Future<Result<void>> saveCurrentDayIndex(int dayIndex);
  Future<Result<void>> saveLogs(List<WorkoutLog> logs);
  Future<Result<void>> clearAll();
}
