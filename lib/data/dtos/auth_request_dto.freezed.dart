// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthRequestDto {

@JsonKey(name: 'deviceId') String get deviceId;@JsonKey(name: 'locale') String get locale;@JsonKey(name: 'platform') String get platform;@JsonKey(name: 'appVersion') String get appVersion;
/// Create a copy of AuthRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthRequestDtoCopyWith<AuthRequestDto> get copyWith => _$AuthRequestDtoCopyWithImpl<AuthRequestDto>(this as AuthRequestDto, _$identity);

  /// Serializes this AuthRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthRequestDto&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,locale,platform,appVersion);

@override
String toString() {
  return 'AuthRequestDto(deviceId: $deviceId, locale: $locale, platform: $platform, appVersion: $appVersion)';
}


}

/// @nodoc
abstract mixin class $AuthRequestDtoCopyWith<$Res>  {
  factory $AuthRequestDtoCopyWith(AuthRequestDto value, $Res Function(AuthRequestDto) _then) = _$AuthRequestDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'deviceId') String deviceId,@JsonKey(name: 'locale') String locale,@JsonKey(name: 'platform') String platform,@JsonKey(name: 'appVersion') String appVersion
});




}
/// @nodoc
class _$AuthRequestDtoCopyWithImpl<$Res>
    implements $AuthRequestDtoCopyWith<$Res> {
  _$AuthRequestDtoCopyWithImpl(this._self, this._then);

  final AuthRequestDto _self;
  final $Res Function(AuthRequestDto) _then;

/// Create a copy of AuthRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? locale = null,Object? platform = null,Object? appVersion = null,}) {
  return _then(_self.copyWith(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthRequestDto].
extension AuthRequestDtoPatterns on AuthRequestDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthRequestDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _AuthRequestDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuthRequestDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'deviceId')  String deviceId, @JsonKey(name: 'locale')  String locale, @JsonKey(name: 'platform')  String platform, @JsonKey(name: 'appVersion')  String appVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthRequestDto() when $default != null:
return $default(_that.deviceId,_that.locale,_that.platform,_that.appVersion);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'deviceId')  String deviceId, @JsonKey(name: 'locale')  String locale, @JsonKey(name: 'platform')  String platform, @JsonKey(name: 'appVersion')  String appVersion)  $default,) {final _that = this;
switch (_that) {
case _AuthRequestDto():
return $default(_that.deviceId,_that.locale,_that.platform,_that.appVersion);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'deviceId')  String deviceId, @JsonKey(name: 'locale')  String locale, @JsonKey(name: 'platform')  String platform, @JsonKey(name: 'appVersion')  String appVersion)?  $default,) {final _that = this;
switch (_that) {
case _AuthRequestDto() when $default != null:
return $default(_that.deviceId,_that.locale,_that.platform,_that.appVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthRequestDto implements AuthRequestDto {
  const _AuthRequestDto({@JsonKey(name: 'deviceId') required this.deviceId, @JsonKey(name: 'locale') required this.locale, @JsonKey(name: 'platform') required this.platform, @JsonKey(name: 'appVersion') required this.appVersion});
  factory _AuthRequestDto.fromJson(Map<String, dynamic> json) => _$AuthRequestDtoFromJson(json);

@override@JsonKey(name: 'deviceId') final  String deviceId;
@override@JsonKey(name: 'locale') final  String locale;
@override@JsonKey(name: 'platform') final  String platform;
@override@JsonKey(name: 'appVersion') final  String appVersion;

/// Create a copy of AuthRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthRequestDtoCopyWith<_AuthRequestDto> get copyWith => __$AuthRequestDtoCopyWithImpl<_AuthRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthRequestDto&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,locale,platform,appVersion);

@override
String toString() {
  return 'AuthRequestDto(deviceId: $deviceId, locale: $locale, platform: $platform, appVersion: $appVersion)';
}


}

/// @nodoc
abstract mixin class _$AuthRequestDtoCopyWith<$Res> implements $AuthRequestDtoCopyWith<$Res> {
  factory _$AuthRequestDtoCopyWith(_AuthRequestDto value, $Res Function(_AuthRequestDto) _then) = __$AuthRequestDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'deviceId') String deviceId,@JsonKey(name: 'locale') String locale,@JsonKey(name: 'platform') String platform,@JsonKey(name: 'appVersion') String appVersion
});




}
/// @nodoc
class __$AuthRequestDtoCopyWithImpl<$Res>
    implements _$AuthRequestDtoCopyWith<$Res> {
  __$AuthRequestDtoCopyWithImpl(this._self, this._then);

  final _AuthRequestDto _self;
  final $Res Function(_AuthRequestDto) _then;

/// Create a copy of AuthRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? locale = null,Object? platform = null,Object? appVersion = null,}) {
  return _then(_AuthRequestDto(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
