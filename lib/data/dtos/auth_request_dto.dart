// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_request_dto.freezed.dart';
part 'auth_request_dto.g.dart';

@freezed
abstract class AuthRequestDto with _$AuthRequestDto {
  const factory AuthRequestDto({
    @JsonKey(name: 'deviceId') required String deviceId,
    @JsonKey(name: 'locale') required String locale,
    @JsonKey(name: 'platform') required String platform,
    @JsonKey(name: 'appVersion') required String appVersion,
  }) = _AuthRequestDto;

  factory AuthRequestDto.fromJson(Map<String, dynamic> json) =>
      _$AuthRequestDtoFromJson(json);
}
