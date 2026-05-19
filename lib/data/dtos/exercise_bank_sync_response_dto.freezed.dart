// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_bank_sync_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExerciseBankSyncResponseDto {

@JsonKey(name: 'serverTimestamp') DateTime get serverTimestamp; List<Map<String, dynamic>> get updates; List<String> get deletes;
/// Create a copy of ExerciseBankSyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseBankSyncResponseDtoCopyWith<ExerciseBankSyncResponseDto> get copyWith => _$ExerciseBankSyncResponseDtoCopyWithImpl<ExerciseBankSyncResponseDto>(this as ExerciseBankSyncResponseDto, _$identity);

  /// Serializes this ExerciseBankSyncResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseBankSyncResponseDto&&(identical(other.serverTimestamp, serverTimestamp) || other.serverTimestamp == serverTimestamp)&&const DeepCollectionEquality().equals(other.updates, updates)&&const DeepCollectionEquality().equals(other.deletes, deletes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,serverTimestamp,const DeepCollectionEquality().hash(updates),const DeepCollectionEquality().hash(deletes));

@override
String toString() {
  return 'ExerciseBankSyncResponseDto(serverTimestamp: $serverTimestamp, updates: $updates, deletes: $deletes)';
}


}

/// @nodoc
abstract mixin class $ExerciseBankSyncResponseDtoCopyWith<$Res>  {
  factory $ExerciseBankSyncResponseDtoCopyWith(ExerciseBankSyncResponseDto value, $Res Function(ExerciseBankSyncResponseDto) _then) = _$ExerciseBankSyncResponseDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'serverTimestamp') DateTime serverTimestamp, List<Map<String, dynamic>> updates, List<String> deletes
});




}
/// @nodoc
class _$ExerciseBankSyncResponseDtoCopyWithImpl<$Res>
    implements $ExerciseBankSyncResponseDtoCopyWith<$Res> {
  _$ExerciseBankSyncResponseDtoCopyWithImpl(this._self, this._then);

  final ExerciseBankSyncResponseDto _self;
  final $Res Function(ExerciseBankSyncResponseDto) _then;

/// Create a copy of ExerciseBankSyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serverTimestamp = null,Object? updates = null,Object? deletes = null,}) {
  return _then(_self.copyWith(
serverTimestamp: null == serverTimestamp ? _self.serverTimestamp : serverTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,updates: null == updates ? _self.updates : updates // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,deletes: null == deletes ? _self.deletes : deletes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseBankSyncResponseDto].
extension ExerciseBankSyncResponseDtoPatterns on ExerciseBankSyncResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseBankSyncResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseBankSyncResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseBankSyncResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseBankSyncResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseBankSyncResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseBankSyncResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'serverTimestamp')  DateTime serverTimestamp,  List<Map<String, dynamic>> updates,  List<String> deletes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseBankSyncResponseDto() when $default != null:
return $default(_that.serverTimestamp,_that.updates,_that.deletes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'serverTimestamp')  DateTime serverTimestamp,  List<Map<String, dynamic>> updates,  List<String> deletes)  $default,) {final _that = this;
switch (_that) {
case _ExerciseBankSyncResponseDto():
return $default(_that.serverTimestamp,_that.updates,_that.deletes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'serverTimestamp')  DateTime serverTimestamp,  List<Map<String, dynamic>> updates,  List<String> deletes)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseBankSyncResponseDto() when $default != null:
return $default(_that.serverTimestamp,_that.updates,_that.deletes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExerciseBankSyncResponseDto implements ExerciseBankSyncResponseDto {
  const _ExerciseBankSyncResponseDto({@JsonKey(name: 'serverTimestamp') required this.serverTimestamp, required final  List<Map<String, dynamic>> updates, required final  List<String> deletes}): _updates = updates,_deletes = deletes;
  factory _ExerciseBankSyncResponseDto.fromJson(Map<String, dynamic> json) => _$ExerciseBankSyncResponseDtoFromJson(json);

@override@JsonKey(name: 'serverTimestamp') final  DateTime serverTimestamp;
 final  List<Map<String, dynamic>> _updates;
@override List<Map<String, dynamic>> get updates {
  if (_updates is EqualUnmodifiableListView) return _updates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_updates);
}

 final  List<String> _deletes;
@override List<String> get deletes {
  if (_deletes is EqualUnmodifiableListView) return _deletes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deletes);
}


/// Create a copy of ExerciseBankSyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseBankSyncResponseDtoCopyWith<_ExerciseBankSyncResponseDto> get copyWith => __$ExerciseBankSyncResponseDtoCopyWithImpl<_ExerciseBankSyncResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExerciseBankSyncResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseBankSyncResponseDto&&(identical(other.serverTimestamp, serverTimestamp) || other.serverTimestamp == serverTimestamp)&&const DeepCollectionEquality().equals(other._updates, _updates)&&const DeepCollectionEquality().equals(other._deletes, _deletes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,serverTimestamp,const DeepCollectionEquality().hash(_updates),const DeepCollectionEquality().hash(_deletes));

@override
String toString() {
  return 'ExerciseBankSyncResponseDto(serverTimestamp: $serverTimestamp, updates: $updates, deletes: $deletes)';
}


}

/// @nodoc
abstract mixin class _$ExerciseBankSyncResponseDtoCopyWith<$Res> implements $ExerciseBankSyncResponseDtoCopyWith<$Res> {
  factory _$ExerciseBankSyncResponseDtoCopyWith(_ExerciseBankSyncResponseDto value, $Res Function(_ExerciseBankSyncResponseDto) _then) = __$ExerciseBankSyncResponseDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'serverTimestamp') DateTime serverTimestamp, List<Map<String, dynamic>> updates, List<String> deletes
});




}
/// @nodoc
class __$ExerciseBankSyncResponseDtoCopyWithImpl<$Res>
    implements _$ExerciseBankSyncResponseDtoCopyWith<$Res> {
  __$ExerciseBankSyncResponseDtoCopyWithImpl(this._self, this._then);

  final _ExerciseBankSyncResponseDto _self;
  final $Res Function(_ExerciseBankSyncResponseDto) _then;

/// Create a copy of ExerciseBankSyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serverTimestamp = null,Object? updates = null,Object? deletes = null,}) {
  return _then(_ExerciseBankSyncResponseDto(
serverTimestamp: null == serverTimestamp ? _self.serverTimestamp : serverTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,updates: null == updates ? _self._updates : updates // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,deletes: null == deletes ? _self._deletes : deletes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
