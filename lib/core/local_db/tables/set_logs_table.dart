import 'package:drift/drift.dart';
import 'workout_logs_table.dart';

@DataClassName('SetLogData')
class SetLogs extends Table {
  TextColumn get id => text()();
  TextColumn get logId => text().references(WorkoutLogs, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text()();
  IntColumn get setNumber => integer()();
  RealColumn get weight => real().withDefault(const Constant(0.0))();
  IntColumn get reps => integer().withDefault(const Constant(0))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
