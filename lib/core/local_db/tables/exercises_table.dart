import 'package:drift/drift.dart';

@DataClassName('ExerciseData')
class Exercises extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get nameFa => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get equipmentType => text()();
  TextColumn get targetMuscles => text().withDefault(const Constant(''))();
  TextColumn get mediaUrl => text().nullable()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  TextColumn get coachCues => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
