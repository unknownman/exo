class SetLog {
  final int setNumber;
  final int reps;
  final double weight;
  final bool isCompleted;

  const SetLog({
    required this.setNumber,
    this.reps = 0,
    this.weight = 0,
    this.isCompleted = false,
  });

  SetLog copyWith({
    int? setNumber,
    int? reps,
    double? weight,
    bool? isCompleted,
  }) {
    return SetLog(
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'setNumber': setNumber,
      'reps': reps,
      'weight': weight,
      'isCompleted': isCompleted,
    };
  }

  factory SetLog.fromMap(Map<String, dynamic> map) {
    return SetLog(
      setNumber: map['setNumber'] as int,
      reps: map['reps'] as int? ?? 0,
      weight: (map['weight'] as num?)?.toDouble() ?? 0,
      isCompleted: map['isCompleted'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SetLog &&
        other.setNumber == setNumber &&
        other.reps == reps &&
        other.weight == weight &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode => Object.hash(setNumber, reps, weight, isCompleted);
}

class ExercisePerformance {
  final String exerciseId;
  final String exerciseName;
  final List<SetLog> sets;

  const ExercisePerformance({
    required this.exerciseId,
    required this.exerciseName,
    this.sets = const [],
  });

  ExercisePerformance copyWith({
    String? exerciseId,
    String? exerciseName,
    List<SetLog>? sets,
  }) {
    return ExercisePerformance(
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      sets: sets ?? this.sets,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'sets': sets.map((s) => s.toMap()).toList(),
    };
  }

  factory ExercisePerformance.fromMap(Map<String, dynamic> map) {
    return ExercisePerformance(
      exerciseId: map['exerciseId'] as String,
      exerciseName: map['exerciseName'] as String,
      sets: (map['sets'] as List?)
              ?.map((s) => SetLog.fromMap(s as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  int get completedSets => sets.where((s) => s.isCompleted).length;

  String get weightSummary {
    final logged = sets.where((s) => s.isCompleted && s.weight > 0);
    if (logged.isEmpty) return '';
    final weights = logged.map((s) => s.weight.toStringAsFixed(1)).toList();
    return weights.join(' - ');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExercisePerformance &&
        other.exerciseId == exerciseId &&
        other.exerciseName == exerciseName &&
        other.sets == sets;
  }

  @override
  int get hashCode => Object.hash(exerciseId, exerciseName, sets);
}

class WorkoutLog {
  final String id;
  final String dayId;
  final String dayName;
  final DateTime completedAt;
  final int exerciseCount;
  final int totalSets;
  final int totalDurationMinutes;
  final bool hasMedia;
  final bool isSynced;
  final List<ExercisePerformance> exercises;

  const WorkoutLog({
    required this.id,
    required this.dayId,
    required this.dayName,
    required this.completedAt,
    required this.exerciseCount,
    required this.totalSets,
    required this.totalDurationMinutes,
    this.hasMedia = false,
    this.isSynced = false,
    this.exercises = const [],
  });

  WorkoutLog copyWith({
    String? id,
    String? dayId,
    String? dayName,
    DateTime? completedAt,
    int? exerciseCount,
    int? totalSets,
    int? totalDurationMinutes,
    bool? hasMedia,
    bool? isSynced,
    List<ExercisePerformance>? exercises,
  }) {
    return WorkoutLog(
      id: id ?? this.id,
      dayId: dayId ?? this.dayId,
      dayName: dayName ?? this.dayName,
      completedAt: completedAt ?? this.completedAt,
      exerciseCount: exerciseCount ?? this.exerciseCount,
      totalSets: totalSets ?? this.totalSets,
      totalDurationMinutes: totalDurationMinutes ?? this.totalDurationMinutes,
      hasMedia: hasMedia ?? this.hasMedia,
      isSynced: isSynced ?? this.isSynced,
      exercises: exercises ?? this.exercises,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dayId': dayId,
      'dayName': dayName,
      'completedAt': completedAt.toIso8601String(),
      'exerciseCount': exerciseCount,
      'totalSets': totalSets,
      'totalDurationMinutes': totalDurationMinutes,
      'hasMedia': hasMedia,
      'isSynced': isSynced,
      'exercises': exercises.map((e) => e.toMap()).toList(),
    };
  }

  factory WorkoutLog.fromMap(Map<String, dynamic> map) {
    return WorkoutLog(
      id: map['id'] as String,
      dayId: map['dayId'] as String,
      dayName: map['dayName'] as String,
      completedAt: DateTime.parse(map['completedAt'] as String),
      exerciseCount: map['exerciseCount'] as int,
      totalSets: map['totalSets'] as int,
      totalDurationMinutes: map['totalDurationMinutes'] as int,
      hasMedia: map['hasMedia'] as bool? ?? false,
      isSynced: map['isSynced'] as bool? ?? false,
      exercises: (map['exercises'] as List?)
              ?.map(
                  (e) => ExercisePerformance.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(completedAt);

    if (diff.inDays == 0) {
      return 'امروز';
    } else if (diff.inDays == 1) {
      return 'دیروز';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} روز پیش';
    } else {
      return '${completedAt.year}/${completedAt.month}/${completedAt.day}';
    }
  }
}
