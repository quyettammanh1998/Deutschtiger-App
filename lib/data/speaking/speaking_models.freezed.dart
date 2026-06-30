// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speaking_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SpeakingSession {

 String get id; String get odlId; String get type; String get title; String get titleVi; String get description; String get transcript; String get translation; int get durationSeconds; double get accuracyScore; int get wordsSpoken; int get correctWords; List<SpeakingAttempt> get attempts; DateTime? get startedAt; DateTime? get completedAt;
/// Create a copy of SpeakingSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeakingSessionCopyWith<SpeakingSession> get copyWith => _$SpeakingSessionCopyWithImpl<SpeakingSession>(this as SpeakingSession, _$identity);

  /// Serializes this SpeakingSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeakingSession&&(identical(other.id, id) || other.id == id)&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.description, description) || other.description == description)&&(identical(other.transcript, transcript) || other.transcript == transcript)&&(identical(other.translation, translation) || other.translation == translation)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.accuracyScore, accuracyScore) || other.accuracyScore == accuracyScore)&&(identical(other.wordsSpoken, wordsSpoken) || other.wordsSpoken == wordsSpoken)&&(identical(other.correctWords, correctWords) || other.correctWords == correctWords)&&const DeepCollectionEquality().equals(other.attempts, attempts)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,odlId,type,title,titleVi,description,transcript,translation,durationSeconds,accuracyScore,wordsSpoken,correctWords,const DeepCollectionEquality().hash(attempts),startedAt,completedAt);

