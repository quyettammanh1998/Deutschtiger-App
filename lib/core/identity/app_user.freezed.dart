// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUser {

 String get id;@JsonKey(name: 'display_name') String get displayName;@JsonKey(name: 'avatar_url') String? get avatarUrl;@JsonKey(name: 'cefr_level') String? get cefrLevel;@JsonKey(name: 'is_premium') bool get isPremium; int get level;@JsonKey(name: 'total_xp') int get totalXp;@JsonKey(name: 'current_streak') int get currentStreak;@JsonKey(name: 'longest_streak') int get longestStreak;@JsonKey(name: 'words_learned') int get wordsLearned;
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserCopyWith<AppUser> get copyWith => _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.cefrLevel, cefrLevel) || other.cefrLevel == cefrLevel)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.level, level) || other.level == level)&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.wordsLearned, wordsLearned) || other.wordsLearned == wordsLearned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,avatarUrl,cefrLevel,isPremium,level,totalXp,currentStreak,longestStreak,wordsLearned);

@override
String toString() {
  return 'AppUser(id: $id, displayName: $displayName, avatarUrl: $avatarUrl, cefrLevel: $cefrLevel, isPremium: $isPremium, level: $level, totalXp: $totalXp, currentStreak: $currentStreak, longestStreak: $longestStreak, wordsLearned: $wordsLearned)';
}


}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res>  {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) = _$AppUserCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'cefr_level') String? cefrLevel,@JsonKey(name: 'is_premium') bool isPremium, int level,@JsonKey(name: 'total_xp') int totalXp,@JsonKey(name: 'current_streak') int currentStreak,@JsonKey(name: 'longest_streak') int longestStreak,@JsonKey(name: 'words_learned') int wordsLearned
});




}
/// @nodoc
class _$AppUserCopyWithImpl<$Res>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? avatarUrl = freezed,Object? cefrLevel = freezed,Object? isPremium = null,Object? level = null,Object? totalXp = null,Object? currentStreak = null,Object? longestStreak = null,Object? wordsLearned = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,cefrLevel: freezed == cefrLevel ? _self.cefrLevel : cefrLevel // ignore: cast_nullable_to_non_nullable
as String?,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,wordsLearned: null == wordsLearned ? _self.wordsLearned : wordsLearned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUser].
extension AppUserPatterns on AppUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUser value)  $default,){
final _that = this;
switch (_that) {
case _AppUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUser value)?  $default,){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'cefr_level')  String? cefrLevel, @JsonKey(name: 'is_premium')  bool isPremium,  int level, @JsonKey(name: 'total_xp')  int totalXp, @JsonKey(name: 'current_streak')  int currentStreak, @JsonKey(name: 'longest_streak')  int longestStreak, @JsonKey(name: 'words_learned')  int wordsLearned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.displayName,_that.avatarUrl,_that.cefrLevel,_that.isPremium,_that.level,_that.totalXp,_that.currentStreak,_that.longestStreak,_that.wordsLearned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'cefr_level')  String? cefrLevel, @JsonKey(name: 'is_premium')  bool isPremium,  int level, @JsonKey(name: 'total_xp')  int totalXp, @JsonKey(name: 'current_streak')  int currentStreak, @JsonKey(name: 'longest_streak')  int longestStreak, @JsonKey(name: 'words_learned')  int wordsLearned)  $default,) {final _that = this;
switch (_that) {
case _AppUser():
return $default(_that.id,_that.displayName,_that.avatarUrl,_that.cefrLevel,_that.isPremium,_that.level,_that.totalXp,_that.currentStreak,_that.longestStreak,_that.wordsLearned);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'cefr_level')  String? cefrLevel, @JsonKey(name: 'is_premium')  bool isPremium,  int level, @JsonKey(name: 'total_xp')  int totalXp, @JsonKey(name: 'current_streak')  int currentStreak, @JsonKey(name: 'longest_streak')  int longestStreak, @JsonKey(name: 'words_learned')  int wordsLearned)?  $default,) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.displayName,_that.avatarUrl,_that.cefrLevel,_that.isPremium,_that.level,_that.totalXp,_that.currentStreak,_that.longestStreak,_that.wordsLearned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUser implements AppUser {
  const _AppUser({required this.id, @JsonKey(name: 'display_name') this.displayName = '', @JsonKey(name: 'avatar_url') this.avatarUrl, @JsonKey(name: 'cefr_level') this.cefrLevel, @JsonKey(name: 'is_premium') this.isPremium = false, this.level = 0, @JsonKey(name: 'total_xp') this.totalXp = 0, @JsonKey(name: 'current_streak') this.currentStreak = 0, @JsonKey(name: 'longest_streak') this.longestStreak = 0, @JsonKey(name: 'words_learned') this.wordsLearned = 0});
  factory _AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

@override final  String id;
@override@JsonKey(name: 'display_name') final  String displayName;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey(name: 'cefr_level') final  String? cefrLevel;
@override@JsonKey(name: 'is_premium') final  bool isPremium;
@override@JsonKey() final  int level;
@override@JsonKey(name: 'total_xp') final  int totalXp;
@override@JsonKey(name: 'current_streak') final  int currentStreak;
@override@JsonKey(name: 'longest_streak') final  int longestStreak;
@override@JsonKey(name: 'words_learned') final  int wordsLearned;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserCopyWith<_AppUser> get copyWith => __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.cefrLevel, cefrLevel) || other.cefrLevel == cefrLevel)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.level, level) || other.level == level)&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.wordsLearned, wordsLearned) || other.wordsLearned == wordsLearned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,avatarUrl,cefrLevel,isPremium,level,totalXp,currentStreak,longestStreak,wordsLearned);

@override
String toString() {
  return 'AppUser(id: $id, displayName: $displayName, avatarUrl: $avatarUrl, cefrLevel: $cefrLevel, isPremium: $isPremium, level: $level, totalXp: $totalXp, currentStreak: $currentStreak, longestStreak: $longestStreak, wordsLearned: $wordsLearned)';
}


}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) = __$AppUserCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'cefr_level') String? cefrLevel,@JsonKey(name: 'is_premium') bool isPremium, int level,@JsonKey(name: 'total_xp') int totalXp,@JsonKey(name: 'current_streak') int currentStreak,@JsonKey(name: 'longest_streak') int longestStreak,@JsonKey(name: 'words_learned') int wordsLearned
});




}
/// @nodoc
class __$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? avatarUrl = freezed,Object? cefrLevel = freezed,Object? isPremium = null,Object? level = null,Object? totalXp = null,Object? currentStreak = null,Object? longestStreak = null,Object? wordsLearned = null,}) {
  return _then(_AppUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,cefrLevel: freezed == cefrLevel ? _self.cefrLevel : cefrLevel // ignore: cast_nullable_to_non_nullable
as String?,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,wordsLearned: null == wordsLearned ? _self.wordsLearned : wordsLearned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
