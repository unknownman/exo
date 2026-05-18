import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/exercise.dart';
import '../models/exercise_media.dart';
import '../models/workout_plan.dart';
import '../models/workout_log.dart';
import '../data/repositories/workout_repository_impl.dart';
part 'workout_provider.g.dart';

@Riverpod(keepAlive: true)
class WorkoutNotifier extends _$WorkoutNotifier {
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
      final defaultPlan = _createDefaultPlan();
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

  WorkoutPlanState _createDefaultState() {
    final defaultPlan = _createDefaultPlan();
    return WorkoutPlanState(
      plans: [defaultPlan],
      activePlanId: defaultPlan.id,
      currentDayIndex: 0,
      isLoading: false,
      errorMessage: null,
    );
  }

  List<Exercise> _warmupExercises() {
    return [
      Exercise(
        id: 'ex_warm_1',
        name: 'رول کف پا',
        sets: 1,
        repsOrDuration: 180,
        isTimeBased: true,
        restTime: 15,
        equipment: 'وزن بدن',
      ),
      Exercise(
        id: 'ex_warm_2',
        name: 'Monster Walk با مینی‌لوپ',
        sets: 3,
        repsOrDuration: 30,
        isTimeBased: false,
        restTime: 45,
        equipment: 'کش ورزشی',
        description: 'فعال‌سازی لگن',
      ),
      Exercise(
        id: 'ex_warm_3',
        name: 'Cat-Cow',
        sets: 1,
        repsOrDuration: 120,
        isTimeBased: true,
        restTime: 15,
        equipment: 'وزن بدن',
        description: 'متحرک‌سازی ستون فقرات',
      ),
      Exercise(
        id: 'ex_warm_4',
        name: 'Clamshell با مینی‌لوپ',
        sets: 2,
        repsOrDuration: 30,
        isTimeBased: false,
        restTime: 45,
        equipment: 'کش ورزشی',
        description: 'ثبات زانو',
      ),
    ];
  }

  WorkoutPlan _createDefaultPlan() {
    return WorkoutPlan(
      id: 'exo_pro',
      name: 'برنامه تخصصی ۳ روزه',
      description: 'برنامه‌ای ترکیبی برای قدرت پا، هایپرتروفی شانه و قدرت مرکزی با تمرکز بر اصلاح ساختار و پیشگیری از آسیب',
      days: [_createDay1(), _createDay2(), _createDay3()],
      createdAt: DateTime.now(),
      isActive: true,
    );
  }

