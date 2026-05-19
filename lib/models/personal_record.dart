class PersonalRecord {
  final String exerciseId;
  final String exerciseName;
  final double best1RM;
  final double bestWeight;
  final int bestReps;
  final DateTime date;

  const PersonalRecord({
    required this.exerciseId,
    required this.exerciseName,
    required this.best1RM,
    required this.bestWeight,
    required this.bestReps,
    required this.date,
  });

  PersonalRecord copyWith({
    String? exerciseId,
    String? exerciseName,
    double? best1RM,
    double? bestWeight,
    int? bestReps,
    DateTime? date,
  }) {
    return PersonalRecord(
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      best1RM: best1RM ?? this.best1RM,
      bestWeight: bestWeight ?? this.bestWeight,
      bestReps: bestReps ?? this.bestReps,
      date: date ?? this.date,
    );
  }

  static PersonalRecord fromSet({
    required String exerciseId,
    required String exerciseName,
    required double weight,
    required int reps,
    double? estimated1RM,
  }) {
    final oneRM = estimated1RM ?? brzycki1RM(weight, reps);
    return PersonalRecord(
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      best1RM: oneRM,
      bestWeight: weight,
      bestReps: reps,
      date: DateTime.now(),
    );
  }
}

double brzycki1RM(double weight, int reps) {
  if (weight == 0) return reps.toDouble();
  if (reps <= 0 || reps >= 36) return weight;
  return weight * (36 / (37 - reps));
}

double epley1RM(double weight, int reps) {
  if (reps <= 0) return weight;
  return weight * (1 + reps / 30);
}
