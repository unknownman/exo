import 'package:hive/hive.dart';
import 'workout_day.dart';

class WorkoutProgram {
  final String id;
  final String name;
  final List<WorkoutDay> days;
  final DateTime createdAt;

  WorkoutProgram({
    required this.id,
    required this.name,
    this.days = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class WorkoutProgramAdapter extends TypeAdapter<WorkoutProgram> {
  @override
  final int typeId = 0;

  @override
  WorkoutProgram read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutProgram(
      id: fields[0] as String,
      name: fields[1] as String,
      days: (fields[2] as List?)?.cast<WorkoutDay>() ?? [],
      createdAt: fields[3] != null
          ? DateTime.fromMillisecondsSinceEpoch(fields[3] as int)
          : DateTime.now(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutProgram obj) {
    writer.writeByte(4);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.name);
    writer.writeByte(2);
    writer.write(obj.days);
    writer.writeByte(3);
    writer.write(obj.createdAt.millisecondsSinceEpoch);
  }
}
