import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app_database.dart';

part 'exercise_dao.g.dart';

class ExerciseDao {
  final AppDatabase _db;

  ExerciseDao(this._db);

  Future<List<ExerciseData>> getAllExercises() {
    return _db.select(_db.exercises).get();
  }

  Future<ExerciseData?> getExerciseById(String id) {
    return (_db.select(_db.exercises)..where((e) => e.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<ExerciseData>> searchExercises(String query) {
    final pattern = '%$query%';
    return (_db.select(_db.exercises)
          ..where((e) =>
              e.name.like(pattern) | e.nameFa.like(pattern)))
        .get();
  }

  Future<List<ExerciseData>> getCustomExercises() {
    return (_db.select(_db.exercises)..where((e) => e.isCustom.equals(true)))
        .get();
  }

  Future<List<ExerciseData>> getExercisesByEquipment(String equipmentType) {
    return (_db.select(_db.exercises)
          ..where((e) => e.equipmentType.equals(equipmentType)))
        .get();
  }

  Future<void> insertExercise(ExercisesCompanion companion) {
    return _db.into(_db.exercises).insert(companion);
  }

  Future<void> upsertExercise(ExercisesCompanion companion) {
    return _db.into(_db.exercises).insertOnConflictUpdate(companion);
  }

  Future<void> updateExercisePartial(
    String id,
    ExercisesCompanion companion,
  ) {
    return (_db.update(_db.exercises)..where((e) => e.id.equals(id)))
        .write(companion);
  }

  Future<void> deleteExercise(String id) {
    return (_db.delete(_db.exercises)..where((e) => e.id.equals(id))).go();
  }

  Future<int> getExerciseCount() {
    return _db.select(_db.exercises).map((e) => e.id).get().then((r) => r.length);
  }

  Future<void> insertExercisesBatch(List<ExercisesCompanion> companions) {
    return _db.batch((b) {
      b.insertAllOnConflictUpdate(_db.exercises, companions);
    });
  }
}

@Riverpod(keepAlive: true)
ExerciseDao exerciseDao(ExerciseDaoRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return ExerciseDao(db);
}
