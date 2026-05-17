class WorkoutLog {
  final String id;
  final String dayId;
  final String dayName;
  final DateTime completedAt;
  final int exerciseCount;
  final int totalSets;
  final int totalDurationMinutes;
  final bool hasMedia;

  const WorkoutLog({
    required this.id,
    required this.dayId,
    required this.dayName,
    required this.completedAt,
    required this.exerciseCount,
    required this.totalSets,
    required this.totalDurationMinutes,
    this.hasMedia = false,
  });

  WorkoutLog copyWith({
    String? id,
    String? dayId,
    String? dayName,
    DateTime? completedAt,
    int? exerciseCount,
    int? totalSets,
    int? totalDurationMinutes,
    bool? hasMedia,
  }) {
    return WorkoutLog(
      id: id ?? this.id,
      dayId: dayId ?? this.dayId,
      dayName: dayName ?? this.dayName,
      completedAt: completedAt ?? this.completedAt,
      exerciseCount: exerciseCount ?? this.exerciseCount,
      totalSets: totalSets ?? this.totalSets,
      totalDurationMinutes: totalDurationMinutes ?? this.totalDurationMinutes,
      hasMedia: hasMedia ?? this.hasMedia,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dayId': dayId,
      'dayName': dayName,
      'completedAt': completedAt.toIso8601String(),
      'exerciseCount': exerciseCount,
      'totalSets': totalSets,
      'totalDurationMinutes': totalDurationMinutes,
      'hasMedia': hasMedia,
    };
  }

  factory WorkoutLog.fromMap(Map<String, dynamic> map) {
    return WorkoutLog(
      id: map['id'] as String,
      dayId: map['dayId'] as String,
      dayName: map['dayName'] as String,
      completedAt: DateTime.parse(map['completedAt'] as String),
      exerciseCount: map['exerciseCount'] as int,
      totalSets: map['totalSets'] as int,
      totalDurationMinutes: map['totalDurationMinutes'] as int,
      hasMedia: map['hasMedia'] as bool? ?? false,
    );
  }

  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(completedAt);

    if (diff.inDays == 0) {
      return 'امروز';
    } else if (diff.inDays == 1) {
      return 'دیروز';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} روز پیش';
    } else {
      return '${completedAt.year}/${completedAt.month}/${completedAt.day}';
    }
  }
}
