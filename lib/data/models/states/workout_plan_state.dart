import 'package:flutter/foundation.dart';
import '../../../models/workout_log.dart';
import '../../../models/workout_plan.dart';

@immutable
class WorkoutPlanState {
  final List<WorkoutPlan> plans;
  final String? activePlanId;
  final int currentDayIndex;
  final bool isLoading;
  final String? errorMessage;
  final List<WorkoutLog> workoutLogs;

  const WorkoutPlanState({
    this.plans = const [],
    this.activePlanId,
    this.currentDayIndex = 0,
    this.isLoading = false,
    this.errorMessage,
    this.workoutLogs = const [],
  });

  WorkoutPlan? get plan {
    if (activePlanId == null) return plans.isNotEmpty ? plans.first : null;
    return plans.cast<WorkoutPlan?>().firstWhere(
      (p) => p?.id == activePlanId,
      orElse: () => plans.isNotEmpty ? plans.first : null,
    );
  }

  WorkoutPlanState copyWith({
    List<WorkoutPlan>? plans,
    String? activePlanId,
    int? currentDayIndex,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    List<WorkoutLog>? workoutLogs,
  }) {
    return WorkoutPlanState(
      plans: plans ?? this.plans,
      activePlanId: activePlanId ?? this.activePlanId,
      currentDayIndex: currentDayIndex ?? this.currentDayIndex,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      workoutLogs: workoutLogs ?? this.workoutLogs,
    );
  }

  WorkoutDay? get currentDay {
    final currentPlan = plan;
    if (currentPlan == null || currentPlan.days.isEmpty) return null;
    if (currentDayIndex >= currentPlan.days.length) {
      return currentPlan.days.first;
    }
    return currentPlan.days[currentDayIndex];
  }

  int get completedDaysCount {
    return plan?.days.where((d) => d.isCompleted).length ?? 0;
  }

  int get totalDays {
    return plan?.days.length ?? 0;
  }

  WorkoutDay? getDayById(String dayId) {
    final currentPlan = plan;
    if (currentPlan == null) return null;
    return currentPlan.days.cast<WorkoutDay?>().firstWhere(
      (d) => d?.id == dayId,
      orElse: () => currentPlan.days.first,
    );
  }
}
