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
mixin _$ErrorPattern {

 String get id; String get odlId; String get grammarCategory; String get grammarCategoryVi; int get errorCount; int get totalAttempts; double get errorRate; List<String> get exampleErrors; List<String> get suggestions; DateTime? get lastOccurredAt;
/// Create a copy of ErrorPattern
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorPatternCopyWith<ErrorPattern> get copyWith => _$ErrorPatternCopyWithImpl<ErrorPattern>(this as ErrorPattern, _$identity);

  /// Serializes this ErrorPattern to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorPattern&&(identical(other.id, id) || other.id == id)&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.grammarCategory, grammarCategory) || other.grammarCategory == grammarCategory)&&(identical(other.grammarCategoryVi, grammarCategoryVi) || other.grammarCategoryVi == grammarCategoryVi)&&(identical(other.errorCount, errorCount) || other.errorCount == errorCount)&&(identical(other.totalAttempts, totalAttempts) || other.totalAttempts == totalAttempts)&&(identical(other.errorRate, errorRate) || other.errorRate == errorRate)&&const DeepCollectionEquality().equals(other.exampleErrors, exampleErrors)&&const DeepCollectionEquality().equals(other.suggestions, suggestions)&&(identical(other.lastOccurredAt, lastOccurredAt) || other.lastOccurredAt == lastOccurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,odlId,grammarCategory,grammarCategoryVi,errorCount,totalAttempts,errorRate,const DeepCollectionEquality().hash(exampleErrors),const DeepCollectionEquality().hash(suggestions),lastOccurredAt);

@override
String toString() {
  return 'ErrorPattern(id: $id, odlId: $odlId, grammarCategory: $grammarCategory, grammarCategoryVi: $grammarCategoryVi, errorCount: $errorCount, totalAttempts: $totalAttempts, errorRate: $errorRate, exampleErrors: $exampleErrors, suggestions: $suggestions, lastOccurredAt: $lastOccurredAt)';
}


}

