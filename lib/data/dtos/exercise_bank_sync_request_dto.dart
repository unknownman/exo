// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_bank_sync_request_dto.freezed.dart';
part 'exercise_bank_sync_request_dto.g.dart';

@freezed
abstract class ExerciseBankSyncRequestDto with _$ExerciseBankSyncRequestDto {
  const factory ExerciseBankSyncRequestDto({
    @JsonKey(name: 'userId') required String userId,
    @JsonKey(name: 'lastSyncTimestamp') DateTime? lastSyncTimestamp,
  }) = _ExerciseBankSyncRequestDto;

  factory ExerciseBankSyncRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ExerciseBankSyncRequestDtoFromJson(json);
}
