import 'exercise_media.dart';

class Exercise {
  final String id;
  final String name;
  final String description;
  final String coachCues;
  final int sets;
  final int repsOrDuration;
  final bool isTimeBased;
  final int restTime;
  final String equipment;
  final ExerciseMedia media;

  const Exercise({
    required this.id,
    required this.name,
    this.description = '',
    this.coachCues = '',
    required this.sets,
    required this.repsOrDuration,
    required this.isTimeBased,
    required this.restTime,
    required this.equipment,
    this.media = const ExerciseMedia.empty(),
  });

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? coachCues,
    int? sets,
    int? repsOrDuration,
    bool? isTimeBased,
    int? restTime,
    String? equipment,
    ExerciseMedia? media,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coachCues: coachCues ?? this.coachCues,
      sets: sets ?? this.sets,
      repsOrDuration: repsOrDuration ?? this.repsOrDuration,
      isTimeBased: isTimeBased ?? this.isTimeBased,
      restTime: restTime ?? this.restTime,
      equipment: equipment ?? this.equipment,
      media: media ?? this.media,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'coachCues': coachCues,
      'sets': sets,
      'repsOrDuration': repsOrDuration,
      'isTimeBased': isTimeBased,
      'restTime': restTime,
      'equipment': equipment,
      'media': media.toMap(),
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      coachCues: map['coachCues'] as String? ?? '',
      sets: map['sets'] as int,
      repsOrDuration: map['repsOrDuration'] as int,
      isTimeBased: map['isTimeBased'] as bool,
      restTime: map['restTime'] as int,
      equipment: map['equipment'] as String,
      media: map['media'] != null
          ? ExerciseMedia.fromMap(map['media'] as Map<String, dynamic>)
          : const ExerciseMedia.empty(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Exercise &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.coachCues == coachCues &&
        other.sets == sets &&
        other.repsOrDuration == repsOrDuration &&
        other.isTimeBased == isTimeBased &&
        other.restTime == restTime &&
        other.equipment == equipment &&
        other.media == media;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      coachCues,
      sets,
      repsOrDuration,
      isTimeBased,
      restTime,
      equipment,
      media,
    );
  }

  @override
  String toString() {
    return 'Exercise(id: $id, name: $name, description: $description, '
        'coachCues: $coachCues, sets: $sets, repsOrDuration: $repsOrDuration, '
        'isTimeBased: $isTimeBased, restTime: $restTime, equipment: $equipment, '
        'media: $media)';
  }
}
