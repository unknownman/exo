import 'package:hive/hive.dart';
import '../models/exercise_type.dart';
import '../models/exercise.dart';
import '../models/workout_day.dart';
import '../models/workout_program.dart';
import '../models/exercise_history.dart';
import '../models/daily_log.dart';
import '../models/workout_progress.dart';

class HiveAdapters {
  HiveAdapters._();

  static void register() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(WorkoutProgramAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(WorkoutDayAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ExerciseAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(ExerciseHistoryAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(DailyLogAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(ExerciseTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(WorkoutProgressAdapter());
    }
  }
}
