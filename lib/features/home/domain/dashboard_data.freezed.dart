// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardData {

 Gamification? get gamification; List<Mission> get missions;@JsonKey(name: 'due_review_count') int get dueReviewCount;@JsonKey(name: 'words_learned') int get wordsLearned;@JsonKey(name: 'online_time_today') int get onlineTimeToday;
/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardDataCopyWith<DashboardData> get copyWith => _$DashboardDataCopyWithImpl<DashboardData>(this as DashboardData, _$identity);

  /// Serializes this DashboardData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardData&&(identical(other.gamification, gamification) || other.gamification == gamification)&&const DeepCollectionEquality().equals(other.missions, missions)&&(identical(other.dueReviewCount, dueReviewCount) || other.dueReviewCount == dueReviewCount)&&(identical(other.wordsLearned, wordsLearned) || other.wordsLearned == wordsLearned)&&(identical(other.onlineTimeToday, onlineTimeToday) || other.onlineTimeToday == onlineTimeToday));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gamification,const DeepCollectionEquality().hash(missions),dueReviewCount,wordsLearned,onlineTimeToday);

@override
String toString() {
  return 'DashboardData(gamification: $gamification, missions: $missions, dueReviewCount: $dueReviewCount, wordsLearned: $wordsLearned, onlineTimeToday: $onlineTimeToday)';
}


}

