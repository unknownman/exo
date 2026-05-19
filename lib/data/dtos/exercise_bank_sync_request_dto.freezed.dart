// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_bank_sync_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseBankSyncRequestDto {

@JsonKey(name: 'userId') String get userId;@JsonKey(name: 'lastSyncTimestamp') DateTime? get lastSyncTimestamp;
/// Create a copy of ExerciseBankSyncRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseBankSyncRequestDtoCopyWith<ExerciseBankSyncRequestDto> get copyWith => _$ExerciseBankSyncRequestDtoCopyWithImpl<ExerciseBankSyncRequestDto>(this as ExerciseBankSyncRequestDto, _$identity);

  /// Serializes this ExerciseBankSyncRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseBankSyncRequestDto&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.lastSyncTimestamp, lastSyncTimestamp) || other.lastSyncTimestamp == lastSyncTimestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,lastSyncTimestamp);

@override
String toString() {
  return 'ExerciseBankSyncRequestDto(userId: $userId, lastSyncTimestamp: $lastSyncTimestamp)';
}


}

/// @nodoc
abstract mixin class $ExerciseBankSyncRequestDtoCopyWith<$Res>  {
  factory $ExerciseBankSyncRequestDtoCopyWith(ExerciseBankSyncRequestDto value, $Res Function(ExerciseBankSyncRequestDto) _then) = _$ExerciseBankSyncRequestDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'userId') String userId,@JsonKey(name: 'lastSyncTimestamp') DateTime? lastSyncTimestamp
});




}
/// @nodoc
class _$ExerciseBankSyncRequestDtoCopyWithImpl<$Res>
    implements $ExerciseBankSyncRequestDtoCopyWith<$Res> {
  _$ExerciseBankSyncRequestDtoCopyWithImpl(this._self, this._then);

  final ExerciseBankSyncRequestDto _self;
  final $Res Function(ExerciseBankSyncRequestDto) _then;

/// Create a copy of ExerciseBankSyncRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? lastSyncTimestamp = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,lastSyncTimestamp: freezed == lastSyncTimestamp ? _self.lastSyncTimestamp : lastSyncTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseBankSyncRequestDto].
extension ExerciseBankSyncRequestDtoPatterns on ExerciseBankSyncRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseBankSyncRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseBankSyncRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseBankSyncRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseBankSyncRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseBankSyncRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseBankSyncRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'userId')  String userId, @JsonKey(name: 'lastSyncTimestamp')  DateTime? lastSyncTimestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseBankSyncRequestDto() when $default != null:
return $default(_that.userId,_that.lastSyncTimestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'userId')  String userId, @JsonKey(name: 'lastSyncTimestamp')  DateTime? lastSyncTimestamp)  $default,) {final _that = this;
switch (_that) {
case _ExerciseBankSyncRequestDto():
return $default(_that.userId,_that.lastSyncTimestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'userId')  String userId, @JsonKey(name: 'lastSyncTimestamp')  DateTime? lastSyncTimestamp)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseBankSyncRequestDto() when $default != null:
return $default(_that.userId,_that.lastSyncTimestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseBankSyncRequestDto implements ExerciseBankSyncRequestDto {
  const _ExerciseBankSyncRequestDto({@JsonKey(name: 'userId') required this.userId, @JsonKey(name: 'lastSyncTimestamp') this.lastSyncTimestamp});
  factory _ExerciseBankSyncRequestDto.fromJson(Map<String, dynamic> json) => _$ExerciseBankSyncRequestDtoFromJson(json);

@override@JsonKey(name: 'userId') final  String userId;
@override@JsonKey(name: 'lastSyncTimestamp') final  DateTime? lastSyncTimestamp;

/// Create a copy of ExerciseBankSyncRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseBankSyncRequestDtoCopyWith<_ExerciseBankSyncRequestDto> get copyWith => __$ExerciseBankSyncRequestDtoCopyWithImpl<_ExerciseBankSyncRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseBankSyncRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseBankSyncRequestDto&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.lastSyncTimestamp, lastSyncTimestamp) || other.lastSyncTimestamp == lastSyncTimestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,lastSyncTimestamp);

@override
String toString() {
  return 'ExerciseBankSyncRequestDto(userId: $userId, lastSyncTimestamp: $lastSyncTimestamp)';
}


}

/// @nodoc
abstract mixin class _$ExerciseBankSyncRequestDtoCopyWith<$Res> implements $ExerciseBankSyncRequestDtoCopyWith<$Res> {
  factory _$ExerciseBankSyncRequestDtoCopyWith(_ExerciseBankSyncRequestDto value, $Res Function(_ExerciseBankSyncRequestDto) _then) = __$ExerciseBankSyncRequestDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'userId') String userId,@JsonKey(name: 'lastSyncTimestamp') DateTime? lastSyncTimestamp
});




}
/// @nodoc
class __$ExerciseBankSyncRequestDtoCopyWithImpl<$Res>
    implements _$ExerciseBankSyncRequestDtoCopyWith<$Res> {
  __$ExerciseBankSyncRequestDtoCopyWithImpl(this._self, this._then);

  final _ExerciseBankSyncRequestDto _self;
  final $Res Function(_ExerciseBankSyncRequestDto) _then;

/// Create a copy of ExerciseBankSyncRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? lastSyncTimestamp = freezed,}) {
  return _then(_ExerciseBankSyncRequestDto(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,lastSyncTimestamp: freezed == lastSyncTimestamp ? _self.lastSyncTimestamp : lastSyncTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
