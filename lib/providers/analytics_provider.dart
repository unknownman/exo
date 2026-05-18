import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/personal_record.dart';
import '../domain/services/analytics_service.dart';
import 'workout_provider.dart';

part 'analytics_provider.g.dart';

class AnalyticsState {
  final Map<String, PersonalRecord> bestLifts;
  final Set<String> exercisePRs;

  const AnalyticsState({
    this.bestLifts = const {},
    this.exercisePRs = const {},
  });

  AnalyticsState copyWith({
    Map<String, PersonalRecord>? bestLifts,
    Set<String>? exercisePRs,
  }) {
    return AnalyticsState(
      bestLifts: bestLifts ?? this.bestLifts,
      exercisePRs: exercisePRs ?? this.exercisePRs,
    );
  }
}

@Riverpod(keepAlive: true)
class AnalyticsNotifier extends _$AnalyticsNotifier {
  @override
  AnalyticsState build() {
    ref.watch(workoutNotifierProvider).whenOrNull(
      data: (state) {
        final service = AnalyticsService(state.workoutLogs);
        return AnalyticsState(
          bestLifts: service.bestLifts,
          exercisePRs: service.exercisesWithPRs,
        );
      },
    );
    return const AnalyticsState();
  }

  ExerciseAnalytics getExerciseAnalytics(String exerciseId) {
    final logs = ref.read(workoutNotifierProvider).valueOrNull?.workoutLogs ?? [];
    final service = AnalyticsService(logs);
    return service.getExerciseAnalytics(exerciseId);
  }

  bool isNewPR(String exerciseId, double weight, int reps) {
    final logs = ref.read(workoutNotifierProvider).valueOrNull?.workoutLogs ?? [];
    final service = AnalyticsService(logs);
    return service.isRecordForExercise(exerciseId, weight, reps);
  }
}
