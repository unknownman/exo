import 'dart:async';
import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_day.dart';
import '../models/exercise.dart';

part 'workout_provider.g.dart';

@riverpod
class WorkoutNotifier extends _$WorkoutNotifier {
  @override
  Future<WorkoutState> build() async {
    return _loadInitialData();
  }

  Future<WorkoutState> _loadInitialData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final daysJson = prefs.getString('workout_days');

      if (daysJson != null && daysJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(daysJson) as List<dynamic>;
        if (decoded.isNotEmpty) {
          final days = decoded
              .map((e) => WorkoutDay.fromMap(e as Map<String, dynamic>))
              .toList();
          return WorkoutState(days: days, isLoading: false, errorMessage: null);
        }
      }
      return _createDefaultState();
    } catch (e) {
      return WorkoutState(
        days: _getDefaultDays(),
        isLoading: false,
        errorMessage: 'خطا در بارگذاری داده‌ها',
      );
    }
  }

  WorkoutState _createDefaultState() {
    return WorkoutState(
      days: _getDefaultDays(),
      isLoading: false,
      errorMessage: null,
    );
  }

  List<WorkoutDay> _getDefaultDays() {
    return [
      WorkoutDay(
        id: 1,
        dayName: 'روز اول - سینه و شانه',
        exercises: _getDay1Exercises(),
        isUnlocked: true,
      ),
      WorkoutDay(
        id: 2,
        dayName: 'روز دوم - پا و شکم',
        exercises: _getDay2Exercises(),
        isUnlocked: false,
      ),
      WorkoutDay(
        id: 3,
        dayName: 'روز سوم - کمر و جلو بازو',
        exercises: _getDay3Exercises(),
        isUnlocked: false,
      ),
    ];
  }

  List<Exercise> _getDay1Exercises() => [
    Exercise(
      id: 'e1_1',
      name: 'پرس سینه هالتر',
      sets: 4,
      repsOrDuration: 12,
      isTimeBased: false,
      restTime: 90,
      equipment: 'هالتر',
    ),
    Exercise(
      id: 'e1_2',
      name: 'زیربغل سیم‌کش',
      sets: 3,
      repsOrDuration: 12,
      isTimeBased: false,
      restTime: 60,
      equipment: 'سیم‌کش',
    ),
    Exercise(
      id: 'e1_3',
      name: 'پرس سرشانه',
      sets: 3,
      repsOrDuration: 10,
      isTimeBased: false,
      restTime: 60,
      equipment: 'دستگاه',
    ),
    Exercise(
      id: 'e1_4',
      name: 'نشر از جانب',
      sets: 3,
      repsOrDuration: 15,
      isTimeBased: false,
      restTime: 45,
      equipment: 'دمبل',
    ),
    Exercise(
      id: 'e1_5',
      name: 'کراس اور',
      sets: 3,
      repsOrDuration: 12,
      isTimeBased: false,
      restTime: 45,
      equipment: 'سیم‌کش',
    ),
  ];

  List<Exercise> _getDay2Exercises() => [
    Exercise(
      id: 'e2_1',
      name: 'اسکات',
      sets: 4,
      repsOrDuration: 12,
      isTimeBased: false,
      restTime: 90,
      equipment: 'هالتر',
    ),
    Exercise(
      id: 'e2_2',
      name: 'پرس پا',
      sets: 3,
      repsOrDuration: 15,
      isTimeBased: false,
      restTime: 60,
      equipment: 'دستگاه',
    ),
    Exercise(
      id: 'e2_3',
      name: 'لانگ',
      sets: 3,
      repsOrDuration: 10,
      isTimeBased: false,
      restTime: 45,
      equipment: 'دمبل',
    ),
    Exercise(
      id: 'e2_4',
      name: 'کرانچ',
      sets: 3,
      repsOrDuration: 20,
      isTimeBased: false,
      restTime: 30,
      equipment: 'بدون',
    ),
    Exercise(
      id: 'e2_5',
      name: 'پلانک',
      sets: 3,
      repsOrDuration: 45,
      isTimeBased: true,
      restTime: 30,
      equipment: 'بدون',
    ),
  ];

  List<Exercise> _getDay3Exercises() => [
    Exercise(
      id: 'e3_1',
      name: 'زیربغل',
      sets: 4,
      repsOrDuration: 12,
      isTimeBased: false,
      restTime: 90,
      equipment: 'هالتر',
    ),
    Exercise(
      id: 'e3_2',
      name: 'لت پول',
      sets: 3,
      repsOrDuration: 12,
      isTimeBased: false,
      restTime: 60,
      equipment: 'دستگاه',
    ),
    Exercise(
      id: 'e3_3',
      name: 'بارفیکس',
      sets: 3,
      repsOrDuration: 8,
      isTimeBased: false,
      restTime: 60,
      equipment: 'بارفیکس',
    ),
    Exercise(
      id: 'e3_4',
      name: 'جلو بازو لاری',
      sets: 3,
      repsOrDuration: 12,
      isTimeBased: false,
      restTime: 45,
      equipment: 'دمبل',
    ),
    Exercise(
      id: 'e3_5',
      name: 'پشت بازو پushdown',
      sets: 3,
      repsOrDuration: 12,
      isTimeBased: false,
      restTime: 45,
      equipment: 'سیم‌کش',
    ),
  ];

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final currentState = state.valueOrNull;
    if (currentState == null) return;
    final encoded = currentState.days.map((d) => d.toMap()).toList();
    await prefs.setString('workout_days', jsonEncode(encoded));
  }

  Future<void> addExercise(int dayId, Exercise exercise) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final index = currentState.getDayIndex(dayId);
    if (index == null) return;

    final updatedDays = List<WorkoutDay>.from(currentState.days);
    updatedDays[index] = updatedDays[index].addExercise(exercise);

    state = AsyncData(
      currentState.copyWith(days: updatedDays, errorMessage: null),
    );
    await _saveData();
  }

  Future<void> removeExercise(int dayId, String exerciseId) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final index = currentState.getDayIndex(dayId);
    if (index == null) return;

    final updatedDays = List<WorkoutDay>.from(currentState.days);
    updatedDays[index] = updatedDays[index].removeExercise(exerciseId);

    state = AsyncData(
      currentState.copyWith(days: updatedDays, errorMessage: null),
    );
    await _saveData();
  }

  Future<void> completeDay(int dayId) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final index = currentState.getDayIndex(dayId);
    if (index == null) return;

    final currentDay = currentState.days[index];
    if (currentDay.isCompletedToday) return;

    final updatedDays = List<WorkoutDay>.from(currentState.days);
    updatedDays[index] = currentDay.copyWith(isCompletedToday: true);

    final nextDayIndex = index + 1;
    if (nextDayIndex < updatedDays.length) {
      final nextDay = updatedDays[nextDayIndex];
      if (!nextDay.isUnlocked) {
        updatedDays[nextDayIndex] = nextDay.copyWith(isUnlocked: true);
      }
    }

    state = AsyncData(
      currentState.copyWith(days: updatedDays, errorMessage: null),
    );
    await _saveData();
  }

  Future<void> resetAllProgress() async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final resetDays = currentState.days.asMap().entries.map((entry) {
      return entry.value.copyWith(
        isCompletedToday: false,
        isUnlocked: entry.key == 0,
      );
    }).toList();

    state = AsyncData(
      currentState.copyWith(days: resetDays, errorMessage: null),
    );
    await _saveData();
  }

  Future<void> resetEverything() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('workout_days');
    state = AsyncData(_createDefaultState());
    await _saveData();
  }
}

class WorkoutState {
  final List<WorkoutDay> days;
  final bool isLoading;
  final String? errorMessage;

  const WorkoutState({
    this.days = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  WorkoutState copyWith({
    List<WorkoutDay>? days,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return WorkoutState(
      days: days ?? this.days,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  List<WorkoutDay> get daysUnmodifiable => List.unmodifiable(days);

  int get totalDays => days.length;

  int get completedDaysCount => days.where((d) => d.isCompletedToday).length;

  bool get allDaysCompleted => completedDaysCount == totalDays && totalDays > 0;

  WorkoutDay? getDayById(int dayId) {
    final index = days.indexWhere((d) => d.id == dayId);
    return index >= 0 ? days[index] : null;
  }

  int? getDayIndex(int dayId) {
    final index = days.indexWhere((d) => d.id == dayId);
    return index >= 0 ? index : null;
  }
}
