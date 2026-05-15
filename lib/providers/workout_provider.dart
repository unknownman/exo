import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise.dart';
import '../models/workout_day.dart';

class WorkoutProvider extends ChangeNotifier {
  List<WorkoutDay> _days = [];

  /// کلید ذخیره‌سازی در SharedPreferences
  static const String _storageKey = 'workout_data';

  /// تعداد پیش‌فرض روزهای تمرینی
  static const int _defaultDayCount = 3;

  /// نام پیش‌فرض روزها
  static const List<String> _defaultDayNames = [
    'روز اول',
    'روز دوم',
    'روز سوم',
  ];

  /// لیست readonly از روزهای تمرینی (ایمن برای خارج شدن از کلاس)
  List<WorkoutDay> get days => List.unmodifiable(_days);

  WorkoutProvider() {
    _initDefaultDays();
  }

  /// راه‌اندازی روزهای پیش‌فرض
  void _initDefaultDays() {
    _days = List.generate(
      _defaultDayCount,
      (index) => WorkoutDay(
        id: index + 1,
        dayName: _defaultDayNames[index],
        exercises: [],
        isUnlocked: index == 0, // فقط روز اول باز است
      ),
    );
  }

  /// بارگذاری داده از SharedPreferences
  Future<void> loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
        _days = decoded
            .map((e) => WorkoutDay.fromMap(e as Map<String, dynamic>))
            .toList();
        debugPrint(
          '[WorkoutProvider] داده با موفقیت بارگذاری شد: ${_days.length} روز',
        );
      } else {
        debugPrint(
          '[WorkoutProvider] داده‌ای ذخیره نشده، استفاده از مقادیر پیش‌فرض',
        );
      }
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('[WorkoutProvider] خطا در بارگذاری داده: $e');
      debugPrint('StackTrace: $stackTrace');
      // در صورت خطا، داده‌های پیش‌فرض حفظ می‌شوند
    }
  }

  /// ذخیره داده در SharedPreferences
  Future<void> saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_days.map((d) => d.toMap()).toList());
      await prefs.setString(_storageKey, jsonString);
      debugPrint('[WorkoutProvider] داده با موفقیت ذخیره شد');
    } catch (e, stackTrace) {
      debugPrint('[WorkoutProvider] خطا در ذخیره داده: $e');
      debugPrint('StackTrace: $stackTrace');
      // خطا را پرتاب نمی‌کنیم تا اپ کرش نکند
    }
  }

  /// یافتن ایندکس روز بر اساس id (nullable)
  int? _findDayIndex(int dayId) {
    try {
      return _days.indexWhere((d) => d.id == dayId);
    } catch (e) {
      debugPrint('[WorkoutProvider] خطا در جستجوی روز: $e');
      return null;
    }
  }

  /// دریافت روز بر اساس id (nullable)
  WorkoutDay? getDayById(int dayId) {
    final index = _findDayIndex(dayId);
    return index != null && index >= 0 ? _days[index] : null;
  }

  /// اضافه کردن تمرین به یک روز خاص (ایمن)
  void addExercise(int dayId, Exercise exercise) {
    final index = _findDayIndex(dayId);
    if (index == null || index < 0) {
      debugPrint('[WorkoutProvider] روز با id=$dayId یافت نشد');
      return;
    }

    _days[index].exercises.add(exercise);
    saveData();
    notifyListeners();
    debugPrint(
      '[WorkoutProvider] تمرین "${exercise.name}" به روز $dayId اضافه شد',
    );
  }

  /// تکمیل یک روز و باز کردن روز بعدی (ایمن)
  Future<void> completeDay(int dayId) async {
    final index = _findDayIndex(dayId);
    if (index == null || index < 0) {
      debugPrint('[WorkoutProvider] روز با id=$dayId یافت نشد');
      return;
    }

    _days[index].isCompletedToday = true;

    // باز کردن روز بعدی
    final nextDayIndex = index + 1;
    if (nextDayIndex < _days.length) {
      _days[nextDayIndex].isUnlocked = true;
      debugPrint('[WorkoutProvider] روز ${nextDayIndex + 1} باز شد');
    }

    await saveData();
    notifyListeners();
  }

  /// بازنشانی پیشرفت یک روز خاص
  void resetDayProgress(int dayId) {
    final index = _findDayIndex(dayId);
    if (index == null || index < 0) {
      debugPrint('[WorkoutProvider] روز با id=$dayId یافت نشد');
      return;
    }

    _days[index].isCompletedToday = false;
    // بستن روزهای بعدی (اگر بخواهیم سیستم sequential داشته باشیم)
    for (int i = index + 1; i < _days.length; i++) {
      _days[i].isUnlocked = false;
    }

    saveData();
    notifyListeners();
    debugPrint('[WorkoutProvider] پیشرفت روز $dayId بازنشانی شد');
  }

  /// پاک کردن تمام داده‌ها و شروع مجدد
  void resetAllData() {
    _initDefaultDays();
    saveData();
    notifyListeners();
    debugPrint('[WorkoutProvider] تمام داده‌ها بازنشانی شد');
  }
}
