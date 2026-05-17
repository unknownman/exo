import 'package:hive/hive.dart';
import '../../models/exercise.dart';
import '../../models/exercise_media.dart';
import '../../models/workout_log.dart';
import '../../models/workout_plan.dart';

class ExerciseMediaAdapter extends TypeAdapter<ExerciseMedia> {
  @override
  final typeId = 0;

  @override
  void write(BinaryWriter writer, ExerciseMedia obj) {
    writer.writeString(obj.type.name);
    writer.writeString(obj.source);
    writer.writeBool(obj.isLocal);
  }

  @override
  ExerciseMedia read(BinaryReader reader) {
    try {
      return ExerciseMedia(
        type: ExerciseMediaType.values.firstWhere(
          (e) => e.name == reader.readString(),
          orElse: () => ExerciseMediaType.none,
        ),
        source: reader.readString(),
        isLocal: reader.readBool(),
      );
    } catch (_) {
      return const ExerciseMedia.empty();
    }
  }
}

class ExerciseAdapter extends TypeAdapter<Exercise> {
  @override
  final typeId = 1;

  @override
  void write(BinaryWriter writer, Exercise obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.description);
    writer.writeString(obj.coachCues);
    writer.writeInt(obj.sets);
    writer.writeInt(obj.repsOrDuration);
    writer.writeBool(obj.isTimeBased);
    writer.writeInt(obj.restTime);
    writer.writeString(obj.equipment);
    writer.write(obj.media);
  }

  @override
  Exercise read(BinaryReader reader) {
    return Exercise(
      id: reader.readString(),
      name: reader.readString(),
      description: reader.readString(),
      coachCues: reader.readString(),
      sets: reader.readInt(),
      repsOrDuration: reader.readInt(),
      isTimeBased: reader.readBool(),
      restTime: reader.readInt(),
      equipment: reader.readString(),
      media: reader.read() as ExerciseMedia,
    );
  }
}

class WorkoutDayAdapter extends TypeAdapter<WorkoutDay> {
  @override
  final typeId = 2;

  @override
  void write(BinaryWriter writer, WorkoutDay obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeInt(obj.orderIndex);
    writer.write(obj.exercises);
    writer.writeBool(obj.isUnlocked);
    writer.writeBool(obj.isCompleted);
    if (obj.completedAt != null) {
      writer.writeBool(true);
      writer.writeInt(obj.completedAt!.millisecondsSinceEpoch);
    } else {
      writer.writeBool(false);
    }
  }

  @override
  WorkoutDay read(BinaryReader reader) {
    DateTime? completedAt;
    final id = reader.readString();
    final name = reader.readString();
    final orderIndex = reader.readInt();
    final exercises = (reader.read() as List).cast<Exercise>();
    final isUnlocked = reader.readBool();
    final isCompleted = reader.readBool();
    if (reader.readBool()) {
      completedAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    }
    return WorkoutDay(
      id: id,
      name: name,
      orderIndex: orderIndex,
      exercises: exercises,
      isUnlocked: isUnlocked,
      isCompleted: isCompleted,
      completedAt: completedAt,
    );
  }
}

class WorkoutPlanAdapter extends TypeAdapter<WorkoutPlan> {
  @override
  final typeId = 3;

  @override
  void write(BinaryWriter writer, WorkoutPlan obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    if (obj.description != null) {
      writer.writeBool(true);
      writer.writeString(obj.description!);
    } else {
      writer.writeBool(false);
    }
    writer.write(obj.days);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
    if (obj.updatedAt != null) {
      writer.writeBool(true);
      writer.writeInt(obj.updatedAt!.millisecondsSinceEpoch);
    } else {
      writer.writeBool(false);
    }
    writer.writeBool(obj.isActive);
  }

  @override
  WorkoutPlan read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    String? description;
    if (reader.readBool()) {
      description = reader.readString();
    }
    final days = (reader.read() as List).cast<WorkoutDay>();
    final createdAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    DateTime? updatedAt;
    if (reader.readBool()) {
      updatedAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    }
    final isActive = reader.readBool();
    return WorkoutPlan(
      id: id,
      name: name,
      description: description,
      days: days,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
    );
  }
}

class WorkoutLogAdapter extends TypeAdapter<WorkoutLog> {
  @override
  final typeId = 4;

  @override
  void write(BinaryWriter writer, WorkoutLog obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.dayId);
    writer.writeString(obj.dayName);
    writer.writeInt(obj.completedAt.millisecondsSinceEpoch);
    writer.writeInt(obj.exerciseCount);
    writer.writeInt(obj.totalSets);
    writer.writeInt(obj.totalDurationMinutes);
    writer.writeBool(obj.hasMedia);
  }

  @override
  WorkoutLog read(BinaryReader reader) {
    return WorkoutLog(
      id: reader.readString(),
      dayId: reader.readString(),
      dayName: reader.readString(),
      completedAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      exerciseCount: reader.readInt(),
      totalSets: reader.readInt(),
      totalDurationMinutes: reader.readInt(),
      hasMedia: reader.readBool(),
    );
  }
}
