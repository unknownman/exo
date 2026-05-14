import 'exercise.dart';

class WorkoutDay {
  final int id;
  final String dayName;
  final List<Exercise> exercises;
  bool isUnlocked;
  bool isCompletedToday;

  WorkoutDay({
    required this.id,
    required this.dayName,
    required this.exercises,
    this.isUnlocked = false,
    this.isCompletedToday = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dayName': dayName,
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'isUnlocked': isUnlocked,
      'isCompletedToday': isCompletedToday,
    };
  }

  factory WorkoutDay.fromMap(Map<String, dynamic> map) {
    return WorkoutDay(
      id: map['id'] as int,
      dayName: map['dayName'] as String,
      exercises: (map['exercises'] as List)
          .map((e) => Exercise.fromMap(e as Map<String, dynamic>))
          .toList(),
      isUnlocked: map['isUnlocked'] as bool,
      isCompletedToday: map['isCompletedToday'] as bool,
    );
  }
}
