import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/workout_repository.dart';
import '../models/workout_program.dart';
import '../models/workout_day.dart';
import '../models/workout_progress.dart';

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return WorkoutRepository();
});

// ─── Program Providers ──────────────────────────────────────────────────────

final programListProvider = FutureProvider<List<WorkoutProgram>>((ref) async {
  final repository = ref.read(workoutRepositoryProvider);
  return repository.getAllPrograms();
});

final programDetailProvider =
    FutureProvider.family<WorkoutProgram?, String>((ref, id) async {
  final repository = ref.read(workoutRepositoryProvider);
  return repository.getProgram(id);
});

// ─── Current Program ────────────────────────────────────────────────────────

final currentProgramIdProvider = StateProvider<String?>((ref) => null);

final currentProgramProvider = FutureProvider<WorkoutProgram?>((ref) async {
  final id = ref.watch(currentProgramIdProvider);
  if (id == null) return null;
  final repository = ref.read(workoutRepositoryProvider);
  return repository.getProgram(id);
});

// ─── Progress ───────────────────────────────────────────────────────────────

final workoutProgressProvider =
    FutureProvider.family<WorkoutProgress?, String>((ref, programId) async {
  final repository = ref.read(workoutRepositoryProvider);
  return repository.getProgress(programId);
});

final currentProgressProvider = FutureProvider<WorkoutProgress?>((ref) async {
  final id = ref.watch(currentProgramIdProvider);
  if (id == null) return null;
  final repository = ref.read(workoutRepositoryProvider);
  return repository.getProgress(id);
});

// ─── Combined State ─────────────────────────────────────────────────────────

final currentWorkoutStateProvider =
    FutureProvider<CurrentWorkoutState?>((ref) async {
  final program = await ref.watch(currentProgramProvider.future);
  final progress = await ref.watch(currentProgressProvider.future);
  if (program == null) return null;
  return CurrentWorkoutState(program: program, progress: progress);
});

class CurrentWorkoutState {
  final WorkoutProgram program;
  final WorkoutProgress? progress;

  const CurrentWorkoutState({
    required this.program,
    this.progress,
  });

  WorkoutDay? get currentDay {
    if (progress == null) {
      return program.days.isNotEmpty ? program.days.first : null;
    }
    final idx = progress!.currentDayIndex;
    if (idx >= program.days.length) return null;
    return program.days[idx];
  }

  List<WorkoutDay> get unlockedDays =>
      program.days.where((d) => progress?.isDayUnlocked(d.order) ?? d.order == 0).toList();

  List<WorkoutDay> get completedDays =>
      program.days.where((d) => progress?.isDayCompleted(d.order) ?? false).toList();
}
