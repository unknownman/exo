class BodyWeightRecord {
  final String id;
  final DateTime date;
  final double weight;
  final String note;

  const BodyWeightRecord({
    required this.id,
    required this.date,
    required this.weight,
    this.note = '',
  });

  BodyWeightRecord copyWith({
    String? id,
    DateTime? date,
    double? weight,
    String? note,
  }) {
    return BodyWeightRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'weight': weight,
      'note': note,
    };
  }

  factory BodyWeightRecord.fromMap(Map<String, dynamic> map) {
    return BodyWeightRecord(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      weight: (map['weight'] as num).toDouble(),
      note: map['note'] as String? ?? '',
    );
  }
}
