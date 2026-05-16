import 'exercise.dart';

class WorkoutPlan {
  final String id;
  final String name;
  final String? description;
  final List<WorkoutDay> days;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  const WorkoutPlan({
    required this.id,
    required this.name,
    this.description,
    required this.days,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  int get totalExercises =>
      days.fold(0, (sum, day) => sum + day.exercises.length);

  int get totalSets => days.fold(0, (sum, day) => sum + day.totalSets);

  int get totalDurationMinutes {
    return days.fold(0, (sum, day) => sum + day.estimatedDurationMinutes);
  }

  WorkoutPlan copyWith({
    String? id,
    String? name,
    String? description,
    List<WorkoutDay>? days,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return WorkoutPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      days: days ?? List.from(this.days),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'days': days.map((d) => d.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory WorkoutPlan.fromMap(Map<String, dynamic> map) {
    return WorkoutPlan(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      days: (map['days'] as List)
          .map((d) => WorkoutDay.fromMap(d as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutPlan && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class WorkoutDay {
  final String id;
  final String name;
  final int orderIndex;
  final List<Exercise> exercises;
  final bool isUnlocked;
  final bool isCompleted;
  final DateTime? completedAt;

  const WorkoutDay({
    required this.id,
    required this.name,
    required this.orderIndex,
    this.exercises = const [],
    this.isUnlocked = false,
    this.isCompleted = false,
    this.completedAt,
  });

  int get totalSets => exercises.fold(0, (sum, e) => sum + e.sets);

  int get estimatedDurationMinutes {
    if (exercises.isEmpty) return 0;
    int total = 0;
    for (final ex in exercises) {
      if (ex.isTimeBased) {
        total += ex.repsOrDuration * ex.sets;
      } else {
        total += ex.sets * 45;
      }
      total += ex.restTime * (ex.sets - 1);
    }
    total += 30 * exercises.length;
    return (total / 60).ceil();
  }

  WorkoutDay copyWith({
    String? id,
    String? name,
    int? orderIndex,
    List<Exercise>? exercises,
    bool? isUnlocked,
    bool? isCompleted,
    DateTime? completedAt,
    bool clearCompletedAt = false,
  }) {
    return WorkoutDay(
      id: id ?? this.id,
      name: name ?? this.name,
      orderIndex: orderIndex ?? this.orderIndex,
      exercises: exercises ?? List.from(this.exercises),
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
    );
  }

  WorkoutDay addExercise(Exercise exercise) {
    return copyWith(exercises: [...exercises, exercise]);
  }

  WorkoutDay removeExercise(String exerciseId) {
    return copyWith(
      exercises: exercises.where((e) => e.id != exerciseId).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'orderIndex': orderIndex,
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'isUnlocked': isUnlocked,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory WorkoutDay.fromMap(Map<String, dynamic> map) {
    return WorkoutDay(
      id: map['id'] as String,
      name: map['name'] as String,
      orderIndex: map['orderIndex'] as int,
      exercises:
          (map['exercises'] as List?)
              ?.map((e) => Exercise.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      isUnlocked: map['isUnlocked'] as bool? ?? false,
      isCompleted: map['isCompleted'] as bool? ?? false,
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutDay && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
