import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/workout_program.dart';
import '../models/workout_day.dart';
import '../models/daily_log.dart';
import '../models/exercise_history.dart';
import '../models/workout_progress.dart';
import '../../core/constants.dart';

class WorkoutRepository {
  static const _boxName = AppConstants.hiveBoxName;

  Box get _box => Hive.box(_boxName);

  // ─── Program CRUD ────────────────────────────────────────────────────────

  Future<List<WorkoutProgram>> getAllPrograms() async {
    final programs = _box.values.whereType<WorkoutProgram>().toList();
    programs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return programs;
  }

  Future<WorkoutProgram?> getProgram(String id) async {
    return _box.get(id) as WorkoutProgram?;
  }

  Future<void> saveProgram(WorkoutProgram program) async {
    await _box.put(program.id, program);
  }

  Future<void> deleteProgram(String id) async {
    await _box.delete(id);
  }

  Future<WorkoutProgram> createProgram({
    required String name,
    List<WorkoutDay> days = const [],
  }) async {
    final program = WorkoutProgram(
      id: const Uuid().v4(),
      name: name,
      days: days,
    );
    await saveProgram(program);
    return program;
  }

  // ─── Progress ────────────────────────────────────────────────────────────

  Future<WorkoutProgress?> getProgress(String programId) async {
    return _box.get(_progressKey(programId)) as WorkoutProgress?;
  }

  Future<void> saveProgress(WorkoutProgress progress) async {
    await _box.put(_progressKey(progress.programId), progress);
  }

  Future<WorkoutProgress> startProgram(String programId) async {
    final program = await getProgram(programId);
    if (program == null) throw Exception('Program not found');

    final progress = WorkoutProgress(
      programId: programId,
      currentDayIndex: 0,
      completedDayIndices: [],
      totalDays: program.days.length,
      startedAt: DateTime.now(),
    );
    await saveProgress(progress);
    return progress;
  }

  Future<WorkoutProgress> completeDay(String programId, int dayIndex) async {
    final progress = await getProgress(programId);
    if (progress == null) throw Exception('No active progress for program');

    final completed = {...progress.completedDayIndices, dayIndex}.toList()
      ..sort();

    final isLastDay = dayIndex >= progress.totalDays - 1;

    final updated = progress.copyWith(
      completedDayIndices: completed,
      currentDayIndex: isLastDay ? dayIndex : dayIndex + 1,
      completedAt: isLastDay ? DateTime.now() : null,
    );
    await saveProgress(updated);
    return updated;
  }

  Future<WorkoutProgress> resetProgress(String programId) async {
    await _box.delete(_progressKey(programId));
    return WorkoutProgress(
      programId: programId,
      totalDays: (await getProgram(programId))?.days.length ?? 0,
    );
  }

  // ─── Daily Logs ──────────────────────────────────────────────────────────

  Future<List<DailyLog>> getLogsForProgram(String programId) async {
    return _box.values
        .whereType<DailyLog>()
        .where((log) => log.programId == programId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<DailyLog?> getLogForDay(String programId, String dayId) async {
    return _box.get(_logKey(programId, dayId)) as DailyLog?;
  }

  Future<void> saveDailyLog(DailyLog log) async {
    await _box.put(_logKey(log.programId, log.dayId), log);
  }

  Future<DailyLog> logExercise(
    String programId,
    String dayId,
    ExerciseHistory history,
  ) async {
    final existing = await getLogForDay(programId, dayId);
    final updated = DailyLog(
      date: DateTime.now(),
      programId: programId,
      dayId: dayId,
      completedExercises: [
        ...?existing?.completedExercises,
        history,
      ],
    );
    await saveDailyLog(updated);
    return updated;
  }

  // ─── Key Helpers ─────────────────────────────────────────────────────────

  String _progressKey(String programId) => 'progress_$programId';
  String _logKey(String programId, String dayId) => 'log_${programId}_$dayId';
}
