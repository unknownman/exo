import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise.dart';
import '../models/workout_plan.dart';
import '../models/workout_log.dart';

part 'workout_provider.g.dart';

@riverpod
class WorkoutNotifier extends _$WorkoutNotifier {
  @override
  Future<WorkoutPlanState> build() async {
    return _loadInitialData();
  }

  Future<WorkoutPlanState> _loadInitialData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final plansJson = prefs.getString('workout_plans');
      final savedActivePlanId = prefs.getString('active_plan_id');
      final savedDayIndex = prefs.getInt('current_day_index');
      final logsJson = prefs.getString('workout_logs');

      List<WorkoutPlan> plans = [];
      String? activePlanId;

      if (plansJson != null && plansJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(plansJson) as List<dynamic>;
        plans = decoded
            .map((p) => WorkoutPlan.fromMap(p as Map<String, dynamic>))
            .toList();
      }

      if (plans.isEmpty) {
        final defaultPlan = _createDefaultPlan();
        plans = [defaultPlan];
        activePlanId = defaultPlan.id;
      } else {
        activePlanId = savedActivePlanId ?? plans.first.id;
      }

      final activePlan = plans.firstWhere(
        (p) => p.id == activePlanId,
        orElse: () => plans.first,
      );

      final restoredDayIndex = savedDayIndex ?? 0;

      List<WorkoutLog> workoutLogs = [];
      if (logsJson != null && logsJson.isNotEmpty) {
        final List<dynamic> decodedLogs = jsonDecode(logsJson) as List<dynamic>;
        workoutLogs = decodedLogs
            .map((l) => WorkoutLog.fromMap(l as Map<String, dynamic>))
            .toList();
      }

