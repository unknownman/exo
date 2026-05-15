/// WorkoutDay Model
/// نسخه: ۱.۰
/// تاریخ: ۱۴۰۴/۰۲/۲۵

import 'exercise.dart';

class WorkoutDay {
  final int id;
  final String dayName;
  final List<Exercise> exercises;
  final bool isUnlocked;
  final bool isCompletedToday;

  const WorkoutDay({
    required this.id,
    required this.dayName,
    required this.exercises,
    this.isUnlocked = false,
    this.isCompletedToday = false,
  });

  /// آیا تمرینی وجود دارد
  bool get hasExercises => exercises.isNotEmpty;

  /// تعداد تمرینات
  int get exerciseCount => exercises.length;

  /// آیا قابل تمرین است
  bool get canExercise => isUnlocked && hasExercises && !isCompletedToday;

  /// ساخت کپی با مقادیر جدید
  WorkoutDay copyWith({
    int? id,
    String? dayName,
    List<Exercise>? exercises,
    bool? isUnlocked,
    bool? isCompletedToday,
  }) {
    return WorkoutDay(
      id: id ?? this.id,
      dayName: dayName ?? this.dayName,
      exercises: exercises ?? List.from(this.exercises),
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
    );
  }

  /// اضافه کردن تمرین جدید
  WorkoutDay addExercise(Exercise exercise) {
    return copyWith(exercises: [...exercises, exercise]);
  }

  /// حذف تمرین با شناسه
  WorkoutDay removeExercise(String exerciseId) {
    return copyWith(
      exercises: exercises.where((e) => e.id != exerciseId).toList(),
    );
  }

  /// تبدیل به Map برای ذخیره‌سازی
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dayName': dayName,
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'isUnlocked': isUnlocked,
      'isCompletedToday': isCompletedToday,
    };
  }

  /// ساخت از Map
  factory WorkoutDay.fromMap(Map<String, dynamic> map) {
    return WorkoutDay(
      id: map['id'] as int,
      dayName: map['dayName'] as String,
      exercises: (map['exercises'] as List)
          .map((e) => Exercise.fromMap(e as Map<String, dynamic>))
          .toList(),
      isUnlocked: map['isUnlocked'] as bool? ?? false,
      isCompletedToday: map['isCompletedToday'] as bool? ?? false,
    );
  }

  /// مقایسه بر اساس مقدار (Value Equality)
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutDay &&
        other.id == id &&
        other.dayName == dayName &&
        other.isUnlocked == isUnlocked &&
        other.isCompletedToday == isCompletedToday;
  }

  @override
  int get hashCode {
    return Object.hash(id, dayName, isUnlocked, isCompletedToday);
  }

  @override
  String toString() {
    return 'WorkoutDay(id: $id, dayName: $dayName, exercises: $exerciseCount, '
        'isUnlocked: $isUnlocked, isCompletedToday: $isCompletedToday)';
  }
}
