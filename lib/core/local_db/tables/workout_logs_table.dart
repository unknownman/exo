import 'package:drift/drift.dart';

@DataClassName('WorkoutLogData')
class WorkoutLogs extends Table {
  TextColumn get id => text()();
  TextColumn get dayId => text()();
  TextColumn get dayName => text()();
  DateTimeColumn get completedAt => dateTime()();
  IntColumn get durationMinutes => integer().withDefault(const Constant(0))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
