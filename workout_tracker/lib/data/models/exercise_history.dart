import 'package:hive/hive.dart';

class ExerciseHistory {
  final String exerciseId;
  final DateTime date;
  final List<int> completedSets;
  final bool completed;
  final List<int>? actualRestTimes;

  ExerciseHistory({
    required this.exerciseId,
    DateTime? date,
    this.completedSets = const [],
    this.completed = false,
    this.actualRestTimes,
  }) : date = date ?? DateTime.now();
}

class ExerciseHistoryAdapter extends TypeAdapter<ExerciseHistory> {
  @override
  final int typeId = 3;

  @override
  ExerciseHistory read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseHistory(
      exerciseId: fields[0] as String,
      date: fields[1] != null
          ? DateTime.fromMillisecondsSinceEpoch(fields[1] as int)
          : DateTime.now(),
      completedSets: (fields[2] as List?)?.cast<int>() ?? [],
      completed: fields[3] as bool? ?? false,
      actualRestTimes: (fields[4] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseHistory obj) {
    writer.writeByte(5);
    writer.writeByte(0);
    writer.write(obj.exerciseId);
    writer.writeByte(1);
    writer.write(obj.date.millisecondsSinceEpoch);
    writer.writeByte(2);
    writer.write(obj.completedSets);
    writer.writeByte(3);
    writer.write(obj.completed);
    writer.writeByte(4);
    writer.write(obj.actualRestTimes);
  }
}
