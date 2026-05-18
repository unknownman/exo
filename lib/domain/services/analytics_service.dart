import '../../models/workout_log.dart';
import '../../models/personal_record.dart';

class ExerciseDataPoint {
  final DateTime date;
  final double value;

  const ExerciseDataPoint({required this.date, required this.value});
}

class ExerciseAnalytics {
  final String exerciseId;
  final String exerciseName;
  final List<ExerciseDataPoint> weightProgress;
  final List<ExerciseDataPoint> volumeProgress;
  final PersonalRecord? bestRecord;
  final double currentEstimated1RM;

  const ExerciseAnalytics({
    required this.exerciseId,
    required this.exerciseName,
    required this.weightProgress,
    required this.volumeProgress,
    required this.bestRecord,
    required this.currentEstimated1RM,
  });

  bool get hasData => weightProgress.isNotEmpty;

  bool isNewPR(double weight, int reps) {
    final estimated = brzycki1RM(weight, reps);
    return bestRecord == null || estimated > bestRecord!.best1RM;
  }
}

class AnalyticsService {
  final List<WorkoutLog> logs;

  AnalyticsService(this.logs);

  Map<String, PersonalRecord> get bestLifts {
    final records = <String, PersonalRecord>{};
    for (final log in logs) {
      for (final perf in log.exercises) {
        for (final set in perf.sets) {
          if (!set.isCompleted || set.weight <= 0) continue;
          final oneRM = brzycki1RM(set.weight, set.reps);
          final existing = records[perf.exerciseId];
          if (existing == null || oneRM > existing.best1RM) {
            records[perf.exerciseId] = PersonalRecord.fromSet(
              exerciseId: perf.exerciseId,
              exerciseName: perf.exerciseName,
              weight: set.weight,
              reps: set.reps,
              estimated1RM: oneRM,
            );
          }
        }
      }
    }
    return records;
  }

  ExerciseAnalytics getExerciseAnalytics(String exerciseId) {
    final weightPoints = <ExerciseDataPoint>[];
    final volumePoints = <ExerciseDataPoint>[];
    double bestEstimated = 0;
    PersonalRecord? bestRec;

    for (final log in logs) {
      for (final perf in log.exercises) {
        if (perf.exerciseId != exerciseId) continue;
        double maxWeight = 0;
        double totalVolume = 0;
        for (final set in perf.sets) {
          if (!set.isCompleted || set.weight <= 0) continue;
          if (set.weight > maxWeight) maxWeight = set.weight;
          totalVolume += set.weight * set.reps;
          final oneRM = brzycki1RM(set.weight, set.reps);
          if (oneRM > bestEstimated) {
            bestEstimated = oneRM;
            bestRec = PersonalRecord.fromSet(
              exerciseId: perf.exerciseId,
              exerciseName: perf.exerciseName,
              weight: set.weight,
              reps: set.reps,
              estimated1RM: oneRM,
            );
          }
        }
        if (maxWeight > 0) {
          weightPoints.add(ExerciseDataPoint(date: log.completedAt, value: maxWeight));
        }
        if (totalVolume > 0) {
          volumePoints.add(ExerciseDataPoint(date: log.completedAt, value: totalVolume));
        }
      }
    }

    weightPoints.sort((a, b) => a.date.compareTo(b.date));
    volumePoints.sort((a, b) => a.date.compareTo(b.date));

    String name = '';
    for (final log in logs) {
      for (final perf in log.exercises) {
        if (perf.exerciseId == exerciseId) {
          name = perf.exerciseName;
          break;
        }
      }
      if (name.isNotEmpty) break;
    }

    return ExerciseAnalytics(
      exerciseId: exerciseId,
      exerciseName: name,
      weightProgress: weightPoints,
      volumeProgress: volumePoints,
      bestRecord: bestRec,
      currentEstimated1RM: bestEstimated,
    );
  }

  Set<String> get exercisesWithPRs {
    final prs = bestLifts;
    final result = <String>{};
    for (final log in logs) {
      for (final perf in log.exercises) {
        for (final set in perf.sets) {
          if (!set.isCompleted || set.weight <= 0) continue;
          final oneRM = brzycki1RM(set.weight, set.reps);
          final existing = prs[perf.exerciseId];
          if (existing != null && oneRM >= existing.best1RM) {
            result.add(perf.exerciseId);
          }
        }
      }
    }
    return result;
  }

  bool isRecordForExercise(String exerciseId, double weight, int reps) {
    final estimated = brzycki1RM(weight, reps);
    final existing = bestLifts[exerciseId];
    return existing == null || estimated > existing.best1RM;
  }
}
