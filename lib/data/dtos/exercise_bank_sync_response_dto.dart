// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_bank_sync_response_dto.freezed.dart';
part 'exercise_bank_sync_response_dto.g.dart';

@freezed
abstract class ExerciseBankSyncResponseDto with _$ExerciseBankSyncResponseDto {
  const factory ExerciseBankSyncResponseDto({
    @JsonKey(name: 'serverTimestamp') required DateTime serverTimestamp,
    required List<Map<String, dynamic>> updates,
    required List<String> deletes,
  }) = _ExerciseBankSyncResponseDto;

  factory ExerciseBankSyncResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ExerciseBankSyncResponseDtoFromJson(json);
}
