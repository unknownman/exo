export '../data/models/states/workout_plan_state.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/exercise.dart';
import '../models/workout_plan.dart';
import '../models/workout_log.dart';
import '../data/models/states/workout_plan_state.dart';
import '../data/repositories/workout_repository_impl.dart';
import '../data/datasources/workout_defaults.dart';
import '../domain/services/workout_state_manager.dart';
part 'workout_provider.g.dart';

@Riverpod(keepAlive: true)
class WorkoutNotifier extends _$WorkoutNotifier {
  final _manager = WorkoutStateManager();

  @override
  Future<WorkoutPlanState> build() async {
    return _loadInitialData();
  }

  Future<WorkoutPlanState> _loadInitialData() async {
    final repository = ref.read(workoutRepositoryProvider);

    final plansResult = await repository.loadPlans();
    final activePlanIdResult = await repository.getActivePlanId();
    final dayIndexResult = await repository.getCurrentDayIndex();
    final logsResult = await repository.loadLogs();

    List<WorkoutPlan> plans = [];
    String? savedActivePlanId;
    int? savedDayIndex;
    List<WorkoutLog> workoutLogs = [];
    String? errorMessage;

    plansResult.fold(
      onSuccess: (data) => plans = data,
      onError: (failure) => errorMessage = failure.message,
    );
    activePlanIdResult.fold(
      onSuccess: (data) => savedActivePlanId = data,
      onError: (failure) {},
    );
    dayIndexResult.fold(
      onSuccess: (data) => savedDayIndex = data,
      onError: (failure) {},
    );
    logsResult.fold(
      onSuccess: (data) => workoutLogs = data,
      onError: (failure) {},
    );

    List<WorkoutPlan> finalPlans = [...plans];
    String? activePlanId;

    if (finalPlans.isEmpty) {
      final defaultPlan = WorkoutDefaults.defaultPlan();
      finalPlans = [defaultPlan];
      activePlanId = defaultPlan.id;
    } else {
      activePlanId = savedActivePlanId ?? finalPlans.first.id;
    }

    final activePlan = finalPlans.firstWhere(
      (p) => p.id == activePlanId,
      orElse: () => finalPlans.first,
    );

    final restoredDayIndex = savedDayIndex ?? 0;

    return WorkoutPlanState(
      plans: finalPlans,
      activePlanId: activePlanId,
      currentDayIndex: restoredDayIndex.clamp(0, activePlan.days.length - 1),
      isLoading: false,
      errorMessage: errorMessage,
      workoutLogs: [...workoutLogs],
    );
  }