@override
String toString() {
  return 'SpeakingSession(id: $id, odlId: $odlId, type: $type, title: $title, titleVi: $titleVi, description: $description, transcript: $transcript, translation: $translation, durationSeconds: $durationSeconds, accuracyScore: $accuracyScore, wordsSpoken: $wordsSpoken, correctWords: $correctWords, attempts: $attempts, startedAt: $startedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $SpeakingSessionCopyWith<$Res>  {
  factory $SpeakingSessionCopyWith(SpeakingSession value, $Res Function(SpeakingSession) _then) = _$SpeakingSessionCopyWithImpl;
@useResult
$Res call({
 String id, String odlId, String type, String title, String titleVi, String description, String transcript, String translation, int durationSeconds, double accuracyScore, int wordsSpoken, int correctWords, List<SpeakingAttempt> attempts, DateTime? startedAt, DateTime? completedAt
});




}
/// @nodoc
class _$SpeakingSessionCopyWithImpl<$Res>
    implements $SpeakingSessionCopyWith<$Res> {
  _$SpeakingSessionCopyWithImpl(this._self, this._then);

  final SpeakingSession _self;
  final $Res Function(SpeakingSession) _then;

/// Create a copy of SpeakingSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? odlId = null,Object? type = null,Object? title = null,Object? titleVi = null,Object? description = null,Object? transcript = null,Object? translation = null,Object? durationSeconds = null,Object? accuracyScore = null,Object? wordsSpoken = null,Object? correctWords = null,Object? attempts = null,Object? startedAt = freezed,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String,translation: null == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,accuracyScore: null == accuracyScore ? _self.accuracyScore : accuracyScore // ignore: cast_nullable_to_non_nullable
as double,wordsSpoken: null == wordsSpoken ? _self.wordsSpoken : wordsSpoken // ignore: cast_nullable_to_non_nullable
as int,correctWords: null == correctWords ? _self.correctWords : correctWords // ignore: cast_nullable_to_non_nullable
as int,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as List<SpeakingAttempt>,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeakingSession].
extension SpeakingSessionPatterns on SpeakingSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeakingSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeakingSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeakingSession value)  $default,){
final _that = this;
switch (_that) {
case _SpeakingSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeakingSession value)?  $default,){
final _that = this;
switch (_that) {
case _SpeakingSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String odlId,  String type,  String title,  String titleVi,  String description,  String transcript,  String translation,  int durationSeconds,  double accuracyScore,  int wordsSpoken,  int correctWords,  List<SpeakingAttempt> attempts,  DateTime? startedAt,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeakingSession() when $default != null:
return $default(_that.id,_that.odlId,_that.type,_that.title,_that.titleVi,_that.description,_that.transcript,_that.translation,_that.durationSeconds,_that.accuracyScore,_that.wordsSpoken,_that.correctWords,_that.attempts,_that.startedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String odlId,  String type,  String title,  String titleVi,  String description,  String transcript,  String translation,  int durationSeconds,  double accuracyScore,  int wordsSpoken,  int correctWords,  List<SpeakingAttempt> attempts,  DateTime? startedAt,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _SpeakingSession():
return $default(_that.id,_that.odlId,_that.type,_that.title,_that.titleVi,_that.description,_that.transcript,_that.translation,_that.durationSeconds,_that.accuracyScore,_that.wordsSpoken,_that.correctWords,_that.attempts,_that.startedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String odlId,  String type,  String title,  String titleVi,  String description,  String transcript,  String translation,  int durationSeconds,  double accuracyScore,  int wordsSpoken,  int correctWords,  List<SpeakingAttempt> attempts,  DateTime? startedAt,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _SpeakingSession() when $default != null:
return $default(_that.id,_that.odlId,_that.type,_that.title,_that.titleVi,_that.description,_that.transcript,_that.translation,_that.durationSeconds,_that.accuracyScore,_that.wordsSpoken,_that.correctWords,_that.attempts,_that.startedAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpeakingSession implements SpeakingSession {
  const _SpeakingSession({required this.id, required this.odlId, required this.type, required this.title, required this.titleVi, this.description = '', this.transcript = '', this.translation = '', this.durationSeconds = 0, this.accuracyScore = 0, this.wordsSpoken = 0, this.correctWords = 0, final  List<SpeakingAttempt> attempts = const <SpeakingAttempt>[], this.startedAt, this.completedAt}): _attempts = attempts;
  factory _SpeakingSession.fromJson(Map<String, dynamic> json) => _$SpeakingSessionFromJson(json);

@override final  String id;
@override final  String odlId;
@override final  String type;
@override final  String title;
@override final  String titleVi;
@override@JsonKey() final  String description;
@override@JsonKey() final  String transcript;
@override@JsonKey() final  String translation;
@override@JsonKey() final  int durationSeconds;
@override@JsonKey() final  double accuracyScore;
@override@JsonKey() final  int wordsSpoken;
@override@JsonKey() final  int correctWords;
 final  List<SpeakingAttempt> _attempts;
@override@JsonKey() List<SpeakingAttempt> get attempts {
  if (_attempts is EqualUnmodifiableListView) return _attempts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attempts);
}

@override final  DateTime? startedAt;
@override final  DateTime? completedAt;

/// Create a copy of SpeakingSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeakingSessionCopyWith<_SpeakingSession> get copyWith => __$SpeakingSessionCopyWithImpl<_SpeakingSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpeakingSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeakingSession&&(identical(other.id, id) || other.id == id)&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.description, description) || other.description == description)&&(identical(other.transcript, transcript) || other.transcript == transcript)&&(identical(other.translation, translation) || other.translation == translation)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.accuracyScore, accuracyScore) || other.accuracyScore == accuracyScore)&&(identical(other.wordsSpoken, wordsSpoken) || other.wordsSpoken == wordsSpoken)&&(identical(other.correctWords, correctWords) || other.correctWords == correctWords)&&const DeepCollectionEquality().equals(other._attempts, _attempts)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,odlId,type,title,titleVi,description,transcript,translation,durationSeconds,accuracyScore,wordsSpoken,correctWords,const DeepCollectionEquality().hash(_attempts),startedAt,completedAt);

@override
String toString() {
  return 'SpeakingSession(id: $id, odlId: $odlId, type: $type, title: $title, titleVi: $titleVi, description: $description, transcript: $transcript, translation: $translation, durationSeconds: $durationSeconds, accuracyScore: $accuracyScore, wordsSpoken: $wordsSpoken, correctWords: $correctWords, attempts: $attempts, startedAt: $startedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$SpeakingSessionCopyWith<$Res> implements $SpeakingSessionCopyWith<$Res> {
  factory _$SpeakingSessionCopyWith(_SpeakingSession value, $Res Function(_SpeakingSession) _then) = __$SpeakingSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String odlId, String type, String title, String titleVi, String description, String transcript, String translation, int durationSeconds, double accuracyScore, int wordsSpoken, int correctWords, List<SpeakingAttempt> attempts, DateTime? startedAt, DateTime? completedAt
});




}
/// @nodoc
class __$SpeakingSessionCopyWithImpl<$Res>
    implements _$SpeakingSessionCopyWith<$Res> {
  __$SpeakingSessionCopyWithImpl(this._self, this._then);

  final _SpeakingSession _self;
  final $Res Function(_SpeakingSession) _then;

/// Create a copy of SpeakingSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? odlId = null,Object? type = null,Object? title = null,Object? titleVi = null,Object? description = null,Object? transcript = null,Object? translation = null,Object? durationSeconds = null,Object? accuracyScore = null,Object? wordsSpoken = null,Object? correctWords = null,Object? attempts = null,Object? startedAt = freezed,Object? completedAt = freezed,}) {
  return _then(_SpeakingSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String,translation: null == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,accuracyScore: null == accuracyScore ? _self.accuracyScore : accuracyScore // ignore: cast_nullable_to_non_nullable
as double,wordsSpoken: null == wordsSpoken ? _self.wordsSpoken : wordsSpoken // ignore: cast_nullable_to_non_nullable
as int,correctWords: null == correctWords ? _self.correctWords : correctWords // ignore: cast_nullable_to_non_nullable
as int,attempts: null == attempts ? _self._attempts : attempts // ignore: cast_nullable_to_non_nullable
as List<SpeakingAttempt>,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SpeakingAttempt {

 String get id; String get sessionId; String get expectedText; String get spokenText; String get audioUrl; double get accuracyScore; List<WordResult> get wordResults; int get durationSeconds; DateTime? get recordedAt;
/// Create a copy of SpeakingAttempt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeakingAttemptCopyWith<SpeakingAttempt> get copyWith => _$SpeakingAttemptCopyWithImpl<SpeakingAttempt>(this as SpeakingAttempt, _$identity);

  /// Serializes this SpeakingAttempt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeakingAttempt&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.expectedText, expectedText) || other.expectedText == expectedText)&&(identical(other.spokenText, spokenText) || other.spokenText == spokenText)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.accuracyScore, accuracyScore) || other.accuracyScore == accuracyScore)&&const DeepCollectionEquality().equals(other.wordResults, wordResults)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,expectedText,spokenText,audioUrl,accuracyScore,const DeepCollectionEquality().hash(wordResults),durationSeconds,recordedAt);

@override
String toString() {
  return 'SpeakingAttempt(id: $id, sessionId: $sessionId, expectedText: $expectedText, spokenText: $spokenText, audioUrl: $audioUrl, accuracyScore: $accuracyScore, wordResults: $wordResults, durationSeconds: $durationSeconds, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class $SpeakingAttemptCopyWith<$Res>  {
  factory $SpeakingAttemptCopyWith(SpeakingAttempt value, $Res Function(SpeakingAttempt) _then) = _$SpeakingAttemptCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, String expectedText, String spokenText, String audioUrl, double accuracyScore, List<WordResult> wordResults, int durationSeconds, DateTime? recordedAt
});




}
/// @nodoc
class _$SpeakingAttemptCopyWithImpl<$Res>
    implements $SpeakingAttemptCopyWith<$Res> {
  _$SpeakingAttemptCopyWithImpl(this._self, this._then);

  final SpeakingAttempt _self;
  final $Res Function(SpeakingAttempt) _then;

/// Create a copy of SpeakingAttempt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? expectedText = null,Object? spokenText = null,Object? audioUrl = null,Object? accuracyScore = null,Object? wordResults = null,Object? durationSeconds = null,Object? recordedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,expectedText: null == expectedText ? _self.expectedText : expectedText // ignore: cast_nullable_to_non_nullable
as String,spokenText: null == spokenText ? _self.spokenText : spokenText // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,accuracyScore: null == accuracyScore ? _self.accuracyScore : accuracyScore // ignore: cast_nullable_to_non_nullable
as double,wordResults: null == wordResults ? _self.wordResults : wordResults // ignore: cast_nullable_to_non_nullable
as List<WordResult>,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,recordedAt: freezed == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeakingAttempt].
extension SpeakingAttemptPatterns on SpeakingAttempt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeakingAttempt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeakingAttempt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeakingAttempt value)  $default,){
final _that = this;
switch (_that) {
case _SpeakingAttempt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeakingAttempt value)?  $default,){
final _that = this;
switch (_that) {
case _SpeakingAttempt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  String expectedText,  String spokenText,  String audioUrl,  double accuracyScore,  List<WordResult> wordResults,  int durationSeconds,  DateTime? recordedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeakingAttempt() when $default != null:
return $default(_that.id,_that.sessionId,_that.expectedText,_that.spokenText,_that.audioUrl,_that.accuracyScore,_that.wordResults,_that.durationSeconds,_that.recordedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  String expectedText,  String spokenText,  String audioUrl,  double accuracyScore,  List<WordResult> wordResults,  int durationSeconds,  DateTime? recordedAt)  $default,) {final _that = this;
switch (_that) {
case _SpeakingAttempt():
return $default(_that.id,_that.sessionId,_that.expectedText,_that.spokenText,_that.audioUrl,_that.accuracyScore,_that.wordResults,_that.durationSeconds,_that.recordedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  String expectedText,  String spokenText,  String audioUrl,  double accuracyScore,  List<WordResult> wordResults,  int durationSeconds,  DateTime? recordedAt)?  $default,) {final _that = this;
switch (_that) {
case _SpeakingAttempt() when $default != null:
return $default(_that.id,_that.sessionId,_that.expectedText,_that.spokenText,_that.audioUrl,_that.accuracyScore,_that.wordResults,_that.durationSeconds,_that.recordedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpeakingAttempt implements SpeakingAttempt {
  const _SpeakingAttempt({required this.id, required this.sessionId, this.expectedText = '', this.spokenText = '', this.audioUrl = '', this.accuracyScore = 0.0, final  List<WordResult> wordResults = const <WordResult>[], this.durationSeconds = 0, this.recordedAt}): _wordResults = wordResults;
  factory _SpeakingAttempt.fromJson(Map<String, dynamic> json) => _$SpeakingAttemptFromJson(json);

@override final  String id;
@override final  String sessionId;
@override@JsonKey() final  String expectedText;
@override@JsonKey() final  String spokenText;
@override@JsonKey() final  String audioUrl;
@override@JsonKey() final  double accuracyScore;
 final  List<WordResult> _wordResults;
@override@JsonKey() List<WordResult> get wordResults {
  if (_wordResults is EqualUnmodifiableListView) return _wordResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wordResults);
}

@override@JsonKey() final  int durationSeconds;
@override final  DateTime? recordedAt;

/// Create a copy of SpeakingAttempt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeakingAttemptCopyWith<_SpeakingAttempt> get copyWith => __$SpeakingAttemptCopyWithImpl<_SpeakingAttempt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpeakingAttemptToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeakingAttempt&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.expectedText, expectedText) || other.expectedText == expectedText)&&(identical(other.spokenText, spokenText) || other.spokenText == spokenText)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.accuracyScore, accuracyScore) || other.accuracyScore == accuracyScore)&&const DeepCollectionEquality().equals(other._wordResults, _wordResults)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,expectedText,spokenText,audioUrl,accuracyScore,const DeepCollectionEquality().hash(_wordResults),durationSeconds,recordedAt);

@override
String toString() {
  return 'SpeakingAttempt(id: $id, sessionId: $sessionId, expectedText: $expectedText, spokenText: $spokenText, audioUrl: $audioUrl, accuracyScore: $accuracyScore, wordResults: $wordResults, durationSeconds: $durationSeconds, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class _$SpeakingAttemptCopyWith<$Res> implements $SpeakingAttemptCopyWith<$Res> {
  factory _$SpeakingAttemptCopyWith(_SpeakingAttempt value, $Res Function(_SpeakingAttempt) _then) = __$SpeakingAttemptCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, String expectedText, String spokenText, String audioUrl, double accuracyScore, List<WordResult> wordResults, int durationSeconds, DateTime? recordedAt
});




}
/// @nodoc
class __$SpeakingAttemptCopyWithImpl<$Res>
    implements _$SpeakingAttemptCopyWith<$Res> {
  __$SpeakingAttemptCopyWithImpl(this._self, this._then);

  final _SpeakingAttempt _self;
  final $Res Function(_SpeakingAttempt) _then;

/// Create a copy of SpeakingAttempt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? expectedText = null,Object? spokenText = null,Object? audioUrl = null,Object? accuracyScore = null,Object? wordResults = null,Object? durationSeconds = null,Object? recordedAt = freezed,}) {
  return _then(_SpeakingAttempt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,expectedText: null == expectedText ? _self.expectedText : expectedText // ignore: cast_nullable_to_non_nullable
as String,spokenText: null == spokenText ? _self.spokenText : spokenText // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,accuracyScore: null == accuracyScore ? _self.accuracyScore : accuracyScore // ignore: cast_nullable_to_non_nullable
as double,wordResults: null == wordResults ? _self._wordResults : wordResults // ignore: cast_nullable_to_non_nullable
as List<WordResult>,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,recordedAt: freezed == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$WordResult {

 String get word; bool get isCorrect; String get expected; String get spoken; double get confidence;
/// Create a copy of WordResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WordResultCopyWith<WordResult> get copyWith => _$WordResultCopyWithImpl<WordResult>(this as WordResult, _$identity);

  /// Serializes this WordResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WordResult&&(identical(other.word, word) || other.word == word)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.expected, expected) || other.expected == expected)&&(identical(other.spoken, spoken) || other.spoken == spoken)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,isCorrect,expected,spoken,confidence);

@override
String toString() {
  return 'WordResult(word: $word, isCorrect: $isCorrect, expected: $expected, spoken: $spoken, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $WordResultCopyWith<$Res>  {
  factory $WordResultCopyWith(WordResult value, $Res Function(WordResult) _then) = _$WordResultCopyWithImpl;
@useResult
$Res call({
 String word, bool isCorrect, String expected, String spoken, double confidence
});




}
/// @nodoc
class _$WordResultCopyWithImpl<$Res>
    implements $WordResultCopyWith<$Res> {
  _$WordResultCopyWithImpl(this._self, this._then);

  final WordResult _self;
  final $Res Function(WordResult) _then;

/// Create a copy of WordResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? word = null,Object? isCorrect = null,Object? expected = null,Object? spoken = null,Object? confidence = null,}) {
  return _then(_self.copyWith(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,expected: null == expected ? _self.expected : expected // ignore: cast_nullable_to_non_nullable
as String,spoken: null == spoken ? _self.spoken : spoken // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WordResult].
extension WordResultPatterns on WordResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WordResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WordResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WordResult value)  $default,){
final _that = this;
switch (_that) {
case _WordResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WordResult value)?  $default,){
final _that = this;
switch (_that) {
case _WordResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String word,  bool isCorrect,  String expected,  String spoken,  double confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WordResult() when $default != null:
return $default(_that.word,_that.isCorrect,_that.expected,_that.spoken,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String word,  bool isCorrect,  String expected,  String spoken,  double confidence)  $default,) {final _that = this;
switch (_that) {
case _WordResult():
return $default(_that.word,_that.isCorrect,_that.expected,_that.spoken,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String word,  bool isCorrect,  String expected,  String spoken,  double confidence)?  $default,) {final _that = this;
switch (_that) {
case _WordResult() when $default != null:
return $default(_that.word,_that.isCorrect,_that.expected,_that.spoken,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WordResult implements WordResult {
  const _WordResult({required this.word, required this.isCorrect, this.expected = '', this.spoken = '', this.confidence = 0.0});
  factory _WordResult.fromJson(Map<String, dynamic> json) => _$WordResultFromJson(json);

@override final  String word;
@override final  bool isCorrect;
@override@JsonKey() final  String expected;
@override@JsonKey() final  String spoken;
@override@JsonKey() final  double confidence;

/// Create a copy of WordResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WordResultCopyWith<_WordResult> get copyWith => __$WordResultCopyWithImpl<_WordResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WordResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WordResult&&(identical(other.word, word) || other.word == word)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.expected, expected) || other.expected == expected)&&(identical(other.spoken, spoken) || other.spoken == spoken)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,isCorrect,expected,spoken,confidence);

@override
String toString() {
  return 'WordResult(word: $word, isCorrect: $isCorrect, expected: $expected, spoken: $spoken, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$WordResultCopyWith<$Res> implements $WordResultCopyWith<$Res> {
  factory _$WordResultCopyWith(_WordResult value, $Res Function(_WordResult) _then) = __$WordResultCopyWithImpl;
@override @useResult
$Res call({
 String word, bool isCorrect, String expected, String spoken, double confidence
});




}
/// @nodoc
class __$WordResultCopyWithImpl<$Res>
    implements _$WordResultCopyWith<$Res> {
  __$WordResultCopyWithImpl(this._self, this._then);

  final _WordResult _self;
  final $Res Function(_WordResult) _then;

/// Create a copy of WordResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? word = null,Object? isCorrect = null,Object? expected = null,Object? spoken = null,Object? confidence = null,}) {
  return _then(_WordResult(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,expected: null == expected ? _self.expected : expected // ignore: cast_nullable_to_non_nullable
as String,spoken: null == spoken ? _self.spoken : spoken // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$PronunciationTrainer {

 String get id; String get type; String get name; String get nameVi; String get targetSound; String get description; String get descriptionVi; List<TrainerExercise> get exercises; int get totalAttempts; int get correctAttempts;
/// Create a copy of PronunciationTrainer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PronunciationTrainerCopyWith<PronunciationTrainer> get copyWith => _$PronunciationTrainerCopyWithImpl<PronunciationTrainer>(this as PronunciationTrainer, _$identity);

  /// Serializes this PronunciationTrainer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PronunciationTrainer&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi)&&(identical(other.targetSound, targetSound) || other.targetSound == targetSound)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&const DeepCollectionEquality().equals(other.exercises, exercises)&&(identical(other.totalAttempts, totalAttempts) || other.totalAttempts == totalAttempts)&&(identical(other.correctAttempts, correctAttempts) || other.correctAttempts == correctAttempts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,nameVi,targetSound,description,descriptionVi,const DeepCollectionEquality().hash(exercises),totalAttempts,correctAttempts);

@override
String toString() {
  return 'PronunciationTrainer(id: $id, type: $type, name: $name, nameVi: $nameVi, targetSound: $targetSound, description: $description, descriptionVi: $descriptionVi, exercises: $exercises, totalAttempts: $totalAttempts, correctAttempts: $correctAttempts)';
}


}

/// @nodoc
abstract mixin class $PronunciationTrainerCopyWith<$Res>  {
  factory $PronunciationTrainerCopyWith(PronunciationTrainer value, $Res Function(PronunciationTrainer) _then) = _$PronunciationTrainerCopyWithImpl;
@useResult
$Res call({
 String id, String type, String name, String nameVi, String targetSound, String description, String descriptionVi, List<TrainerExercise> exercises, int totalAttempts, int correctAttempts
});




}
/// @nodoc
class _$PronunciationTrainerCopyWithImpl<$Res>
    implements $PronunciationTrainerCopyWith<$Res> {
  _$PronunciationTrainerCopyWithImpl(this._self, this._then);

  final PronunciationTrainer _self;
  final $Res Function(PronunciationTrainer) _then;

/// Create a copy of PronunciationTrainer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? name = null,Object? nameVi = null,Object? targetSound = null,Object? description = null,Object? descriptionVi = null,Object? exercises = null,Object? totalAttempts = null,Object? correctAttempts = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameVi: null == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String,targetSound: null == targetSound ? _self.targetSound : targetSound // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<TrainerExercise>,totalAttempts: null == totalAttempts ? _self.totalAttempts : totalAttempts // ignore: cast_nullable_to_non_nullable
as int,correctAttempts: null == correctAttempts ? _self.correctAttempts : correctAttempts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PronunciationTrainer].
extension PronunciationTrainerPatterns on PronunciationTrainer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PronunciationTrainer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PronunciationTrainer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PronunciationTrainer value)  $default,){
final _that = this;
switch (_that) {
case _PronunciationTrainer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PronunciationTrainer value)?  $default,){
final _that = this;
switch (_that) {
case _PronunciationTrainer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String name,  String nameVi,  String targetSound,  String description,  String descriptionVi,  List<TrainerExercise> exercises,  int totalAttempts,  int correctAttempts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PronunciationTrainer() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.nameVi,_that.targetSound,_that.description,_that.descriptionVi,_that.exercises,_that.totalAttempts,_that.correctAttempts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String name,  String nameVi,  String targetSound,  String description,  String descriptionVi,  List<TrainerExercise> exercises,  int totalAttempts,  int correctAttempts)  $default,) {final _that = this;
switch (_that) {
case _PronunciationTrainer():
return $default(_that.id,_that.type,_that.name,_that.nameVi,_that.targetSound,_that.description,_that.descriptionVi,_that.exercises,_that.totalAttempts,_that.correctAttempts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String name,  String nameVi,  String targetSound,  String description,  String descriptionVi,  List<TrainerExercise> exercises,  int totalAttempts,  int correctAttempts)?  $default,) {final _that = this;
switch (_that) {
case _PronunciationTrainer() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.nameVi,_that.targetSound,_that.description,_that.descriptionVi,_that.exercises,_that.totalAttempts,_that.correctAttempts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PronunciationTrainer implements PronunciationTrainer {
  const _PronunciationTrainer({required this.id, required this.type, required this.name, required this.nameVi, required this.targetSound, this.description = '', this.descriptionVi = '', final  List<TrainerExercise> exercises = const <TrainerExercise>[], this.totalAttempts = 0, this.correctAttempts = 0}): _exercises = exercises;
  factory _PronunciationTrainer.fromJson(Map<String, dynamic> json) => _$PronunciationTrainerFromJson(json);

@override final  String id;
@override final  String type;
@override final  String name;
@override final  String nameVi;
@override final  String targetSound;
@override@JsonKey() final  String description;
@override@JsonKey() final  String descriptionVi;
 final  List<TrainerExercise> _exercises;
@override@JsonKey() List<TrainerExercise> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}

@override@JsonKey() final  int totalAttempts;
@override@JsonKey() final  int correctAttempts;

/// Create a copy of PronunciationTrainer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PronunciationTrainerCopyWith<_PronunciationTrainer> get copyWith => __$PronunciationTrainerCopyWithImpl<_PronunciationTrainer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PronunciationTrainerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PronunciationTrainer&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi)&&(identical(other.targetSound, targetSound) || other.targetSound == targetSound)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&const DeepCollectionEquality().equals(other._exercises, _exercises)&&(identical(other.totalAttempts, totalAttempts) || other.totalAttempts == totalAttempts)&&(identical(other.correctAttempts, correctAttempts) || other.correctAttempts == correctAttempts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,nameVi,targetSound,description,descriptionVi,const DeepCollectionEquality().hash(_exercises),totalAttempts,correctAttempts);

@override
String toString() {
  return 'PronunciationTrainer(id: $id, type: $type, name: $name, nameVi: $nameVi, targetSound: $targetSound, description: $description, descriptionVi: $descriptionVi, exercises: $exercises, totalAttempts: $totalAttempts, correctAttempts: $correctAttempts)';
}


}

/// @nodoc
abstract mixin class _$PronunciationTrainerCopyWith<$Res> implements $PronunciationTrainerCopyWith<$Res> {
  factory _$PronunciationTrainerCopyWith(_PronunciationTrainer value, $Res Function(_PronunciationTrainer) _then) = __$PronunciationTrainerCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String name, String nameVi, String targetSound, String description, String descriptionVi, List<TrainerExercise> exercises, int totalAttempts, int correctAttempts
});




}
/// @nodoc
class __$PronunciationTrainerCopyWithImpl<$Res>
    implements _$PronunciationTrainerCopyWith<$Res> {
  __$PronunciationTrainerCopyWithImpl(this._self, this._then);

  final _PronunciationTrainer _self;
  final $Res Function(_PronunciationTrainer) _then;

/// Create a copy of PronunciationTrainer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? name = null,Object? nameVi = null,Object? targetSound = null,Object? description = null,Object? descriptionVi = null,Object? exercises = null,Object? totalAttempts = null,Object? correctAttempts = null,}) {
  return _then(_PronunciationTrainer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameVi: null == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String,targetSound: null == targetSound ? _self.targetSound : targetSound // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<TrainerExercise>,totalAttempts: null == totalAttempts ? _self.totalAttempts : totalAttempts // ignore: cast_nullable_to_non_nullable
as int,correctAttempts: null == correctAttempts ? _self.correctAttempts : correctAttempts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TrainerExercise {

 String get id; String get trainerId; String get word; String get translation; String get phonetic; String get audioUrl; int get order;
/// Create a copy of TrainerExercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrainerExerciseCopyWith<TrainerExercise> get copyWith => _$TrainerExerciseCopyWithImpl<TrainerExercise>(this as TrainerExercise, _$identity);

  /// Serializes this TrainerExercise to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrainerExercise&&(identical(other.id, id) || other.id == id)&&(identical(other.trainerId, trainerId) || other.trainerId == trainerId)&&(identical(other.word, word) || other.word == word)&&(identical(other.translation, translation) || other.translation == translation)&&(identical(other.phonetic, phonetic) || other.phonetic == phonetic)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,trainerId,word,translation,phonetic,audioUrl,order);

@override
String toString() {
  return 'TrainerExercise(id: $id, trainerId: $trainerId, word: $word, translation: $translation, phonetic: $phonetic, audioUrl: $audioUrl, order: $order)';
}


}

/// @nodoc
abstract mixin class $TrainerExerciseCopyWith<$Res>  {
  factory $TrainerExerciseCopyWith(TrainerExercise value, $Res Function(TrainerExercise) _then) = _$TrainerExerciseCopyWithImpl;
@useResult
$Res call({
 String id, String trainerId, String word, String translation, String phonetic, String audioUrl, int order
});




}
/// @nodoc
class _$TrainerExerciseCopyWithImpl<$Res>
    implements $TrainerExerciseCopyWith<$Res> {
  _$TrainerExerciseCopyWithImpl(this._self, this._then);

  final TrainerExercise _self;
  final $Res Function(TrainerExercise) _then;

/// Create a copy of TrainerExercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? trainerId = null,Object? word = null,Object? translation = null,Object? phonetic = null,Object? audioUrl = null,Object? order = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,trainerId: null == trainerId ? _self.trainerId : trainerId // ignore: cast_nullable_to_non_nullable
as String,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,translation: null == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String,phonetic: null == phonetic ? _self.phonetic : phonetic // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TrainerExercise].
extension TrainerExercisePatterns on TrainerExercise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrainerExercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrainerExercise() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrainerExercise value)  $default,){
final _that = this;
switch (_that) {
case _TrainerExercise():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrainerExercise value)?  $default,){
final _that = this;
switch (_that) {
case _TrainerExercise() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String trainerId,  String word,  String translation,  String phonetic,  String audioUrl,  int order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrainerExercise() when $default != null:
return $default(_that.id,_that.trainerId,_that.word,_that.translation,_that.phonetic,_that.audioUrl,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String trainerId,  String word,  String translation,  String phonetic,  String audioUrl,  int order)  $default,) {final _that = this;
switch (_that) {
case _TrainerExercise():
return $default(_that.id,_that.trainerId,_that.word,_that.translation,_that.phonetic,_that.audioUrl,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String trainerId,  String word,  String translation,  String phonetic,  String audioUrl,  int order)?  $default,) {final _that = this;
switch (_that) {
case _TrainerExercise() when $default != null:
return $default(_that.id,_that.trainerId,_that.word,_that.translation,_that.phonetic,_that.audioUrl,_that.order);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrainerExercise implements TrainerExercise {
  const _TrainerExercise({required this.id, required this.trainerId, required this.word, required this.translation, this.phonetic = '', this.audioUrl = '', this.order = 0});
  factory _TrainerExercise.fromJson(Map<String, dynamic> json) => _$TrainerExerciseFromJson(json);

@override final  String id;
@override final  String trainerId;
@override final  String word;
@override final  String translation;
@override@JsonKey() final  String phonetic;
@override@JsonKey() final  String audioUrl;
@override@JsonKey() final  int order;

/// Create a copy of TrainerExercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrainerExerciseCopyWith<_TrainerExercise> get copyWith => __$TrainerExerciseCopyWithImpl<_TrainerExercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrainerExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrainerExercise&&(identical(other.id, id) || other.id == id)&&(identical(other.trainerId, trainerId) || other.trainerId == trainerId)&&(identical(other.word, word) || other.word == word)&&(identical(other.translation, translation) || other.translation == translation)&&(identical(other.phonetic, phonetic) || other.phonetic == phonetic)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,trainerId,word,translation,phonetic,audioUrl,order);

@override
String toString() {
  return 'TrainerExercise(id: $id, trainerId: $trainerId, word: $word, translation: $translation, phonetic: $phonetic, audioUrl: $audioUrl, order: $order)';
}


}

/// @nodoc
abstract mixin class _$TrainerExerciseCopyWith<$Res> implements $TrainerExerciseCopyWith<$Res> {
  factory _$TrainerExerciseCopyWith(_TrainerExercise value, $Res Function(_TrainerExercise) _then) = __$TrainerExerciseCopyWithImpl;
@override @useResult
$Res call({
 String id, String trainerId, String word, String translation, String phonetic, String audioUrl, int order
});




}
/// @nodoc
class __$TrainerExerciseCopyWithImpl<$Res>
    implements _$TrainerExerciseCopyWith<$Res> {
  __$TrainerExerciseCopyWithImpl(this._self, this._then);

  final _TrainerExercise _self;
  final $Res Function(_TrainerExercise) _then;

/// Create a copy of TrainerExercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? trainerId = null,Object? word = null,Object? translation = null,Object? phonetic = null,Object? audioUrl = null,Object? order = null,}) {
  return _then(_TrainerExercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,trainerId: null == trainerId ? _self.trainerId : trainerId // ignore: cast_nullable_to_non_nullable
as String,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,translation: null == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String,phonetic: null == phonetic ? _self.phonetic : phonetic // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AIConversation {

 String get id; String get title; String get titleVi; String get scenario; String get scenarioVi; String get level; String get imageUrl; int get estimatedMinutes; int get conversationCount; List<AIMessage> get messages; double get averageScore;
/// Create a copy of AIConversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AIConversationCopyWith<AIConversation> get copyWith => _$AIConversationCopyWithImpl<AIConversation>(this as AIConversation, _$identity);

  /// Serializes this AIConversation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AIConversation&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.scenario, scenario) || other.scenario == scenario)&&(identical(other.scenarioVi, scenarioVi) || other.scenarioVi == scenarioVi)&&(identical(other.level, level) || other.level == level)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.conversationCount, conversationCount) || other.conversationCount == conversationCount)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.averageScore, averageScore) || other.averageScore == averageScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,titleVi,scenario,scenarioVi,level,imageUrl,estimatedMinutes,conversationCount,const DeepCollectionEquality().hash(messages),averageScore);

@override
String toString() {
  return 'AIConversation(id: $id, title: $title, titleVi: $titleVi, scenario: $scenario, scenarioVi: $scenarioVi, level: $level, imageUrl: $imageUrl, estimatedMinutes: $estimatedMinutes, conversationCount: $conversationCount, messages: $messages, averageScore: $averageScore)';
}


}

/// @nodoc
abstract mixin class $AIConversationCopyWith<$Res>  {
  factory $AIConversationCopyWith(AIConversation value, $Res Function(AIConversation) _then) = _$AIConversationCopyWithImpl;
@useResult
$Res call({
 String id, String title, String titleVi, String scenario, String scenarioVi, String level, String imageUrl, int estimatedMinutes, int conversationCount, List<AIMessage> messages, double averageScore
});




}
/// @nodoc
class _$AIConversationCopyWithImpl<$Res>
    implements $AIConversationCopyWith<$Res> {
  _$AIConversationCopyWithImpl(this._self, this._then);

  final AIConversation _self;
  final $Res Function(AIConversation) _then;

/// Create a copy of AIConversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? titleVi = null,Object? scenario = null,Object? scenarioVi = null,Object? level = null,Object? imageUrl = null,Object? estimatedMinutes = null,Object? conversationCount = null,Object? messages = null,Object? averageScore = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,scenario: null == scenario ? _self.scenario : scenario // ignore: cast_nullable_to_non_nullable
as String,scenarioVi: null == scenarioVi ? _self.scenarioVi : scenarioVi // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,estimatedMinutes: null == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int,conversationCount: null == conversationCount ? _self.conversationCount : conversationCount // ignore: cast_nullable_to_non_nullable
as int,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<AIMessage>,averageScore: null == averageScore ? _self.averageScore : averageScore // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AIConversation].
extension AIConversationPatterns on AIConversation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AIConversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AIConversation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AIConversation value)  $default,){
final _that = this;
switch (_that) {
case _AIConversation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AIConversation value)?  $default,){
final _that = this;
switch (_that) {
case _AIConversation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String titleVi,  String scenario,  String scenarioVi,  String level,  String imageUrl,  int estimatedMinutes,  int conversationCount,  List<AIMessage> messages,  double averageScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AIConversation() when $default != null:
return $default(_that.id,_that.title,_that.titleVi,_that.scenario,_that.scenarioVi,_that.level,_that.imageUrl,_that.estimatedMinutes,_that.conversationCount,_that.messages,_that.averageScore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String titleVi,  String scenario,  String scenarioVi,  String level,  String imageUrl,  int estimatedMinutes,  int conversationCount,  List<AIMessage> messages,  double averageScore)  $default,) {final _that = this;
switch (_that) {
case _AIConversation():
return $default(_that.id,_that.title,_that.titleVi,_that.scenario,_that.scenarioVi,_that.level,_that.imageUrl,_that.estimatedMinutes,_that.conversationCount,_that.messages,_that.averageScore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String titleVi,  String scenario,  String scenarioVi,  String level,  String imageUrl,  int estimatedMinutes,  int conversationCount,  List<AIMessage> messages,  double averageScore)?  $default,) {final _that = this;
switch (_that) {
case _AIConversation() when $default != null:
return $default(_that.id,_that.title,_that.titleVi,_that.scenario,_that.scenarioVi,_that.level,_that.imageUrl,_that.estimatedMinutes,_that.conversationCount,_that.messages,_that.averageScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AIConversation implements AIConversation {
  const _AIConversation({required this.id, required this.title, required this.titleVi, required this.scenario, required this.scenarioVi, this.level = '', this.imageUrl = '', this.estimatedMinutes = 0, this.conversationCount = 0, final  List<AIMessage> messages = const <AIMessage>[], this.averageScore = 0.0}): _messages = messages;
  factory _AIConversation.fromJson(Map<String, dynamic> json) => _$AIConversationFromJson(json);

@override final  String id;
@override final  String title;
@override final  String titleVi;
@override final  String scenario;
@override final  String scenarioVi;
@override@JsonKey() final  String level;
@override@JsonKey() final  String imageUrl;
@override@JsonKey() final  int estimatedMinutes;
@override@JsonKey() final  int conversationCount;
 final  List<AIMessage> _messages;
@override@JsonKey() List<AIMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override@JsonKey() final  double averageScore;

/// Create a copy of AIConversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AIConversationCopyWith<_AIConversation> get copyWith => __$AIConversationCopyWithImpl<_AIConversation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AIConversationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AIConversation&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.scenario, scenario) || other.scenario == scenario)&&(identical(other.scenarioVi, scenarioVi) || other.scenarioVi == scenarioVi)&&(identical(other.level, level) || other.level == level)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.conversationCount, conversationCount) || other.conversationCount == conversationCount)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.averageScore, averageScore) || other.averageScore == averageScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,titleVi,scenario,scenarioVi,level,imageUrl,estimatedMinutes,conversationCount,const DeepCollectionEquality().hash(_messages),averageScore);

@override
String toString() {
  return 'AIConversation(id: $id, title: $title, titleVi: $titleVi, scenario: $scenario, scenarioVi: $scenarioVi, level: $level, imageUrl: $imageUrl, estimatedMinutes: $estimatedMinutes, conversationCount: $conversationCount, messages: $messages, averageScore: $averageScore)';
}


}

/// @nodoc
abstract mixin class _$AIConversationCopyWith<$Res> implements $AIConversationCopyWith<$Res> {
  factory _$AIConversationCopyWith(_AIConversation value, $Res Function(_AIConversation) _then) = __$AIConversationCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String titleVi, String scenario, String scenarioVi, String level, String imageUrl, int estimatedMinutes, int conversationCount, List<AIMessage> messages, double averageScore
});




}
/// @nodoc
class __$AIConversationCopyWithImpl<$Res>
    implements _$AIConversationCopyWith<$Res> {
  __$AIConversationCopyWithImpl(this._self, this._then);

  final _AIConversation _self;
  final $Res Function(_AIConversation) _then;

/// Create a copy of AIConversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? titleVi = null,Object? scenario = null,Object? scenarioVi = null,Object? level = null,Object? imageUrl = null,Object? estimatedMinutes = null,Object? conversationCount = null,Object? messages = null,Object? averageScore = null,}) {
  return _then(_AIConversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,scenario: null == scenario ? _self.scenario : scenario // ignore: cast_nullable_to_non_nullable
as String,scenarioVi: null == scenarioVi ? _self.scenarioVi : scenarioVi // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,estimatedMinutes: null == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int,conversationCount: null == conversationCount ? _self.conversationCount : conversationCount // ignore: cast_nullable_to_non_nullable
as int,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<AIMessage>,averageScore: null == averageScore ? _self.averageScore : averageScore // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$AIMessage {

 String get id; String get role; String get content; String get translation; double get score;
/// Create a copy of AIMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AIMessageCopyWith<AIMessage> get copyWith => _$AIMessageCopyWithImpl<AIMessage>(this as AIMessage, _$identity);

  /// Serializes this AIMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AIMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.translation, translation) || other.translation == translation)&&(identical(other.score, score) || other.score == score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,content,translation,score);

@override
String toString() {
  return 'AIMessage(id: $id, role: $role, content: $content, translation: $translation, score: $score)';
}


}

/// @nodoc
abstract mixin class $AIMessageCopyWith<$Res>  {
  factory $AIMessageCopyWith(AIMessage value, $Res Function(AIMessage) _then) = _$AIMessageCopyWithImpl;
@useResult
$Res call({
 String id, String role, String content, String translation, double score
});




}
/// @nodoc
class _$AIMessageCopyWithImpl<$Res>
    implements $AIMessageCopyWith<$Res> {
  _$AIMessageCopyWithImpl(this._self, this._then);

  final AIMessage _self;
  final $Res Function(AIMessage) _then;

/// Create a copy of AIMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? content = null,Object? translation = null,Object? score = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,translation: null == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AIMessage].
extension AIMessagePatterns on AIMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AIMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AIMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AIMessage value)  $default,){
final _that = this;
switch (_that) {
case _AIMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AIMessage value)?  $default,){
final _that = this;
switch (_that) {
case _AIMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String role,  String content,  String translation,  double score)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AIMessage() when $default != null:
return $default(_that.id,_that.role,_that.content,_that.translation,_that.score);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String role,  String content,  String translation,  double score)  $default,) {final _that = this;
switch (_that) {
case _AIMessage():
return $default(_that.id,_that.role,_that.content,_that.translation,_that.score);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String role,  String content,  String translation,  double score)?  $default,) {final _that = this;
switch (_that) {
case _AIMessage() when $default != null:
return $default(_that.id,_that.role,_that.content,_that.translation,_that.score);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AIMessage implements AIMessage {
  const _AIMessage({required this.id, required this.role, required this.content, this.translation = '', this.score = 0.0});
  factory _AIMessage.fromJson(Map<String, dynamic> json) => _$AIMessageFromJson(json);

@override final  String id;
@override final  String role;
@override final  String content;
@override@JsonKey() final  String translation;
@override@JsonKey() final  double score;

/// Create a copy of AIMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AIMessageCopyWith<_AIMessage> get copyWith => __$AIMessageCopyWithImpl<_AIMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AIMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AIMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.translation, translation) || other.translation == translation)&&(identical(other.score, score) || other.score == score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,content,translation,score);

@override
String toString() {
  return 'AIMessage(id: $id, role: $role, content: $content, translation: $translation, score: $score)';
}


}

/// @nodoc
abstract mixin class _$AIMessageCopyWith<$Res> implements $AIMessageCopyWith<$Res> {
  factory _$AIMessageCopyWith(_AIMessage value, $Res Function(_AIMessage) _then) = __$AIMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String role, String content, String translation, double score
});




}
/// @nodoc
class __$AIMessageCopyWithImpl<$Res>
    implements _$AIMessageCopyWith<$Res> {
  __$AIMessageCopyWithImpl(this._self, this._then);

  final _AIMessage _self;
  final $Res Function(_AIMessage) _then;

/// Create a copy of AIMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? content = null,Object? translation = null,Object? score = null,}) {
  return _then(_AIMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,translation: null == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$AIConversationHistory {

 String get id; String get conversationId; List<AIMessage> get messages; double get finalScore; int get messageCount; int get durationSeconds; DateTime? get startedAt; DateTime? get completedAt;
/// Create a copy of AIConversationHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AIConversationHistoryCopyWith<AIConversationHistory> get copyWith => _$AIConversationHistoryCopyWithImpl<AIConversationHistory>(this as AIConversationHistory, _$identity);

  /// Serializes this AIConversationHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AIConversationHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.finalScore, finalScore) || other.finalScore == finalScore)&&(identical(other.messageCount, messageCount) || other.messageCount == messageCount)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,const DeepCollectionEquality().hash(messages),finalScore,messageCount,durationSeconds,startedAt,completedAt);

@override
String toString() {
  return 'AIConversationHistory(id: $id, conversationId: $conversationId, messages: $messages, finalScore: $finalScore, messageCount: $messageCount, durationSeconds: $durationSeconds, startedAt: $startedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $AIConversationHistoryCopyWith<$Res>  {
  factory $AIConversationHistoryCopyWith(AIConversationHistory value, $Res Function(AIConversationHistory) _then) = _$AIConversationHistoryCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, List<AIMessage> messages, double finalScore, int messageCount, int durationSeconds, DateTime? startedAt, DateTime? completedAt
});




}
/// @nodoc
class _$AIConversationHistoryCopyWithImpl<$Res>
    implements $AIConversationHistoryCopyWith<$Res> {
  _$AIConversationHistoryCopyWithImpl(this._self, this._then);

  final AIConversationHistory _self;
  final $Res Function(AIConversationHistory) _then;

/// Create a copy of AIConversationHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? messages = null,Object? finalScore = null,Object? messageCount = null,Object? durationSeconds = null,Object? startedAt = freezed,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<AIMessage>,finalScore: null == finalScore ? _self.finalScore : finalScore // ignore: cast_nullable_to_non_nullable
as double,messageCount: null == messageCount ? _self.messageCount : messageCount // ignore: cast_nullable_to_non_nullable
as int,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AIConversationHistory].
extension AIConversationHistoryPatterns on AIConversationHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AIConversationHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AIConversationHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AIConversationHistory value)  $default,){
final _that = this;
switch (_that) {
case _AIConversationHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AIConversationHistory value)?  $default,){
final _that = this;
switch (_that) {
case _AIConversationHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  List<AIMessage> messages,  double finalScore,  int messageCount,  int durationSeconds,  DateTime? startedAt,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AIConversationHistory() when $default != null:
return $default(_that.id,_that.conversationId,_that.messages,_that.finalScore,_that.messageCount,_that.durationSeconds,_that.startedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  List<AIMessage> messages,  double finalScore,  int messageCount,  int durationSeconds,  DateTime? startedAt,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _AIConversationHistory():
return $default(_that.id,_that.conversationId,_that.messages,_that.finalScore,_that.messageCount,_that.durationSeconds,_that.startedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  List<AIMessage> messages,  double finalScore,  int messageCount,  int durationSeconds,  DateTime? startedAt,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _AIConversationHistory() when $default != null:
return $default(_that.id,_that.conversationId,_that.messages,_that.finalScore,_that.messageCount,_that.durationSeconds,_that.startedAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AIConversationHistory implements AIConversationHistory {
  const _AIConversationHistory({required this.id, required this.conversationId, final  List<AIMessage> messages = const <AIMessage>[], this.finalScore = 0.0, this.messageCount = 0, this.durationSeconds = 0, this.startedAt, this.completedAt}): _messages = messages;
  factory _AIConversationHistory.fromJson(Map<String, dynamic> json) => _$AIConversationHistoryFromJson(json);

@override final  String id;
@override final  String conversationId;
 final  List<AIMessage> _messages;
@override@JsonKey() List<AIMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override@JsonKey() final  double finalScore;
@override@JsonKey() final  int messageCount;
@override@JsonKey() final  int durationSeconds;
@override final  DateTime? startedAt;
@override final  DateTime? completedAt;

/// Create a copy of AIConversationHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AIConversationHistoryCopyWith<_AIConversationHistory> get copyWith => __$AIConversationHistoryCopyWithImpl<_AIConversationHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AIConversationHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AIConversationHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.finalScore, finalScore) || other.finalScore == finalScore)&&(identical(other.messageCount, messageCount) || other.messageCount == messageCount)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,const DeepCollectionEquality().hash(_messages),finalScore,messageCount,durationSeconds,startedAt,completedAt);

@override
String toString() {
  return 'AIConversationHistory(id: $id, conversationId: $conversationId, messages: $messages, finalScore: $finalScore, messageCount: $messageCount, durationSeconds: $durationSeconds, startedAt: $startedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$AIConversationHistoryCopyWith<$Res> implements $AIConversationHistoryCopyWith<$Res> {
  factory _$AIConversationHistoryCopyWith(_AIConversationHistory value, $Res Function(_AIConversationHistory) _then) = __$AIConversationHistoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, List<AIMessage> messages, double finalScore, int messageCount, int durationSeconds, DateTime? startedAt, DateTime? completedAt
});




}
/// @nodoc
class __$AIConversationHistoryCopyWithImpl<$Res>
    implements _$AIConversationHistoryCopyWith<$Res> {
  __$AIConversationHistoryCopyWithImpl(this._self, this._then);

  final _AIConversationHistory _self;
  final $Res Function(_AIConversationHistory) _then;

/// Create a copy of AIConversationHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? messages = null,Object? finalScore = null,Object? messageCount = null,Object? durationSeconds = null,Object? startedAt = freezed,Object? completedAt = freezed,}) {
  return _then(_AIConversationHistory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<AIMessage>,finalScore: null == finalScore ? _self.finalScore : finalScore // ignore: cast_nullable_to_non_nullable
as double,messageCount: null == messageCount ? _self.messageCount : messageCount // ignore: cast_nullable_to_non_nullable
as int,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
