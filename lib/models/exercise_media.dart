enum ExerciseMediaType { image, video, lottie, none }

class ExerciseMedia {
  final ExerciseMediaType type;
  final String source;
  final bool isLocal;

  const ExerciseMedia({
    this.type = ExerciseMediaType.none,
    this.source = '',
    this.isLocal = false,
  });

  const ExerciseMedia.empty()
      : type = ExerciseMediaType.none,
        source = '',
        isLocal = false;

  factory ExerciseMedia.local(String source) {
    final extension = source.split('.').last.toLowerCase();
    final type = switch (extension) {
      'jpg' || 'jpeg' || 'png' || 'gif' || 'webp' => ExerciseMediaType.image,
      'mp4' || 'mov' || 'avi' => ExerciseMediaType.video,
      'json' => ExerciseMediaType.lottie,
      _ => ExerciseMediaType.none,
    };
    return ExerciseMedia(type: type, source: source, isLocal: true);
  }

  ExerciseMedia copyWith({
    ExerciseMediaType? type,
    String? source,
    bool? isLocal,
  }) {
    return ExerciseMedia(
      type: type ?? this.type,
      source: source ?? this.source,
      isLocal: isLocal ?? this.isLocal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'source': source,
      'isLocal': isLocal,
    };
  }

  factory ExerciseMedia.fromMap(Map<String, dynamic> map) {
    return ExerciseMedia(
      type: ExerciseMediaType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => ExerciseMediaType.none,
      ),
      source: map['source'] as String? ?? '',
      isLocal: map['isLocal'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExerciseMedia &&
        other.type == type &&
        other.source == source &&
        other.isLocal == isLocal;
  }

  @override
  int get hashCode => Object.hash(type, source, isLocal);

  @override
  String toString() {
    return 'ExerciseMedia(type: $type, source: $source, isLocal: $isLocal)';
  }
}