  Future<void> _saveData() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plans.isEmpty) return;

    final repository = ref.read(workoutRepositoryProvider);
    await repository.savePlans(currentState.plans);
    if (currentState.activePlanId != null) {
      await repository.saveActivePlanId(currentState.activePlanId!);
    }
    await repository.saveCurrentDayIndex(currentState.currentDayIndex);
  }

  Future<void> _updateCurrentPlan(WorkoutPlan updatedPlan) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final planWithTimestamp = updatedPlan.copyWith(updatedAt: DateTime.now());
    final updatedPlans = currentState.plans.map((p) {
      return p.id == planWithTimestamp.id ? planWithTimestamp : p;
    }).toList();

    state = AsyncData(
      currentState.copyWith(plans: updatedPlans, errorMessage: null),
    );
    await _saveData();
  }

  Future<void> addExercise(String dayId, Exercise exercise) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plan == null) return;

    final updatedPlan = _manager.addExerciseToDay(currentState.plan!, dayId, exercise);
    await _updateCurrentPlan(updatedPlan);
  }

  Future<void> updateExercise(String dayId, String exerciseId, Exercise updatedExercise) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plan == null) return;

    final updatedPlan = _manager.updateExerciseInDay(currentState.plan!, dayId, exerciseId, updatedExercise);
    await _updateCurrentPlan(updatedPlan);
  }

  Future<void> removeExercise(String dayId, String exerciseId) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plan == null) return;

    final updatedPlan = _manager.removeExerciseFromDay(currentState.plan!, dayId, exerciseId);
    await _updateCurrentPlan(updatedPlan);
  }

  Future<void> completeDay(String dayId, {Map<String, List<SetLog>>? sessionData}) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plan == null) return;

    final dayIndex = currentState.plan!.days.indexWhere((d) => d.id == dayId);
    if (dayIndex == -1) return;

    final day = currentState.plan!.days[dayIndex];

    final updatedPlan = _manager.markDayCompleted(currentState.plan!, dayId);
    final log = _manager.createWorkoutLogFromData(
      dayId: day.id,
      dayName: day.name,
      exercises: day.exercises,
      durationMinutes: day.estimatedDurationMinutes,
      sessionData: sessionData,
    );
    final nextDayIndex = _manager.calculateNextDayIndex(updatedPlan.days, dayIndex);

    final planWithTimestamp = updatedPlan.copyWith(updatedAt: DateTime.now());
    final updatedPlans = currentState.plans.map((p) {
      return p.id == planWithTimestamp.id ? planWithTimestamp : p;
    }).toList();

    state = AsyncData(
      currentState.copyWith(
        plans: updatedPlans,
        currentDayIndex: nextDayIndex,
        workoutLogs: [log, ...currentState.workoutLogs],
        errorMessage: null,
      ),
    );
    await _saveData();
    await _saveLogs();
  }

  Future<void> setCurrentDayByIndex(int index) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plan == null) return;
    if (index < 0 || index >= currentState.plan!.days.length) return;

    state = AsyncData(
      currentState.copyWith(currentDayIndex: index, errorMessage: null),
    );
    await _saveData();
  }

  Future<void> setCurrentDay(String dayId) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plan == null) return;

    final dayIndex = currentState.plan!.days.indexWhere((d) => d.id == dayId);
    if (dayIndex == -1) return;

    state = AsyncData(
      currentState.copyWith(currentDayIndex: dayIndex, errorMessage: null),
    );
    await _saveData();
  }

  Future<void> addDay(String dayName) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plan == null) return;

    final updatedPlan = _manager.addDayToPlan(currentState.plan!, dayName);
    await _updateCurrentPlan(updatedPlan);
  }

  Future<void> removeDay(String dayId) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plan == null) return;
    if (currentState.plan!.days.length <= 1) return;

    final updatedPlan = _manager.removeDayFromPlan(currentState.plan!, dayId);
    await _updateCurrentPlan(updatedPlan);

    final fresh = state.valueOrNull;
    if (fresh != null) {
      int newIndex = fresh.currentDayIndex;
      if (newIndex >= fresh.plan!.days.length) {
        newIndex = fresh.plan!.days.length - 1;
      }
      state = AsyncData(fresh.copyWith(currentDayIndex: newIndex));
      await _saveData();
    }
  }

  Future<void> updatePlanName(String name) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plan == null) return;

    final updatedPlan = currentState.plan!.copyWith(name: name);
    await _updateCurrentPlan(updatedPlan);
  }

  Future<void> updatePlanOrder(WorkoutPlan updatedPlan) async {
    await _updateCurrentPlan(updatedPlan);
  }

  Future<void> _saveLogs() async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;
    final repository = ref.read(workoutRepositoryProvider);
    await repository.saveLogs(currentState.workoutLogs);
  }

  Future<void> createPlan(String name, {List<String>? dayNames}) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final days = dayNames != null
        ? _manager.createDayList(dayNames)
        : [_manager.createSingleDay('روز اول')];

    final newPlan = _manager.buildPlan(name, 'برنامه جدید', days);

    final updatedPlans = [...currentState.plans, newPlan];
    state = AsyncData(
      currentState.copyWith(
        plans: updatedPlans,
        activePlanId: newPlan.id,
        currentDayIndex: 0,
        errorMessage: null,
      ),
    );
    await _saveData();
  }

  Future<void> switchActivePlan(String planId) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final exists = currentState.plans.any((p) => p.id == planId);
    if (!exists) return;

    state = AsyncData(
      currentState.copyWith(
        activePlanId: planId,
        currentDayIndex: 0,
        errorMessage: null,
      ),
    );
    await _saveData();
  }
}
