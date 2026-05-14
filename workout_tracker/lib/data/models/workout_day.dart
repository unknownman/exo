import 'package:hive/hive.dart';
import 'exercise.dart';

class WorkoutDay {
  final String id;
  final String dayName;
  final List<Exercise> exercises;
  final int order;

  WorkoutDay({
    required this.id,
    required this.dayName,
    this.exercises = const [],
    this.order = 0,
  });
}

class WorkoutDayAdapter extends TypeAdapter<WorkoutDay> {
  @override
  final int typeId = 1;

  @override
  WorkoutDay read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutDay(
      id: fields[0] as String,
      dayName: fields[1] as String,
      exercises: (fields[2] as List?)?.cast<Exercise>() ?? [],
      order: fields[3] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutDay obj) {
    writer.writeByte(4);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.dayName);
    writer.writeByte(2);
    writer.write(obj.exercises);
    writer.writeByte(3);
    writer.write(obj.order);
  }
}
