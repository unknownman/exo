// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, ExerciseData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameFaMeta = const VerificationMeta('nameFa');
  @override
  late final GeneratedColumn<String> nameFa = GeneratedColumn<String>(
    'name_fa',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _equipmentTypeMeta = const VerificationMeta(
    'equipmentType',
  );
  @override
  late final GeneratedColumn<String> equipmentType = GeneratedColumn<String>(
    'equipment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMusclesMeta = const VerificationMeta(
    'targetMuscles',
  );
  @override
  late final GeneratedColumn<String> targetMuscles = GeneratedColumn<String>(
    'target_muscles',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _mediaUrlMeta = const VerificationMeta(
    'mediaUrl',
  );
  @override
  late final GeneratedColumn<String> mediaUrl = GeneratedColumn<String>(
    'media_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _coachCuesMeta = const VerificationMeta(
    'coachCues',
  );
  @override
  late final GeneratedColumn<String> coachCues = GeneratedColumn<String>(
    'coach_cues',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameFa,
    description,
    equipmentType,
    targetMuscles,
    mediaUrl,
    isCustom,
    coachCues,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_fa')) {
      context.handle(
        _nameFaMeta,
        nameFa.isAcceptableOrUnknown(data['name_fa']!, _nameFaMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('equipment_type')) {
      context.handle(
        _equipmentTypeMeta,
        equipmentType.isAcceptableOrUnknown(
          data['equipment_type']!,
          _equipmentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_equipmentTypeMeta);
    }
    if (data.containsKey('target_muscles')) {
      context.handle(
        _targetMusclesMeta,
        targetMuscles.isAcceptableOrUnknown(
          data['target_muscles']!,
          _targetMusclesMeta,
        ),
      );
    }
    if (data.containsKey('media_url')) {
      context.handle(
        _mediaUrlMeta,
        mediaUrl.isAcceptableOrUnknown(data['media_url']!, _mediaUrlMeta),
      );
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    if (data.containsKey('coach_cues')) {
      context.handle(
        _coachCuesMeta,
        coachCues.isAcceptableOrUnknown(data['coach_cues']!, _coachCuesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameFa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_fa'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      equipmentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment_type'],
      )!,
      targetMuscles: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_muscles'],
      )!,
      mediaUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_url'],
      ),
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
      coachCues: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}coach_cues'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class ExerciseData extends DataClass implements Insertable<ExerciseData> {
  final String id;
  final String name;
  final String? nameFa;
  final String? description;
  final String equipmentType;
  final String targetMuscles;
  final String? mediaUrl;
  final bool isCustom;
  final String coachCues;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const ExerciseData({
    required this.id,
    required this.name,
    this.nameFa,
    this.description,
    required this.equipmentType,
    required this.targetMuscles,
    this.mediaUrl,
    required this.isCustom,
    required this.coachCues,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameFa != null) {
      map['name_fa'] = Variable<String>(nameFa);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['equipment_type'] = Variable<String>(equipmentType);
    map['target_muscles'] = Variable<String>(targetMuscles);
    if (!nullToAbsent || mediaUrl != null) {
      map['media_url'] = Variable<String>(mediaUrl);
    }
    map['is_custom'] = Variable<bool>(isCustom);
    map['coach_cues'] = Variable<String>(coachCues);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      nameFa: nameFa == null && nullToAbsent
          ? const Value.absent()
          : Value(nameFa),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      equipmentType: Value(equipmentType),
      targetMuscles: Value(targetMuscles),
      mediaUrl: mediaUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaUrl),
      isCustom: Value(isCustom),
      coachCues: Value(coachCues),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ExerciseData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameFa: serializer.fromJson<String?>(json['nameFa']),
      description: serializer.fromJson<String?>(json['description']),
      equipmentType: serializer.fromJson<String>(json['equipmentType']),
      targetMuscles: serializer.fromJson<String>(json['targetMuscles']),
      mediaUrl: serializer.fromJson<String?>(json['mediaUrl']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      coachCues: serializer.fromJson<String>(json['coachCues']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'nameFa': serializer.toJson<String?>(nameFa),
      'description': serializer.toJson<String?>(description),
      'equipmentType': serializer.toJson<String>(equipmentType),
      'targetMuscles': serializer.toJson<String>(targetMuscles),
      'mediaUrl': serializer.toJson<String?>(mediaUrl),
      'isCustom': serializer.toJson<bool>(isCustom),
      'coachCues': serializer.toJson<String>(coachCues),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  ExerciseData copyWith({
    String? id,
    String? name,
    Value<String?> nameFa = const Value.absent(),
    Value<String?> description = const Value.absent(),
    String? equipmentType,
    String? targetMuscles,
    Value<String?> mediaUrl = const Value.absent(),
    bool? isCustom,
    String? coachCues,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => ExerciseData(
    id: id ?? this.id,
    name: name ?? this.name,
    nameFa: nameFa.present ? nameFa.value : this.nameFa,
    description: description.present ? description.value : this.description,
    equipmentType: equipmentType ?? this.equipmentType,
    targetMuscles: targetMuscles ?? this.targetMuscles,
    mediaUrl: mediaUrl.present ? mediaUrl.value : this.mediaUrl,
    isCustom: isCustom ?? this.isCustom,
    coachCues: coachCues ?? this.coachCues,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  ExerciseData copyWithCompanion(ExercisesCompanion data) {
    return ExerciseData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameFa: data.nameFa.present ? data.nameFa.value : this.nameFa,
      description: data.description.present
          ? data.description.value
          : this.description,
      equipmentType: data.equipmentType.present
          ? data.equipmentType.value
          : this.equipmentType,
      targetMuscles: data.targetMuscles.present
          ? data.targetMuscles.value
          : this.targetMuscles,
      mediaUrl: data.mediaUrl.present ? data.mediaUrl.value : this.mediaUrl,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      coachCues: data.coachCues.present ? data.coachCues.value : this.coachCues,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameFa: $nameFa, ')
          ..write('description: $description, ')
          ..write('equipmentType: $equipmentType, ')
          ..write('targetMuscles: $targetMuscles, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('isCustom: $isCustom, ')
          ..write('coachCues: $coachCues, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    nameFa,
    description,
    equipmentType,
    targetMuscles,
    mediaUrl,
    isCustom,
    coachCues,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseData &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameFa == this.nameFa &&
          other.description == this.description &&
          other.equipmentType == this.equipmentType &&
          other.targetMuscles == this.targetMuscles &&
          other.mediaUrl == this.mediaUrl &&
          other.isCustom == this.isCustom &&
          other.coachCues == this.coachCues &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExercisesCompanion extends UpdateCompanion<ExerciseData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> nameFa;
  final Value<String?> description;
  final Value<String> equipmentType;
  final Value<String> targetMuscles;
  final Value<String?> mediaUrl;
  final Value<bool> isCustom;
  final Value<String> coachCues;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameFa = const Value.absent(),
    this.description = const Value.absent(),
    this.equipmentType = const Value.absent(),
    this.targetMuscles = const Value.absent(),
    this.mediaUrl = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.coachCues = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisesCompanion.insert({
    required String id,
    required String name,
    this.nameFa = const Value.absent(),
    this.description = const Value.absent(),
    required String equipmentType,
    this.targetMuscles = const Value.absent(),
    this.mediaUrl = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.coachCues = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       equipmentType = Value(equipmentType),
       createdAt = Value(createdAt);
  static Insertable<ExerciseData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? nameFa,
    Expression<String>? description,
    Expression<String>? equipmentType,
    Expression<String>? targetMuscles,
    Expression<String>? mediaUrl,
    Expression<bool>? isCustom,
    Expression<String>? coachCues,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameFa != null) 'name_fa': nameFa,
      if (description != null) 'description': description,
      if (equipmentType != null) 'equipment_type': equipmentType,
      if (targetMuscles != null) 'target_muscles': targetMuscles,
      if (mediaUrl != null) 'media_url': mediaUrl,
      if (isCustom != null) 'is_custom': isCustom,
      if (coachCues != null) 'coach_cues': coachCues,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? nameFa,
    Value<String?>? description,
    Value<String>? equipmentType,
    Value<String>? targetMuscles,
    Value<String?>? mediaUrl,
    Value<bool>? isCustom,
    Value<String>? coachCues,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameFa: nameFa ?? this.nameFa,
      description: description ?? this.description,
      equipmentType: equipmentType ?? this.equipmentType,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      isCustom: isCustom ?? this.isCustom,
      coachCues: coachCues ?? this.coachCues,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameFa.present) {
      map['name_fa'] = Variable<String>(nameFa.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (equipmentType.present) {
      map['equipment_type'] = Variable<String>(equipmentType.value);
    }
    if (targetMuscles.present) {
      map['target_muscles'] = Variable<String>(targetMuscles.value);
    }
    if (mediaUrl.present) {
      map['media_url'] = Variable<String>(mediaUrl.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (coachCues.present) {
      map['coach_cues'] = Variable<String>(coachCues.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameFa: $nameFa, ')
          ..write('description: $description, ')
          ..write('equipmentType: $equipmentType, ')
          ..write('targetMuscles: $targetMuscles, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('isCustom: $isCustom, ')
          ..write('coachCues: $coachCues, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutPlansTable extends WorkoutPlans
    with TableInfo<$WorkoutPlansTable, WorkoutPlanData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    createdAt,
    updatedAt,
    isActive,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutPlanData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutPlanData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutPlanData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $WorkoutPlansTable createAlias(String alias) {
    return $WorkoutPlansTable(attachedDatabase, alias);
  }
}

class WorkoutPlanData extends DataClass implements Insertable<WorkoutPlanData> {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final bool isSynced;
  const WorkoutPlanData({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    this.updatedAt,
    required this.isActive,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  WorkoutPlansCompanion toCompanion(bool nullToAbsent) {
    return WorkoutPlansCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      isActive: Value(isActive),
      isSynced: Value(isSynced),
    );
  }

  factory WorkoutPlanData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutPlanData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'isActive': serializer.toJson<bool>(isActive),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  WorkoutPlanData copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    bool? isActive,
    bool? isSynced,
  }) => WorkoutPlanData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    isActive: isActive ?? this.isActive,
    isSynced: isSynced ?? this.isSynced,
  );
  WorkoutPlanData copyWithCompanion(WorkoutPlansCompanion data) {
    return WorkoutPlanData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlanData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isActive: $isActive, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    createdAt,
    updatedAt,
    isActive,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutPlanData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isActive == this.isActive &&
          other.isSynced == this.isSynced);
}

class WorkoutPlansCompanion extends UpdateCompanion<WorkoutPlanData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<bool> isActive;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const WorkoutPlansCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutPlansCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<WorkoutPlanData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isActive,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isActive != null) 'is_active': isActive,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutPlansCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<bool>? isActive,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return WorkoutPlansCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlansCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isActive: $isActive, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutDaysTable extends WorkoutDays
    with TableInfo<$WorkoutDaysTable, WorkoutDayData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_plans (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, planId, name, orderIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutDayData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutDayData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutDayData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $WorkoutDaysTable createAlias(String alias) {
    return $WorkoutDaysTable(attachedDatabase, alias);
  }
}

class WorkoutDayData extends DataClass implements Insertable<WorkoutDayData> {
  final String id;
  final String planId;
  final String name;
  final int orderIndex;
  const WorkoutDayData({
    required this.id,
    required this.planId,
    required this.name,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['plan_id'] = Variable<String>(planId);
    map['name'] = Variable<String>(name);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  WorkoutDaysCompanion toCompanion(bool nullToAbsent) {
    return WorkoutDaysCompanion(
      id: Value(id),
      planId: Value(planId),
      name: Value(name),
      orderIndex: Value(orderIndex),
    );
  }

  factory WorkoutDayData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutDayData(
      id: serializer.fromJson<String>(json['id']),
      planId: serializer.fromJson<String>(json['planId']),
      name: serializer.fromJson<String>(json['name']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'planId': serializer.toJson<String>(planId),
      'name': serializer.toJson<String>(name),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  WorkoutDayData copyWith({
    String? id,
    String? planId,
    String? name,
    int? orderIndex,
  }) => WorkoutDayData(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    name: name ?? this.name,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  WorkoutDayData copyWithCompanion(WorkoutDaysCompanion data) {
    return WorkoutDayData(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      name: data.name.present ? data.name.value : this.name,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutDayData(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('name: $name, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, planId, name, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutDayData &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.name == this.name &&
          other.orderIndex == this.orderIndex);
}

class WorkoutDaysCompanion extends UpdateCompanion<WorkoutDayData> {
  final Value<String> id;
  final Value<String> planId;
  final Value<String> name;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const WorkoutDaysCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.name = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutDaysCompanion.insert({
    required String id,
    required String planId,
    required String name,
    required int orderIndex,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       planId = Value(planId),
       name = Value(name),
       orderIndex = Value(orderIndex);
  static Insertable<WorkoutDayData> custom({
    Expression<String>? id,
    Expression<String>? planId,
    Expression<String>? name,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (name != null) 'name': name,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutDaysCompanion copyWith({
    Value<String>? id,
    Value<String>? planId,
    Value<String>? name,
    Value<int>? orderIndex,
    Value<int>? rowid,
  }) {
    return WorkoutDaysCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      name: name ?? this.name,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutDaysCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('name: $name, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutDayExercisesTable extends WorkoutDayExercises
    with TableInfo<$WorkoutDayExercisesTable, WorkoutDayExerciseData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutDayExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayIdMeta = const VerificationMeta('dayId');
  @override
  late final GeneratedColumn<String> dayId = GeneratedColumn<String>(
    'day_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_days (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _setsMeta = const VerificationMeta('sets');
  @override
  late final GeneratedColumn<int> sets = GeneratedColumn<int>(
    'sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _repsOrDurationMeta = const VerificationMeta(
    'repsOrDuration',
  );
  @override
  late final GeneratedColumn<int> repsOrDuration = GeneratedColumn<int>(
    'reps_or_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isTimeBasedMeta = const VerificationMeta(
    'isTimeBased',
  );
  @override
  late final GeneratedColumn<bool> isTimeBased = GeneratedColumn<bool>(
    'is_time_based',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_time_based" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _restTimeMeta = const VerificationMeta(
    'restTime',
  );
  @override
  late final GeneratedColumn<int> restTime = GeneratedColumn<int>(
    'rest_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayId,
    exerciseId,
    sets,
    repsOrDuration,
    isTimeBased,
    restTime,
    orderIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_day_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutDayExerciseData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('day_id')) {
      context.handle(
        _dayIdMeta,
        dayId.isAcceptableOrUnknown(data['day_id']!, _dayIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('sets')) {
      context.handle(
        _setsMeta,
        sets.isAcceptableOrUnknown(data['sets']!, _setsMeta),
      );
    }
    if (data.containsKey('reps_or_duration')) {
      context.handle(
        _repsOrDurationMeta,
        repsOrDuration.isAcceptableOrUnknown(
          data['reps_or_duration']!,
          _repsOrDurationMeta,
        ),
      );
    }
    if (data.containsKey('is_time_based')) {
      context.handle(
        _isTimeBasedMeta,
        isTimeBased.isAcceptableOrUnknown(
          data['is_time_based']!,
          _isTimeBasedMeta,
        ),
      );
    }
    if (data.containsKey('rest_time')) {
      context.handle(
        _restTimeMeta,
        restTime.isAcceptableOrUnknown(data['rest_time']!, _restTimeMeta),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutDayExerciseData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutDayExerciseData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      sets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sets'],
      )!,
      repsOrDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps_or_duration'],
      )!,
      isTimeBased: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_time_based'],
      )!,
      restTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_time'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $WorkoutDayExercisesTable createAlias(String alias) {
    return $WorkoutDayExercisesTable(attachedDatabase, alias);
  }
}

class WorkoutDayExerciseData extends DataClass
    implements Insertable<WorkoutDayExerciseData> {
  final String id;
  final String dayId;
  final String exerciseId;
  final int sets;
  final int repsOrDuration;
  final bool isTimeBased;
  final int restTime;
  final int orderIndex;
  const WorkoutDayExerciseData({
    required this.id,
    required this.dayId,
    required this.exerciseId,
    required this.sets,
    required this.repsOrDuration,
    required this.isTimeBased,
    required this.restTime,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['day_id'] = Variable<String>(dayId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['sets'] = Variable<int>(sets);
    map['reps_or_duration'] = Variable<int>(repsOrDuration);
    map['is_time_based'] = Variable<bool>(isTimeBased);
    map['rest_time'] = Variable<int>(restTime);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  WorkoutDayExercisesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutDayExercisesCompanion(
      id: Value(id),
      dayId: Value(dayId),
      exerciseId: Value(exerciseId),
      sets: Value(sets),
      repsOrDuration: Value(repsOrDuration),
      isTimeBased: Value(isTimeBased),
      restTime: Value(restTime),
      orderIndex: Value(orderIndex),
    );
  }

  factory WorkoutDayExerciseData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutDayExerciseData(
      id: serializer.fromJson<String>(json['id']),
      dayId: serializer.fromJson<String>(json['dayId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      sets: serializer.fromJson<int>(json['sets']),
      repsOrDuration: serializer.fromJson<int>(json['repsOrDuration']),
      isTimeBased: serializer.fromJson<bool>(json['isTimeBased']),
      restTime: serializer.fromJson<int>(json['restTime']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dayId': serializer.toJson<String>(dayId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'sets': serializer.toJson<int>(sets),
      'repsOrDuration': serializer.toJson<int>(repsOrDuration),
      'isTimeBased': serializer.toJson<bool>(isTimeBased),
      'restTime': serializer.toJson<int>(restTime),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  WorkoutDayExerciseData copyWith({
    String? id,
    String? dayId,
    String? exerciseId,
    int? sets,
    int? repsOrDuration,
    bool? isTimeBased,
    int? restTime,
    int? orderIndex,
  }) => WorkoutDayExerciseData(
    id: id ?? this.id,
    dayId: dayId ?? this.dayId,
    exerciseId: exerciseId ?? this.exerciseId,
    sets: sets ?? this.sets,
    repsOrDuration: repsOrDuration ?? this.repsOrDuration,
    isTimeBased: isTimeBased ?? this.isTimeBased,
    restTime: restTime ?? this.restTime,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  WorkoutDayExerciseData copyWithCompanion(WorkoutDayExercisesCompanion data) {
    return WorkoutDayExerciseData(
      id: data.id.present ? data.id.value : this.id,
      dayId: data.dayId.present ? data.dayId.value : this.dayId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      sets: data.sets.present ? data.sets.value : this.sets,
      repsOrDuration: data.repsOrDuration.present
          ? data.repsOrDuration.value
          : this.repsOrDuration,
      isTimeBased: data.isTimeBased.present
          ? data.isTimeBased.value
          : this.isTimeBased,
      restTime: data.restTime.present ? data.restTime.value : this.restTime,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutDayExerciseData(')
          ..write('id: $id, ')
          ..write('dayId: $dayId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sets: $sets, ')
          ..write('repsOrDuration: $repsOrDuration, ')
          ..write('isTimeBased: $isTimeBased, ')
          ..write('restTime: $restTime, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dayId,
    exerciseId,
    sets,
    repsOrDuration,
    isTimeBased,
    restTime,
    orderIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutDayExerciseData &&
          other.id == this.id &&
          other.dayId == this.dayId &&
          other.exerciseId == this.exerciseId &&
          other.sets == this.sets &&
          other.repsOrDuration == this.repsOrDuration &&
          other.isTimeBased == this.isTimeBased &&
          other.restTime == this.restTime &&
          other.orderIndex == this.orderIndex);
}

class WorkoutDayExercisesCompanion
    extends UpdateCompanion<WorkoutDayExerciseData> {
  final Value<String> id;
  final Value<String> dayId;
  final Value<String> exerciseId;
  final Value<int> sets;
  final Value<int> repsOrDuration;
  final Value<bool> isTimeBased;
  final Value<int> restTime;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const WorkoutDayExercisesCompanion({
    this.id = const Value.absent(),
    this.dayId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.sets = const Value.absent(),
    this.repsOrDuration = const Value.absent(),
    this.isTimeBased = const Value.absent(),
    this.restTime = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutDayExercisesCompanion.insert({
    required String id,
    required String dayId,
    required String exerciseId,
    this.sets = const Value.absent(),
    this.repsOrDuration = const Value.absent(),
    this.isTimeBased = const Value.absent(),
    this.restTime = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dayId = Value(dayId),
       exerciseId = Value(exerciseId);
  static Insertable<WorkoutDayExerciseData> custom({
    Expression<String>? id,
    Expression<String>? dayId,
    Expression<String>? exerciseId,
    Expression<int>? sets,
    Expression<int>? repsOrDuration,
    Expression<bool>? isTimeBased,
    Expression<int>? restTime,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayId != null) 'day_id': dayId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (sets != null) 'sets': sets,
      if (repsOrDuration != null) 'reps_or_duration': repsOrDuration,
      if (isTimeBased != null) 'is_time_based': isTimeBased,
      if (restTime != null) 'rest_time': restTime,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutDayExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? dayId,
    Value<String>? exerciseId,
    Value<int>? sets,
    Value<int>? repsOrDuration,
    Value<bool>? isTimeBased,
    Value<int>? restTime,
    Value<int>? orderIndex,
    Value<int>? rowid,
  }) {
    return WorkoutDayExercisesCompanion(
      id: id ?? this.id,
      dayId: dayId ?? this.dayId,
      exerciseId: exerciseId ?? this.exerciseId,
      sets: sets ?? this.sets,
      repsOrDuration: repsOrDuration ?? this.repsOrDuration,
      isTimeBased: isTimeBased ?? this.isTimeBased,
      restTime: restTime ?? this.restTime,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dayId.present) {
      map['day_id'] = Variable<String>(dayId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (sets.present) {
      map['sets'] = Variable<int>(sets.value);
    }
    if (repsOrDuration.present) {
      map['reps_or_duration'] = Variable<int>(repsOrDuration.value);
    }
    if (isTimeBased.present) {
      map['is_time_based'] = Variable<bool>(isTimeBased.value);
    }
    if (restTime.present) {
      map['rest_time'] = Variable<int>(restTime.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutDayExercisesCompanion(')
          ..write('id: $id, ')
          ..write('dayId: $dayId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sets: $sets, ')
          ..write('repsOrDuration: $repsOrDuration, ')
          ..write('isTimeBased: $isTimeBased, ')
          ..write('restTime: $restTime, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutLogsTable extends WorkoutLogs
    with TableInfo<$WorkoutLogsTable, WorkoutLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayIdMeta = const VerificationMeta('dayId');
  @override
  late final GeneratedColumn<String> dayId = GeneratedColumn<String>(
    'day_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayNameMeta = const VerificationMeta(
    'dayName',
  );
  @override
  late final GeneratedColumn<String> dayName = GeneratedColumn<String>(
    'day_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayId,
    dayName,
    completedAt,
    durationMinutes,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('day_id')) {
      context.handle(
        _dayIdMeta,
        dayId.isAcceptableOrUnknown(data['day_id']!, _dayIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIdMeta);
    }
    if (data.containsKey('day_name')) {
      context.handle(
        _dayNameMeta,
        dayName.isAcceptableOrUnknown(data['day_name']!, _dayNameMeta),
      );
    } else if (isInserting) {
      context.missing(_dayNameMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_id'],
      )!,
      dayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_name'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $WorkoutLogsTable createAlias(String alias) {
    return $WorkoutLogsTable(attachedDatabase, alias);
  }
}

class WorkoutLogData extends DataClass implements Insertable<WorkoutLogData> {
  final String id;
  final String dayId;
  final String dayName;
  final DateTime completedAt;
  final int durationMinutes;
  final bool isSynced;
  const WorkoutLogData({
    required this.id,
    required this.dayId,
    required this.dayName,
    required this.completedAt,
    required this.durationMinutes,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['day_id'] = Variable<String>(dayId);
    map['day_name'] = Variable<String>(dayName);
    map['completed_at'] = Variable<DateTime>(completedAt);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  WorkoutLogsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutLogsCompanion(
      id: Value(id),
      dayId: Value(dayId),
      dayName: Value(dayName),
      completedAt: Value(completedAt),
      durationMinutes: Value(durationMinutes),
      isSynced: Value(isSynced),
    );
  }

  factory WorkoutLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutLogData(
      id: serializer.fromJson<String>(json['id']),
      dayId: serializer.fromJson<String>(json['dayId']),
      dayName: serializer.fromJson<String>(json['dayName']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dayId': serializer.toJson<String>(dayId),
      'dayName': serializer.toJson<String>(dayName),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  WorkoutLogData copyWith({
    String? id,
    String? dayId,
    String? dayName,
    DateTime? completedAt,
    int? durationMinutes,
    bool? isSynced,
  }) => WorkoutLogData(
    id: id ?? this.id,
    dayId: dayId ?? this.dayId,
    dayName: dayName ?? this.dayName,
    completedAt: completedAt ?? this.completedAt,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    isSynced: isSynced ?? this.isSynced,
  );
  WorkoutLogData copyWithCompanion(WorkoutLogsCompanion data) {
    return WorkoutLogData(
      id: data.id.present ? data.id.value : this.id,
      dayId: data.dayId.present ? data.dayId.value : this.dayId,
      dayName: data.dayName.present ? data.dayName.value : this.dayName,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutLogData(')
          ..write('id: $id, ')
          ..write('dayId: $dayId, ')
          ..write('dayName: $dayName, ')
          ..write('completedAt: $completedAt, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dayId, dayName, completedAt, durationMinutes, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutLogData &&
          other.id == this.id &&
          other.dayId == this.dayId &&
          other.dayName == this.dayName &&
          other.completedAt == this.completedAt &&
          other.durationMinutes == this.durationMinutes &&
          other.isSynced == this.isSynced);
}

class WorkoutLogsCompanion extends UpdateCompanion<WorkoutLogData> {
  final Value<String> id;
  final Value<String> dayId;
  final Value<String> dayName;
  final Value<DateTime> completedAt;
  final Value<int> durationMinutes;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const WorkoutLogsCompanion({
    this.id = const Value.absent(),
    this.dayId = const Value.absent(),
    this.dayName = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutLogsCompanion.insert({
    required String id,
    required String dayId,
    required String dayName,
    required DateTime completedAt,
    this.durationMinutes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dayId = Value(dayId),
       dayName = Value(dayName),
       completedAt = Value(completedAt);
  static Insertable<WorkoutLogData> custom({
    Expression<String>? id,
    Expression<String>? dayId,
    Expression<String>? dayName,
    Expression<DateTime>? completedAt,
    Expression<int>? durationMinutes,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayId != null) 'day_id': dayId,
      if (dayName != null) 'day_name': dayName,
      if (completedAt != null) 'completed_at': completedAt,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? dayId,
    Value<String>? dayName,
    Value<DateTime>? completedAt,
    Value<int>? durationMinutes,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return WorkoutLogsCompanion(
      id: id ?? this.id,
      dayId: dayId ?? this.dayId,
      dayName: dayName ?? this.dayName,
      completedAt: completedAt ?? this.completedAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dayId.present) {
      map['day_id'] = Variable<String>(dayId.value);
    }
    if (dayName.present) {
      map['day_name'] = Variable<String>(dayName.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutLogsCompanion(')
          ..write('id: $id, ')
          ..write('dayId: $dayId, ')
          ..write('dayName: $dayName, ')
          ..write('completedAt: $completedAt, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SetLogsTable extends SetLogs with TableInfo<$SetLogsTable, SetLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logIdMeta = const VerificationMeta('logId');
  @override
  late final GeneratedColumn<String> logId = GeneratedColumn<String>(
    'log_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_logs (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setNumberMeta = const VerificationMeta(
    'setNumber',
  );
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
    'set_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    logId,
    exerciseId,
    setNumber,
    weight,
    reps,
    isCompleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'set_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SetLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('log_id')) {
      context.handle(
        _logIdMeta,
        logId.isAcceptableOrUnknown(data['log_id']!, _logIdMeta),
      );
    } else if (isInserting) {
      context.missing(_logIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(
        _setNumberMeta,
        setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      logId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}log_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      setNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_number'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
    );
  }

  @override
  $SetLogsTable createAlias(String alias) {
    return $SetLogsTable(attachedDatabase, alias);
  }
}

class SetLogData extends DataClass implements Insertable<SetLogData> {
  final String id;
  final String logId;
  final String exerciseId;
  final int setNumber;
  final double weight;
  final int reps;
  final bool isCompleted;
  const SetLogData({
    required this.id,
    required this.logId,
    required this.exerciseId,
    required this.setNumber,
    required this.weight,
    required this.reps,
    required this.isCompleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['log_id'] = Variable<String>(logId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['set_number'] = Variable<int>(setNumber);
    map['weight'] = Variable<double>(weight);
    map['reps'] = Variable<int>(reps);
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  SetLogsCompanion toCompanion(bool nullToAbsent) {
    return SetLogsCompanion(
      id: Value(id),
      logId: Value(logId),
      exerciseId: Value(exerciseId),
      setNumber: Value(setNumber),
      weight: Value(weight),
      reps: Value(reps),
      isCompleted: Value(isCompleted),
    );
  }

  factory SetLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetLogData(
      id: serializer.fromJson<String>(json['id']),
      logId: serializer.fromJson<String>(json['logId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      weight: serializer.fromJson<double>(json['weight']),
      reps: serializer.fromJson<int>(json['reps']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'logId': serializer.toJson<String>(logId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'setNumber': serializer.toJson<int>(setNumber),
      'weight': serializer.toJson<double>(weight),
      'reps': serializer.toJson<int>(reps),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  SetLogData copyWith({
    String? id,
    String? logId,
    String? exerciseId,
    int? setNumber,
    double? weight,
    int? reps,
    bool? isCompleted,
  }) => SetLogData(
    id: id ?? this.id,
    logId: logId ?? this.logId,
    exerciseId: exerciseId ?? this.exerciseId,
    setNumber: setNumber ?? this.setNumber,
    weight: weight ?? this.weight,
    reps: reps ?? this.reps,
    isCompleted: isCompleted ?? this.isCompleted,
  );
  SetLogData copyWithCompanion(SetLogsCompanion data) {
    return SetLogData(
      id: data.id.present ? data.id.value : this.id,
      logId: data.logId.present ? data.logId.value : this.logId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      weight: data.weight.present ? data.weight.value : this.weight,
      reps: data.reps.present ? data.reps.value : this.reps,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetLogData(')
          ..write('id: $id, ')
          ..write('logId: $logId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, logId, exerciseId, setNumber, weight, reps, isCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetLogData &&
          other.id == this.id &&
          other.logId == this.logId &&
          other.exerciseId == this.exerciseId &&
          other.setNumber == this.setNumber &&
          other.weight == this.weight &&
          other.reps == this.reps &&
          other.isCompleted == this.isCompleted);
}

class SetLogsCompanion extends UpdateCompanion<SetLogData> {
  final Value<String> id;
  final Value<String> logId;
  final Value<String> exerciseId;
  final Value<int> setNumber;
  final Value<double> weight;
  final Value<int> reps;
  final Value<bool> isCompleted;
  final Value<int> rowid;
  const SetLogsCompanion({
    this.id = const Value.absent(),
    this.logId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.weight = const Value.absent(),
    this.reps = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SetLogsCompanion.insert({
    required String id,
    required String logId,
    required String exerciseId,
    required int setNumber,
    this.weight = const Value.absent(),
    this.reps = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       logId = Value(logId),
       exerciseId = Value(exerciseId),
       setNumber = Value(setNumber);
  static Insertable<SetLogData> custom({
    Expression<String>? id,
    Expression<String>? logId,
    Expression<String>? exerciseId,
    Expression<int>? setNumber,
    Expression<double>? weight,
    Expression<int>? reps,
    Expression<bool>? isCompleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (logId != null) 'log_id': logId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (setNumber != null) 'set_number': setNumber,
      if (weight != null) 'weight': weight,
      if (reps != null) 'reps': reps,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SetLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? logId,
    Value<String>? exerciseId,
    Value<int>? setNumber,
    Value<double>? weight,
    Value<int>? reps,
    Value<bool>? isCompleted,
    Value<int>? rowid,
  }) {
    return SetLogsCompanion(
      id: id ?? this.id,
      logId: logId ?? this.logId,
      exerciseId: exerciseId ?? this.exerciseId,
      setNumber: setNumber ?? this.setNumber,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      isCompleted: isCompleted ?? this.isCompleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (logId.present) {
      map['log_id'] = Variable<String>(logId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetLogsCompanion(')
          ..write('id: $id, ')
          ..write('logId: $logId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    operation,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final String entityType;
  final String entityId;
  final String operation;
  final DateTime createdAt;
  const SyncQueueData({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      createdAt: Value(createdAt),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncQueueData copyWith({
    int? id,
    String? entityType,
    String? entityId,
    String? operation,
    DateTime? createdAt,
  }) => SyncQueueData(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entityType, entityId, operation, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.createdAt == this.createdAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<DateTime> createdAt;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required String entityId,
    required String operation,
    required DateTime createdAt,
  }) : entityType = Value(entityType),
       entityId = Value(entityId),
       operation = Value(operation),
       createdAt = Value(createdAt);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? operation,
    Value<DateTime>? createdAt,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $WorkoutPlansTable workoutPlans = $WorkoutPlansTable(this);
  late final $WorkoutDaysTable workoutDays = $WorkoutDaysTable(this);
  late final $WorkoutDayExercisesTable workoutDayExercises =
      $WorkoutDayExercisesTable(this);
  late final $WorkoutLogsTable workoutLogs = $WorkoutLogsTable(this);
  late final $SetLogsTable setLogs = $SetLogsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    exercises,
    workoutPlans,
    workoutDays,
    workoutDayExercises,
    workoutLogs,
    setLogs,
    syncQueue,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_plans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_days', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_days',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_day_exercises', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_day_exercises', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_logs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('set_logs', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ExercisesTableCreateCompanionBuilder =
    ExercisesCompanion Function({
      required String id,
      required String name,
      Value<String?> nameFa,
      Value<String?> description,
      required String equipmentType,
      Value<String> targetMuscles,
      Value<String?> mediaUrl,
      Value<bool> isCustom,
      Value<String> coachCues,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$ExercisesTableUpdateCompanionBuilder =
    ExercisesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> nameFa,
      Value<String?> description,
      Value<String> equipmentType,
      Value<String> targetMuscles,
      Value<String?> mediaUrl,
      Value<bool> isCustom,
      Value<String> coachCues,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, ExerciseData> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $WorkoutDayExercisesTable,
    List<WorkoutDayExerciseData>
  >
  _workoutDayExercisesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.workoutDayExercises,
        aliasName: $_aliasNameGenerator(
          db.exercises.id,
          db.workoutDayExercises.exerciseId,
        ),
      );

  $$WorkoutDayExercisesTableProcessedTableManager get workoutDayExercisesRefs {
    final manager = $$WorkoutDayExercisesTableTableManager(
      $_db,
      $_db.workoutDayExercises,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutDayExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameFa => $composableBuilder(
    column: $table.nameFa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipmentType => $composableBuilder(
    column: $table.equipmentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetMuscles => $composableBuilder(
    column: $table.targetMuscles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaUrl => $composableBuilder(
    column: $table.mediaUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coachCues => $composableBuilder(
    column: $table.coachCues,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutDayExercisesRefs(
    Expression<bool> Function($$WorkoutDayExercisesTableFilterComposer f) f,
  ) {
    final $$WorkoutDayExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutDayExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutDayExercisesTableFilterComposer(
            $db: $db,
            $table: $db.workoutDayExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameFa => $composableBuilder(
    column: $table.nameFa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipmentType => $composableBuilder(
    column: $table.equipmentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetMuscles => $composableBuilder(
    column: $table.targetMuscles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaUrl => $composableBuilder(
    column: $table.mediaUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coachCues => $composableBuilder(
    column: $table.coachCues,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameFa =>
      $composableBuilder(column: $table.nameFa, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipmentType => $composableBuilder(
    column: $table.equipmentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetMuscles => $composableBuilder(
    column: $table.targetMuscles,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mediaUrl =>
      $composableBuilder(column: $table.mediaUrl, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<String> get coachCues =>
      $composableBuilder(column: $table.coachCues, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> workoutDayExercisesRefs<T extends Object>(
    Expression<T> Function($$WorkoutDayExercisesTableAnnotationComposer a) f,
  ) {
    final $$WorkoutDayExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutDayExercises,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutDayExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutDayExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          ExerciseData,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (ExerciseData, $$ExercisesTableReferences),
          ExerciseData,
          PrefetchHooks Function({bool workoutDayExercisesRefs})
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameFa = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> equipmentType = const Value.absent(),
                Value<String> targetMuscles = const Value.absent(),
                Value<String?> mediaUrl = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<String> coachCues = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                name: name,
                nameFa: nameFa,
                description: description,
                equipmentType: equipmentType,
                targetMuscles: targetMuscles,
                mediaUrl: mediaUrl,
                isCustom: isCustom,
                coachCues: coachCues,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> nameFa = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required String equipmentType,
                Value<String> targetMuscles = const Value.absent(),
                Value<String?> mediaUrl = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<String> coachCues = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                name: name,
                nameFa: nameFa,
                description: description,
                equipmentType: equipmentType,
                targetMuscles: targetMuscles,
                mediaUrl: mediaUrl,
                isCustom: isCustom,
                coachCues: coachCues,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutDayExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutDayExercisesRefs) db.workoutDayExercises,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutDayExercisesRefs)
                    await $_getPrefetchedData<
                      ExerciseData,
                      $ExercisesTable,
                      WorkoutDayExerciseData
                    >(
                      currentTable: table,
                      referencedTable: $$ExercisesTableReferences
                          ._workoutDayExercisesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ExercisesTableReferences(
                            db,
                            table,
                            p0,
                          ).workoutDayExercisesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.exerciseId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      ExerciseData,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (ExerciseData, $$ExercisesTableReferences),
      ExerciseData,
      PrefetchHooks Function({bool workoutDayExercisesRefs})
    >;
typedef $$WorkoutPlansTableCreateCompanionBuilder =
    WorkoutPlansCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
      Value<bool> isActive,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$WorkoutPlansTableUpdateCompanionBuilder =
    WorkoutPlansCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<bool> isActive,
      Value<bool> isSynced,
      Value<int> rowid,
    });

final class $$WorkoutPlansTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutPlansTable, WorkoutPlanData> {
  $$WorkoutPlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkoutDaysTable, List<WorkoutDayData>>
  _workoutDaysRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutDays,
    aliasName: $_aliasNameGenerator(db.workoutPlans.id, db.workoutDays.planId),
  );

  $$WorkoutDaysTableProcessedTableManager get workoutDaysRefs {
    final manager = $$WorkoutDaysTableTableManager(
      $_db,
      $_db.workoutDays,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutDaysRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutPlansTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutPlansTable> {
  $$WorkoutPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutDaysRefs(
    Expression<bool> Function($$WorkoutDaysTableFilterComposer f) f,
  ) {
    final $$WorkoutDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutDays,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutDaysTableFilterComposer(
            $db: $db,
            $table: $db.workoutDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutPlansTable> {
  $$WorkoutPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutPlansTable> {
  $$WorkoutPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  Expression<T> workoutDaysRefs<T extends Object>(
    Expression<T> Function($$WorkoutDaysTableAnnotationComposer a) f,
  ) {
    final $$WorkoutDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutDays,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutPlansTable,
          WorkoutPlanData,
          $$WorkoutPlansTableFilterComposer,
          $$WorkoutPlansTableOrderingComposer,
          $$WorkoutPlansTableAnnotationComposer,
          $$WorkoutPlansTableCreateCompanionBuilder,
          $$WorkoutPlansTableUpdateCompanionBuilder,
          (WorkoutPlanData, $$WorkoutPlansTableReferences),
          WorkoutPlanData,
          PrefetchHooks Function({bool workoutDaysRefs})
        > {
  $$WorkoutPlansTableTableManager(_$AppDatabase db, $WorkoutPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutPlansCompanion(
                id: id,
                name: name,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isActive: isActive,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutPlansCompanion.insert(
                id: id,
                name: name,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isActive: isActive,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutPlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutDaysRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (workoutDaysRefs) db.workoutDays],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutDaysRefs)
                    await $_getPrefetchedData<
                      WorkoutPlanData,
                      $WorkoutPlansTable,
                      WorkoutDayData
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutPlansTableReferences
                          ._workoutDaysRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkoutPlansTableReferences(
                            db,
                            table,
                            p0,
                          ).workoutDaysRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.planId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutPlansTable,
      WorkoutPlanData,
      $$WorkoutPlansTableFilterComposer,
      $$WorkoutPlansTableOrderingComposer,
      $$WorkoutPlansTableAnnotationComposer,
      $$WorkoutPlansTableCreateCompanionBuilder,
      $$WorkoutPlansTableUpdateCompanionBuilder,
      (WorkoutPlanData, $$WorkoutPlansTableReferences),
      WorkoutPlanData,
      PrefetchHooks Function({bool workoutDaysRefs})
    >;
typedef $$WorkoutDaysTableCreateCompanionBuilder =
    WorkoutDaysCompanion Function({
      required String id,
      required String planId,
      required String name,
      required int orderIndex,
      Value<int> rowid,
    });
typedef $$WorkoutDaysTableUpdateCompanionBuilder =
    WorkoutDaysCompanion Function({
      Value<String> id,
      Value<String> planId,
      Value<String> name,
      Value<int> orderIndex,
      Value<int> rowid,
    });

final class $$WorkoutDaysTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutDaysTable, WorkoutDayData> {
  $$WorkoutDaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutPlansTable _planIdTable(_$AppDatabase db) =>
      db.workoutPlans.createAlias(
        $_aliasNameGenerator(db.workoutDays.planId, db.workoutPlans.id),
      );

  $$WorkoutPlansTableProcessedTableManager get planId {
    final $_column = $_itemColumn<String>('plan_id')!;

    final manager = $$WorkoutPlansTableTableManager(
      $_db,
      $_db.workoutPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $WorkoutDayExercisesTable,
    List<WorkoutDayExerciseData>
  >
  _workoutDayExercisesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.workoutDayExercises,
        aliasName: $_aliasNameGenerator(
          db.workoutDays.id,
          db.workoutDayExercises.dayId,
        ),
      );

  $$WorkoutDayExercisesTableProcessedTableManager get workoutDayExercisesRefs {
    final manager = $$WorkoutDayExercisesTableTableManager(
      $_db,
      $_db.workoutDayExercises,
    ).filter((f) => f.dayId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutDayExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutDaysTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutDaysTable> {
  $$WorkoutDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutPlansTableFilterComposer get planId {
    final $$WorkoutPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.workoutPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutPlansTableFilterComposer(
            $db: $db,
            $table: $db.workoutPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutDayExercisesRefs(
    Expression<bool> Function($$WorkoutDayExercisesTableFilterComposer f) f,
  ) {
    final $$WorkoutDayExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutDayExercises,
      getReferencedColumn: (t) => t.dayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutDayExercisesTableFilterComposer(
            $db: $db,
            $table: $db.workoutDayExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutDaysTable> {
  $$WorkoutDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutPlansTableOrderingComposer get planId {
    final $$WorkoutPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.workoutPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutPlansTableOrderingComposer(
            $db: $db,
            $table: $db.workoutPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutDaysTable> {
  $$WorkoutDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  $$WorkoutPlansTableAnnotationComposer get planId {
    final $$WorkoutPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.workoutPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutDayExercisesRefs<T extends Object>(
    Expression<T> Function($$WorkoutDayExercisesTableAnnotationComposer a) f,
  ) {
    final $$WorkoutDayExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutDayExercises,
          getReferencedColumn: (t) => t.dayId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutDayExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutDayExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutDaysTable,
          WorkoutDayData,
          $$WorkoutDaysTableFilterComposer,
          $$WorkoutDaysTableOrderingComposer,
          $$WorkoutDaysTableAnnotationComposer,
          $$WorkoutDaysTableCreateCompanionBuilder,
          $$WorkoutDaysTableUpdateCompanionBuilder,
          (WorkoutDayData, $$WorkoutDaysTableReferences),
          WorkoutDayData,
          PrefetchHooks Function({bool planId, bool workoutDayExercisesRefs})
        > {
  $$WorkoutDaysTableTableManager(_$AppDatabase db, $WorkoutDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> planId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutDaysCompanion(
                id: id,
                planId: planId,
                name: name,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String planId,
                required String name,
                required int orderIndex,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutDaysCompanion.insert(
                id: id,
                planId: planId,
                name: name,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutDaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({planId = false, workoutDayExercisesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutDayExercisesRefs) db.workoutDayExercises,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (planId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.planId,
                                    referencedTable:
                                        $$WorkoutDaysTableReferences
                                            ._planIdTable(db),
                                    referencedColumn:
                                        $$WorkoutDaysTableReferences
                                            ._planIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutDayExercisesRefs)
                        await $_getPrefetchedData<
                          WorkoutDayData,
                          $WorkoutDaysTable,
                          WorkoutDayExerciseData
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutDaysTableReferences
                              ._workoutDayExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutDaysTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutDayExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.dayId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutDaysTable,
      WorkoutDayData,
      $$WorkoutDaysTableFilterComposer,
      $$WorkoutDaysTableOrderingComposer,
      $$WorkoutDaysTableAnnotationComposer,
      $$WorkoutDaysTableCreateCompanionBuilder,
      $$WorkoutDaysTableUpdateCompanionBuilder,
      (WorkoutDayData, $$WorkoutDaysTableReferences),
      WorkoutDayData,
      PrefetchHooks Function({bool planId, bool workoutDayExercisesRefs})
    >;
typedef $$WorkoutDayExercisesTableCreateCompanionBuilder =
    WorkoutDayExercisesCompanion Function({
      required String id,
      required String dayId,
      required String exerciseId,
      Value<int> sets,
      Value<int> repsOrDuration,
      Value<bool> isTimeBased,
      Value<int> restTime,
      Value<int> orderIndex,
      Value<int> rowid,
    });
typedef $$WorkoutDayExercisesTableUpdateCompanionBuilder =
    WorkoutDayExercisesCompanion Function({
      Value<String> id,
      Value<String> dayId,
      Value<String> exerciseId,
      Value<int> sets,
      Value<int> repsOrDuration,
      Value<bool> isTimeBased,
      Value<int> restTime,
      Value<int> orderIndex,
      Value<int> rowid,
    });

final class $$WorkoutDayExercisesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutDayExercisesTable,
          WorkoutDayExerciseData
        > {
  $$WorkoutDayExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutDaysTable _dayIdTable(_$AppDatabase db) =>
      db.workoutDays.createAlias(
        $_aliasNameGenerator(db.workoutDayExercises.dayId, db.workoutDays.id),
      );

  $$WorkoutDaysTableProcessedTableManager get dayId {
    final $_column = $_itemColumn<String>('day_id')!;

    final manager = $$WorkoutDaysTableTableManager(
      $_db,
      $_db.workoutDays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias(
        $_aliasNameGenerator(
          db.workoutDayExercises.exerciseId,
          db.exercises.id,
        ),
      );

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutDayExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutDayExercisesTable> {
  $$WorkoutDayExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repsOrDuration => $composableBuilder(
    column: $table.repsOrDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isTimeBased => $composableBuilder(
    column: $table.isTimeBased,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restTime => $composableBuilder(
    column: $table.restTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutDaysTableFilterComposer get dayId {
    final $$WorkoutDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dayId,
      referencedTable: $db.workoutDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutDaysTableFilterComposer(
            $db: $db,
            $table: $db.workoutDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutDayExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutDayExercisesTable> {
  $$WorkoutDayExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repsOrDuration => $composableBuilder(
    column: $table.repsOrDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTimeBased => $composableBuilder(
    column: $table.isTimeBased,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restTime => $composableBuilder(
    column: $table.restTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutDaysTableOrderingComposer get dayId {
    final $$WorkoutDaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dayId,
      referencedTable: $db.workoutDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutDaysTableOrderingComposer(
            $db: $db,
            $table: $db.workoutDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutDayExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutDayExercisesTable> {
  $$WorkoutDayExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sets =>
      $composableBuilder(column: $table.sets, builder: (column) => column);

  GeneratedColumn<int> get repsOrDuration => $composableBuilder(
    column: $table.repsOrDuration,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isTimeBased => $composableBuilder(
    column: $table.isTimeBased,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restTime =>
      $composableBuilder(column: $table.restTime, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  $$WorkoutDaysTableAnnotationComposer get dayId {
    final $$WorkoutDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dayId,
      referencedTable: $db.workoutDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutDayExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutDayExercisesTable,
          WorkoutDayExerciseData,
          $$WorkoutDayExercisesTableFilterComposer,
          $$WorkoutDayExercisesTableOrderingComposer,
          $$WorkoutDayExercisesTableAnnotationComposer,
          $$WorkoutDayExercisesTableCreateCompanionBuilder,
          $$WorkoutDayExercisesTableUpdateCompanionBuilder,
          (WorkoutDayExerciseData, $$WorkoutDayExercisesTableReferences),
          WorkoutDayExerciseData,
          PrefetchHooks Function({bool dayId, bool exerciseId})
        > {
  $$WorkoutDayExercisesTableTableManager(
    _$AppDatabase db,
    $WorkoutDayExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutDayExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutDayExercisesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WorkoutDayExercisesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> dayId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> sets = const Value.absent(),
                Value<int> repsOrDuration = const Value.absent(),
                Value<bool> isTimeBased = const Value.absent(),
                Value<int> restTime = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutDayExercisesCompanion(
                id: id,
                dayId: dayId,
                exerciseId: exerciseId,
                sets: sets,
                repsOrDuration: repsOrDuration,
                isTimeBased: isTimeBased,
                restTime: restTime,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String dayId,
                required String exerciseId,
                Value<int> sets = const Value.absent(),
                Value<int> repsOrDuration = const Value.absent(),
                Value<bool> isTimeBased = const Value.absent(),
                Value<int> restTime = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutDayExercisesCompanion.insert(
                id: id,
                dayId: dayId,
                exerciseId: exerciseId,
                sets: sets,
                repsOrDuration: repsOrDuration,
                isTimeBased: isTimeBased,
                restTime: restTime,
                orderIndex: orderIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutDayExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({dayId = false, exerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (dayId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.dayId,
                                referencedTable:
                                    $$WorkoutDayExercisesTableReferences
                                        ._dayIdTable(db),
                                referencedColumn:
                                    $$WorkoutDayExercisesTableReferences
                                        ._dayIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (exerciseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.exerciseId,
                                referencedTable:
                                    $$WorkoutDayExercisesTableReferences
                                        ._exerciseIdTable(db),
                                referencedColumn:
                                    $$WorkoutDayExercisesTableReferences
                                        ._exerciseIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutDayExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutDayExercisesTable,
      WorkoutDayExerciseData,
      $$WorkoutDayExercisesTableFilterComposer,
      $$WorkoutDayExercisesTableOrderingComposer,
      $$WorkoutDayExercisesTableAnnotationComposer,
      $$WorkoutDayExercisesTableCreateCompanionBuilder,
      $$WorkoutDayExercisesTableUpdateCompanionBuilder,
      (WorkoutDayExerciseData, $$WorkoutDayExercisesTableReferences),
      WorkoutDayExerciseData,
      PrefetchHooks Function({bool dayId, bool exerciseId})
    >;
typedef $$WorkoutLogsTableCreateCompanionBuilder =
    WorkoutLogsCompanion Function({
      required String id,
      required String dayId,
      required String dayName,
      required DateTime completedAt,
      Value<int> durationMinutes,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$WorkoutLogsTableUpdateCompanionBuilder =
    WorkoutLogsCompanion Function({
      Value<String> id,
      Value<String> dayId,
      Value<String> dayName,
      Value<DateTime> completedAt,
      Value<int> durationMinutes,
      Value<bool> isSynced,
      Value<int> rowid,
    });

final class $$WorkoutLogsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutLogsTable, WorkoutLogData> {
  $$WorkoutLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SetLogsTable, List<SetLogData>> _setLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.setLogs,
    aliasName: $_aliasNameGenerator(db.workoutLogs.id, db.setLogs.logId),
  );

  $$SetLogsTableProcessedTableManager get setLogsRefs {
    final manager = $$SetLogsTableTableManager(
      $_db,
      $_db.setLogs,
    ).filter((f) => f.logId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_setLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutLogsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutLogsTable> {
  $$WorkoutLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayName => $composableBuilder(
    column: $table.dayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> setLogsRefs(
    Expression<bool> Function($$SetLogsTableFilterComposer f) f,
  ) {
    final $$SetLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.logId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableFilterComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutLogsTable> {
  $$WorkoutLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayName => $composableBuilder(
    column: $table.dayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutLogsTable> {
  $$WorkoutLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dayId =>
      $composableBuilder(column: $table.dayId, builder: (column) => column);

  GeneratedColumn<String> get dayName =>
      $composableBuilder(column: $table.dayName, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  Expression<T> setLogsRefs<T extends Object>(
    Expression<T> Function($$SetLogsTableAnnotationComposer a) f,
  ) {
    final $$SetLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.logId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutLogsTable,
          WorkoutLogData,
          $$WorkoutLogsTableFilterComposer,
          $$WorkoutLogsTableOrderingComposer,
          $$WorkoutLogsTableAnnotationComposer,
          $$WorkoutLogsTableCreateCompanionBuilder,
          $$WorkoutLogsTableUpdateCompanionBuilder,
          (WorkoutLogData, $$WorkoutLogsTableReferences),
          WorkoutLogData,
          PrefetchHooks Function({bool setLogsRefs})
        > {
  $$WorkoutLogsTableTableManager(_$AppDatabase db, $WorkoutLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> dayId = const Value.absent(),
                Value<String> dayName = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutLogsCompanion(
                id: id,
                dayId: dayId,
                dayName: dayName,
                completedAt: completedAt,
                durationMinutes: durationMinutes,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String dayId,
                required String dayName,
                required DateTime completedAt,
                Value<int> durationMinutes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutLogsCompanion.insert(
                id: id,
                dayId: dayId,
                dayName: dayName,
                completedAt: completedAt,
                durationMinutes: durationMinutes,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({setLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (setLogsRefs) db.setLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (setLogsRefs)
                    await $_getPrefetchedData<
                      WorkoutLogData,
                      $WorkoutLogsTable,
                      SetLogData
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutLogsTableReferences
                          ._setLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkoutLogsTableReferences(
                            db,
                            table,
                            p0,
                          ).setLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.logId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutLogsTable,
      WorkoutLogData,
      $$WorkoutLogsTableFilterComposer,
      $$WorkoutLogsTableOrderingComposer,
      $$WorkoutLogsTableAnnotationComposer,
      $$WorkoutLogsTableCreateCompanionBuilder,
      $$WorkoutLogsTableUpdateCompanionBuilder,
      (WorkoutLogData, $$WorkoutLogsTableReferences),
      WorkoutLogData,
      PrefetchHooks Function({bool setLogsRefs})
    >;
typedef $$SetLogsTableCreateCompanionBuilder =
    SetLogsCompanion Function({
      required String id,
      required String logId,
      required String exerciseId,
      required int setNumber,
      Value<double> weight,
      Value<int> reps,
      Value<bool> isCompleted,
      Value<int> rowid,
    });
typedef $$SetLogsTableUpdateCompanionBuilder =
    SetLogsCompanion Function({
      Value<String> id,
      Value<String> logId,
      Value<String> exerciseId,
      Value<int> setNumber,
      Value<double> weight,
      Value<int> reps,
      Value<bool> isCompleted,
      Value<int> rowid,
    });

final class $$SetLogsTableReferences
    extends BaseReferences<_$AppDatabase, $SetLogsTable, SetLogData> {
  $$SetLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutLogsTable _logIdTable(_$AppDatabase db) => db.workoutLogs
      .createAlias($_aliasNameGenerator(db.setLogs.logId, db.workoutLogs.id));

  $$WorkoutLogsTableProcessedTableManager get logId {
    final $_column = $_itemColumn<String>('log_id')!;

    final manager = $$WorkoutLogsTableTableManager(
      $_db,
      $_db.workoutLogs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_logIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SetLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutLogsTableFilterComposer get logId {
    final $$WorkoutLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logId,
      referencedTable: $db.workoutLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutLogsTableFilterComposer(
            $db: $db,
            $table: $db.workoutLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutLogsTableOrderingComposer get logId {
    final $$WorkoutLogsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logId,
      referencedTable: $db.workoutLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutLogsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  $$WorkoutLogsTableAnnotationComposer get logId {
    final $$WorkoutLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logId,
      referencedTable: $db.workoutLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SetLogsTable,
          SetLogData,
          $$SetLogsTableFilterComposer,
          $$SetLogsTableOrderingComposer,
          $$SetLogsTableAnnotationComposer,
          $$SetLogsTableCreateCompanionBuilder,
          $$SetLogsTableUpdateCompanionBuilder,
          (SetLogData, $$SetLogsTableReferences),
          SetLogData,
          PrefetchHooks Function({bool logId})
        > {
  $$SetLogsTableTableManager(_$AppDatabase db, $SetLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> logId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> setNumber = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SetLogsCompanion(
                id: id,
                logId: logId,
                exerciseId: exerciseId,
                setNumber: setNumber,
                weight: weight,
                reps: reps,
                isCompleted: isCompleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String logId,
                required String exerciseId,
                required int setNumber,
                Value<double> weight = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SetLogsCompanion.insert(
                id: id,
                logId: logId,
                exerciseId: exerciseId,
                setNumber: setNumber,
                weight: weight,
                reps: reps,
                isCompleted: isCompleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SetLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({logId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (logId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.logId,
                                referencedTable: $$SetLogsTableReferences
                                    ._logIdTable(db),
                                referencedColumn: $$SetLogsTableReferences
                                    ._logIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SetLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SetLogsTable,
      SetLogData,
      $$SetLogsTableFilterComposer,
      $$SetLogsTableOrderingComposer,
      $$SetLogsTableAnnotationComposer,
      $$SetLogsTableCreateCompanionBuilder,
      $$SetLogsTableUpdateCompanionBuilder,
      (SetLogData, $$SetLogsTableReferences),
      SetLogData,
      PrefetchHooks Function({bool logId})
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      required String entityType,
      required String entityId,
      required String operation,
      required DateTime createdAt,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> operation,
      Value<DateTime> createdAt,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityType,
                required String entityId,
                required String operation,
                required DateTime createdAt,
              }) => SyncQueueCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$WorkoutPlansTableTableManager get workoutPlans =>
      $$WorkoutPlansTableTableManager(_db, _db.workoutPlans);
  $$WorkoutDaysTableTableManager get workoutDays =>
      $$WorkoutDaysTableTableManager(_db, _db.workoutDays);
  $$WorkoutDayExercisesTableTableManager get workoutDayExercises =>
      $$WorkoutDayExercisesTableTableManager(_db, _db.workoutDayExercises);
  $$WorkoutLogsTableTableManager get workoutLogs =>
      $$WorkoutLogsTableTableManager(_db, _db.workoutLogs);
  $$SetLogsTableTableManager get setLogs =>
      $$SetLogsTableTableManager(_db, _db.setLogs);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'3d3a397d2ea952fc020fce0506793a5564e93530';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = ProviderRef<AppDatabase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
