import 'package:hive/hive.dart';

class WorkoutProgress {
  final String programId;
  final int currentDayIndex;
  final List<int> completedDayIndices;
  final int totalDays;
  final DateTime? startedAt;
  final DateTime? completedAt;

  WorkoutProgress({
    required this.programId,
    this.currentDayIndex = 0,
    this.completedDayIndices = const [],
    this.totalDays = 0,
    this.startedAt,
    this.completedAt,
  });

  bool get isComplete => completedDayIndices.length >= totalDays;

  bool isDayUnlocked(int dayIndex) => dayIndex <= currentDayIndex;

  bool isDayCompleted(int dayIndex) => completedDayIndices.contains(dayIndex);

  double get progressPercent {
    if (totalDays == 0) return 0;
    return completedDayIndices.length / totalDays;
  }

  WorkoutProgress copyWith({
    int? currentDayIndex,
    List<int>? completedDayIndices,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return WorkoutProgress(
      programId: programId,
      currentDayIndex: currentDayIndex ?? this.currentDayIndex,
      completedDayIndices: completedDayIndices ?? this.completedDayIndices,
      totalDays: totalDays,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class WorkoutProgressAdapter extends TypeAdapter<WorkoutProgress> {
  @override
  final int typeId = 6;

  @override
  WorkoutProgress read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutProgress(
      programId: fields[0] as String,
      currentDayIndex: fields[1] as int? ?? 0,
      completedDayIndices: (fields[2] as List?)?.cast<int>() ?? [],
      totalDays: fields[3] as int? ?? 0,
      startedAt: fields[4] != null
          ? DateTime.fromMillisecondsSinceEpoch(fields[4] as int)
          : null,
      completedAt: fields[5] != null
          ? DateTime.fromMillisecondsSinceEpoch(fields[5] as int)
          : null,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutProgress obj) {
    writer.writeByte(6);
    writer.writeByte(0);
    writer.write(obj.programId);
    writer.writeByte(1);
    writer.write(obj.currentDayIndex);
    writer.writeByte(2);
    writer.write(obj.completedDayIndices);
    writer.writeByte(3);
    writer.write(obj.totalDays);
    writer.writeByte(4);
    writer.write(obj.startedAt?.millisecondsSinceEpoch);
    writer.writeByte(5);
    writer.write(obj.completedAt?.millisecondsSinceEpoch);
  }
}