      return WorkoutPlanState(
        plans: plans,
        activePlanId: activePlanId,
        currentDayIndex: restoredDayIndex.clamp(0, activePlan.days.length - 1),
        isLoading: false,
        errorMessage: null,
        workoutLogs: workoutLogs,
      );
    } catch (e) {
      final defaultPlan = _createDefaultPlan();
      return WorkoutPlanState(
        plans: [defaultPlan],
        activePlanId: defaultPlan.id,
        currentDayIndex: 0,
        isLoading: false,
        errorMessage: 'خطا در بارگذاری داده‌ها',
      );
    }
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

  WorkoutPlan _createDefaultPlan() {
    return WorkoutPlan(
      id: 'running_strength_plan',
      name: 'برنامه ۳ روزه قدرت و حجم برای بهبود دویدن',
      description:
          'برنامه‌ای ترکیبی برای افزایش قدرت، حجم عضلانی کاربردی، ثبات مفاصل، بهبود عملکرد در دویدن و کاهش ریسک آسیب‌دیدگی.',
      days: [_createDay1(), _createDay2(), _createDay3()],
      createdAt: DateTime.now(),
      isActive: true,
    );
  }

  WorkoutDay _createDay1() {
    return WorkoutDay(
      id: 'run_day_1',
      name: 'روز اول - پایین‌تنه و ثبات لگن',
      orderIndex: 0,
      exercises: [
        Exercise(
          id: 'ex_r1_1',
          name: 'پل باسن با دمبل',
          sets: 3,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 60,
          equipment: 'دمبل',
        ),
        Exercise(
          id: 'ex_r1_2',
          name: 'ددلیفت رومانیایی با دمبل',
          sets: 3,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
        ),
        Exercise(
          id: 'ex_r1_3',
          name: 'اسکوات جام با دمبل',
          sets: 3,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
        ),
        Exercise(
          id: 'ex_r1_4',
          name: 'لانج معکوس کنترل‌شده',
          sets: 2,
          repsOrDuration: 10,
          isTimeBased: false,
          restTime: 60,
          equipment: 'دمبل',
        ),
        Exercise(
          id: 'ex_r1_5',
          name: 'راه رفتن جانبی با کش',
          sets: 3,
          repsOrDuration: 30,
          isTimeBased: true,
          restTime: 45,
          equipment: 'کش مقاومتی',
        ),
        Exercise(
          id: 'ex_r1_6',
          name: 'ساق پا تک‌پا',
          sets: 3,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 45,
          equipment: 'دمبل',
        ),
        Exercise(
          id: 'ex_r1_7',
          name: 'برد داگ',
          sets: 2,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 45,
          equipment: 'وزن بدن',
        ),
        Exercise(
          id: 'ex_r1_8',
          name: 'ددباگ',
          sets: 2,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 45,
          equipment: 'وزن بدن',
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    );
  }

  WorkoutDay _createDay2() {
    return WorkoutDay(
      id: 'run_day_2',
      name: 'روز دوم - بالاتنه و قدرت مرکزی',
      orderIndex: 1,
      exercises: [
        Exercise(
          id: 'ex_r2_1',
          name: 'پرس سرشانه نشسته با دمبل',
          sets: 3,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
        ),
        Exercise(
          id: 'ex_r2_2',
          name: 'پارویی تک‌دست با دمبل',
          sets: 3,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 75,
          equipment: 'دمبل',
        ),
        Exercise(
          id: 'ex_r2_3',
          name: 'شنا سوئدی',
          sets: 3,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 60,
          equipment: 'وزن بدن',
        ),
        Exercise(
          id: 'ex_r2_4',
          name: 'نشر خم دمبل',
          sets: 3,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 45,
          equipment: 'دمبل',
        ),
        Exercise(
          id: 'ex_r2_5',
          name: 'کشش کش برای پشت شانه',
          sets: 3,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 45,
          equipment: 'کش مقاومتی',
        ),
        Exercise(
          id: 'ex_r2_6',
          name: 'پلانک',
          sets: 3,
          repsOrDuration: 40,
          isTimeBased: true,
          restTime: 45,
          equipment: 'وزن بدن',
        ),
        Exercise(
          id: 'ex_r2_7',
          name: 'پلانک بغل',
          sets: 2,
          repsOrDuration: 30,
          isTimeBased: true,
          restTime: 45,
          equipment: 'وزن بدن',
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    );
  }

  WorkoutDay _createDay3() {
    return WorkoutDay(
      id: 'run_day_3',
      name: 'روز سوم - تمرین ترکیبی و اصلاحی',
      orderIndex: 2,
      exercises: [
        Exercise(
          id: 'ex_r3_1',
          name: 'اسکوات به جعبه با دمبل',
          sets: 3,
          repsOrDuration: 12,
          isTimeBased: false,
          restTime: 60,
          equipment: 'دمبل',
        ),
        Exercise(
          id: 'ex_r3_2',
          name: 'ددلیفت تک‌پا با دمبل',
          sets: 3,
          repsOrDuration: 10,
          isTimeBased: false,
          restTime: 60,
          equipment: 'دمبل',
        ),
        Exercise(
          id: 'ex_r3_3',
          name: 'بالا رفتن از پله با دمبل',
          sets: 3,
          repsOrDuration: 10,
          isTimeBased: false,
          restTime: 60,
          equipment: 'دمبل',
        ),
        Exercise(
          id: 'ex_r3_4',
          name: 'باز کردن پا به طرفین با کش',
          sets: 3,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 45,
          equipment: 'کش مقاومتی',
        ),
        Exercise(
          id: 'ex_r3_5',
          name: 'کلم‌شل با کش',
          sets: 3,
          repsOrDuration: 15,
          isTimeBased: false,
          restTime: 45,
          equipment: 'کش مقاومتی',
        ),
        Exercise(
          id: 'ex_r3_6',
          name: 'تعادل تک‌پا',
          sets: 2,
          repsOrDuration: 40,
          isTimeBased: true,
          restTime: 30,
          equipment: 'وزن بدن',
        ),
        Exercise(
          id: 'ex_r3_7',
          name: 'کشش همسترینگ و مچ پا',
          sets: 2,
          repsOrDuration: 45,
          isTimeBased: true,
          restTime: 30,
          equipment: 'وزن بدن',
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    );
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.plans.isEmpty) return;

    final plansJson = currentState.plans.map((p) => p.toMap()).toList();
    await prefs.setString('workout_plans', jsonEncode(plansJson));
    if (currentState.activePlanId != null) {
      await prefs.setString('active_plan_id', currentState.activePlanId!);
    }
    await prefs.setInt('current_day_index', currentState.currentDayIndex);
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

    final updatedDays = List<WorkoutDay>.from(currentState.plan!.days);
    updatedDays[dayIndex] = day.copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );

    final updatedPlan = currentState.plan!.copyWith(
      days: updatedDays,
      updatedAt: DateTime.now(),
    );

    final nextDayIndex = (dayIndex + 1) % updatedDays.length;

    await logCompletedWorkout(
      dayId: day.id,
      dayName: day.name,
      exercises: day.exercises,
      durationMinutes: day.estimatedDurationMinutes,
    );

    await _updateCurrentPlan(updatedPlan);
    state = AsyncData(
      currentState.copyWith(currentDayIndex: nextDayIndex),
    );
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
    state = AsyncData(currentState.copyWith(currentDayIndex: 0));
  }

  Future<void> resetEverything() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('workout_plans');
    await prefs.remove('active_plan_id');
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
    state = AsyncData(currentState.copyWith(currentDayIndex: newCurrentIndex));
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
    );

    final updatedLogs = [log, ...currentState.workoutLogs];
    state = AsyncData(currentState.copyWith(workoutLogs: updatedLogs));
    await _saveLogs();
  }

  Future<List<WorkoutLog>> getWorkoutLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final logsJson = prefs.getString('workout_logs');
      if (logsJson != null && logsJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(logsJson) as List<dynamic>;
        return decoded
            .map((e) => WorkoutLog.fromMap(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      // Ignore errors
    }
    return [];
  }

  Future<void> _saveLogs() async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;
    final prefs = await SharedPreferences.getInstance();
    final encoded = currentState.workoutLogs.map((l) => l.toMap()).toList();
    await prefs.setString('workout_logs', jsonEncode(encoded));
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
