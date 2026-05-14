import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise.dart';
import '../models/workout_day.dart';

class WorkoutProvider extends ChangeNotifier {
  List<WorkoutDay> _days = [];
  static const String _storageKey = 'workout_data';

  List<WorkoutDay> get days => _days;

  WorkoutProvider() {
    _initDefaultDays();
  }

  void _initDefaultDays() {
    _days = [
      WorkoutDay(id: 1, dayName: 'روز اول', exercises: [], isUnlocked: true),
      WorkoutDay(id: 2, dayName: 'روز دوم', exercises: [], isUnlocked: false),
      WorkoutDay(id: 3, dayName: 'روز سوم', exercises: [], isUnlocked: false),
    ];
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
      _days = decoded
          .map((e) => WorkoutDay.fromMap(e as Map<String, dynamic>))
          .toList();
      notifyListeners();
    }
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        jsonEncode(_days.map((d) => d.toMap()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  void addExercise(int dayId, Exercise exercise) {
    final day = _days.firstWhere((d) => d.id == dayId);
    day.exercises.add(exercise);
    saveData();
    notifyListeners();
  }

  Future<void> completeDay(int dayId) async {
    final day = _days.firstWhere((d) => d.id == dayId);
    day.isCompletedToday = true;

    final nextDayIndex = _days.indexOf(day) + 1;
    if (nextDayIndex < _days.length) {
      _days[nextDayIndex].isUnlocked = true;
    }

    await saveData();
    notifyListeners();
  }
}
