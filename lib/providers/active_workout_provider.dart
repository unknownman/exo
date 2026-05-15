/// ActiveWorkoutProvider - مدیریت وضعیت تمرین فعال
/// نسخه: ۱.۰
/// تاریخ: ۱۴۰۴/۰۲/۲۵

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/exercise.dart';
import 'workout_provider.dart';

/// وضعیت تمرین فعال (Immutable)
class ActiveWorkoutState {
  final int? dayId;
  final int currentExerciseIndex;
  final int currentSet;
  final bool isResting;
  final bool isWorkoutTimerRunning;
  final int remainingWorkoutSeconds;
  final int remainingRestSeconds;
  final bool isAllDone;
  final bool isLoading;
  final String? errorMessage;

  const ActiveWorkoutState({
    this.dayId,
    this.currentExerciseIndex = 0,
    this.currentSet = 1,
    this.isResting = false,
    this.isWorkoutTimerRunning = false,
    this.remainingWorkoutSeconds = 0,
    this.remainingRestSeconds = 0,
    this.isAllDone = false,
    this.isLoading = false,
    this.errorMessage,
  });

  factory ActiveWorkoutState.initial() => const ActiveWorkoutState();

  bool get hasDay => dayId != null;

  bool get hasError => errorMessage != null;

  ActiveWorkoutState copyWith({
    int? dayId,
    int? currentExerciseIndex,
    int? currentSet,
    bool? isResting,
    bool? isWorkoutTimerRunning,
    int? remainingWorkoutSeconds,
    int? remainingRestSeconds,
    bool? isAllDone,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool clearDay = false,
  }) {
    return ActiveWorkoutState(
      dayId: clearDay ? null : (dayId ?? this.dayId),
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      currentSet: currentSet ?? this.currentSet,
      isResting: isResting ?? this.isResting,
      isWorkoutTimerRunning:
          isWorkoutTimerRunning ?? this.isWorkoutTimerRunning,
      remainingWorkoutSeconds:
          remainingWorkoutSeconds ?? this.remainingWorkoutSeconds,
      remainingRestSeconds: remainingRestSeconds ?? this.remainingRestSeconds,
      isAllDone: isAllDone ?? this.isAllDone,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Provider برای تمرین فعال
class ActiveWorkoutProvider extends ChangeNotifier {
  final WorkoutProvider _workoutProvider;
  Timer? _timer;

  ActiveWorkoutState _state = ActiveWorkoutState.initial();
  ActiveWorkoutState get state => _state;

  ActiveWorkoutProvider(this._workoutProvider);

  /// دریافت لیست تمرینات روز جاری
  List<Exercise> get _exercises {
    if (_state.dayId == null) return [];
    final day = _workoutProvider.getDayById(_state.dayId!);
    return day?.exercises ?? [];
  }

  /// تعداد کل تمرینات
  int get totalExercises => _exercises.length;

  /// تمرین فعلی (nullable برای جلوگیری از crash)
  Exercise? get currentExercise {
    if (_exercises.isEmpty) return null;
    final idx = _state.currentExerciseIndex;
    return idx < _exercises.length ? _exercises[idx] : null;
  }

  /// آیا تمرینی وجود دارد
  bool get hasExercises => _exercises.isNotEmpty;

  /// آیا روز قابل شروع است
  bool get canStart => _state.dayId != null && hasExercises;

  /// ═══════════════════════════════════════════════════════════
  /// متدهای اصلی
  /// ═══════════════════════════════════════════════════════════

  /// شروع تمرین برای یک روز خاص
  Future<void> startWorkout(int dayId) async {
    final exercises = _workoutProvider.getExercisesForDay(dayId);

    if (exercises.isEmpty) {
      _state = _state.copyWith(
        errorMessage: 'هیچ تمرینی برای این روز تعریف نشده است',
      );
      debugPrint('[ActiveWorkoutProvider] خطا: روز $dayId تمرینی ندارد');
      notifyListeners();
      return;
    }

    _state = ActiveWorkoutState(dayId: dayId);
    _resetWorkoutTimer();

    debugPrint('[ActiveWorkoutProvider] ✓ تمرین شروع شد: روز $dayId');
    notifyListeners();
  }

  /// شروع/توقف تایمر تمرین زمانی
  void toggleTimer() {
    if (currentExercise == null || !currentExercise!.isTimeBased) return;

    if (_state.isWorkoutTimerRunning) {
      _stopTimer();
      _state = _state.copyWith(isWorkoutTimerRunning: false);
      debugPrint('[ActiveWorkoutProvider] تایمر متوقف شد');
    } else {
      _startWorkoutTimer();
    }
    notifyListeners();
  }

  /// پایان ست فعلی
  void finishSet() {
    _stopTimer();

    final exercise = currentExercise;
    if (exercise == null) {
      debugPrint('[ActiveWorkoutProvider] خطا: تمرین فعلی یافت نشد');
      return;
    }

    if (_state.currentSet < exercise.sets) {
      _state = _state.copyWith(currentSet: _state.currentSet + 1);
      _resetWorkoutTimer();
      debugPrint('[ActiveWorkoutProvider] ست ${_state.currentSet} شروع شد');
    } else {
      nextExercise();
    }
  }

  /// رد کردن استراحت
  void skipRest() {
    _stopTimer();
    _onRestEnd();
  }

  /// رفتن به تمرین بعدی
  void nextExercise() {
    final exercises = _exercises;

    if (exercises.isEmpty) {
      _completeWorkout();
      return;
    }

    final nextIndex = _state.currentExerciseIndex + 1;
    if (nextIndex < exercises.length) {
      _state = _state.copyWith(
        currentExerciseIndex: nextIndex,
        currentSet: 1,
        isResting: false,
      );
      _resetWorkoutTimer();
      debugPrint('[ActiveWorkoutProvider] رفتن به تمرین ${nextIndex + 1}');
    } else {
      _completeWorkout();
    }
    notifyListeners();
  }

  /// پایان و ثبت تمرین
  Future<void> finishWorkout() async {
    final dayId = _state.dayId;
    if (dayId == null) return;

    _stopTimer();

    await _workoutProvider.completeDay(dayId);

    _state = ActiveWorkoutState.initial();

    debugPrint('[ActiveWorkoutProvider] ✓ تمرین روز $dayId ثبت شد');
    notifyListeners();
  }

  /// لغو و بازگشت بدون ثبت
  void cancelWorkout() {
    _stopTimer();
    _state = ActiveWorkoutState.initial();
    debugPrint('[ActiveWorkoutProvider] تمرین لغو شد');
    notifyListeners();
  }

  /// ═══════════════════════════════════════════════════════════
  /// متدهای داخلی تایمر
  /// ═══════════════════════════════════════════════════════════

  void _resetWorkoutTimer() {
    final exercise = currentExercise;
    if (exercise == null || !exercise.isTimeBased) return;

    _state = _state.copyWith(
      remainingWorkoutSeconds: exercise.repsOrDuration,
      isWorkoutTimerRunning: false,
    );
  }

  void _startWorkoutTimer() {
    _stopTimer();

    _state = _state.copyWith(isWorkoutTimerRunning: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_state.remainingWorkoutSeconds <= 0) {
        _stopTimer();
        _startRest();
        return;
      }

      _state = _state.copyWith(
        remainingWorkoutSeconds: _state.remainingWorkoutSeconds - 1,
      );
      notifyListeners();
    });
  }

  void _startRest() {
    final exercise = currentExercise;
    if (exercise == null) return;

    _state = _state.copyWith(
      isResting: true,
      isWorkoutTimerRunning: false,
      remainingRestSeconds: exercise.restTime,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_state.remainingRestSeconds <= 0) {
        _stopTimer();
        _onRestEnd();
        return;
      }

      _state = _state.copyWith(
        remainingRestSeconds: _state.remainingRestSeconds - 1,
      );
      notifyListeners();
    });

    debugPrint(
      '[ActiveWorkoutProvider] استراحت شروع شد: ${exercise.restTime} ثانیه',
    );
  }

  void _onRestEnd() {
    final exercise = currentExercise;
    if (exercise == null) {
      _completeWorkout();
      return;
    }

    _state = _state.copyWith(isResting: false);

    if (_state.currentSet < exercise.sets) {
      _state = _state.copyWith(currentSet: _state.currentSet + 1);
      _resetWorkoutTimer();
      debugPrint('[ActiveWorkoutProvider] ست ${_state.currentSet} شروع شد');
    } else {
      nextExercise();
    }
    notifyListeners();
  }

  void _completeWorkout() {
    _state = _state.copyWith(isAllDone: true, isResting: false);
    debugPrint('[ActiveWorkoutProvider] ✓ همه تمرینات انجام شد');
    notifyListeners();
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// ═══════════════════════════════════════════════════════════
  /// Lifecycle
  /// ═══════════════════════════════════════════════════════════

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}

/// تابع کمکی برای فرمت زمان
String formatWorkoutTime(int seconds) {
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final secs = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$secs';
}
