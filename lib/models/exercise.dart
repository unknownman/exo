class Exercise {
  final String id;
  final String name;
  final int sets;
  final int repsOrDuration;
  final bool isTimeBased;
  final int restTime;
  final String equipment;

  Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.repsOrDuration,
    required this.isTimeBased,
    required this.restTime,
    required this.equipment,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sets': sets,
      'repsOrDuration': repsOrDuration,
      'isTimeBased': isTimeBased,
      'restTime': restTime,
      'equipment': equipment,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as String,
      name: map['name'] as String,
      sets: map['sets'] as int,
      repsOrDuration: map['repsOrDuration'] as int,
      isTimeBased: map['isTimeBased'] as bool,
      restTime: map['restTime'] as int,
      equipment: map['equipment'] as String,
    );
  }
}
