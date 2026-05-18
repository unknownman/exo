import '../../models/exercise.dart';
import '../../models/exercise_media.dart';
import '../../models/workout_log.dart';
import '../../models/workout_plan.dart';
import '../../core/utils/id_generator.dart';

class WorkoutStateManager {
  static bool isDayFinishedToday(WorkoutDay day) => day.isCompletedToday;
  WorkoutPlan addExerciseToDay(WorkoutPlan plan, String dayId, Exercise exercise) {
    final updatedDays = plan.days.map((day) {
      if (day.id == dayId) return day.addExercise(exercise);
      return day;
    }).toList();
    return plan.copyWith(days: updatedDays);
  }

  WorkoutPlan updateExerciseInDay(
    WorkoutPlan plan,
    String dayId,
    String exerciseId,
    Exercise updated,
  ) {
    final updatedDays = plan.days.map((day) {
      if (day.id == dayId) {
        final updatedExercises = day.exercises.map((ex) {
          return ex.id == exerciseId ? updated : ex;
        }).toList();
        return day.copyWith(exercises: updatedExercises);
      }
      return day;
    }).toList();
    return plan.copyWith(days: updatedDays);
  }

  WorkoutPlan removeExerciseFromDay(WorkoutPlan plan, String dayId, String exerciseId) {
    final updatedDays = plan.days.map((day) {
      if (day.id == dayId) return day.removeExercise(exerciseId);
      return day;
    }).toList();
    return plan.copyWith(days: updatedDays);
  }

  WorkoutPlan updateDayExercises(WorkoutPlan plan, String dayId, List<Exercise> exercises) {
    final updatedDays = plan.days.map((day) {
      if (day.id == dayId) return day.copyWith(exercises: exercises);
      return day;
    }).toList();
    return plan.copyWith(days: updatedDays);
  }

  WorkoutPlan addDayToPlan(WorkoutPlan plan, String dayName) {
    final newDay = WorkoutDay(
      id: IdGenerator.generate(),
      name: dayName,
      orderIndex: plan.days.length,
      exercises: [],
      isUnlocked: true,
      isCompleted: false,
    );
    return plan.copyWith(days: [...plan.days, newDay]);
  }

  WorkoutPlan removeDayFromPlan(WorkoutPlan plan, String dayId) {
    final updatedDays = plan.days.where((d) => d.id != dayId).toList();
    for (int i = 0; i < updatedDays.length; i++) {
      updatedDays[i] = updatedDays[i].copyWith(orderIndex: i);
    }
    return plan.copyWith(days: updatedDays);
  }

  WorkoutPlan markDayCompleted(WorkoutPlan plan, String dayId) {
    final updatedDays = plan.days.map((day) {
      if (day.id == dayId) {
        return day.copyWith(isCompleted: true, completedAt: DateTime.now());
      }
      return day;
    }).toList();
    return plan.copyWith(days: updatedDays);
  }

  WorkoutPlan resetDayCompletion(WorkoutPlan plan) {
    final resetDays = plan.days.map((day) {
      return day.copyWith(isCompleted: false, clearCompletedAt: true);
    }).toList();
    return plan.copyWith(days: resetDays);
  }

  int calculateNextDayIndex(List<WorkoutDay> days, int currentDayIndex) {
    final allCompleted = days.every((d) => d.isCompleted);
    return allCompleted ? currentDayIndex : (currentDayIndex + 1) % days.length;
  }

  WorkoutLog createWorkoutLog(WorkoutDay day) {
    return WorkoutLog(
      id: IdGenerator.generate(),
      dayId: day.id,
      dayName: day.name,
      completedAt: DateTime.now(),
      exerciseCount: day.exercises.length,
      totalSets: day.exercises.fold(0, (sum, e) => sum + e.sets),
      totalDurationMinutes: day.estimatedDurationMinutes,
      hasMedia: day.exercises.any((e) => e.media.type != ExerciseMediaType.none),
    );
  }

  WorkoutLog createWorkoutLogFromData({
    required String dayId,
    required String dayName,
    required List<Exercise> exercises,
    required int durationMinutes,
  }) {
    return WorkoutLog(
      id: IdGenerator.generate(),
      dayId: dayId,
      dayName: dayName,
      completedAt: DateTime.now(),
      exerciseCount: exercises.length,
      totalSets: exercises.fold(0, (sum, e) => sum + e.sets),
      totalDurationMinutes: durationMinutes,
      hasMedia: exercises.any((e) => e.media.type != ExerciseMediaType.none),
    );
  }

  List<WorkoutDay> createDayList(List<String> dayNames) {
    return List.generate(
      dayNames.length,
      (i) => WorkoutDay(
        id: IdGenerator.generate(),
        name: dayNames[i],
        orderIndex: i,
        exercises: [],
        isUnlocked: true,
        isCompleted: false,
      ),
    );
  }

  WorkoutDay createSingleDay(String name) {
    return WorkoutDay(
      id: IdGenerator.generate(),
      name: name,
      orderIndex: 0,
      exercises: [],
      isUnlocked: true,
      isCompleted: false,
    );
  }

  WorkoutPlan buildPlan(String name, String description, List<WorkoutDay> days) {
    return WorkoutPlan(
      id: IdGenerator.generate(),
      name: name,
      description: description,
      days: days,
      createdAt: DateTime.now(),
      isActive: true,
    );
  }
}
