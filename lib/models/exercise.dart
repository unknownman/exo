class Exercise {
  final String id;
  final String name;
  final int sets;
  final int repsOrDuration;
  final bool isTimeBased;
  final int restTime;
  final String equipment;
  final String? imagePath;

  const Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.repsOrDuration,
    required this.isTimeBased,
    required this.restTime,
    required this.equipment,
    this.imagePath,
  });

  Exercise copyWith({
    String? id,
    String? name,
    int? sets,
    int? repsOrDuration,
    bool? isTimeBased,
    int? restTime,
    String? equipment,
    String? imagePath,
    bool clearImagePath = false,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      sets: sets ?? this.sets,
      repsOrDuration: repsOrDuration ?? this.repsOrDuration,
      isTimeBased: isTimeBased ?? this.isTimeBased,
      restTime: restTime ?? this.restTime,
      equipment: equipment ?? this.equipment,
      imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sets': sets,
      'repsOrDuration': repsOrDuration,
      'isTimeBased': isTimeBased,
      'restTime': restTime,
      'equipment': equipment,
      'imagePath': imagePath,
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
      imagePath: map['imagePath'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Exercise &&
        other.id == id &&
        other.name == name &&
        other.sets == sets &&
        other.repsOrDuration == repsOrDuration &&
        other.isTimeBased == isTimeBased &&
        other.restTime == restTime &&
        other.equipment == equipment &&
        other.imagePath == imagePath;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      sets,
      repsOrDuration,
      isTimeBased,
      restTime,
      equipment,
      imagePath,
    );
  }

  @override
  String toString() {
    return 'Exercise(id: $id, name: $name, sets: $sets, repsOrDuration: $repsOrDuration, '
        'isTimeBased: $isTimeBased, restTime: $restTime, equipment: $equipment, imagePath: $imagePath)';
  }
}