/// @nodoc
abstract mixin class $DashboardDataCopyWith<$Res>  {
  factory $DashboardDataCopyWith(DashboardData value, $Res Function(DashboardData) _then) = _$DashboardDataCopyWithImpl;
@useResult
$Res call({
 Gamification? gamification, List<Mission> missions,@JsonKey(name: 'due_review_count') int dueReviewCount,@JsonKey(name: 'words_learned') int wordsLearned,@JsonKey(name: 'online_time_today') int onlineTimeToday
});


$GamificationCopyWith<$Res>? get gamification;

}
/// @nodoc
class _$DashboardDataCopyWithImpl<$Res>
    implements $DashboardDataCopyWith<$Res> {
  _$DashboardDataCopyWithImpl(this._self, this._then);

  final DashboardData _self;
  final $Res Function(DashboardData) _then;

/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gamification = freezed,Object? missions = null,Object? dueReviewCount = null,Object? wordsLearned = null,Object? onlineTimeToday = null,}) {
  return _then(_self.copyWith(
gamification: freezed == gamification ? _self.gamification : gamification // ignore: cast_nullable_to_non_nullable
as Gamification?,missions: null == missions ? _self.missions : missions // ignore: cast_nullable_to_non_nullable
as List<Mission>,dueReviewCount: null == dueReviewCount ? _self.dueReviewCount : dueReviewCount // ignore: cast_nullable_to_non_nullable
as int,wordsLearned: null == wordsLearned ? _self.wordsLearned : wordsLearned // ignore: cast_nullable_to_non_nullable
as int,onlineTimeToday: null == onlineTimeToday ? _self.onlineTimeToday : onlineTimeToday // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GamificationCopyWith<$Res>? get gamification {
    if (_self.gamification == null) {
    return null;
  }

  return $GamificationCopyWith<$Res>(_self.gamification!, (value) {
    return _then(_self.copyWith(gamification: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardData].
extension DashboardDataPatterns on DashboardData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardData value)  $default,){
final _that = this;
switch (_that) {
case _DashboardData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardData value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Gamification? gamification,  List<Mission> missions, @JsonKey(name: 'due_review_count')  int dueReviewCount, @JsonKey(name: 'words_learned')  int wordsLearned, @JsonKey(name: 'online_time_today')  int onlineTimeToday)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
return $default(_that.gamification,_that.missions,_that.dueReviewCount,_that.wordsLearned,_that.onlineTimeToday);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Gamification? gamification,  List<Mission> missions, @JsonKey(name: 'due_review_count')  int dueReviewCount, @JsonKey(name: 'words_learned')  int wordsLearned, @JsonKey(name: 'online_time_today')  int onlineTimeToday)  $default,) {final _that = this;
switch (_that) {
case _DashboardData():
return $default(_that.gamification,_that.missions,_that.dueReviewCount,_that.wordsLearned,_that.onlineTimeToday);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Gamification? gamification,  List<Mission> missions, @JsonKey(name: 'due_review_count')  int dueReviewCount, @JsonKey(name: 'words_learned')  int wordsLearned, @JsonKey(name: 'online_time_today')  int onlineTimeToday)?  $default,) {final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
return $default(_that.gamification,_that.missions,_that.dueReviewCount,_that.wordsLearned,_that.onlineTimeToday);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardData implements DashboardData {
  const _DashboardData({this.gamification, final  List<Mission> missions = const <Mission>[], @JsonKey(name: 'due_review_count') this.dueReviewCount = 0, @JsonKey(name: 'words_learned') this.wordsLearned = 0, @JsonKey(name: 'online_time_today') this.onlineTimeToday = 0}): _missions = missions;
  factory _DashboardData.fromJson(Map<String, dynamic> json) => _$DashboardDataFromJson(json);

@override final  Gamification? gamification;
 final  List<Mission> _missions;
@override@JsonKey() List<Mission> get missions {
  if (_missions is EqualUnmodifiableListView) return _missions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_missions);
}

@override@JsonKey(name: 'due_review_count') final  int dueReviewCount;
@override@JsonKey(name: 'words_learned') final  int wordsLearned;
@override@JsonKey(name: 'online_time_today') final  int onlineTimeToday;

/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardDataCopyWith<_DashboardData> get copyWith => __$DashboardDataCopyWithImpl<_DashboardData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardData&&(identical(other.gamification, gamification) || other.gamification == gamification)&&const DeepCollectionEquality().equals(other._missions, _missions)&&(identical(other.dueReviewCount, dueReviewCount) || other.dueReviewCount == dueReviewCount)&&(identical(other.wordsLearned, wordsLearned) || other.wordsLearned == wordsLearned)&&(identical(other.onlineTimeToday, onlineTimeToday) || other.onlineTimeToday == onlineTimeToday));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gamification,const DeepCollectionEquality().hash(_missions),dueReviewCount,wordsLearned,onlineTimeToday);

@override
String toString() {
  return 'DashboardData(gamification: $gamification, missions: $missions, dueReviewCount: $dueReviewCount, wordsLearned: $wordsLearned, onlineTimeToday: $onlineTimeToday)';
}


}

/// @nodoc
abstract mixin class _$DashboardDataCopyWith<$Res> implements $DashboardDataCopyWith<$Res> {
  factory _$DashboardDataCopyWith(_DashboardData value, $Res Function(_DashboardData) _then) = __$DashboardDataCopyWithImpl;
@override @useResult
$Res call({
 Gamification? gamification, List<Mission> missions,@JsonKey(name: 'due_review_count') int dueReviewCount,@JsonKey(name: 'words_learned') int wordsLearned,@JsonKey(name: 'online_time_today') int onlineTimeToday
});


@override $GamificationCopyWith<$Res>? get gamification;

}
/// @nodoc
class __$DashboardDataCopyWithImpl<$Res>
    implements _$DashboardDataCopyWith<$Res> {
  __$DashboardDataCopyWithImpl(this._self, this._then);

  final _DashboardData _self;
  final $Res Function(_DashboardData) _then;

/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gamification = freezed,Object? missions = null,Object? dueReviewCount = null,Object? wordsLearned = null,Object? onlineTimeToday = null,}) {
  return _then(_DashboardData(
gamification: freezed == gamification ? _self.gamification : gamification // ignore: cast_nullable_to_non_nullable
as Gamification?,missions: null == missions ? _self._missions : missions // ignore: cast_nullable_to_non_nullable
as List<Mission>,dueReviewCount: null == dueReviewCount ? _self.dueReviewCount : dueReviewCount // ignore: cast_nullable_to_non_nullable
as int,wordsLearned: null == wordsLearned ? _self.wordsLearned : wordsLearned // ignore: cast_nullable_to_non_nullable
as int,onlineTimeToday: null == onlineTimeToday ? _self.onlineTimeToday : onlineTimeToday // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GamificationCopyWith<$Res>? get gamification {
    if (_self.gamification == null) {
    return null;
  }

  return $GamificationCopyWith<$Res>(_self.gamification!, (value) {
    return _then(_self.copyWith(gamification: value));
  });
}
}


/// @nodoc
mixin _$Gamification {

@JsonKey(name: 'total_xp') int get totalXp; int get level;@JsonKey(name: 'current_streak') int get currentStreak;@JsonKey(name: 'longest_streak') int get longestStreak;@JsonKey(name: 'daily_xp_today') int get dailyXpToday;@JsonKey(name: 'daily_goal') int get dailyGoal;
/// Create a copy of Gamification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GamificationCopyWith<Gamification> get copyWith => _$GamificationCopyWithImpl<Gamification>(this as Gamification, _$identity);

  /// Serializes this Gamification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Gamification&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.level, level) || other.level == level)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.dailyXpToday, dailyXpToday) || other.dailyXpToday == dailyXpToday)&&(identical(other.dailyGoal, dailyGoal) || other.dailyGoal == dailyGoal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalXp,level,currentStreak,longestStreak,dailyXpToday,dailyGoal);

@override
String toString() {
  return 'Gamification(totalXp: $totalXp, level: $level, currentStreak: $currentStreak, longestStreak: $longestStreak, dailyXpToday: $dailyXpToday, dailyGoal: $dailyGoal)';
}


}

/// @nodoc
abstract mixin class $GamificationCopyWith<$Res>  {
  factory $GamificationCopyWith(Gamification value, $Res Function(Gamification) _then) = _$GamificationCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_xp') int totalXp, int level,@JsonKey(name: 'current_streak') int currentStreak,@JsonKey(name: 'longest_streak') int longestStreak,@JsonKey(name: 'daily_xp_today') int dailyXpToday,@JsonKey(name: 'daily_goal') int dailyGoal
});




}
/// @nodoc
class _$GamificationCopyWithImpl<$Res>
    implements $GamificationCopyWith<$Res> {
  _$GamificationCopyWithImpl(this._self, this._then);

  final Gamification _self;
  final $Res Function(Gamification) _then;

/// Create a copy of Gamification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalXp = null,Object? level = null,Object? currentStreak = null,Object? longestStreak = null,Object? dailyXpToday = null,Object? dailyGoal = null,}) {
  return _then(_self.copyWith(
totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,dailyXpToday: null == dailyXpToday ? _self.dailyXpToday : dailyXpToday // ignore: cast_nullable_to_non_nullable
as int,dailyGoal: null == dailyGoal ? _self.dailyGoal : dailyGoal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Gamification].
extension GamificationPatterns on Gamification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Gamification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Gamification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Gamification value)  $default,){
final _that = this;
switch (_that) {
case _Gamification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Gamification value)?  $default,){
final _that = this;
switch (_that) {
case _Gamification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_xp')  int totalXp,  int level, @JsonKey(name: 'current_streak')  int currentStreak, @JsonKey(name: 'longest_streak')  int longestStreak, @JsonKey(name: 'daily_xp_today')  int dailyXpToday, @JsonKey(name: 'daily_goal')  int dailyGoal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Gamification() when $default != null:
return $default(_that.totalXp,_that.level,_that.currentStreak,_that.longestStreak,_that.dailyXpToday,_that.dailyGoal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_xp')  int totalXp,  int level, @JsonKey(name: 'current_streak')  int currentStreak, @JsonKey(name: 'longest_streak')  int longestStreak, @JsonKey(name: 'daily_xp_today')  int dailyXpToday, @JsonKey(name: 'daily_goal')  int dailyGoal)  $default,) {final _that = this;
switch (_that) {
case _Gamification():
return $default(_that.totalXp,_that.level,_that.currentStreak,_that.longestStreak,_that.dailyXpToday,_that.dailyGoal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_xp')  int totalXp,  int level, @JsonKey(name: 'current_streak')  int currentStreak, @JsonKey(name: 'longest_streak')  int longestStreak, @JsonKey(name: 'daily_xp_today')  int dailyXpToday, @JsonKey(name: 'daily_goal')  int dailyGoal)?  $default,) {final _that = this;
switch (_that) {
case _Gamification() when $default != null:
return $default(_that.totalXp,_that.level,_that.currentStreak,_that.longestStreak,_that.dailyXpToday,_that.dailyGoal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Gamification implements Gamification {
  const _Gamification({@JsonKey(name: 'total_xp') this.totalXp = 0, this.level = 1, @JsonKey(name: 'current_streak') this.currentStreak = 0, @JsonKey(name: 'longest_streak') this.longestStreak = 0, @JsonKey(name: 'daily_xp_today') this.dailyXpToday = 0, @JsonKey(name: 'daily_goal') this.dailyGoal = 50});
  factory _Gamification.fromJson(Map<String, dynamic> json) => _$GamificationFromJson(json);

@override@JsonKey(name: 'total_xp') final  int totalXp;
@override@JsonKey() final  int level;
@override@JsonKey(name: 'current_streak') final  int currentStreak;
@override@JsonKey(name: 'longest_streak') final  int longestStreak;
@override@JsonKey(name: 'daily_xp_today') final  int dailyXpToday;
@override@JsonKey(name: 'daily_goal') final  int dailyGoal;

/// Create a copy of Gamification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GamificationCopyWith<_Gamification> get copyWith => __$GamificationCopyWithImpl<_Gamification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GamificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Gamification&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.level, level) || other.level == level)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.dailyXpToday, dailyXpToday) || other.dailyXpToday == dailyXpToday)&&(identical(other.dailyGoal, dailyGoal) || other.dailyGoal == dailyGoal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalXp,level,currentStreak,longestStreak,dailyXpToday,dailyGoal);

@override
String toString() {
  return 'Gamification(totalXp: $totalXp, level: $level, currentStreak: $currentStreak, longestStreak: $longestStreak, dailyXpToday: $dailyXpToday, dailyGoal: $dailyGoal)';
}


}

/// @nodoc
abstract mixin class _$GamificationCopyWith<$Res> implements $GamificationCopyWith<$Res> {
  factory _$GamificationCopyWith(_Gamification value, $Res Function(_Gamification) _then) = __$GamificationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_xp') int totalXp, int level,@JsonKey(name: 'current_streak') int currentStreak,@JsonKey(name: 'longest_streak') int longestStreak,@JsonKey(name: 'daily_xp_today') int dailyXpToday,@JsonKey(name: 'daily_goal') int dailyGoal
});




}
/// @nodoc
class __$GamificationCopyWithImpl<$Res>
    implements _$GamificationCopyWith<$Res> {
  __$GamificationCopyWithImpl(this._self, this._then);

  final _Gamification _self;
  final $Res Function(_Gamification) _then;

/// Create a copy of Gamification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalXp = null,Object? level = null,Object? currentStreak = null,Object? longestStreak = null,Object? dailyXpToday = null,Object? dailyGoal = null,}) {
  return _then(_Gamification(
totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,dailyXpToday: null == dailyXpToday ? _self.dailyXpToday : dailyXpToday // ignore: cast_nullable_to_non_nullable
as int,dailyGoal: null == dailyGoal ? _self.dailyGoal : dailyGoal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Mission {

 String get id;@JsonKey(name: 'target_count') int get targetCount;@JsonKey(name: 'current_progress') int get currentProgress;@JsonKey(name: 'xp_reward') int get xpReward;@JsonKey(name: 'title_vi') String get titleVi;@JsonKey(name: 'description_vi') String get descriptionVi; String get icon; String get status;
/// Create a copy of Mission
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionCopyWith<Mission> get copyWith => _$MissionCopyWithImpl<Mission>(this as Mission, _$identity);

  /// Serializes this Mission to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Mission&&(identical(other.id, id) || other.id == id)&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.currentProgress, currentProgress) || other.currentProgress == currentProgress)&&(identical(other.xpReward, xpReward) || other.xpReward == xpReward)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,targetCount,currentProgress,xpReward,titleVi,descriptionVi,icon,status);

@override
String toString() {
  return 'Mission(id: $id, targetCount: $targetCount, currentProgress: $currentProgress, xpReward: $xpReward, titleVi: $titleVi, descriptionVi: $descriptionVi, icon: $icon, status: $status)';
}


}

/// @nodoc
abstract mixin class $MissionCopyWith<$Res>  {
  factory $MissionCopyWith(Mission value, $Res Function(Mission) _then) = _$MissionCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'target_count') int targetCount,@JsonKey(name: 'current_progress') int currentProgress,@JsonKey(name: 'xp_reward') int xpReward,@JsonKey(name: 'title_vi') String titleVi,@JsonKey(name: 'description_vi') String descriptionVi, String icon, String status
});




}
/// @nodoc
class _$MissionCopyWithImpl<$Res>
    implements $MissionCopyWith<$Res> {
  _$MissionCopyWithImpl(this._self, this._then);

  final Mission _self;
  final $Res Function(Mission) _then;

/// Create a copy of Mission
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? targetCount = null,Object? currentProgress = null,Object? xpReward = null,Object? titleVi = null,Object? descriptionVi = null,Object? icon = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,targetCount: null == targetCount ? _self.targetCount : targetCount // ignore: cast_nullable_to_non_nullable
as int,currentProgress: null == currentProgress ? _self.currentProgress : currentProgress // ignore: cast_nullable_to_non_nullable
as int,xpReward: null == xpReward ? _self.xpReward : xpReward // ignore: cast_nullable_to_non_nullable
as int,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Mission].
extension MissionPatterns on Mission {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Mission value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Mission() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Mission value)  $default,){
final _that = this;
switch (_that) {
case _Mission():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Mission value)?  $default,){
final _that = this;
switch (_that) {
case _Mission() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'target_count')  int targetCount, @JsonKey(name: 'current_progress')  int currentProgress, @JsonKey(name: 'xp_reward')  int xpReward, @JsonKey(name: 'title_vi')  String titleVi, @JsonKey(name: 'description_vi')  String descriptionVi,  String icon,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Mission() when $default != null:
return $default(_that.id,_that.targetCount,_that.currentProgress,_that.xpReward,_that.titleVi,_that.descriptionVi,_that.icon,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'target_count')  int targetCount, @JsonKey(name: 'current_progress')  int currentProgress, @JsonKey(name: 'xp_reward')  int xpReward, @JsonKey(name: 'title_vi')  String titleVi, @JsonKey(name: 'description_vi')  String descriptionVi,  String icon,  String status)  $default,) {final _that = this;
switch (_that) {
case _Mission():
return $default(_that.id,_that.targetCount,_that.currentProgress,_that.xpReward,_that.titleVi,_that.descriptionVi,_that.icon,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'target_count')  int targetCount, @JsonKey(name: 'current_progress')  int currentProgress, @JsonKey(name: 'xp_reward')  int xpReward, @JsonKey(name: 'title_vi')  String titleVi, @JsonKey(name: 'description_vi')  String descriptionVi,  String icon,  String status)?  $default,) {final _that = this;
switch (_that) {
case _Mission() when $default != null:
return $default(_that.id,_that.targetCount,_that.currentProgress,_that.xpReward,_that.titleVi,_that.descriptionVi,_that.icon,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Mission extends Mission {
  const _Mission({required this.id, @JsonKey(name: 'target_count') this.targetCount = 1, @JsonKey(name: 'current_progress') this.currentProgress = 0, @JsonKey(name: 'xp_reward') this.xpReward = 0, @JsonKey(name: 'title_vi') this.titleVi = '', @JsonKey(name: 'description_vi') this.descriptionVi = '', this.icon = '', this.status = 'active'}): super._();
  factory _Mission.fromJson(Map<String, dynamic> json) => _$MissionFromJson(json);

@override final  String id;
@override@JsonKey(name: 'target_count') final  int targetCount;
@override@JsonKey(name: 'current_progress') final  int currentProgress;
@override@JsonKey(name: 'xp_reward') final  int xpReward;
@override@JsonKey(name: 'title_vi') final  String titleVi;
@override@JsonKey(name: 'description_vi') final  String descriptionVi;
@override@JsonKey() final  String icon;
@override@JsonKey() final  String status;

/// Create a copy of Mission
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionCopyWith<_Mission> get copyWith => __$MissionCopyWithImpl<_Mission>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Mission&&(identical(other.id, id) || other.id == id)&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.currentProgress, currentProgress) || other.currentProgress == currentProgress)&&(identical(other.xpReward, xpReward) || other.xpReward == xpReward)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,targetCount,currentProgress,xpReward,titleVi,descriptionVi,icon,status);

@override
String toString() {
  return 'Mission(id: $id, targetCount: $targetCount, currentProgress: $currentProgress, xpReward: $xpReward, titleVi: $titleVi, descriptionVi: $descriptionVi, icon: $icon, status: $status)';
}


}

/// @nodoc
abstract mixin class _$MissionCopyWith<$Res> implements $MissionCopyWith<$Res> {
  factory _$MissionCopyWith(_Mission value, $Res Function(_Mission) _then) = __$MissionCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'target_count') int targetCount,@JsonKey(name: 'current_progress') int currentProgress,@JsonKey(name: 'xp_reward') int xpReward,@JsonKey(name: 'title_vi') String titleVi,@JsonKey(name: 'description_vi') String descriptionVi, String icon, String status
});




}
/// @nodoc
class __$MissionCopyWithImpl<$Res>
    implements _$MissionCopyWith<$Res> {
  __$MissionCopyWithImpl(this._self, this._then);

  final _Mission _self;
  final $Res Function(_Mission) _then;

/// Create a copy of Mission
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? targetCount = null,Object? currentProgress = null,Object? xpReward = null,Object? titleVi = null,Object? descriptionVi = null,Object? icon = null,Object? status = null,}) {
  return _then(_Mission(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,targetCount: null == targetCount ? _self.targetCount : targetCount // ignore: cast_nullable_to_non_nullable
as int,currentProgress: null == currentProgress ? _self.currentProgress : currentProgress // ignore: cast_nullable_to_non_nullable
as int,xpReward: null == xpReward ? _self.xpReward : xpReward // ignore: cast_nullable_to_non_nullable
as int,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