  WorkoutDay _createDay1() {
    return WorkoutDay(
      id: 'exo_pro_day_1',
      name: 'قدرت پا و ثبات زنجیره خلفی',
      orderIndex: 0,
      exercises: [
        ..._warmupExercises(),
        Exercise(
          id: 'ex_d1_1',
          name: 'اسکات گابلت (۱۷.۵ ک‌گ)',
          sets: 4,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
          description: 'تمرکز: VMO',
        ),
        Exercise(
          id: 'ex_d1_2',
          name: 'ددلیفت تک پا (۱۰ ک‌گ)',
          sets: 4,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
          description: 'تمرکز: همسترینگ و مچ پا',
        ),
        Exercise(
          id: 'ex_d1_3',
          name: 'لانژ معکوس (۸ ک‌گ)',
          sets: 3,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 60,
          equipment: 'دمبل',
          description: 'تمرکز: ثبات زانو',
        ),
        Exercise(
          id: 'ex_d1_4',
          name: 'پل باسن با مینی‌لوپ',
          sets: 3,
          repsOrDuration: 20,
          isTimeBased: false,
          restTime: 60,
          equipment: 'کش ورزشی',
          description: 'تمرکز: گلوتئوس ماکسیموس',
        ),
        Exercise(
          id: 'ex_d1_5',
          name: 'ساق پا ایستاده با دمبل',
          sets: 3,
          repsOrDuration: 20,
          isTimeBased: false,
          restTime: 45,
          equipment: 'دمبل',
          description: 'تقویت عضلات مچ پا',
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    );
  }

  WorkoutDay _createDay2() {
    return WorkoutDay(
      id: 'exo_pro_day_2',
      name: 'هایپرتروفی شانه و اصلاح قوز',
      orderIndex: 1,
      exercises: [
        ..._warmupExercises(),
        Exercise(
          id: 'ex_d2_1',
          name: 'پرس سرشانه نشسته (۱۷.۵ ک‌گ)',
          sets: 4,
          repsOrDuration: 10,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
          description: 'قدرتی',
        ),
        Exercise(
          id: 'ex_d2_2',
          name: 'نشر جانب دمبل (۵ ک‌گ)',
          sets: 4,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 60,
          equipment: 'دمبل',
          description: 'هایپرتروفی دلتوئید میانی',
        ),
        Exercise(
          id: 'ex_d2_3',
          name: 'نشر خم دمبل (۸ ک‌گ)',
          sets: 4,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 60,
          equipment: 'دمبل',
          description: 'اصلاح قوز - دلتوئید خلفی',
        ),
        Exercise(
          id: 'ex_d2_4',
          name: 'فیس‌پول با مینی‌لوپ',
          sets: 4,
          repsOrDuration: 20,
          isTimeBased: false,
          restTime: 45,
          equipment: 'کش ورزشی',
          description: 'اصلاح وضعیت گردن',
        ),
        Exercise(
          id: 'ex_d2_5',
          name: 'شنا سوئدی',
          sets: 3,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 60,
          equipment: 'وزن بدن',
          description: 'تقویت سینه و ثبات کتف',
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    );
  }

  WorkoutDay _createDay3() {
    return WorkoutDay(
      id: 'exo_pro_day_3',
      name: 'قدرت مرکزی و اصلاح لگن',
      orderIndex: 2,
      exercises: [
        ..._warmupExercises(),
        Exercise(
          id: 'ex_d3_1',
          name: 'اسکات سومو (۱۷.۵ ک‌گ)',
          sets: 4,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
          description: 'تمرکز: آداکتورها/داخل ران',
        ),
        Exercise(
          id: 'ex_d3_2',
          name: 'پلانک شکم',
          sets: 4,
          repsOrDuration: 60,
          isTimeBased: true,
          restTime: 45,
          equipment: 'وزن بدن',
        ),
        Exercise(
          id: 'ex_d3_3',
          name: 'پلانک پهلو',
          sets: 3,
          repsOrDuration: 45,
          isTimeBased: true,
          restTime: 45,
          equipment: 'وزن بدن',
        ),
        Exercise(
          id: 'ex_d3_4',
          name: 'ددباگ (Dead Bug)',
          sets: 3,
          repsOrDuration: 16,
          isTimeBased: false,
          restTime: 45,
          equipment: 'وزن بدن',
          description: 'اصلاح کمر و لگن',
        ),
        Exercise(
          id: 'ex_d3_5',
          name: 'پارویی دمبل تک‌دست (۱۷.۵ ک‌گ)',
          sets: 4,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
          description: 'اصلاح تقارن کمر',
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
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

    final updatedPlans = currentState.plans.map((p) {
      return p.id == updatedPlan.id ? updatedPlan : p;
    }).toList();

    state = AsyncData(
      currentState.copyWith(plans: updatedPlans, errorMessage: null),
    );
    await _saveData();
  }

  Future<void> addExercise(String dayId, Exercise exercise) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plan == null) return;

    final updatedDays = currentState.plan!.days.map((day) {
      if (day.id == dayId) {
        return day.addExercise(exercise);
      }
      return day;
    }).toList();

    final updatedPlan = currentState.plan!.copyWith(
      days: updatedDays,
      updatedAt: DateTime.now(),
    );

    await _updateCurrentPlan(updatedPlan);
  }

  Future<void> updateExercise(String dayId, String exerciseId, Exercise updatedExercise) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plan == null) return;

    final updatedDays = currentState.plan!.days.map((day) {
      if (day.id == dayId) {
        final updatedExercises = day.exercises.map((ex) {
          return ex.id == exerciseId ? updatedExercise : ex;
        }).toList();
        return day.copyWith(exercises: updatedExercises);
      }
      return day;
    }).toList();

    final updatedPlan = currentState.plan!.copyWith(
      days: updatedDays,
      updatedAt: DateTime.now(),
    );

    await _updateCurrentPlan(updatedPlan);
  }

  Future<void> removeExercise(String dayId, String exerciseId) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plan == null) return;

    final updatedDays = currentState.plan!.days.map((day) {
      if (day.id == dayId) {
        return day.removeExercise(exerciseId);
      }
      return day;
    }).toList();

    final updatedPlan = currentState.plan!.copyWith(
      days: updatedDays,
      updatedAt: DateTime.now(),
    );

    await _updateCurrentPlan(updatedPlan);
  }

  Future<void> completeDay(String dayId) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plan == null) return;

