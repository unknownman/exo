// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthResponseDto _$AuthResponseDtoFromJson(Map<String, dynamic> json) =>
    _AuthResponseDto(
      userId: json['userId'] as String,
      token: json['token'] as String,
      tokenExpiresAt: DateTime.parse(json['tokenExpiresAt'] as String),
    );

Map<String, dynamic> _$AuthResponseDtoToJson(_AuthResponseDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'token': instance.token,
      'tokenExpiresAt': instance.tokenExpiresAt.toIso8601String(),
    };
