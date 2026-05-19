import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'tables/exercises_table.dart';
import 'tables/set_logs_table.dart';
import 'tables/sync_queue_table.dart';
import 'tables/workout_day_exercises_table.dart';
import 'tables/workout_days_table.dart';
import 'tables/workout_logs_table.dart';
import 'tables/workout_plans_table.dart';

part 'app_database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'exo.db'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(
  tables: [
    Exercises,
    WorkoutPlans,
    WorkoutDays,
    WorkoutDayExercises,
    WorkoutLogs,
    SetLogs,
    SyncQueue,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(LazyDatabase db) : super(db);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
        }
      },
    );
  }
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  return AppDatabase();
}
