import 'package:hive_flutter/hive_flutter.dart';
import '../../core/errors/failure.dart';
import '../../core/errors/error_handler.dart';
import '../../domain/repositories/workout_repository.dart';
import '../../models/workout_plan.dart';
import '../../models/workout_log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_repository_impl.g.dart';

class WorkoutRepositoryImpl with ErrorHandlerMixin implements WorkoutRepository {
  static const String _boxName = 'app_data';

  Future<Box> _getBox() async {
    return await Hive.openBox(_boxName);
  }

  @override
  Future<Result<List<WorkoutPlan>>> loadPlans() async {
    return executeSafely(() async {
      final box = await _getBox();
      final plans = (box.get('workout_plans', defaultValue: <WorkoutPlan>[]) as List)
          .cast<WorkoutPlan>();
      return plans;
    });
  }

  @override
  Future<Result<String?>> getActivePlanId() async {
    return executeSafely(() async {
      final box = await _getBox();
      return box.get('active_plan_id') as String?;
    });
  }

  @override
  Future<Result<int?>> getCurrentDayIndex() async {
    return executeSafely(() async {
      final box = await _getBox();
      return box.get('current_day_index') as int?;
    });
  }

  @override
  Future<Result<List<WorkoutLog>>> loadLogs() async {
    return executeSafely(() async {
      final box = await _getBox();
      final logs = (box.get('workout_logs', defaultValue: <WorkoutLog>[]) as List)
          .cast<WorkoutLog>();
      return logs;
    });
  }

  @override
  Future<Result<void>> savePlans(List<WorkoutPlan> plans) async {
    return executeSafely(() async {
      final box = await _getBox();
      await box.put('workout_plans', plans);
    });
  }

  @override
  Future<Result<void>> saveActivePlanId(String planId) async {
    return executeSafely(() async {
      final box = await _getBox();
      await box.put('active_plan_id', planId);
    });
  }

  @override
  Future<Result<void>> saveCurrentDayIndex(int dayIndex) async {
    return executeSafely(() async {
      final box = await _getBox();
      await box.put('current_day_index', dayIndex);
    });
  }

  @override
  Future<Result<void>> saveLogs(List<WorkoutLog> logs) async {
    return executeSafely(() async {
      final box = await _getBox();
      await box.put('workout_logs', logs);
    });
  }

  @override
  Future<Result<void>> clearAll() async {
    return executeSafely(() async {
      final box = await _getBox();
      await box.clear();
    });
  }
}

@riverpod
WorkoutRepository workoutRepository(WorkoutRepositoryRef ref) {
  return WorkoutRepositoryImpl();
}
