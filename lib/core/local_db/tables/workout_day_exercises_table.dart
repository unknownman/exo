import 'package:drift/drift.dart';
import 'workout_days_table.dart';
import 'exercises_table.dart';

@DataClassName('WorkoutDayExerciseData')
class WorkoutDayExercises extends Table {
  TextColumn get id => text()();
  TextColumn get dayId => text().references(WorkoutDays, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text().references(Exercises, #id, onDelete: KeyAction.cascade)();
  IntColumn get sets => integer().withDefault(const Constant(0))();
  IntColumn get repsOrDuration => integer().withDefault(const Constant(0))();
  BoolColumn get isTimeBased => boolean().withDefault(const Constant(false))();
  IntColumn get restTime => integer().withDefault(const Constant(0))();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
