import 'package:hive/hive.dart';

enum ExerciseType { reps, timed }

class ExerciseTypeAdapter extends TypeAdapter<ExerciseType> {
  @override
  final int typeId = 5;

  @override
  ExerciseType read(BinaryReader reader) {
    return ExerciseType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, ExerciseType obj) {
    writer.writeByte(obj.index);
  }
}
