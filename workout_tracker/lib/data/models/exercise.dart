import 'package:hive/hive.dart';
import 'exercise_type.dart';

class Exercise {
  final String id;
  final String name;
  final ExerciseType type;
  final int sets;
  final int? reps;
  final int? durationSeconds;
  final int restSeconds;
  final String? equipment;
  final String? imageUrl;
  final String? videoUrl;
  final String? notes;

  Exercise({
    required this.id,
    required this.name,
    this.type = ExerciseType.reps,
    this.sets = 3,
    this.reps,
    this.durationSeconds,
    this.restSeconds = 60,
    this.equipment,
    this.imageUrl,
    this.videoUrl,
    this.notes,
  });
}

class ExerciseAdapter extends TypeAdapter<Exercise> {
  @override
  final int typeId = 2;

  @override
  Exercise read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return Exercise(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as ExerciseType? ?? ExerciseType.reps,
      sets: fields[3] as int? ?? 3,
      reps: fields[4] as int?,
      durationSeconds: fields[5] as int?,
      restSeconds: fields[6] as int? ?? 60,
      equipment: fields[7] as String?,
      imageUrl: fields[8] as String?,
      videoUrl: fields[9] as String?,
      notes: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Exercise obj) {
    writer.writeByte(11);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.name);
    writer.writeByte(2);
    writer.write(obj.type);
    writer.writeByte(3);
    writer.write(obj.sets);
    writer.writeByte(4);
    writer.write(obj.reps);
    writer.writeByte(5);
    writer.write(obj.durationSeconds);
    writer.writeByte(6);
    writer.write(obj.restSeconds);
    writer.writeByte(7);
    writer.write(obj.equipment);
    writer.writeByte(8);
    writer.write(obj.imageUrl);
    writer.writeByte(9);
    writer.write(obj.videoUrl);
    writer.writeByte(10);
    writer.write(obj.notes);
  }
}
