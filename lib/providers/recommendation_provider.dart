import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/errors/failure.dart';
import '../data/repositories/workout_repository_impl.dart';
import '../domain/services/recommendation_service.dart';
import '../models/workout_plan.dart';
import 'workout_provider.dart';

part 'recommendation_provider.g.dart';

@Riverpod(keepAlive: true)
class RecommendationNotifier extends _$RecommendationNotifier {
  @override
  AsyncValue<WorkoutPlan?> build() => const AsyncData(null);

  Future<void> generateRecommendation() async {
    state = const AsyncLoading();

    final service = ref.read(recommendationServiceProvider);
    final result = await service.generateRecommendation();

    result.fold(
      onSuccess: (plan) => state = AsyncData(plan),
      onError: (failure) => state = AsyncError(failure.message, StackTrace.current),
    );
  }

  void rejectRecommendation() {
    state = const AsyncData(null);
  }

  Future<void> acceptRecommendation() async {
    final plan = state.valueOrNull;
    if (plan == null) return;

    state = const AsyncLoading();

    final repository = ref.read(workoutRepositoryProvider);

    final saveResult = await repository.savePlan(plan);
    final failure = saveResult.fold<Failure?>(
      onSuccess: (_) => null,
      onError: (f) => f,
    );
    if (failure != null) {
      state = AsyncError(failure.message, StackTrace.current);
      return;
    }

    final activateResult = await repository.saveActivePlanId(plan.id);
    activateResult.fold(
      onSuccess: (_) => state = AsyncData(plan),
      onError: (f) => state = AsyncError(f.message, StackTrace.current),
    );

    ref.invalidate(workoutNotifierProvider);
  }
}

@riverpod
bool aiCreditsAvailable(AiCreditsAvailableRef ref) {
  final service = ref.watch(recommendationServiceProvider);
  return service.hasEnoughCredits();
}
