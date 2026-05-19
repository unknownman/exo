import 'package:drift/drift.dart';

import '../../../models/exercise.dart';
import '../../../models/exercise_media.dart';
import '../app_database.dart';

Exercise exerciseFromData(ExerciseData data) {
  return Exercise(
    id: data.id,
    name: data.name,
    nameFa: data.nameFa ?? '',
    description: data.description ?? '',
    coachCues: data.coachCues,
    sets: 0,
    repsOrDuration: 0,
    isTimeBased: false,
    restTime: 0,
    equipment: data.equipmentType,
    media: data.mediaUrl != null
        ? ExerciseMedia.local(data.mediaUrl!)
        : const ExerciseMedia.empty(),
    targetMuscles: data.targetMuscles.isNotEmpty
        ? data.targetMuscles
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList()
        : [],
    isCustom: data.isCustom,
  );
}

ExerciseData exerciseToData(Exercise domain) {
  return ExerciseData(
    id: domain.id,
    name: domain.name,
    nameFa: domain.nameFa.isNotEmpty ? domain.nameFa : null,
    description: domain.description.isNotEmpty ? domain.description : null,
    equipmentType: domain.equipment,
    targetMuscles: domain.targetMuscles.join(','),
    mediaUrl: domain.media.source.isNotEmpty ? domain.media.source : null,
    isCustom: domain.isCustom,
    coachCues: domain.coachCues,
    createdAt: DateTime.now(),
    updatedAt: null,
  );
}

ExercisesCompanion exerciseToCompanion(Exercise domain) {
  return ExercisesCompanion(
    id: Value(domain.id),
    name: Value(domain.name),
    nameFa: Value(domain.nameFa.isNotEmpty ? domain.nameFa : null),
    description:
        Value(domain.description.isNotEmpty ? domain.description : null),
    equipmentType: Value(domain.equipment),
    targetMuscles: Value(domain.targetMuscles.join(',')),
    mediaUrl: Value(domain.media.source.isNotEmpty ? domain.media.source : null),
    isCustom: Value(domain.isCustom),
    coachCues: Value(domain.coachCues),
    createdAt: Value(DateTime.now()),
    updatedAt: Value(null),
  );
}

Exercise exerciseWithOverrides(
    ExerciseData data, int sets, int repsOrDuration, bool isTimeBased, int restTime) {
  return Exercise(
    id: data.id,
    name: data.name,
    nameFa: data.nameFa ?? '',
    description: data.description ?? '',
    coachCues: data.coachCues,
    sets: sets,
    repsOrDuration: repsOrDuration,
    isTimeBased: isTimeBased,
    restTime: restTime,
    equipment: data.equipmentType,
    media: data.mediaUrl != null
        ? ExerciseMedia.local(data.mediaUrl!)
        : const ExerciseMedia.empty(),
    targetMuscles: data.targetMuscles.isNotEmpty
        ? data.targetMuscles
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList()
        : [],
    isCustom: data.isCustom,
  );
}