/// @nodoc
abstract mixin class $ErrorPatternCopyWith<$Res>  {
  factory $ErrorPatternCopyWith(ErrorPattern value, $Res Function(ErrorPattern) _then) = _$ErrorPatternCopyWithImpl;
@useResult
$Res call({
 String id, String odlId, String grammarCategory, String grammarCategoryVi, int errorCount, int totalAttempts, double errorRate, List<String> exampleErrors, List<String> suggestions, DateTime? lastOccurredAt
});




}
/// @nodoc
class _$ErrorPatternCopyWithImpl<$Res>
    implements $ErrorPatternCopyWith<$Res> {
  _$ErrorPatternCopyWithImpl(this._self, this._then);

  final ErrorPattern _self;
  final $Res Function(ErrorPattern) _then;

/// Create a copy of ErrorPattern
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? odlId = null,Object? grammarCategory = null,Object? grammarCategoryVi = null,Object? errorCount = null,Object? totalAttempts = null,Object? errorRate = null,Object? exampleErrors = null,Object? suggestions = null,Object? lastOccurredAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,grammarCategory: null == grammarCategory ? _self.grammarCategory : grammarCategory // ignore: cast_nullable_to_non_nullable
as String,grammarCategoryVi: null == grammarCategoryVi ? _self.grammarCategoryVi : grammarCategoryVi // ignore: cast_nullable_to_non_nullable
as String,errorCount: null == errorCount ? _self.errorCount : errorCount // ignore: cast_nullable_to_non_nullable
as int,totalAttempts: null == totalAttempts ? _self.totalAttempts : totalAttempts // ignore: cast_nullable_to_non_nullable
as int,errorRate: null == errorRate ? _self.errorRate : errorRate // ignore: cast_nullable_to_non_nullable
as double,exampleErrors: null == exampleErrors ? _self.exampleErrors : exampleErrors // ignore: cast_nullable_to_non_nullable
as List<String>,suggestions: null == suggestions ? _self.suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<String>,lastOccurredAt: freezed == lastOccurredAt ? _self.lastOccurredAt : lastOccurredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ErrorPattern].
extension ErrorPatternPatterns on ErrorPattern {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ErrorPattern value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ErrorPattern() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ErrorPattern value)  $default,){
final _that = this;
switch (_that) {
case _ErrorPattern():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ErrorPattern value)?  $default,){
final _that = this;
switch (_that) {
case _ErrorPattern() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String odlId,  String grammarCategory,  String grammarCategoryVi,  int errorCount,  int totalAttempts,  double errorRate,  List<String> exampleErrors,  List<String> suggestions,  DateTime? lastOccurredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ErrorPattern() when $default != null:
return $default(_that.id,_that.odlId,_that.grammarCategory,_that.grammarCategoryVi,_that.errorCount,_that.totalAttempts,_that.errorRate,_that.exampleErrors,_that.suggestions,_that.lastOccurredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String odlId,  String grammarCategory,  String grammarCategoryVi,  int errorCount,  int totalAttempts,  double errorRate,  List<String> exampleErrors,  List<String> suggestions,  DateTime? lastOccurredAt)  $default,) {final _that = this;
switch (_that) {
case _ErrorPattern():
return $default(_that.id,_that.odlId,_that.grammarCategory,_that.grammarCategoryVi,_that.errorCount,_that.totalAttempts,_that.errorRate,_that.exampleErrors,_that.suggestions,_that.lastOccurredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String odlId,  String grammarCategory,  String grammarCategoryVi,  int errorCount,  int totalAttempts,  double errorRate,  List<String> exampleErrors,  List<String> suggestions,  DateTime? lastOccurredAt)?  $default,) {final _that = this;
switch (_that) {
case _ErrorPattern() when $default != null:
return $default(_that.id,_that.odlId,_that.grammarCategory,_that.grammarCategoryVi,_that.errorCount,_that.totalAttempts,_that.errorRate,_that.exampleErrors,_that.suggestions,_that.lastOccurredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ErrorPattern implements ErrorPattern {
  const _ErrorPattern({required this.id, required this.odlId, required this.grammarCategory, required this.grammarCategoryVi, required this.errorCount, required this.totalAttempts, this.errorRate = 0.0, final  List<String> exampleErrors = const <String>[], final  List<String> suggestions = const <String>[], this.lastOccurredAt}): _exampleErrors = exampleErrors,_suggestions = suggestions;
  factory _ErrorPattern.fromJson(Map<String, dynamic> json) => _$ErrorPatternFromJson(json);

@override final  String id;
@override final  String odlId;
@override final  String grammarCategory;
@override final  String grammarCategoryVi;
@override final  int errorCount;
@override final  int totalAttempts;
@override@JsonKey() final  double errorRate;
 final  List<String> _exampleErrors;
@override@JsonKey() List<String> get exampleErrors {
  if (_exampleErrors is EqualUnmodifiableListView) return _exampleErrors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exampleErrors);
}

 final  List<String> _suggestions;
@override@JsonKey() List<String> get suggestions {
  if (_suggestions is EqualUnmodifiableListView) return _suggestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suggestions);
}

@override final  DateTime? lastOccurredAt;

/// Create a copy of ErrorPattern
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorPatternCopyWith<_ErrorPattern> get copyWith => __$ErrorPatternCopyWithImpl<_ErrorPattern>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ErrorPatternToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ErrorPattern&&(identical(other.id, id) || other.id == id)&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.grammarCategory, grammarCategory) || other.grammarCategory == grammarCategory)&&(identical(other.grammarCategoryVi, grammarCategoryVi) || other.grammarCategoryVi == grammarCategoryVi)&&(identical(other.errorCount, errorCount) || other.errorCount == errorCount)&&(identical(other.totalAttempts, totalAttempts) || other.totalAttempts == totalAttempts)&&(identical(other.errorRate, errorRate) || other.errorRate == errorRate)&&const DeepCollectionEquality().equals(other._exampleErrors, _exampleErrors)&&const DeepCollectionEquality().equals(other._suggestions, _suggestions)&&(identical(other.lastOccurredAt, lastOccurredAt) || other.lastOccurredAt == lastOccurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,odlId,grammarCategory,grammarCategoryVi,errorCount,totalAttempts,errorRate,const DeepCollectionEquality().hash(_exampleErrors),const DeepCollectionEquality().hash(_suggestions),lastOccurredAt);

@override
String toString() {
  return 'ErrorPattern(id: $id, odlId: $odlId, grammarCategory: $grammarCategory, grammarCategoryVi: $grammarCategoryVi, errorCount: $errorCount, totalAttempts: $totalAttempts, errorRate: $errorRate, exampleErrors: $exampleErrors, suggestions: $suggestions, lastOccurredAt: $lastOccurredAt)';
}


}

/// @nodoc
abstract mixin class _$ErrorPatternCopyWith<$Res> implements $ErrorPatternCopyWith<$Res> {
  factory _$ErrorPatternCopyWith(_ErrorPattern value, $Res Function(_ErrorPattern) _then) = __$ErrorPatternCopyWithImpl;
@override @useResult
$Res call({
 String id, String odlId, String grammarCategory, String grammarCategoryVi, int errorCount, int totalAttempts, double errorRate, List<String> exampleErrors, List<String> suggestions, DateTime? lastOccurredAt
});




}
/// @nodoc
class __$ErrorPatternCopyWithImpl<$Res>
    implements _$ErrorPatternCopyWith<$Res> {
  __$ErrorPatternCopyWithImpl(this._self, this._then);

  final _ErrorPattern _self;
  final $Res Function(_ErrorPattern) _then;

/// Create a copy of ErrorPattern
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? odlId = null,Object? grammarCategory = null,Object? grammarCategoryVi = null,Object? errorCount = null,Object? totalAttempts = null,Object? errorRate = null,Object? exampleErrors = null,Object? suggestions = null,Object? lastOccurredAt = freezed,}) {
  return _then(_ErrorPattern(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,grammarCategory: null == grammarCategory ? _self.grammarCategory : grammarCategory // ignore: cast_nullable_to_non_nullable
as String,grammarCategoryVi: null == grammarCategoryVi ? _self.grammarCategoryVi : grammarCategoryVi // ignore: cast_nullable_to_non_nullable
as String,errorCount: null == errorCount ? _self.errorCount : errorCount // ignore: cast_nullable_to_non_nullable
as int,totalAttempts: null == totalAttempts ? _self.totalAttempts : totalAttempts // ignore: cast_nullable_to_non_nullable
as int,errorRate: null == errorRate ? _self.errorRate : errorRate // ignore: cast_nullable_to_non_nullable
as double,exampleErrors: null == exampleErrors ? _self._exampleErrors : exampleErrors // ignore: cast_nullable_to_non_nullable
as List<String>,suggestions: null == suggestions ? _self._suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<String>,lastOccurredAt: freezed == lastOccurredAt ? _self.lastOccurredAt : lastOccurredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SRSStats {

 String get odlId; int get totalReviews; int get totalCorrect; int get totalIncorrect; double get retentionRate; int get currentStreak; int get longestStreak; int get totalActiveDays; int get cardsLearned; int get cardsMature; int get cardsYoung; int get cardsRelearning; Map<String, int> get reviewsByDay; Map<String, double> get retentionByDay; Map<String, int> get intervalDistribution;
/// Create a copy of SRSStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SRSStatsCopyWith<SRSStats> get copyWith => _$SRSStatsCopyWithImpl<SRSStats>(this as SRSStats, _$identity);

  /// Serializes this SRSStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SRSStats&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.totalReviews, totalReviews) || other.totalReviews == totalReviews)&&(identical(other.totalCorrect, totalCorrect) || other.totalCorrect == totalCorrect)&&(identical(other.totalIncorrect, totalIncorrect) || other.totalIncorrect == totalIncorrect)&&(identical(other.retentionRate, retentionRate) || other.retentionRate == retentionRate)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.totalActiveDays, totalActiveDays) || other.totalActiveDays == totalActiveDays)&&(identical(other.cardsLearned, cardsLearned) || other.cardsLearned == cardsLearned)&&(identical(other.cardsMature, cardsMature) || other.cardsMature == cardsMature)&&(identical(other.cardsYoung, cardsYoung) || other.cardsYoung == cardsYoung)&&(identical(other.cardsRelearning, cardsRelearning) || other.cardsRelearning == cardsRelearning)&&const DeepCollectionEquality().equals(other.reviewsByDay, reviewsByDay)&&const DeepCollectionEquality().equals(other.retentionByDay, retentionByDay)&&const DeepCollectionEquality().equals(other.intervalDistribution, intervalDistribution));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,odlId,totalReviews,totalCorrect,totalIncorrect,retentionRate,currentStreak,longestStreak,totalActiveDays,cardsLearned,cardsMature,cardsYoung,cardsRelearning,const DeepCollectionEquality().hash(reviewsByDay),const DeepCollectionEquality().hash(retentionByDay),const DeepCollectionEquality().hash(intervalDistribution));

@override
String toString() {
  return 'SRSStats(odlId: $odlId, totalReviews: $totalReviews, totalCorrect: $totalCorrect, totalIncorrect: $totalIncorrect, retentionRate: $retentionRate, currentStreak: $currentStreak, longestStreak: $longestStreak, totalActiveDays: $totalActiveDays, cardsLearned: $cardsLearned, cardsMature: $cardsMature, cardsYoung: $cardsYoung, cardsRelearning: $cardsRelearning, reviewsByDay: $reviewsByDay, retentionByDay: $retentionByDay, intervalDistribution: $intervalDistribution)';
}


}

/// @nodoc
abstract mixin class $SRSStatsCopyWith<$Res>  {
  factory $SRSStatsCopyWith(SRSStats value, $Res Function(SRSStats) _then) = _$SRSStatsCopyWithImpl;
@useResult
$Res call({
 String odlId, int totalReviews, int totalCorrect, int totalIncorrect, double retentionRate, int currentStreak, int longestStreak, int totalActiveDays, int cardsLearned, int cardsMature, int cardsYoung, int cardsRelearning, Map<String, int> reviewsByDay, Map<String, double> retentionByDay, Map<String, int> intervalDistribution
});




}
/// @nodoc
class _$SRSStatsCopyWithImpl<$Res>
    implements $SRSStatsCopyWith<$Res> {
  _$SRSStatsCopyWithImpl(this._self, this._then);

  final SRSStats _self;
  final $Res Function(SRSStats) _then;

/// Create a copy of SRSStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? odlId = null,Object? totalReviews = null,Object? totalCorrect = null,Object? totalIncorrect = null,Object? retentionRate = null,Object? currentStreak = null,Object? longestStreak = null,Object? totalActiveDays = null,Object? cardsLearned = null,Object? cardsMature = null,Object? cardsYoung = null,Object? cardsRelearning = null,Object? reviewsByDay = null,Object? retentionByDay = null,Object? intervalDistribution = null,}) {
  return _then(_self.copyWith(
odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,totalReviews: null == totalReviews ? _self.totalReviews : totalReviews // ignore: cast_nullable_to_non_nullable
as int,totalCorrect: null == totalCorrect ? _self.totalCorrect : totalCorrect // ignore: cast_nullable_to_non_nullable
as int,totalIncorrect: null == totalIncorrect ? _self.totalIncorrect : totalIncorrect // ignore: cast_nullable_to_non_nullable
as int,retentionRate: null == retentionRate ? _self.retentionRate : retentionRate // ignore: cast_nullable_to_non_nullable
as double,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,totalActiveDays: null == totalActiveDays ? _self.totalActiveDays : totalActiveDays // ignore: cast_nullable_to_non_nullable
as int,cardsLearned: null == cardsLearned ? _self.cardsLearned : cardsLearned // ignore: cast_nullable_to_non_nullable
as int,cardsMature: null == cardsMature ? _self.cardsMature : cardsMature // ignore: cast_nullable_to_non_nullable
as int,cardsYoung: null == cardsYoung ? _self.cardsYoung : cardsYoung // ignore: cast_nullable_to_non_nullable
as int,cardsRelearning: null == cardsRelearning ? _self.cardsRelearning : cardsRelearning // ignore: cast_nullable_to_non_nullable
as int,reviewsByDay: null == reviewsByDay ? _self.reviewsByDay : reviewsByDay // ignore: cast_nullable_to_non_nullable
as Map<String, int>,retentionByDay: null == retentionByDay ? _self.retentionByDay : retentionByDay // ignore: cast_nullable_to_non_nullable
as Map<String, double>,intervalDistribution: null == intervalDistribution ? _self.intervalDistribution : intervalDistribution // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [SRSStats].
extension SRSStatsPatterns on SRSStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SRSStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SRSStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SRSStats value)  $default,){
final _that = this;
switch (_that) {
case _SRSStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SRSStats value)?  $default,){
final _that = this;
switch (_that) {
case _SRSStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String odlId,  int totalReviews,  int totalCorrect,  int totalIncorrect,  double retentionRate,  int currentStreak,  int longestStreak,  int totalActiveDays,  int cardsLearned,  int cardsMature,  int cardsYoung,  int cardsRelearning,  Map<String, int> reviewsByDay,  Map<String, double> retentionByDay,  Map<String, int> intervalDistribution)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SRSStats() when $default != null:
return $default(_that.odlId,_that.totalReviews,_that.totalCorrect,_that.totalIncorrect,_that.retentionRate,_that.currentStreak,_that.longestStreak,_that.totalActiveDays,_that.cardsLearned,_that.cardsMature,_that.cardsYoung,_that.cardsRelearning,_that.reviewsByDay,_that.retentionByDay,_that.intervalDistribution);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String odlId,  int totalReviews,  int totalCorrect,  int totalIncorrect,  double retentionRate,  int currentStreak,  int longestStreak,  int totalActiveDays,  int cardsLearned,  int cardsMature,  int cardsYoung,  int cardsRelearning,  Map<String, int> reviewsByDay,  Map<String, double> retentionByDay,  Map<String, int> intervalDistribution)  $default,) {final _that = this;
switch (_that) {
case _SRSStats():
return $default(_that.odlId,_that.totalReviews,_that.totalCorrect,_that.totalIncorrect,_that.retentionRate,_that.currentStreak,_that.longestStreak,_that.totalActiveDays,_that.cardsLearned,_that.cardsMature,_that.cardsYoung,_that.cardsRelearning,_that.reviewsByDay,_that.retentionByDay,_that.intervalDistribution);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String odlId,  int totalReviews,  int totalCorrect,  int totalIncorrect,  double retentionRate,  int currentStreak,  int longestStreak,  int totalActiveDays,  int cardsLearned,  int cardsMature,  int cardsYoung,  int cardsRelearning,  Map<String, int> reviewsByDay,  Map<String, double> retentionByDay,  Map<String, int> intervalDistribution)?  $default,) {final _that = this;
switch (_that) {
case _SRSStats() when $default != null:
return $default(_that.odlId,_that.totalReviews,_that.totalCorrect,_that.totalIncorrect,_that.retentionRate,_that.currentStreak,_that.longestStreak,_that.totalActiveDays,_that.cardsLearned,_that.cardsMature,_that.cardsYoung,_that.cardsRelearning,_that.reviewsByDay,_that.retentionByDay,_that.intervalDistribution);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SRSStats implements SRSStats {
  const _SRSStats({required this.odlId, this.totalReviews = 0, this.totalCorrect = 0, this.totalIncorrect = 0, this.retentionRate = 0.0, this.currentStreak = 0, this.longestStreak = 0, this.totalActiveDays = 0, this.cardsLearned = 0, this.cardsMature = 0, this.cardsYoung = 0, this.cardsRelearning = 0, final  Map<String, int> reviewsByDay = const <String, int>{}, final  Map<String, double> retentionByDay = const <String, double>{}, final  Map<String, int> intervalDistribution = const <String, int>{}}): _reviewsByDay = reviewsByDay,_retentionByDay = retentionByDay,_intervalDistribution = intervalDistribution;
  factory _SRSStats.fromJson(Map<String, dynamic> json) => _$SRSStatsFromJson(json);

@override final  String odlId;
@override@JsonKey() final  int totalReviews;
@override@JsonKey() final  int totalCorrect;
@override@JsonKey() final  int totalIncorrect;
@override@JsonKey() final  double retentionRate;
@override@JsonKey() final  int currentStreak;
@override@JsonKey() final  int longestStreak;
@override@JsonKey() final  int totalActiveDays;
@override@JsonKey() final  int cardsLearned;
@override@JsonKey() final  int cardsMature;
@override@JsonKey() final  int cardsYoung;
@override@JsonKey() final  int cardsRelearning;
 final  Map<String, int> _reviewsByDay;
@override@JsonKey() Map<String, int> get reviewsByDay {
  if (_reviewsByDay is EqualUnmodifiableMapView) return _reviewsByDay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_reviewsByDay);
}

 final  Map<String, double> _retentionByDay;
@override@JsonKey() Map<String, double> get retentionByDay {
  if (_retentionByDay is EqualUnmodifiableMapView) return _retentionByDay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_retentionByDay);
}

 final  Map<String, int> _intervalDistribution;
@override@JsonKey() Map<String, int> get intervalDistribution {
  if (_intervalDistribution is EqualUnmodifiableMapView) return _intervalDistribution;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_intervalDistribution);
}


/// Create a copy of SRSStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SRSStatsCopyWith<_SRSStats> get copyWith => __$SRSStatsCopyWithImpl<_SRSStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SRSStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SRSStats&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.totalReviews, totalReviews) || other.totalReviews == totalReviews)&&(identical(other.totalCorrect, totalCorrect) || other.totalCorrect == totalCorrect)&&(identical(other.totalIncorrect, totalIncorrect) || other.totalIncorrect == totalIncorrect)&&(identical(other.retentionRate, retentionRate) || other.retentionRate == retentionRate)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.totalActiveDays, totalActiveDays) || other.totalActiveDays == totalActiveDays)&&(identical(other.cardsLearned, cardsLearned) || other.cardsLearned == cardsLearned)&&(identical(other.cardsMature, cardsMature) || other.cardsMature == cardsMature)&&(identical(other.cardsYoung, cardsYoung) || other.cardsYoung == cardsYoung)&&(identical(other.cardsRelearning, cardsRelearning) || other.cardsRelearning == cardsRelearning)&&const DeepCollectionEquality().equals(other._reviewsByDay, _reviewsByDay)&&const DeepCollectionEquality().equals(other._retentionByDay, _retentionByDay)&&const DeepCollectionEquality().equals(other._intervalDistribution, _intervalDistribution));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,odlId,totalReviews,totalCorrect,totalIncorrect,retentionRate,currentStreak,longestStreak,totalActiveDays,cardsLearned,cardsMature,cardsYoung,cardsRelearning,const DeepCollectionEquality().hash(_reviewsByDay),const DeepCollectionEquality().hash(_retentionByDay),const DeepCollectionEquality().hash(_intervalDistribution));

@override
String toString() {
  return 'SRSStats(odlId: $odlId, totalReviews: $totalReviews, totalCorrect: $totalCorrect, totalIncorrect: $totalIncorrect, retentionRate: $retentionRate, currentStreak: $currentStreak, longestStreak: $longestStreak, totalActiveDays: $totalActiveDays, cardsLearned: $cardsLearned, cardsMature: $cardsMature, cardsYoung: $cardsYoung, cardsRelearning: $cardsRelearning, reviewsByDay: $reviewsByDay, retentionByDay: $retentionByDay, intervalDistribution: $intervalDistribution)';
}


}

/// @nodoc
abstract mixin class _$SRSStatsCopyWith<$Res> implements $SRSStatsCopyWith<$Res> {
  factory _$SRSStatsCopyWith(_SRSStats value, $Res Function(_SRSStats) _then) = __$SRSStatsCopyWithImpl;
@override @useResult
$Res call({
 String odlId, int totalReviews, int totalCorrect, int totalIncorrect, double retentionRate, int currentStreak, int longestStreak, int totalActiveDays, int cardsLearned, int cardsMature, int cardsYoung, int cardsRelearning, Map<String, int> reviewsByDay, Map<String, double> retentionByDay, Map<String, int> intervalDistribution
});




}
/// @nodoc
class __$SRSStatsCopyWithImpl<$Res>
    implements _$SRSStatsCopyWith<$Res> {
  __$SRSStatsCopyWithImpl(this._self, this._then);

  final _SRSStats _self;
  final $Res Function(_SRSStats) _then;

/// Create a copy of SRSStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? odlId = null,Object? totalReviews = null,Object? totalCorrect = null,Object? totalIncorrect = null,Object? retentionRate = null,Object? currentStreak = null,Object? longestStreak = null,Object? totalActiveDays = null,Object? cardsLearned = null,Object? cardsMature = null,Object? cardsYoung = null,Object? cardsRelearning = null,Object? reviewsByDay = null,Object? retentionByDay = null,Object? intervalDistribution = null,}) {
  return _then(_SRSStats(
odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,totalReviews: null == totalReviews ? _self.totalReviews : totalReviews // ignore: cast_nullable_to_non_nullable
as int,totalCorrect: null == totalCorrect ? _self.totalCorrect : totalCorrect // ignore: cast_nullable_to_non_nullable
as int,totalIncorrect: null == totalIncorrect ? _self.totalIncorrect : totalIncorrect // ignore: cast_nullable_to_non_nullable
as int,retentionRate: null == retentionRate ? _self.retentionRate : retentionRate // ignore: cast_nullable_to_non_nullable
as double,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,totalActiveDays: null == totalActiveDays ? _self.totalActiveDays : totalActiveDays // ignore: cast_nullable_to_non_nullable
as int,cardsLearned: null == cardsLearned ? _self.cardsLearned : cardsLearned // ignore: cast_nullable_to_non_nullable
as int,cardsMature: null == cardsMature ? _self.cardsMature : cardsMature // ignore: cast_nullable_to_non_nullable
as int,cardsYoung: null == cardsYoung ? _self.cardsYoung : cardsYoung // ignore: cast_nullable_to_non_nullable
as int,cardsRelearning: null == cardsRelearning ? _self.cardsRelearning : cardsRelearning // ignore: cast_nullable_to_non_nullable
as int,reviewsByDay: null == reviewsByDay ? _self._reviewsByDay : reviewsByDay // ignore: cast_nullable_to_non_nullable
as Map<String, int>,retentionByDay: null == retentionByDay ? _self._retentionByDay : retentionByDay // ignore: cast_nullable_to_non_nullable
as Map<String, double>,intervalDistribution: null == intervalDistribution ? _self._intervalDistribution : intervalDistribution // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}


/// @nodoc
mixin _$NearAchievement {

 String get achievementId; String get name; String get nameVi; String get description; String get descriptionVi; String get icon; double get progress; int get currentValue; int get targetValue; int get xpReward;
/// Create a copy of NearAchievement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NearAchievementCopyWith<NearAchievement> get copyWith => _$NearAchievementCopyWithImpl<NearAchievement>(this as NearAchievement, _$identity);

  /// Serializes this NearAchievement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NearAchievement&&(identical(other.achievementId, achievementId) || other.achievementId == achievementId)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue)&&(identical(other.targetValue, targetValue) || other.targetValue == targetValue)&&(identical(other.xpReward, xpReward) || other.xpReward == xpReward));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,achievementId,name,nameVi,description,descriptionVi,icon,progress,currentValue,targetValue,xpReward);

@override
String toString() {
  return 'NearAchievement(achievementId: $achievementId, name: $name, nameVi: $nameVi, description: $description, descriptionVi: $descriptionVi, icon: $icon, progress: $progress, currentValue: $currentValue, targetValue: $targetValue, xpReward: $xpReward)';
}


}

/// @nodoc
abstract mixin class $NearAchievementCopyWith<$Res>  {
  factory $NearAchievementCopyWith(NearAchievement value, $Res Function(NearAchievement) _then) = _$NearAchievementCopyWithImpl;
@useResult
$Res call({
 String achievementId, String name, String nameVi, String description, String descriptionVi, String icon, double progress, int currentValue, int targetValue, int xpReward
});




}
/// @nodoc
class _$NearAchievementCopyWithImpl<$Res>
    implements $NearAchievementCopyWith<$Res> {
  _$NearAchievementCopyWithImpl(this._self, this._then);

  final NearAchievement _self;
  final $Res Function(NearAchievement) _then;

/// Create a copy of NearAchievement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? achievementId = null,Object? name = null,Object? nameVi = null,Object? description = null,Object? descriptionVi = null,Object? icon = null,Object? progress = null,Object? currentValue = null,Object? targetValue = null,Object? xpReward = null,}) {
  return _then(_self.copyWith(
achievementId: null == achievementId ? _self.achievementId : achievementId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameVi: null == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as int,targetValue: null == targetValue ? _self.targetValue : targetValue // ignore: cast_nullable_to_non_nullable
as int,xpReward: null == xpReward ? _self.xpReward : xpReward // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NearAchievement].
extension NearAchievementPatterns on NearAchievement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NearAchievement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NearAchievement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NearAchievement value)  $default,){
final _that = this;
switch (_that) {
case _NearAchievement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NearAchievement value)?  $default,){
final _that = this;
switch (_that) {
case _NearAchievement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String achievementId,  String name,  String nameVi,  String description,  String descriptionVi,  String icon,  double progress,  int currentValue,  int targetValue,  int xpReward)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NearAchievement() when $default != null:
return $default(_that.achievementId,_that.name,_that.nameVi,_that.description,_that.descriptionVi,_that.icon,_that.progress,_that.currentValue,_that.targetValue,_that.xpReward);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String achievementId,  String name,  String nameVi,  String description,  String descriptionVi,  String icon,  double progress,  int currentValue,  int targetValue,  int xpReward)  $default,) {final _that = this;
switch (_that) {
case _NearAchievement():
return $default(_that.achievementId,_that.name,_that.nameVi,_that.description,_that.descriptionVi,_that.icon,_that.progress,_that.currentValue,_that.targetValue,_that.xpReward);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String achievementId,  String name,  String nameVi,  String description,  String descriptionVi,  String icon,  double progress,  int currentValue,  int targetValue,  int xpReward)?  $default,) {final _that = this;
switch (_that) {
case _NearAchievement() when $default != null:
return $default(_that.achievementId,_that.name,_that.nameVi,_that.description,_that.descriptionVi,_that.icon,_that.progress,_that.currentValue,_that.targetValue,_that.xpReward);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NearAchievement implements NearAchievement {
  const _NearAchievement({required this.achievementId, required this.name, required this.nameVi, required this.description, required this.descriptionVi, this.icon = '', this.progress = 0.0, this.currentValue = 0, this.targetValue = 0, this.xpReward = 0});
  factory _NearAchievement.fromJson(Map<String, dynamic> json) => _$NearAchievementFromJson(json);

@override final  String achievementId;
@override final  String name;
@override final  String nameVi;
@override final  String description;
@override final  String descriptionVi;
@override@JsonKey() final  String icon;
@override@JsonKey() final  double progress;
@override@JsonKey() final  int currentValue;
@override@JsonKey() final  int targetValue;
@override@JsonKey() final  int xpReward;

/// Create a copy of NearAchievement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NearAchievementCopyWith<_NearAchievement> get copyWith => __$NearAchievementCopyWithImpl<_NearAchievement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NearAchievementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NearAchievement&&(identical(other.achievementId, achievementId) || other.achievementId == achievementId)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue)&&(identical(other.targetValue, targetValue) || other.targetValue == targetValue)&&(identical(other.xpReward, xpReward) || other.xpReward == xpReward));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,achievementId,name,nameVi,description,descriptionVi,icon,progress,currentValue,targetValue,xpReward);

@override
String toString() {
  return 'NearAchievement(achievementId: $achievementId, name: $name, nameVi: $nameVi, description: $description, descriptionVi: $descriptionVi, icon: $icon, progress: $progress, currentValue: $currentValue, targetValue: $targetValue, xpReward: $xpReward)';
}


}

/// @nodoc
abstract mixin class _$NearAchievementCopyWith<$Res> implements $NearAchievementCopyWith<$Res> {
  factory _$NearAchievementCopyWith(_NearAchievement value, $Res Function(_NearAchievement) _then) = __$NearAchievementCopyWithImpl;
@override @useResult
$Res call({
 String achievementId, String name, String nameVi, String description, String descriptionVi, String icon, double progress, int currentValue, int targetValue, int xpReward
});




}
/// @nodoc
class __$NearAchievementCopyWithImpl<$Res>
    implements _$NearAchievementCopyWith<$Res> {
  __$NearAchievementCopyWithImpl(this._self, this._then);

  final _NearAchievement _self;
  final $Res Function(_NearAchievement) _then;

/// Create a copy of NearAchievement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? achievementId = null,Object? name = null,Object? nameVi = null,Object? description = null,Object? descriptionVi = null,Object? icon = null,Object? progress = null,Object? currentValue = null,Object? targetValue = null,Object? xpReward = null,}) {
  return _then(_NearAchievement(
achievementId: null == achievementId ? _self.achievementId : achievementId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameVi: null == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as int,targetValue: null == targetValue ? _self.targetValue : targetValue // ignore: cast_nullable_to_non_nullable
as int,xpReward: null == xpReward ? _self.xpReward : xpReward // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$StreakInfo {

 String get odlId; int get currentStreak; int get longestStreak; int get totalActiveDays; int get weeklyGoal; int get weeklyProgress; List<DateTime> get activeDays; DateTime? get lastActiveAt;
/// Create a copy of StreakInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreakInfoCopyWith<StreakInfo> get copyWith => _$StreakInfoCopyWithImpl<StreakInfo>(this as StreakInfo, _$identity);

  /// Serializes this StreakInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreakInfo&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.totalActiveDays, totalActiveDays) || other.totalActiveDays == totalActiveDays)&&(identical(other.weeklyGoal, weeklyGoal) || other.weeklyGoal == weeklyGoal)&&(identical(other.weeklyProgress, weeklyProgress) || other.weeklyProgress == weeklyProgress)&&const DeepCollectionEquality().equals(other.activeDays, activeDays)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,odlId,currentStreak,longestStreak,totalActiveDays,weeklyGoal,weeklyProgress,const DeepCollectionEquality().hash(activeDays),lastActiveAt);

@override
String toString() {
  return 'StreakInfo(odlId: $odlId, currentStreak: $currentStreak, longestStreak: $longestStreak, totalActiveDays: $totalActiveDays, weeklyGoal: $weeklyGoal, weeklyProgress: $weeklyProgress, activeDays: $activeDays, lastActiveAt: $lastActiveAt)';
}


}

/// @nodoc
abstract mixin class $StreakInfoCopyWith<$Res>  {
  factory $StreakInfoCopyWith(StreakInfo value, $Res Function(StreakInfo) _then) = _$StreakInfoCopyWithImpl;
@useResult
$Res call({
 String odlId, int currentStreak, int longestStreak, int totalActiveDays, int weeklyGoal, int weeklyProgress, List<DateTime> activeDays, DateTime? lastActiveAt
});




}
/// @nodoc
class _$StreakInfoCopyWithImpl<$Res>
    implements $StreakInfoCopyWith<$Res> {
  _$StreakInfoCopyWithImpl(this._self, this._then);

  final StreakInfo _self;
  final $Res Function(StreakInfo) _then;

/// Create a copy of StreakInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? odlId = null,Object? currentStreak = null,Object? longestStreak = null,Object? totalActiveDays = null,Object? weeklyGoal = null,Object? weeklyProgress = null,Object? activeDays = null,Object? lastActiveAt = freezed,}) {
  return _then(_self.copyWith(
odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,totalActiveDays: null == totalActiveDays ? _self.totalActiveDays : totalActiveDays // ignore: cast_nullable_to_non_nullable
as int,weeklyGoal: null == weeklyGoal ? _self.weeklyGoal : weeklyGoal // ignore: cast_nullable_to_non_nullable
as int,weeklyProgress: null == weeklyProgress ? _self.weeklyProgress : weeklyProgress // ignore: cast_nullable_to_non_nullable
as int,activeDays: null == activeDays ? _self.activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as List<DateTime>,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StreakInfo].
extension StreakInfoPatterns on StreakInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StreakInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StreakInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StreakInfo value)  $default,){
final _that = this;
switch (_that) {
case _StreakInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StreakInfo value)?  $default,){
final _that = this;
switch (_that) {
case _StreakInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String odlId,  int currentStreak,  int longestStreak,  int totalActiveDays,  int weeklyGoal,  int weeklyProgress,  List<DateTime> activeDays,  DateTime? lastActiveAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StreakInfo() when $default != null:
return $default(_that.odlId,_that.currentStreak,_that.longestStreak,_that.totalActiveDays,_that.weeklyGoal,_that.weeklyProgress,_that.activeDays,_that.lastActiveAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String odlId,  int currentStreak,  int longestStreak,  int totalActiveDays,  int weeklyGoal,  int weeklyProgress,  List<DateTime> activeDays,  DateTime? lastActiveAt)  $default,) {final _that = this;
switch (_that) {
case _StreakInfo():
return $default(_that.odlId,_that.currentStreak,_that.longestStreak,_that.totalActiveDays,_that.weeklyGoal,_that.weeklyProgress,_that.activeDays,_that.lastActiveAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String odlId,  int currentStreak,  int longestStreak,  int totalActiveDays,  int weeklyGoal,  int weeklyProgress,  List<DateTime> activeDays,  DateTime? lastActiveAt)?  $default,) {final _that = this;
switch (_that) {
case _StreakInfo() when $default != null:
return $default(_that.odlId,_that.currentStreak,_that.longestStreak,_that.totalActiveDays,_that.weeklyGoal,_that.weeklyProgress,_that.activeDays,_that.lastActiveAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StreakInfo implements StreakInfo {
  const _StreakInfo({required this.odlId, this.currentStreak = 0, this.longestStreak = 0, this.totalActiveDays = 0, this.weeklyGoal = 0, this.weeklyProgress = 0, final  List<DateTime> activeDays = const <DateTime>[], this.lastActiveAt}): _activeDays = activeDays;
  factory _StreakInfo.fromJson(Map<String, dynamic> json) => _$StreakInfoFromJson(json);

@override final  String odlId;
@override@JsonKey() final  int currentStreak;
@override@JsonKey() final  int longestStreak;
@override@JsonKey() final  int totalActiveDays;
@override@JsonKey() final  int weeklyGoal;
@override@JsonKey() final  int weeklyProgress;
 final  List<DateTime> _activeDays;
@override@JsonKey() List<DateTime> get activeDays {
  if (_activeDays is EqualUnmodifiableListView) return _activeDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activeDays);
}

@override final  DateTime? lastActiveAt;

/// Create a copy of StreakInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreakInfoCopyWith<_StreakInfo> get copyWith => __$StreakInfoCopyWithImpl<_StreakInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StreakInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StreakInfo&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.totalActiveDays, totalActiveDays) || other.totalActiveDays == totalActiveDays)&&(identical(other.weeklyGoal, weeklyGoal) || other.weeklyGoal == weeklyGoal)&&(identical(other.weeklyProgress, weeklyProgress) || other.weeklyProgress == weeklyProgress)&&const DeepCollectionEquality().equals(other._activeDays, _activeDays)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,odlId,currentStreak,longestStreak,totalActiveDays,weeklyGoal,weeklyProgress,const DeepCollectionEquality().hash(_activeDays),lastActiveAt);

@override
String toString() {
  return 'StreakInfo(odlId: $odlId, currentStreak: $currentStreak, longestStreak: $longestStreak, totalActiveDays: $totalActiveDays, weeklyGoal: $weeklyGoal, weeklyProgress: $weeklyProgress, activeDays: $activeDays, lastActiveAt: $lastActiveAt)';
}


}

/// @nodoc
abstract mixin class _$StreakInfoCopyWith<$Res> implements $StreakInfoCopyWith<$Res> {
  factory _$StreakInfoCopyWith(_StreakInfo value, $Res Function(_StreakInfo) _then) = __$StreakInfoCopyWithImpl;
@override @useResult
$Res call({
 String odlId, int currentStreak, int longestStreak, int totalActiveDays, int weeklyGoal, int weeklyProgress, List<DateTime> activeDays, DateTime? lastActiveAt
});




}
/// @nodoc
class __$StreakInfoCopyWithImpl<$Res>
    implements _$StreakInfoCopyWith<$Res> {
  __$StreakInfoCopyWithImpl(this._self, this._then);

  final _StreakInfo _self;
  final $Res Function(_StreakInfo) _then;

/// Create a copy of StreakInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? odlId = null,Object? currentStreak = null,Object? longestStreak = null,Object? totalActiveDays = null,Object? weeklyGoal = null,Object? weeklyProgress = null,Object? activeDays = null,Object? lastActiveAt = freezed,}) {
  return _then(_StreakInfo(
odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,totalActiveDays: null == totalActiveDays ? _self.totalActiveDays : totalActiveDays // ignore: cast_nullable_to_non_nullable
as int,weeklyGoal: null == weeklyGoal ? _self.weeklyGoal : weeklyGoal // ignore: cast_nullable_to_non_nullable
as int,weeklyProgress: null == weeklyProgress ? _self.weeklyProgress : weeklyProgress // ignore: cast_nullable_to_non_nullable
as int,activeDays: null == activeDays ? _self._activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as List<DateTime>,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$TimeStats {

 String get odlId; int get totalMinutes; int get todayMinutes; int get weekMinutes; int get monthMinutes; Map<String, int> get minutesByFeature; Map<String, int> get minutesByDay; double get averageMinutesPerDay;
/// Create a copy of TimeStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeStatsCopyWith<TimeStats> get copyWith => _$TimeStatsCopyWithImpl<TimeStats>(this as TimeStats, _$identity);

  /// Serializes this TimeStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeStats&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.totalMinutes, totalMinutes) || other.totalMinutes == totalMinutes)&&(identical(other.todayMinutes, todayMinutes) || other.todayMinutes == todayMinutes)&&(identical(other.weekMinutes, weekMinutes) || other.weekMinutes == weekMinutes)&&(identical(other.monthMinutes, monthMinutes) || other.monthMinutes == monthMinutes)&&const DeepCollectionEquality().equals(other.minutesByFeature, minutesByFeature)&&const DeepCollectionEquality().equals(other.minutesByDay, minutesByDay)&&(identical(other.averageMinutesPerDay, averageMinutesPerDay) || other.averageMinutesPerDay == averageMinutesPerDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,odlId,totalMinutes,todayMinutes,weekMinutes,monthMinutes,const DeepCollectionEquality().hash(minutesByFeature),const DeepCollectionEquality().hash(minutesByDay),averageMinutesPerDay);

@override
String toString() {
  return 'TimeStats(odlId: $odlId, totalMinutes: $totalMinutes, todayMinutes: $todayMinutes, weekMinutes: $weekMinutes, monthMinutes: $monthMinutes, minutesByFeature: $minutesByFeature, minutesByDay: $minutesByDay, averageMinutesPerDay: $averageMinutesPerDay)';
}


}

/// @nodoc
abstract mixin class $TimeStatsCopyWith<$Res>  {
  factory $TimeStatsCopyWith(TimeStats value, $Res Function(TimeStats) _then) = _$TimeStatsCopyWithImpl;
@useResult
$Res call({
 String odlId, int totalMinutes, int todayMinutes, int weekMinutes, int monthMinutes, Map<String, int> minutesByFeature, Map<String, int> minutesByDay, double averageMinutesPerDay
});




}
/// @nodoc
class _$TimeStatsCopyWithImpl<$Res>
    implements $TimeStatsCopyWith<$Res> {
  _$TimeStatsCopyWithImpl(this._self, this._then);

  final TimeStats _self;
  final $Res Function(TimeStats) _then;

/// Create a copy of TimeStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? odlId = null,Object? totalMinutes = null,Object? todayMinutes = null,Object? weekMinutes = null,Object? monthMinutes = null,Object? minutesByFeature = null,Object? minutesByDay = null,Object? averageMinutesPerDay = null,}) {
  return _then(_self.copyWith(
odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,totalMinutes: null == totalMinutes ? _self.totalMinutes : totalMinutes // ignore: cast_nullable_to_non_nullable
as int,todayMinutes: null == todayMinutes ? _self.todayMinutes : todayMinutes // ignore: cast_nullable_to_non_nullable
as int,weekMinutes: null == weekMinutes ? _self.weekMinutes : weekMinutes // ignore: cast_nullable_to_non_nullable
as int,monthMinutes: null == monthMinutes ? _self.monthMinutes : monthMinutes // ignore: cast_nullable_to_non_nullable
as int,minutesByFeature: null == minutesByFeature ? _self.minutesByFeature : minutesByFeature // ignore: cast_nullable_to_non_nullable
as Map<String, int>,minutesByDay: null == minutesByDay ? _self.minutesByDay : minutesByDay // ignore: cast_nullable_to_non_nullable
as Map<String, int>,averageMinutesPerDay: null == averageMinutesPerDay ? _self.averageMinutesPerDay : averageMinutesPerDay // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeStats].
extension TimeStatsPatterns on TimeStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeStats value)  $default,){
final _that = this;
switch (_that) {
case _TimeStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeStats value)?  $default,){
final _that = this;
switch (_that) {
case _TimeStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String odlId,  int totalMinutes,  int todayMinutes,  int weekMinutes,  int monthMinutes,  Map<String, int> minutesByFeature,  Map<String, int> minutesByDay,  double averageMinutesPerDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeStats() when $default != null:
return $default(_that.odlId,_that.totalMinutes,_that.todayMinutes,_that.weekMinutes,_that.monthMinutes,_that.minutesByFeature,_that.minutesByDay,_that.averageMinutesPerDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String odlId,  int totalMinutes,  int todayMinutes,  int weekMinutes,  int monthMinutes,  Map<String, int> minutesByFeature,  Map<String, int> minutesByDay,  double averageMinutesPerDay)  $default,) {final _that = this;
switch (_that) {
case _TimeStats():
return $default(_that.odlId,_that.totalMinutes,_that.todayMinutes,_that.weekMinutes,_that.monthMinutes,_that.minutesByFeature,_that.minutesByDay,_that.averageMinutesPerDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String odlId,  int totalMinutes,  int todayMinutes,  int weekMinutes,  int monthMinutes,  Map<String, int> minutesByFeature,  Map<String, int> minutesByDay,  double averageMinutesPerDay)?  $default,) {final _that = this;
switch (_that) {
case _TimeStats() when $default != null:
return $default(_that.odlId,_that.totalMinutes,_that.todayMinutes,_that.weekMinutes,_that.monthMinutes,_that.minutesByFeature,_that.minutesByDay,_that.averageMinutesPerDay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeStats implements TimeStats {
  const _TimeStats({required this.odlId, this.totalMinutes = 0, this.todayMinutes = 0, this.weekMinutes = 0, this.monthMinutes = 0, final  Map<String, int> minutesByFeature = const <String, int>{}, final  Map<String, int> minutesByDay = const <String, int>{}, this.averageMinutesPerDay = 0}): _minutesByFeature = minutesByFeature,_minutesByDay = minutesByDay;
  factory _TimeStats.fromJson(Map<String, dynamic> json) => _$TimeStatsFromJson(json);

@override final  String odlId;
@override@JsonKey() final  int totalMinutes;
@override@JsonKey() final  int todayMinutes;
@override@JsonKey() final  int weekMinutes;
@override@JsonKey() final  int monthMinutes;
 final  Map<String, int> _minutesByFeature;
@override@JsonKey() Map<String, int> get minutesByFeature {
  if (_minutesByFeature is EqualUnmodifiableMapView) return _minutesByFeature;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_minutesByFeature);
}

 final  Map<String, int> _minutesByDay;
@override@JsonKey() Map<String, int> get minutesByDay {
  if (_minutesByDay is EqualUnmodifiableMapView) return _minutesByDay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_minutesByDay);
}

@override@JsonKey() final  double averageMinutesPerDay;

/// Create a copy of TimeStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeStatsCopyWith<_TimeStats> get copyWith => __$TimeStatsCopyWithImpl<_TimeStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeStats&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.totalMinutes, totalMinutes) || other.totalMinutes == totalMinutes)&&(identical(other.todayMinutes, todayMinutes) || other.todayMinutes == todayMinutes)&&(identical(other.weekMinutes, weekMinutes) || other.weekMinutes == weekMinutes)&&(identical(other.monthMinutes, monthMinutes) || other.monthMinutes == monthMinutes)&&const DeepCollectionEquality().equals(other._minutesByFeature, _minutesByFeature)&&const DeepCollectionEquality().equals(other._minutesByDay, _minutesByDay)&&(identical(other.averageMinutesPerDay, averageMinutesPerDay) || other.averageMinutesPerDay == averageMinutesPerDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,odlId,totalMinutes,todayMinutes,weekMinutes,monthMinutes,const DeepCollectionEquality().hash(_minutesByFeature),const DeepCollectionEquality().hash(_minutesByDay),averageMinutesPerDay);

@override
String toString() {
  return 'TimeStats(odlId: $odlId, totalMinutes: $totalMinutes, todayMinutes: $todayMinutes, weekMinutes: $weekMinutes, monthMinutes: $monthMinutes, minutesByFeature: $minutesByFeature, minutesByDay: $minutesByDay, averageMinutesPerDay: $averageMinutesPerDay)';
}


}

/// @nodoc
abstract mixin class _$TimeStatsCopyWith<$Res> implements $TimeStatsCopyWith<$Res> {
  factory _$TimeStatsCopyWith(_TimeStats value, $Res Function(_TimeStats) _then) = __$TimeStatsCopyWithImpl;
@override @useResult
$Res call({
 String odlId, int totalMinutes, int todayMinutes, int weekMinutes, int monthMinutes, Map<String, int> minutesByFeature, Map<String, int> minutesByDay, double averageMinutesPerDay
});




}
/// @nodoc
class __$TimeStatsCopyWithImpl<$Res>
    implements _$TimeStatsCopyWith<$Res> {
  __$TimeStatsCopyWithImpl(this._self, this._then);

  final _TimeStats _self;
  final $Res Function(_TimeStats) _then;

/// Create a copy of TimeStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? odlId = null,Object? totalMinutes = null,Object? todayMinutes = null,Object? weekMinutes = null,Object? monthMinutes = null,Object? minutesByFeature = null,Object? minutesByDay = null,Object? averageMinutesPerDay = null,}) {
  return _then(_TimeStats(
odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,totalMinutes: null == totalMinutes ? _self.totalMinutes : totalMinutes // ignore: cast_nullable_to_non_nullable
as int,todayMinutes: null == todayMinutes ? _self.todayMinutes : todayMinutes // ignore: cast_nullable_to_non_nullable
as int,weekMinutes: null == weekMinutes ? _self.weekMinutes : weekMinutes // ignore: cast_nullable_to_non_nullable
as int,monthMinutes: null == monthMinutes ? _self.monthMinutes : monthMinutes // ignore: cast_nullable_to_non_nullable
as int,minutesByFeature: null == minutesByFeature ? _self._minutesByFeature : minutesByFeature // ignore: cast_nullable_to_non_nullable
as Map<String, int>,minutesByDay: null == minutesByDay ? _self._minutesByDay : minutesByDay // ignore: cast_nullable_to_non_nullable
as Map<String, int>,averageMinutesPerDay: null == averageMinutesPerDay ? _self.averageMinutesPerDay : averageMinutesPerDay // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
