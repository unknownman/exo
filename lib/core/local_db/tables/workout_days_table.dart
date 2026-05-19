import 'package:drift/drift.dart';
import 'workout_plans_table.dart';

@DataClassName('WorkoutDayData')
class WorkoutDays extends Table {
  TextColumn get id => text()();
  TextColumn get planId => text().references(WorkoutPlans, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn get orderIndex => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
