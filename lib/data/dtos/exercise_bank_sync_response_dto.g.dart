// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_bank_sync_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExerciseBankSyncResponseDto _$ExerciseBankSyncResponseDtoFromJson(
  Map<String, dynamic> json,
) => _ExerciseBankSyncResponseDto(
  serverTimestamp: DateTime.parse(json['serverTimestamp'] as String),
  updates: (json['updates'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
  deletes: (json['deletes'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$ExerciseBankSyncResponseDtoToJson(
  _ExerciseBankSyncResponseDto instance,
) => <String, dynamic>{
  'serverTimestamp': instance.serverTimestamp.toIso8601String(),
  'updates': instance.updates,
  'deletes': instance.deletes,
};
