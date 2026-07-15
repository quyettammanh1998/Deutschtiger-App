// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stats_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReviewStats {

@JsonKey(name: 'total_reviews') int get totalReviews;@JsonKey(name: 'words_learned') int get wordsLearned;
/// Create a copy of ReviewStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewStatsCopyWith<ReviewStats> get copyWith => _$ReviewStatsCopyWithImpl<ReviewStats>(this as ReviewStats, _$identity);

  /// Serializes this ReviewStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewStats&&(identical(other.totalReviews, totalReviews) || other.totalReviews == totalReviews)&&(identical(other.wordsLearned, wordsLearned) || other.wordsLearned == wordsLearned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalReviews,wordsLearned);

@override
String toString() {
  return 'ReviewStats(totalReviews: $totalReviews, wordsLearned: $wordsLearned)';
}


}

/// @nodoc
abstract mixin class $ReviewStatsCopyWith<$Res>  {
  factory $ReviewStatsCopyWith(ReviewStats value, $Res Function(ReviewStats) _then) = _$ReviewStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_reviews') int totalReviews,@JsonKey(name: 'words_learned') int wordsLearned
});




}
/// @nodoc
class _$ReviewStatsCopyWithImpl<$Res>
    implements $ReviewStatsCopyWith<$Res> {
  _$ReviewStatsCopyWithImpl(this._self, this._then);

  final ReviewStats _self;
  final $Res Function(ReviewStats) _then;

/// Create a copy of ReviewStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalReviews = null,Object? wordsLearned = null,}) {
  return _then(_self.copyWith(
totalReviews: null == totalReviews ? _self.totalReviews : totalReviews // ignore: cast_nullable_to_non_nullable
as int,wordsLearned: null == wordsLearned ? _self.wordsLearned : wordsLearned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewStats].
extension ReviewStatsPatterns on ReviewStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewStats value)  $default,){
final _that = this;
switch (_that) {
case _ReviewStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewStats value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_reviews')  int totalReviews, @JsonKey(name: 'words_learned')  int wordsLearned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewStats() when $default != null:
return $default(_that.totalReviews,_that.wordsLearned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_reviews')  int totalReviews, @JsonKey(name: 'words_learned')  int wordsLearned)  $default,) {final _that = this;
switch (_that) {
case _ReviewStats():
return $default(_that.totalReviews,_that.wordsLearned);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_reviews')  int totalReviews, @JsonKey(name: 'words_learned')  int wordsLearned)?  $default,) {final _that = this;
switch (_that) {
case _ReviewStats() when $default != null:
return $default(_that.totalReviews,_that.wordsLearned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewStats implements ReviewStats {
  const _ReviewStats({@JsonKey(name: 'total_reviews') this.totalReviews = 0, @JsonKey(name: 'words_learned') this.wordsLearned = 0});
  factory _ReviewStats.fromJson(Map<String, dynamic> json) => _$ReviewStatsFromJson(json);

@override@JsonKey(name: 'total_reviews') final  int totalReviews;
@override@JsonKey(name: 'words_learned') final  int wordsLearned;

/// Create a copy of ReviewStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewStatsCopyWith<_ReviewStats> get copyWith => __$ReviewStatsCopyWithImpl<_ReviewStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewStats&&(identical(other.totalReviews, totalReviews) || other.totalReviews == totalReviews)&&(identical(other.wordsLearned, wordsLearned) || other.wordsLearned == wordsLearned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalReviews,wordsLearned);

@override
String toString() {
  return 'ReviewStats(totalReviews: $totalReviews, wordsLearned: $wordsLearned)';
}


}

/// @nodoc
abstract mixin class _$ReviewStatsCopyWith<$Res> implements $ReviewStatsCopyWith<$Res> {
  factory _$ReviewStatsCopyWith(_ReviewStats value, $Res Function(_ReviewStats) _then) = __$ReviewStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_reviews') int totalReviews,@JsonKey(name: 'words_learned') int wordsLearned
});




}
/// @nodoc
class __$ReviewStatsCopyWithImpl<$Res>
    implements _$ReviewStatsCopyWith<$Res> {
  __$ReviewStatsCopyWithImpl(this._self, this._then);

  final _ReviewStats _self;
  final $Res Function(_ReviewStats) _then;

/// Create a copy of ReviewStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalReviews = null,Object? wordsLearned = null,}) {
  return _then(_ReviewStats(
totalReviews: null == totalReviews ? _self.totalReviews : totalReviews // ignore: cast_nullable_to_non_nullable
as int,wordsLearned: null == wordsLearned ? _self.wordsLearned : wordsLearned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$XpDailyLogEntry {

@JsonKey(name: 'log_date') DateTime get logDate;@JsonKey(name: 'xp_earned') int get xpEarned;
/// Create a copy of XpDailyLogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$XpDailyLogEntryCopyWith<XpDailyLogEntry> get copyWith => _$XpDailyLogEntryCopyWithImpl<XpDailyLogEntry>(this as XpDailyLogEntry, _$identity);

  /// Serializes this XpDailyLogEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is XpDailyLogEntry&&(identical(other.logDate, logDate) || other.logDate == logDate)&&(identical(other.xpEarned, xpEarned) || other.xpEarned == xpEarned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,logDate,xpEarned);

@override
String toString() {
  return 'XpDailyLogEntry(logDate: $logDate, xpEarned: $xpEarned)';
}


}

/// @nodoc
abstract mixin class $XpDailyLogEntryCopyWith<$Res>  {
  factory $XpDailyLogEntryCopyWith(XpDailyLogEntry value, $Res Function(XpDailyLogEntry) _then) = _$XpDailyLogEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'log_date') DateTime logDate,@JsonKey(name: 'xp_earned') int xpEarned
});




}
/// @nodoc
class _$XpDailyLogEntryCopyWithImpl<$Res>
    implements $XpDailyLogEntryCopyWith<$Res> {
  _$XpDailyLogEntryCopyWithImpl(this._self, this._then);

  final XpDailyLogEntry _self;
  final $Res Function(XpDailyLogEntry) _then;

/// Create a copy of XpDailyLogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? logDate = null,Object? xpEarned = null,}) {
  return _then(_self.copyWith(
logDate: null == logDate ? _self.logDate : logDate // ignore: cast_nullable_to_non_nullable
as DateTime,xpEarned: null == xpEarned ? _self.xpEarned : xpEarned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [XpDailyLogEntry].
extension XpDailyLogEntryPatterns on XpDailyLogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _XpDailyLogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _XpDailyLogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _XpDailyLogEntry value)  $default,){
final _that = this;
switch (_that) {
case _XpDailyLogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _XpDailyLogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _XpDailyLogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'log_date')  DateTime logDate, @JsonKey(name: 'xp_earned')  int xpEarned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _XpDailyLogEntry() when $default != null:
return $default(_that.logDate,_that.xpEarned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'log_date')  DateTime logDate, @JsonKey(name: 'xp_earned')  int xpEarned)  $default,) {final _that = this;
switch (_that) {
case _XpDailyLogEntry():
return $default(_that.logDate,_that.xpEarned);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'log_date')  DateTime logDate, @JsonKey(name: 'xp_earned')  int xpEarned)?  $default,) {final _that = this;
switch (_that) {
case _XpDailyLogEntry() when $default != null:
return $default(_that.logDate,_that.xpEarned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _XpDailyLogEntry implements XpDailyLogEntry {
  const _XpDailyLogEntry({@JsonKey(name: 'log_date') required this.logDate, @JsonKey(name: 'xp_earned') this.xpEarned = 0});
  factory _XpDailyLogEntry.fromJson(Map<String, dynamic> json) => _$XpDailyLogEntryFromJson(json);

@override@JsonKey(name: 'log_date') final  DateTime logDate;
@override@JsonKey(name: 'xp_earned') final  int xpEarned;

/// Create a copy of XpDailyLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$XpDailyLogEntryCopyWith<_XpDailyLogEntry> get copyWith => __$XpDailyLogEntryCopyWithImpl<_XpDailyLogEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$XpDailyLogEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _XpDailyLogEntry&&(identical(other.logDate, logDate) || other.logDate == logDate)&&(identical(other.xpEarned, xpEarned) || other.xpEarned == xpEarned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,logDate,xpEarned);

@override
String toString() {
  return 'XpDailyLogEntry(logDate: $logDate, xpEarned: $xpEarned)';
}


}

/// @nodoc
abstract mixin class _$XpDailyLogEntryCopyWith<$Res> implements $XpDailyLogEntryCopyWith<$Res> {
  factory _$XpDailyLogEntryCopyWith(_XpDailyLogEntry value, $Res Function(_XpDailyLogEntry) _then) = __$XpDailyLogEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'log_date') DateTime logDate,@JsonKey(name: 'xp_earned') int xpEarned
});




}
/// @nodoc
class __$XpDailyLogEntryCopyWithImpl<$Res>
    implements _$XpDailyLogEntryCopyWith<$Res> {
  __$XpDailyLogEntryCopyWithImpl(this._self, this._then);

  final _XpDailyLogEntry _self;
  final $Res Function(_XpDailyLogEntry) _then;

/// Create a copy of XpDailyLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? logDate = null,Object? xpEarned = null,}) {
  return _then(_XpDailyLogEntry(
logDate: null == logDate ? _self.logDate : logDate // ignore: cast_nullable_to_non_nullable
as DateTime,xpEarned: null == xpEarned ? _self.xpEarned : xpEarned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MasterySummary {

@JsonKey(name: 'new') int get newCount; int get learning; int get young; int get mature; int get total;
/// Create a copy of MasterySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MasterySummaryCopyWith<MasterySummary> get copyWith => _$MasterySummaryCopyWithImpl<MasterySummary>(this as MasterySummary, _$identity);

  /// Serializes this MasterySummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MasterySummary&&(identical(other.newCount, newCount) || other.newCount == newCount)&&(identical(other.learning, learning) || other.learning == learning)&&(identical(other.young, young) || other.young == young)&&(identical(other.mature, mature) || other.mature == mature)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,newCount,learning,young,mature,total);

@override
String toString() {
  return 'MasterySummary(newCount: $newCount, learning: $learning, young: $young, mature: $mature, total: $total)';
}


}

/// @nodoc
abstract mixin class $MasterySummaryCopyWith<$Res>  {
  factory $MasterySummaryCopyWith(MasterySummary value, $Res Function(MasterySummary) _then) = _$MasterySummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'new') int newCount, int learning, int young, int mature, int total
});




}
/// @nodoc
class _$MasterySummaryCopyWithImpl<$Res>
    implements $MasterySummaryCopyWith<$Res> {
  _$MasterySummaryCopyWithImpl(this._self, this._then);

  final MasterySummary _self;
  final $Res Function(MasterySummary) _then;

/// Create a copy of MasterySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? newCount = null,Object? learning = null,Object? young = null,Object? mature = null,Object? total = null,}) {
  return _then(_self.copyWith(
newCount: null == newCount ? _self.newCount : newCount // ignore: cast_nullable_to_non_nullable
as int,learning: null == learning ? _self.learning : learning // ignore: cast_nullable_to_non_nullable
as int,young: null == young ? _self.young : young // ignore: cast_nullable_to_non_nullable
as int,mature: null == mature ? _self.mature : mature // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MasterySummary].
extension MasterySummaryPatterns on MasterySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MasterySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MasterySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MasterySummary value)  $default,){
final _that = this;
switch (_that) {
case _MasterySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MasterySummary value)?  $default,){
final _that = this;
switch (_that) {
case _MasterySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'new')  int newCount,  int learning,  int young,  int mature,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MasterySummary() when $default != null:
return $default(_that.newCount,_that.learning,_that.young,_that.mature,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'new')  int newCount,  int learning,  int young,  int mature,  int total)  $default,) {final _that = this;
switch (_that) {
case _MasterySummary():
return $default(_that.newCount,_that.learning,_that.young,_that.mature,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'new')  int newCount,  int learning,  int young,  int mature,  int total)?  $default,) {final _that = this;
switch (_that) {
case _MasterySummary() when $default != null:
return $default(_that.newCount,_that.learning,_that.young,_that.mature,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MasterySummary implements MasterySummary {
  const _MasterySummary({@JsonKey(name: 'new') this.newCount = 0, this.learning = 0, this.young = 0, this.mature = 0, this.total = 0});
  factory _MasterySummary.fromJson(Map<String, dynamic> json) => _$MasterySummaryFromJson(json);

@override@JsonKey(name: 'new') final  int newCount;
@override@JsonKey() final  int learning;
@override@JsonKey() final  int young;
@override@JsonKey() final  int mature;
@override@JsonKey() final  int total;

/// Create a copy of MasterySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MasterySummaryCopyWith<_MasterySummary> get copyWith => __$MasterySummaryCopyWithImpl<_MasterySummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MasterySummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MasterySummary&&(identical(other.newCount, newCount) || other.newCount == newCount)&&(identical(other.learning, learning) || other.learning == learning)&&(identical(other.young, young) || other.young == young)&&(identical(other.mature, mature) || other.mature == mature)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,newCount,learning,young,mature,total);

@override
String toString() {
  return 'MasterySummary(newCount: $newCount, learning: $learning, young: $young, mature: $mature, total: $total)';
}


}

/// @nodoc
abstract mixin class _$MasterySummaryCopyWith<$Res> implements $MasterySummaryCopyWith<$Res> {
  factory _$MasterySummaryCopyWith(_MasterySummary value, $Res Function(_MasterySummary) _then) = __$MasterySummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'new') int newCount, int learning, int young, int mature, int total
});




}
/// @nodoc
class __$MasterySummaryCopyWithImpl<$Res>
    implements _$MasterySummaryCopyWith<$Res> {
  __$MasterySummaryCopyWithImpl(this._self, this._then);

  final _MasterySummary _self;
  final $Res Function(_MasterySummary) _then;

/// Create a copy of MasterySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? newCount = null,Object? learning = null,Object? young = null,Object? mature = null,Object? total = null,}) {
  return _then(_MasterySummary(
newCount: null == newCount ? _self.newCount : newCount // ignore: cast_nullable_to_non_nullable
as int,learning: null == learning ? _self.learning : learning // ignore: cast_nullable_to_non_nullable
as int,young: null == young ? _self.young : young // ignore: cast_nullable_to_non_nullable
as int,mature: null == mature ? _self.mature : mature // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SrsDailyStat {

 String get date;@JsonKey(name: 'reviews_count') int get reviewsCount;@JsonKey(name: 'retention_rate') double? get retentionRate; int get lapses;@JsonKey(name: 'new_cards_added') int get newCardsAdded;
/// Create a copy of SrsDailyStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SrsDailyStatCopyWith<SrsDailyStat> get copyWith => _$SrsDailyStatCopyWithImpl<SrsDailyStat>(this as SrsDailyStat, _$identity);

  /// Serializes this SrsDailyStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SrsDailyStat&&(identical(other.date, date) || other.date == date)&&(identical(other.reviewsCount, reviewsCount) || other.reviewsCount == reviewsCount)&&(identical(other.retentionRate, retentionRate) || other.retentionRate == retentionRate)&&(identical(other.lapses, lapses) || other.lapses == lapses)&&(identical(other.newCardsAdded, newCardsAdded) || other.newCardsAdded == newCardsAdded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,reviewsCount,retentionRate,lapses,newCardsAdded);

@override
String toString() {
  return 'SrsDailyStat(date: $date, reviewsCount: $reviewsCount, retentionRate: $retentionRate, lapses: $lapses, newCardsAdded: $newCardsAdded)';
}


}

/// @nodoc
abstract mixin class $SrsDailyStatCopyWith<$Res>  {
  factory $SrsDailyStatCopyWith(SrsDailyStat value, $Res Function(SrsDailyStat) _then) = _$SrsDailyStatCopyWithImpl;
@useResult
$Res call({
 String date,@JsonKey(name: 'reviews_count') int reviewsCount,@JsonKey(name: 'retention_rate') double? retentionRate, int lapses,@JsonKey(name: 'new_cards_added') int newCardsAdded
});




}
/// @nodoc
class _$SrsDailyStatCopyWithImpl<$Res>
    implements $SrsDailyStatCopyWith<$Res> {
  _$SrsDailyStatCopyWithImpl(this._self, this._then);

  final SrsDailyStat _self;
  final $Res Function(SrsDailyStat) _then;

/// Create a copy of SrsDailyStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? reviewsCount = null,Object? retentionRate = freezed,Object? lapses = null,Object? newCardsAdded = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,reviewsCount: null == reviewsCount ? _self.reviewsCount : reviewsCount // ignore: cast_nullable_to_non_nullable
as int,retentionRate: freezed == retentionRate ? _self.retentionRate : retentionRate // ignore: cast_nullable_to_non_nullable
as double?,lapses: null == lapses ? _self.lapses : lapses // ignore: cast_nullable_to_non_nullable
as int,newCardsAdded: null == newCardsAdded ? _self.newCardsAdded : newCardsAdded // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SrsDailyStat].
extension SrsDailyStatPatterns on SrsDailyStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SrsDailyStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SrsDailyStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SrsDailyStat value)  $default,){
final _that = this;
switch (_that) {
case _SrsDailyStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SrsDailyStat value)?  $default,){
final _that = this;
switch (_that) {
case _SrsDailyStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date, @JsonKey(name: 'reviews_count')  int reviewsCount, @JsonKey(name: 'retention_rate')  double? retentionRate,  int lapses, @JsonKey(name: 'new_cards_added')  int newCardsAdded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SrsDailyStat() when $default != null:
return $default(_that.date,_that.reviewsCount,_that.retentionRate,_that.lapses,_that.newCardsAdded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date, @JsonKey(name: 'reviews_count')  int reviewsCount, @JsonKey(name: 'retention_rate')  double? retentionRate,  int lapses, @JsonKey(name: 'new_cards_added')  int newCardsAdded)  $default,) {final _that = this;
switch (_that) {
case _SrsDailyStat():
return $default(_that.date,_that.reviewsCount,_that.retentionRate,_that.lapses,_that.newCardsAdded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date, @JsonKey(name: 'reviews_count')  int reviewsCount, @JsonKey(name: 'retention_rate')  double? retentionRate,  int lapses, @JsonKey(name: 'new_cards_added')  int newCardsAdded)?  $default,) {final _that = this;
switch (_that) {
case _SrsDailyStat() when $default != null:
return $default(_that.date,_that.reviewsCount,_that.retentionRate,_that.lapses,_that.newCardsAdded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SrsDailyStat implements SrsDailyStat {
  const _SrsDailyStat({required this.date, @JsonKey(name: 'reviews_count') this.reviewsCount = 0, @JsonKey(name: 'retention_rate') this.retentionRate, this.lapses = 0, @JsonKey(name: 'new_cards_added') this.newCardsAdded = 0});
  factory _SrsDailyStat.fromJson(Map<String, dynamic> json) => _$SrsDailyStatFromJson(json);

@override final  String date;
@override@JsonKey(name: 'reviews_count') final  int reviewsCount;
@override@JsonKey(name: 'retention_rate') final  double? retentionRate;
@override@JsonKey() final  int lapses;
@override@JsonKey(name: 'new_cards_added') final  int newCardsAdded;

/// Create a copy of SrsDailyStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SrsDailyStatCopyWith<_SrsDailyStat> get copyWith => __$SrsDailyStatCopyWithImpl<_SrsDailyStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SrsDailyStatToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SrsDailyStat&&(identical(other.date, date) || other.date == date)&&(identical(other.reviewsCount, reviewsCount) || other.reviewsCount == reviewsCount)&&(identical(other.retentionRate, retentionRate) || other.retentionRate == retentionRate)&&(identical(other.lapses, lapses) || other.lapses == lapses)&&(identical(other.newCardsAdded, newCardsAdded) || other.newCardsAdded == newCardsAdded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,reviewsCount,retentionRate,lapses,newCardsAdded);

@override
String toString() {
  return 'SrsDailyStat(date: $date, reviewsCount: $reviewsCount, retentionRate: $retentionRate, lapses: $lapses, newCardsAdded: $newCardsAdded)';
}


}

/// @nodoc
abstract mixin class _$SrsDailyStatCopyWith<$Res> implements $SrsDailyStatCopyWith<$Res> {
  factory _$SrsDailyStatCopyWith(_SrsDailyStat value, $Res Function(_SrsDailyStat) _then) = __$SrsDailyStatCopyWithImpl;
@override @useResult
$Res call({
 String date,@JsonKey(name: 'reviews_count') int reviewsCount,@JsonKey(name: 'retention_rate') double? retentionRate, int lapses,@JsonKey(name: 'new_cards_added') int newCardsAdded
});




}
/// @nodoc
class __$SrsDailyStatCopyWithImpl<$Res>
    implements _$SrsDailyStatCopyWith<$Res> {
  __$SrsDailyStatCopyWithImpl(this._self, this._then);

  final _SrsDailyStat _self;
  final $Res Function(_SrsDailyStat) _then;

/// Create a copy of SrsDailyStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? reviewsCount = null,Object? retentionRate = freezed,Object? lapses = null,Object? newCardsAdded = null,}) {
  return _then(_SrsDailyStat(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,reviewsCount: null == reviewsCount ? _self.reviewsCount : reviewsCount // ignore: cast_nullable_to_non_nullable
as int,retentionRate: freezed == retentionRate ? _self.retentionRate : retentionRate // ignore: cast_nullable_to_non_nullable
as double?,lapses: null == lapses ? _self.lapses : lapses // ignore: cast_nullable_to_non_nullable
as int,newCardsAdded: null == newCardsAdded ? _self.newCardsAdded : newCardsAdded // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ErrorPatternSummary {

@JsonKey(name: 'error_type') String get errorType;@JsonKey(name: 'total_count') int get totalCount;@JsonKey(name: 'last_seen') DateTime? get lastSeen;@JsonKey(name: 'example_original') String? get exampleOriginal;@JsonKey(name: 'example_corrected') String? get exampleCorrected; List<String> get sources;
/// Create a copy of ErrorPatternSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorPatternSummaryCopyWith<ErrorPatternSummary> get copyWith => _$ErrorPatternSummaryCopyWithImpl<ErrorPatternSummary>(this as ErrorPatternSummary, _$identity);

  /// Serializes this ErrorPatternSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorPatternSummary&&(identical(other.errorType, errorType) || other.errorType == errorType)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen)&&(identical(other.exampleOriginal, exampleOriginal) || other.exampleOriginal == exampleOriginal)&&(identical(other.exampleCorrected, exampleCorrected) || other.exampleCorrected == exampleCorrected)&&const DeepCollectionEquality().equals(other.sources, sources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,errorType,totalCount,lastSeen,exampleOriginal,exampleCorrected,const DeepCollectionEquality().hash(sources));

@override
String toString() {
  return 'ErrorPatternSummary(errorType: $errorType, totalCount: $totalCount, lastSeen: $lastSeen, exampleOriginal: $exampleOriginal, exampleCorrected: $exampleCorrected, sources: $sources)';
}


}

/// @nodoc
abstract mixin class $ErrorPatternSummaryCopyWith<$Res>  {
  factory $ErrorPatternSummaryCopyWith(ErrorPatternSummary value, $Res Function(ErrorPatternSummary) _then) = _$ErrorPatternSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'error_type') String errorType,@JsonKey(name: 'total_count') int totalCount,@JsonKey(name: 'last_seen') DateTime? lastSeen,@JsonKey(name: 'example_original') String? exampleOriginal,@JsonKey(name: 'example_corrected') String? exampleCorrected, List<String> sources
});




}
/// @nodoc
class _$ErrorPatternSummaryCopyWithImpl<$Res>
    implements $ErrorPatternSummaryCopyWith<$Res> {
  _$ErrorPatternSummaryCopyWithImpl(this._self, this._then);

  final ErrorPatternSummary _self;
  final $Res Function(ErrorPatternSummary) _then;

/// Create a copy of ErrorPatternSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? errorType = null,Object? totalCount = null,Object? lastSeen = freezed,Object? exampleOriginal = freezed,Object? exampleCorrected = freezed,Object? sources = null,}) {
  return _then(_self.copyWith(
errorType: null == errorType ? _self.errorType : errorType // ignore: cast_nullable_to_non_nullable
as String,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,lastSeen: freezed == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as DateTime?,exampleOriginal: freezed == exampleOriginal ? _self.exampleOriginal : exampleOriginal // ignore: cast_nullable_to_non_nullable
as String?,exampleCorrected: freezed == exampleCorrected ? _self.exampleCorrected : exampleCorrected // ignore: cast_nullable_to_non_nullable
as String?,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ErrorPatternSummary].
extension ErrorPatternSummaryPatterns on ErrorPatternSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ErrorPatternSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ErrorPatternSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ErrorPatternSummary value)  $default,){
final _that = this;
switch (_that) {
case _ErrorPatternSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ErrorPatternSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ErrorPatternSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'error_type')  String errorType, @JsonKey(name: 'total_count')  int totalCount, @JsonKey(name: 'last_seen')  DateTime? lastSeen, @JsonKey(name: 'example_original')  String? exampleOriginal, @JsonKey(name: 'example_corrected')  String? exampleCorrected,  List<String> sources)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ErrorPatternSummary() when $default != null:
return $default(_that.errorType,_that.totalCount,_that.lastSeen,_that.exampleOriginal,_that.exampleCorrected,_that.sources);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'error_type')  String errorType, @JsonKey(name: 'total_count')  int totalCount, @JsonKey(name: 'last_seen')  DateTime? lastSeen, @JsonKey(name: 'example_original')  String? exampleOriginal, @JsonKey(name: 'example_corrected')  String? exampleCorrected,  List<String> sources)  $default,) {final _that = this;
switch (_that) {
case _ErrorPatternSummary():
return $default(_that.errorType,_that.totalCount,_that.lastSeen,_that.exampleOriginal,_that.exampleCorrected,_that.sources);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'error_type')  String errorType, @JsonKey(name: 'total_count')  int totalCount, @JsonKey(name: 'last_seen')  DateTime? lastSeen, @JsonKey(name: 'example_original')  String? exampleOriginal, @JsonKey(name: 'example_corrected')  String? exampleCorrected,  List<String> sources)?  $default,) {final _that = this;
switch (_that) {
case _ErrorPatternSummary() when $default != null:
return $default(_that.errorType,_that.totalCount,_that.lastSeen,_that.exampleOriginal,_that.exampleCorrected,_that.sources);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ErrorPatternSummary implements ErrorPatternSummary {
  const _ErrorPatternSummary({@JsonKey(name: 'error_type') required this.errorType, @JsonKey(name: 'total_count') this.totalCount = 0, @JsonKey(name: 'last_seen') this.lastSeen, @JsonKey(name: 'example_original') this.exampleOriginal, @JsonKey(name: 'example_corrected') this.exampleCorrected, final  List<String> sources = const <String>[]}): _sources = sources;
  factory _ErrorPatternSummary.fromJson(Map<String, dynamic> json) => _$ErrorPatternSummaryFromJson(json);

@override@JsonKey(name: 'error_type') final  String errorType;
@override@JsonKey(name: 'total_count') final  int totalCount;
@override@JsonKey(name: 'last_seen') final  DateTime? lastSeen;
@override@JsonKey(name: 'example_original') final  String? exampleOriginal;
@override@JsonKey(name: 'example_corrected') final  String? exampleCorrected;
 final  List<String> _sources;
@override@JsonKey() List<String> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}


/// Create a copy of ErrorPatternSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorPatternSummaryCopyWith<_ErrorPatternSummary> get copyWith => __$ErrorPatternSummaryCopyWithImpl<_ErrorPatternSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ErrorPatternSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ErrorPatternSummary&&(identical(other.errorType, errorType) || other.errorType == errorType)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen)&&(identical(other.exampleOriginal, exampleOriginal) || other.exampleOriginal == exampleOriginal)&&(identical(other.exampleCorrected, exampleCorrected) || other.exampleCorrected == exampleCorrected)&&const DeepCollectionEquality().equals(other._sources, _sources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,errorType,totalCount,lastSeen,exampleOriginal,exampleCorrected,const DeepCollectionEquality().hash(_sources));

@override
String toString() {
  return 'ErrorPatternSummary(errorType: $errorType, totalCount: $totalCount, lastSeen: $lastSeen, exampleOriginal: $exampleOriginal, exampleCorrected: $exampleCorrected, sources: $sources)';
}


}

/// @nodoc
abstract mixin class _$ErrorPatternSummaryCopyWith<$Res> implements $ErrorPatternSummaryCopyWith<$Res> {
  factory _$ErrorPatternSummaryCopyWith(_ErrorPatternSummary value, $Res Function(_ErrorPatternSummary) _then) = __$ErrorPatternSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'error_type') String errorType,@JsonKey(name: 'total_count') int totalCount,@JsonKey(name: 'last_seen') DateTime? lastSeen,@JsonKey(name: 'example_original') String? exampleOriginal,@JsonKey(name: 'example_corrected') String? exampleCorrected, List<String> sources
});




}
/// @nodoc
class __$ErrorPatternSummaryCopyWithImpl<$Res>
    implements _$ErrorPatternSummaryCopyWith<$Res> {
  __$ErrorPatternSummaryCopyWithImpl(this._self, this._then);

  final _ErrorPatternSummary _self;
  final $Res Function(_ErrorPatternSummary) _then;

/// Create a copy of ErrorPatternSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? errorType = null,Object? totalCount = null,Object? lastSeen = freezed,Object? exampleOriginal = freezed,Object? exampleCorrected = freezed,Object? sources = null,}) {
  return _then(_ErrorPatternSummary(
errorType: null == errorType ? _self.errorType : errorType // ignore: cast_nullable_to_non_nullable
as String,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,lastSeen: freezed == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as DateTime?,exampleOriginal: freezed == exampleOriginal ? _self.exampleOriginal : exampleOriginal // ignore: cast_nullable_to_non_nullable
as String?,exampleCorrected: freezed == exampleCorrected ? _self.exampleCorrected : exampleCorrected // ignore: cast_nullable_to_non_nullable
as String?,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
