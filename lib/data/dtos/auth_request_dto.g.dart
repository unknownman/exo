// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthRequestDto _$AuthRequestDtoFromJson(Map<String, dynamic> json) =>
    _AuthRequestDto(
      deviceId: json['deviceId'] as String,
      locale: json['locale'] as String,
      platform: json['platform'] as String,
      appVersion: json['appVersion'] as String,
    );

Map<String, dynamic> _$AuthRequestDtoToJson(_AuthRequestDto instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'locale': instance.locale,
      'platform': instance.platform,
      'appVersion': instance.appVersion,
    };
