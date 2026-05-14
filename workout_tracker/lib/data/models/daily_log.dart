import 'package:hive/hive.dart';
import 'exercise_history.dart';

class DailyLog {
  final DateTime date;
  final String programId;
  final String dayId;
  final List<ExerciseHistory> completedExercises;

  DailyLog({
    DateTime? date,
    required this.programId,
    required this.dayId,
    this.completedExercises = const [],
  }) : date = date ?? DateTime.now();
}

class DailyLogAdapter extends TypeAdapter<DailyLog> {
  @override
  final int typeId = 4;

  @override
  DailyLog read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return DailyLog(
      date: fields[0] != null
          ? DateTime.fromMillisecondsSinceEpoch(fields[0] as int)
          : DateTime.now(),
      programId: fields[1] as String,
      dayId: fields[2] as String,
      completedExercises:
          (fields[3] as List?)?.cast<ExerciseHistory>() ?? [],
    );
  }

  @override
  void write(BinaryWriter writer, DailyLog obj) {
    writer.writeByte(4);
    writer.writeByte(0);
    writer.write(obj.date.millisecondsSinceEpoch);
    writer.writeByte(1);
    writer.write(obj.programId);
    writer.writeByte(2);
    writer.write(obj.dayId);
    writer.writeByte(3);
    writer.write(obj.completedExercises);
  }
}