    final dayIndex = currentState.plan!.days.indexWhere((d) => d.id == dayId);
    if (dayIndex == -1) return;

    final day = currentState.plan!.days[dayIndex];
    if (day.isCompleted) return;

    // Build updated days list
    final updatedDays = [...currentState.plan!.days];
    updatedDays[dayIndex] = day.copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );

    final updatedPlan = currentState.plan!.copyWith(
      days: updatedDays,
      updatedAt: DateTime.now(),
    );

    // Determine next day: don't wrap to 0 if all days are done
    final allCompleted = updatedDays.every((d) => d.isCompleted);
    final nextDayIndex = allCompleted
        ? dayIndex
        : (dayIndex + 1) % updatedDays.length;

    // Build log entry inline to avoid intermediate state mutations
    final log = WorkoutLog(
      id: 'log_${DateTime.now().millisecondsSinceEpoch}',
      dayId: day.id,
      dayName: day.name,
      completedAt: DateTime.now(),
      exerciseCount: day.exercises.length,
      totalSets: day.exercises.fold(0, (sum, e) => sum + e.sets),
      totalDurationMinutes: day.estimatedDurationMinutes,
      hasMedia: day.exercises.any(
        (e) => e.media.type != ExerciseMediaType.none,
      ),
    );

    // Build updated plans list
    final updatedPlans = currentState.plans.map((p) {
      return p.id == updatedPlan.id ? updatedPlan : p;
    }).toList();

    // Single atomic state update
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

  Future<void> resetAllProgress() async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plan == null) return;

    final resetDays = currentState.plan!.days.map((day) {
      return day.copyWith(
        isCompleted: false,
        clearCompletedAt: true,
      );
    }).toList();

    final updatedPlan = currentState.plan!.copyWith(
      days: resetDays,
      updatedAt: DateTime.now(),
    );

    await _updateCurrentPlan(updatedPlan);
    // Re-read fresh state after _updateCurrentPlan mutated it
    final fresh = state.valueOrNull;
    if (fresh != null) {
      state = AsyncData(fresh.copyWith(currentDayIndex: 0));
      await _saveData();
    }
  }

  Future<void> resetEverything() async {
    final repository = ref.read(workoutRepositoryProvider);
    await repository.clearAll();
    state = AsyncData(_createDefaultState());
    await _saveData();
  }

  Future<void> addDay(String dayName) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plan == null) return;

    final newDayId =
        'day_${currentState.plan!.days.length + 1}_${DateTime.now().millisecondsSinceEpoch}';
    final newDay = WorkoutDay(
      id: newDayId,
      name: dayName,
      orderIndex: currentState.plan!.days.length,
      exercises: [],
      isUnlocked: true,
      isCompleted: false,
    );

    final updatedDays = [...currentState.plan!.days, newDay];
    final updatedPlan = currentState.plan!.copyWith(
      days: updatedDays,
      updatedAt: DateTime.now(),
    );

    await _updateCurrentPlan(updatedPlan);
  }

  Future<void> removeDay(String dayId) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plan == null) return;
    if (currentState.plan!.days.length <= 1) return;

    final updatedDays = currentState.plan!.days
        .where((d) => d.id != dayId)
        .toList();

    for (int i = 0; i < updatedDays.length; i++) {
      updatedDays[i] = updatedDays[i].copyWith(orderIndex: i);
    }

    final updatedPlan = currentState.plan!.copyWith(
      days: updatedDays,
      updatedAt: DateTime.now(),
    );

    int newCurrentIndex = currentState.currentDayIndex;
    if (newCurrentIndex >= updatedDays.length) {
      newCurrentIndex = updatedDays.length - 1;
    }

    await _updateCurrentPlan(updatedPlan);
    // Re-read fresh state after _updateCurrentPlan mutated it
    final fresh = state.valueOrNull;
    if (fresh != null) {
      state = AsyncData(fresh.copyWith(currentDayIndex: newCurrentIndex));
      await _saveData();
    }
  }

  Future<void> updatePlanName(String name) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plan == null) return;

    final updatedPlan = currentState.plan!.copyWith(
      name: name,
      updatedAt: DateTime.now(),
    );

    await _updateCurrentPlan(updatedPlan);
  }

  Future<void> updatePlanOrder(WorkoutPlan updatedPlan) async {
    await _updateCurrentPlan(updatedPlan);
  }

  Future<void> logCompletedWorkout({
    required String dayId,
    required String dayName,
    required List<Exercise> exercises,
    required int durationMinutes,
  }) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final log = WorkoutLog(
      id: 'log_${DateTime.now().millisecondsSinceEpoch}',
      dayId: dayId,
      dayName: dayName,
      completedAt: DateTime.now(),
      exerciseCount: exercises.length,
      totalSets: exercises.fold(0, (sum, e) => sum + e.sets),
      totalDurationMinutes: durationMinutes,
      hasMedia: exercises.any(
        (e) => e.media.type != ExerciseMediaType.none,
      ),
    );

    final updatedLogs = [log, ...currentState.workoutLogs];
    state = AsyncData(currentState.copyWith(workoutLogs: updatedLogs));
    await _saveLogs();
  }

  Future<List<WorkoutLog>> getWorkoutLogs() async {
    final repository = ref.read(workoutRepositoryProvider);
    final result = await repository.loadLogs();
    return result.fold(
      onSuccess: (logs) => logs,
      onError: (_) => [],
    );
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
        ? List.generate(
            dayNames.length,
            (i) => WorkoutDay(
              id:
                  'day_${i + 1}_${DateTime.now().millisecondsSinceEpoch}',
              name: dayNames[i],
              orderIndex: i,
              exercises: [],
              isUnlocked: true,
              isCompleted: false,
            ),
          )
        : [
            WorkoutDay(
              id: 'day_1_${DateTime.now().millisecondsSinceEpoch}',
              name: 'روز اول',
              orderIndex: 0,
              exercises: [],
              isUnlocked: true,
              isCompleted: false,
            ),
          ];

    final newPlan = WorkoutPlan(
      id: 'plan_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: 'برنامه جدید',
      days: days,
      createdAt: DateTime.now(),
      isActive: true,
    );

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

  Future<void> deletePlan(String planId) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plans.length <= 1) return;

    final updatedPlans = currentState.plans
        .where((p) => p.id != planId)
        .toList();

    String? newActivePlanId = currentState.activePlanId;
    if (newActivePlanId == planId) {
      newActivePlanId = updatedPlans.isNotEmpty ? updatedPlans.first.id : null;
    }

    const newDayIndex = 0;

    state = AsyncData(
      currentState.copyWith(
        plans: updatedPlans,
        activePlanId: newActivePlanId,
        currentDayIndex: newDayIndex,
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

  bool get allDaysCompleted {
    final currentPlan = plan;
    if (currentPlan == null || currentPlan.days.isEmpty) return false;
    return completedDaysCount == totalDays;
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
