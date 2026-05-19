// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_bank_sync_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseBankSyncRequestDto _$ExerciseBankSyncRequestDtoFromJson(
  Map<String, dynamic> json,
) => _ExerciseBankSyncRequestDto(
  userId: json['userId'] as String,
  lastSyncTimestamp: json['lastSyncTimestamp'] == null
      ? null
      : DateTime.parse(json['lastSyncTimestamp'] as String),
);

Map<String, dynamic> _$ExerciseBankSyncRequestDtoToJson(
  _ExerciseBankSyncRequestDto instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'lastSyncTimestamp': instance.lastSyncTimestamp?.toIso8601String(),
};
