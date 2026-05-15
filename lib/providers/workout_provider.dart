/// نسخه بهبود یافته - WorkoutProvider v2.0
/// تاریخ: ۱۴۰۴/۰۲/۲۵
/// تغییرات: اضافه شدن متدهای کمکی، بهبود امنیت، Error handling کامل

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise.dart';
import '../models/workout_day.dart';

class WorkoutProvider extends ChangeNotifier {
  // ═══════════════════════════════════════════════════════════
  // ثابت‌های کلاس
  // ═══════════════════════════════════════════════════════════

  static const String _storageKey = 'workout_data';
  static const int _defaultDayCount = 3;
  static const List<String> _defaultDayNames = [
    'روز اول',
    'روز دوم',
    'روز سوم',
  ];
  static const int _minRestSeconds = 5;
  static const int _maxRestSeconds = 300;
  static const int _minSets = 1;
  static const int _maxSets = 20;

  // ═══════════════════════════════════════════════════════════
  // State
  // ═══════════════════════════════════════════════════════════

  List<WorkoutDay> _days = [];
  bool _isLoading = false;
  String? _errorMessage;

  // ═══════════════════════════════════════════════════════════
  // Getters (فقط خواندنی - Immutable)
  // ═══════════════════════════════════════════════════════════

  /// لیست فقط‌خواندنی از روزهای تمرینی
  List<WorkoutDay> get days => List.unmodifiable(_days);

  /// وضعیت بارگذاری
  bool get isLoading => _isLoading;

  /// پیام خطای فعلی
  String? get errorMessage => _errorMessage;

  /// تعداد کل روزها
  int get totalDays => _days.length;

  /// تعداد روزهای تکمیل‌شده
  int get completedDaysCount => _days.where((d) => d.isCompletedToday).length;

  /// آیا همه روزها تکمیل شده‌اند
  bool get allDaysCompleted => completedDaysCount == totalDays && totalDays > 0;

  // ═══════════════════════════════════════════════════════════
  // Constructor
  // ═══════════════════════════════════════════════════════════

  WorkoutProvider() {
    _initializeDefaultDays();
  }

  // ═══════════════════════════════════════════════════════════
  // متدهای خصوصی (Private)
  // ═══════════════════════════════════════════════════════════

  /// راه‌اندازی روزهای پیش‌فرض
  void _initializeDefaultDays() {
    _days = List.generate(
      _defaultDayCount,
      (index) => WorkoutDay(
        id: index + 1,
        dayName: _defaultDayNames[index],
        exercises: [],
        isUnlocked: index == 0,
      ),
    );
  }

  /// یافتن ایندکس روز با شناسه (ایمن - nullable)
  int? _findDayIndex(int dayId) {
    try {
      final index = _days.indexWhere((d) => d.id == dayId);
      return index >= 0 ? index : null;
    } catch (e) {
      debugPrint('[WorkoutProvider] خطا در یافتن ایندکس روز: $e');
      return null;
    }
  }

  /// پاک کردن پیام خطا
  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// تنظیم پیام خطا
  void _setError(String message) {
    _errorMessage = message;
    debugPrint('[WorkoutProvider] خطا: $message');
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════
  // Persistence Methods (بارگذاری و ذخیره‌سازی)
  // ═══════════════════════════════════════════════════════════

  /// بارگذاری داده از SharedPreferences
  Future<void> loadData() async {
    _isLoading = true;
    _clearError();
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        try {
          final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
          _days = decoded
              .map((e) => WorkoutDay.fromMap(e as Map<String, dynamic>))
              .toList();
          debugPrint('[WorkoutProvider] ✓ بارگذاری موفق: ${_days.length} روز');
        } catch (parseError) {
          debugPrint('[WorkoutProvider] خطا در parsing داده: $parseError');
          _setError('خطا در خواندن داده‌ها. داده‌های پیش‌فرض بارگذاری می‌شود.');
          _initializeDefaultDays();
        }
      } else {
        debugPrint(
          '[WorkoutProvider] داده‌ای ذخیره نشده، استفاده از مقادیر پیش‌فرض',
        );
        _initializeDefaultDays();
      }
    } catch (e, stackTrace) {
      debugPrint('[WorkoutProvider] خطا در بارگذاری: $e');
      debugPrint('StackTrace: $stackTrace');
      _setError('خطا در بارگذاری داده‌ها');
      _initializeDefaultDays();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ذخیره داده در SharedPreferences
  Future<void> saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_days.map((d) => d.toMap()).toList());
      await prefs.setString(_storageKey, jsonString);
      debugPrint('[WorkoutProvider] ✓ ذخیره‌سازی موفق');
    } catch (e, stackTrace) {
      debugPrint('[WorkoutProvider] خطا در ذخیره‌سازی: $e');
      debugPrint('StackTrace: $stackTrace');
      _setError('خطا در ذخیره داده‌ها');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // Query Methods (متدهای پرس‌وجو)
  // ═══════════════════════════════════════════════════════════

  /// دریافت روز بر اساس شناسه (nullable)
  WorkoutDay? getDayById(int dayId) {
    final index = _findDayIndex(dayId);
    return index != null ? _days[index] : null;
  }

  /// دریافت تمرینات یک روز خاص
  List<Exercise> getExercisesForDay(int dayId) {
    final day = getDayById(dayId);
    return day != null ? List.unmodifiable(day.exercises) : [];
  }

  /// آیا روز قابل دسترسی است
  bool isDayUnlocked(int dayId) {
    final day = getDayById(dayId);
    return day?.isUnlocked ?? false;
  }

  /// آیا روز تکمیل شده است
  bool isDayCompleted(int dayId) {
    final day = getDayById(dayId);
    return day?.isCompletedToday ?? false;
  }

  /// دریافت روز بعدی (برای نمایش)
  WorkoutDay? getNextUnlockedDay() {
    try {
      return _days.firstWhere((d) => d.isUnlocked && !d.isCompletedToday);
    } catch (_) {
      return _days.isNotEmpty ? _days.first : null;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // Mutation Methods (متغیرهای وضعیت)
  // ═══════════════════════════════════════════════════════════

  /// اضافه کردن تمرین به یک روز خاص
  void addExercise(int dayId, Exercise exercise) {
    final index = _findDayIndex(dayId);

    if (index == null) {
      debugPrint('[WorkoutProvider] روز با id=$dayId یافت نشد');
      return;
    }

    // اعتبارسنجی ورودی
    if (exercise.name.trim().isEmpty) {
      _setError('نام تمرین نمی‌تواند خالی باشد');
      return;
    }

    if (exercise.sets < _minSets || exercise.sets > _maxSets) {
      _setError('تعداد ست باید بین $_minSets و $_maxSets باشد');
      return;
    }

    if (exercise.restTime < _minRestSeconds ||
        exercise.restTime > _maxRestSeconds) {
      _setError(
        'زمان استراحت باید بین $_minRestSeconds و $_maxRestSeconds ثانیه باشد',
      );
      return;
    }

    _days[index].exercises.add(exercise);
    saveData();
    notifyListeners();

    debugPrint(
      '[WorkoutProvider] ✓ تمرین "${exercise.name}" به روز $dayId اضافه شد',
    );
  }

  /// تکمیل یک روز و باز کردن روز بعدی
  Future<void> completeDay(int dayId) async {
    final index = _findDayIndex(dayId);

    if (index == null) {
      debugPrint('[WorkoutProvider] روز با id=$dayId یافت نشد');
      return;
    }

    // علامت‌گذاری روز فعلی به عنوان تکمیل‌شده
    _days[index].isCompletedToday = true;

    // باز کردن روز بعدی (اگر وجود دارد)
    final nextDayIndex = index + 1;
    if (nextDayIndex < _days.length) {
      _days[nextDayIndex].isUnlocked = true;
      debugPrint('[WorkoutProvider] ✓ روز ${nextDayIndex + 1} باز شد');
    }

    await saveData();
    notifyListeners();

    debugPrint('[WorkoutProvider] ✓ روز $dayId تکمیل شد');
  }

  /// حذف یک تمرین از روز
  void removeExercise(int dayId, String exerciseId) {
    final index = _findDayIndex(dayId);

    if (index == null) {
      debugPrint('[WorkoutProvider] روز با id=$dayId یافت نشد');
      return;
    }

    final exerciseIndex = _days[index].exercises.indexWhere(
      (e) => e.id == exerciseId,
    );

    if (exerciseIndex < 0) {
      debugPrint('[WorkoutProvider] تمرین با id=$exerciseId یافت نشد');
      return;
    }

    _days[index].exercises.removeAt(exerciseIndex);
    saveData();
    notifyListeners();

    debugPrint('[WorkoutProvider] ✓ تمرین با id=$exerciseId حذف شد');
  }

  /// بازنشانی پیشرفت یک روز خاص (بستن روزهای بعدی)
  void resetDayProgress(int dayId) {
    final index = _findDayIndex(dayId);

    if (index == null) {
      debugPrint('[WorkoutProvider] روز با id=$dayId یافت نشد');
      return;
    }

    // بازنشانی وضعیت روز فعلی
    _days[index].isCompletedToday = false;

    // بستن تمام روزهای بعدی
    for (int i = index + 1; i < _days.length; i++) {
      _days[i].isUnlocked = false;
    }

    saveData();
    notifyListeners();

    debugPrint('[WorkoutProvider] ✓ پیشرفت روز $dayId بازنشانی شد');
  }

  /// بازنشانی پیشرفت تمام روزها
  void resetAllProgress() {
    for (int i = 0; i < _days.length; i++) {
      if (i == 0) {
        _days[i].isUnlocked = true;
      } else {
        _days[i].isUnlocked = false;
      }
      _days[i].isCompletedToday = false;
    }

    saveData();
    notifyListeners();

    debugPrint('[WorkoutProvider] ✓ پیشرفت تمام روزها بازنشانی شد');
  }

  /// پاک کردن تمام داده‌ها و شروع مجدد
  void resetAllData() {
    _initializeDefaultDays();
    saveData();
    notifyListeners();

    debugPrint('[WorkoutProvider] ✓ تمام داده‌ها بازنشانی شد');
  }

  // ═══════════════════════════════════════════════════════════
  // Validation Helpers
  // ═══════════════════════════════════════════════════════════

  /// اعتبارسنجی نام تمرین
  bool isValidExerciseName(String name) {
    return name.trim().isNotEmpty && name.trim().length >= 2;
  }

  /// اعتبارسنجی تعداد ست
  bool isValidSets(int sets) {
    return sets >= _minSets && sets <= _maxSets;
  }

  /// اعتبارسنجی زمان استراحت
  bool isValidRestTime(int seconds) {
    return seconds >= _minRestSeconds && seconds <= _maxRestSeconds;
  }

  /// اعتبارسنجی تعداد تکرار/زمان
  bool isValidRepsOrDuration(int value, {bool isTimeBased = false}) {
    if (isTimeBased) {
      return value > 0 && value <= 3600; // حداکثر ۱ ساعت
    }
    return value > 0 && value <= 100;
  }
}
