// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_tutor_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AITutorSession {

 String get id; String get odlId; String get title; List<AITutorMessage> get messages; int get messageCount; int get tokensUsed; double get avgResponseTime; DateTime? get createdAt; DateTime? get lastMessageAt;
/// Create a copy of AITutorSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AITutorSessionCopyWith<AITutorSession> get copyWith => _$AITutorSessionCopyWithImpl<AITutorSession>(this as AITutorSession, _$identity);

  /// Serializes this AITutorSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AITutorSession&&(identical(other.id, id) || other.id == id)&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.messageCount, messageCount) || other.messageCount == messageCount)&&(identical(other.tokensUsed, tokensUsed) || other.tokensUsed == tokensUsed)&&(identical(other.avgResponseTime, avgResponseTime) || other.avgResponseTime == avgResponseTime)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,odlId,title,const DeepCollectionEquality().hash(messages),messageCount,tokensUsed,avgResponseTime,createdAt,lastMessageAt);

@override
String toString() {
  return 'AITutorSession(id: $id, odlId: $odlId, title: $title, messages: $messages, messageCount: $messageCount, tokensUsed: $tokensUsed, avgResponseTime: $avgResponseTime, createdAt: $createdAt, lastMessageAt: $lastMessageAt)';
}


}

/// @nodoc
abstract mixin class $AITutorSessionCopyWith<$Res>  {
  factory $AITutorSessionCopyWith(AITutorSession value, $Res Function(AITutorSession) _then) = _$AITutorSessionCopyWithImpl;
@useResult
$Res call({
 String id, String odlId, String title, List<AITutorMessage> messages, int messageCount, int tokensUsed, double avgResponseTime, DateTime? createdAt, DateTime? lastMessageAt
});




}
/// @nodoc
class _$AITutorSessionCopyWithImpl<$Res>
    implements $AITutorSessionCopyWith<$Res> {
  _$AITutorSessionCopyWithImpl(this._self, this._then);

  final AITutorSession _self;
  final $Res Function(AITutorSession) _then;

/// Create a copy of AITutorSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? odlId = null,Object? title = null,Object? messages = null,Object? messageCount = null,Object? tokensUsed = null,Object? avgResponseTime = null,Object? createdAt = freezed,Object? lastMessageAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<AITutorMessage>,messageCount: null == messageCount ? _self.messageCount : messageCount // ignore: cast_nullable_to_non_nullable
as int,tokensUsed: null == tokensUsed ? _self.tokensUsed : tokensUsed // ignore: cast_nullable_to_non_nullable
as int,avgResponseTime: null == avgResponseTime ? _self.avgResponseTime : avgResponseTime // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AITutorSession].
extension AITutorSessionPatterns on AITutorSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AITutorSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AITutorSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AITutorSession value)  $default,){
final _that = this;
switch (_that) {
case _AITutorSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AITutorSession value)?  $default,){
final _that = this;
switch (_that) {
case _AITutorSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String odlId,  String title,  List<AITutorMessage> messages,  int messageCount,  int tokensUsed,  double avgResponseTime,  DateTime? createdAt,  DateTime? lastMessageAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AITutorSession() when $default != null:
return $default(_that.id,_that.odlId,_that.title,_that.messages,_that.messageCount,_that.tokensUsed,_that.avgResponseTime,_that.createdAt,_that.lastMessageAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String odlId,  String title,  List<AITutorMessage> messages,  int messageCount,  int tokensUsed,  double avgResponseTime,  DateTime? createdAt,  DateTime? lastMessageAt)  $default,) {final _that = this;
switch (_that) {
case _AITutorSession():
return $default(_that.id,_that.odlId,_that.title,_that.messages,_that.messageCount,_that.tokensUsed,_that.avgResponseTime,_that.createdAt,_that.lastMessageAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String odlId,  String title,  List<AITutorMessage> messages,  int messageCount,  int tokensUsed,  double avgResponseTime,  DateTime? createdAt,  DateTime? lastMessageAt)?  $default,) {final _that = this;
switch (_that) {
case _AITutorSession() when $default != null:
return $default(_that.id,_that.odlId,_that.title,_that.messages,_that.messageCount,_that.tokensUsed,_that.avgResponseTime,_that.createdAt,_that.lastMessageAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AITutorSession implements AITutorSession {
  const _AITutorSession({required this.id, required this.odlId, required this.title, final  List<AITutorMessage> messages = const <AITutorMessage>[], this.messageCount = 0, this.tokensUsed = 0, this.avgResponseTime = 0.0, this.createdAt, this.lastMessageAt}): _messages = messages;
  factory _AITutorSession.fromJson(Map<String, dynamic> json) => _$AITutorSessionFromJson(json);

@override final  String id;
@override final  String odlId;
@override final  String title;
 final  List<AITutorMessage> _messages;
@override@JsonKey() List<AITutorMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override@JsonKey() final  int messageCount;
@override@JsonKey() final  int tokensUsed;
@override@JsonKey() final  double avgResponseTime;
@override final  DateTime? createdAt;
@override final  DateTime? lastMessageAt;

/// Create a copy of AITutorSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AITutorSessionCopyWith<_AITutorSession> get copyWith => __$AITutorSessionCopyWithImpl<_AITutorSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AITutorSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AITutorSession&&(identical(other.id, id) || other.id == id)&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.messageCount, messageCount) || other.messageCount == messageCount)&&(identical(other.tokensUsed, tokensUsed) || other.tokensUsed == tokensUsed)&&(identical(other.avgResponseTime, avgResponseTime) || other.avgResponseTime == avgResponseTime)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,odlId,title,const DeepCollectionEquality().hash(_messages),messageCount,tokensUsed,avgResponseTime,createdAt,lastMessageAt);

@override
String toString() {
  return 'AITutorSession(id: $id, odlId: $odlId, title: $title, messages: $messages, messageCount: $messageCount, tokensUsed: $tokensUsed, avgResponseTime: $avgResponseTime, createdAt: $createdAt, lastMessageAt: $lastMessageAt)';
}


}

/// @nodoc
abstract mixin class _$AITutorSessionCopyWith<$Res> implements $AITutorSessionCopyWith<$Res> {
  factory _$AITutorSessionCopyWith(_AITutorSession value, $Res Function(_AITutorSession) _then) = __$AITutorSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String odlId, String title, List<AITutorMessage> messages, int messageCount, int tokensUsed, double avgResponseTime, DateTime? createdAt, DateTime? lastMessageAt
});




}
/// @nodoc
class __$AITutorSessionCopyWithImpl<$Res>
    implements _$AITutorSessionCopyWith<$Res> {
  __$AITutorSessionCopyWithImpl(this._self, this._then);

  final _AITutorSession _self;
  final $Res Function(_AITutorSession) _then;

/// Create a copy of AITutorSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? odlId = null,Object? title = null,Object? messages = null,Object? messageCount = null,Object? tokensUsed = null,Object? avgResponseTime = null,Object? createdAt = freezed,Object? lastMessageAt = freezed,}) {
  return _then(_AITutorSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<AITutorMessage>,messageCount: null == messageCount ? _self.messageCount : messageCount // ignore: cast_nullable_to_non_nullable
as int,tokensUsed: null == tokensUsed ? _self.tokensUsed : tokensUsed // ignore: cast_nullable_to_non_nullable
as int,avgResponseTime: null == avgResponseTime ? _self.avgResponseTime : avgResponseTime // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AITutorMessage {

 String get id; String get sessionId; String get role; String get content; String get translation; List<String> get vocabularyHighlight; bool get isGrammarHint; bool get isCorrection;
/// Create a copy of AITutorMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AITutorMessageCopyWith<AITutorMessage> get copyWith => _$AITutorMessageCopyWithImpl<AITutorMessage>(this as AITutorMessage, _$identity);

  /// Serializes this AITutorMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AITutorMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.translation, translation) || other.translation == translation)&&const DeepCollectionEquality().equals(other.vocabularyHighlight, vocabularyHighlight)&&(identical(other.isGrammarHint, isGrammarHint) || other.isGrammarHint == isGrammarHint)&&(identical(other.isCorrection, isCorrection) || other.isCorrection == isCorrection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,role,content,translation,const DeepCollectionEquality().hash(vocabularyHighlight),isGrammarHint,isCorrection);

@override
String toString() {
  return 'AITutorMessage(id: $id, sessionId: $sessionId, role: $role, content: $content, translation: $translation, vocabularyHighlight: $vocabularyHighlight, isGrammarHint: $isGrammarHint, isCorrection: $isCorrection)';
}


}

/// @nodoc
abstract mixin class $AITutorMessageCopyWith<$Res>  {
  factory $AITutorMessageCopyWith(AITutorMessage value, $Res Function(AITutorMessage) _then) = _$AITutorMessageCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, String role, String content, String translation, List<String> vocabularyHighlight, bool isGrammarHint, bool isCorrection
});




}
/// @nodoc
class _$AITutorMessageCopyWithImpl<$Res>
    implements $AITutorMessageCopyWith<$Res> {
  _$AITutorMessageCopyWithImpl(this._self, this._then);

  final AITutorMessage _self;
  final $Res Function(AITutorMessage) _then;

/// Create a copy of AITutorMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? role = null,Object? content = null,Object? translation = null,Object? vocabularyHighlight = null,Object? isGrammarHint = null,Object? isCorrection = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,translation: null == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String,vocabularyHighlight: null == vocabularyHighlight ? _self.vocabularyHighlight : vocabularyHighlight // ignore: cast_nullable_to_non_nullable
as List<String>,isGrammarHint: null == isGrammarHint ? _self.isGrammarHint : isGrammarHint // ignore: cast_nullable_to_non_nullable
as bool,isCorrection: null == isCorrection ? _self.isCorrection : isCorrection // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AITutorMessage].
extension AITutorMessagePatterns on AITutorMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AITutorMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AITutorMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AITutorMessage value)  $default,){
final _that = this;
switch (_that) {
case _AITutorMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AITutorMessage value)?  $default,){
final _that = this;
switch (_that) {
case _AITutorMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  String role,  String content,  String translation,  List<String> vocabularyHighlight,  bool isGrammarHint,  bool isCorrection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AITutorMessage() when $default != null:
return $default(_that.id,_that.sessionId,_that.role,_that.content,_that.translation,_that.vocabularyHighlight,_that.isGrammarHint,_that.isCorrection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  String role,  String content,  String translation,  List<String> vocabularyHighlight,  bool isGrammarHint,  bool isCorrection)  $default,) {final _that = this;
switch (_that) {
case _AITutorMessage():
return $default(_that.id,_that.sessionId,_that.role,_that.content,_that.translation,_that.vocabularyHighlight,_that.isGrammarHint,_that.isCorrection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  String role,  String content,  String translation,  List<String> vocabularyHighlight,  bool isGrammarHint,  bool isCorrection)?  $default,) {final _that = this;
switch (_that) {
case _AITutorMessage() when $default != null:
return $default(_that.id,_that.sessionId,_that.role,_that.content,_that.translation,_that.vocabularyHighlight,_that.isGrammarHint,_that.isCorrection);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AITutorMessage implements AITutorMessage {
  const _AITutorMessage({required this.id, required this.sessionId, required this.role, required this.content, this.translation = '', final  List<String> vocabularyHighlight = const <String>[], this.isGrammarHint = false, this.isCorrection = false}): _vocabularyHighlight = vocabularyHighlight;
  factory _AITutorMessage.fromJson(Map<String, dynamic> json) => _$AITutorMessageFromJson(json);

@override final  String id;
@override final  String sessionId;
@override final  String role;
@override final  String content;
@override@JsonKey() final  String translation;
 final  List<String> _vocabularyHighlight;
@override@JsonKey() List<String> get vocabularyHighlight {
  if (_vocabularyHighlight is EqualUnmodifiableListView) return _vocabularyHighlight;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vocabularyHighlight);
}

@override@JsonKey() final  bool isGrammarHint;
@override@JsonKey() final  bool isCorrection;

/// Create a copy of AITutorMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AITutorMessageCopyWith<_AITutorMessage> get copyWith => __$AITutorMessageCopyWithImpl<_AITutorMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AITutorMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AITutorMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.translation, translation) || other.translation == translation)&&const DeepCollectionEquality().equals(other._vocabularyHighlight, _vocabularyHighlight)&&(identical(other.isGrammarHint, isGrammarHint) || other.isGrammarHint == isGrammarHint)&&(identical(other.isCorrection, isCorrection) || other.isCorrection == isCorrection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,role,content,translation,const DeepCollectionEquality().hash(_vocabularyHighlight),isGrammarHint,isCorrection);

@override
String toString() {
  return 'AITutorMessage(id: $id, sessionId: $sessionId, role: $role, content: $content, translation: $translation, vocabularyHighlight: $vocabularyHighlight, isGrammarHint: $isGrammarHint, isCorrection: $isCorrection)';
}


}

/// @nodoc
abstract mixin class _$AITutorMessageCopyWith<$Res> implements $AITutorMessageCopyWith<$Res> {
  factory _$AITutorMessageCopyWith(_AITutorMessage value, $Res Function(_AITutorMessage) _then) = __$AITutorMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, String role, String content, String translation, List<String> vocabularyHighlight, bool isGrammarHint, bool isCorrection
});




}
/// @nodoc
class __$AITutorMessageCopyWithImpl<$Res>
    implements _$AITutorMessageCopyWith<$Res> {
  __$AITutorMessageCopyWithImpl(this._self, this._then);

  final _AITutorMessage _self;
  final $Res Function(_AITutorMessage) _then;

/// Create a copy of AITutorMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? role = null,Object? content = null,Object? translation = null,Object? vocabularyHighlight = null,Object? isGrammarHint = null,Object? isCorrection = null,}) {
  return _then(_AITutorMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,translation: null == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String,vocabularyHighlight: null == vocabularyHighlight ? _self._vocabularyHighlight : vocabularyHighlight // ignore: cast_nullable_to_non_nullable
as List<String>,isGrammarHint: null == isGrammarHint ? _self.isGrammarHint : isGrammarHint // ignore: cast_nullable_to_non_nullable
as bool,isCorrection: null == isCorrection ? _self.isCorrection : isCorrection // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AIWritingPractice {

 String get id; String get odlId; String get topic; String get topicVi; String get prompt; String get promptVi; int get wordLimit; String get userText; List<AIWritingFeedback> get feedback; double get overallScore; double get grammarScore; double get vocabularyScore; double get coherenceScore; bool get isCompleted; DateTime? get submittedAt;
/// Create a copy of AIWritingPractice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AIWritingPracticeCopyWith<AIWritingPractice> get copyWith => _$AIWritingPracticeCopyWithImpl<AIWritingPractice>(this as AIWritingPractice, _$identity);

  /// Serializes this AIWritingPractice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AIWritingPractice&&(identical(other.id, id) || other.id == id)&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.topicVi, topicVi) || other.topicVi == topicVi)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.promptVi, promptVi) || other.promptVi == promptVi)&&(identical(other.wordLimit, wordLimit) || other.wordLimit == wordLimit)&&(identical(other.userText, userText) || other.userText == userText)&&const DeepCollectionEquality().equals(other.feedback, feedback)&&(identical(other.overallScore, overallScore) || other.overallScore == overallScore)&&(identical(other.grammarScore, grammarScore) || other.grammarScore == grammarScore)&&(identical(other.vocabularyScore, vocabularyScore) || other.vocabularyScore == vocabularyScore)&&(identical(other.coherenceScore, coherenceScore) || other.coherenceScore == coherenceScore)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,odlId,topic,topicVi,prompt,promptVi,wordLimit,userText,const DeepCollectionEquality().hash(feedback),overallScore,grammarScore,vocabularyScore,coherenceScore,isCompleted,submittedAt);

@override
String toString() {
  return 'AIWritingPractice(id: $id, odlId: $odlId, topic: $topic, topicVi: $topicVi, prompt: $prompt, promptVi: $promptVi, wordLimit: $wordLimit, userText: $userText, feedback: $feedback, overallScore: $overallScore, grammarScore: $grammarScore, vocabularyScore: $vocabularyScore, coherenceScore: $coherenceScore, isCompleted: $isCompleted, submittedAt: $submittedAt)';
}


}

/// @nodoc
abstract mixin class $AIWritingPracticeCopyWith<$Res>  {
  factory $AIWritingPracticeCopyWith(AIWritingPractice value, $Res Function(AIWritingPractice) _then) = _$AIWritingPracticeCopyWithImpl;
@useResult
$Res call({
 String id, String odlId, String topic, String topicVi, String prompt, String promptVi, int wordLimit, String userText, List<AIWritingFeedback> feedback, double overallScore, double grammarScore, double vocabularyScore, double coherenceScore, bool isCompleted, DateTime? submittedAt
});




}
/// @nodoc
class _$AIWritingPracticeCopyWithImpl<$Res>
    implements $AIWritingPracticeCopyWith<$Res> {
  _$AIWritingPracticeCopyWithImpl(this._self, this._then);

  final AIWritingPractice _self;
  final $Res Function(AIWritingPractice) _then;

/// Create a copy of AIWritingPractice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? odlId = null,Object? topic = null,Object? topicVi = null,Object? prompt = null,Object? promptVi = null,Object? wordLimit = null,Object? userText = null,Object? feedback = null,Object? overallScore = null,Object? grammarScore = null,Object? vocabularyScore = null,Object? coherenceScore = null,Object? isCompleted = null,Object? submittedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,topicVi: null == topicVi ? _self.topicVi : topicVi // ignore: cast_nullable_to_non_nullable
as String,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,promptVi: null == promptVi ? _self.promptVi : promptVi // ignore: cast_nullable_to_non_nullable
as String,wordLimit: null == wordLimit ? _self.wordLimit : wordLimit // ignore: cast_nullable_to_non_nullable
as int,userText: null == userText ? _self.userText : userText // ignore: cast_nullable_to_non_nullable
as String,feedback: null == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as List<AIWritingFeedback>,overallScore: null == overallScore ? _self.overallScore : overallScore // ignore: cast_nullable_to_non_nullable
as double,grammarScore: null == grammarScore ? _self.grammarScore : grammarScore // ignore: cast_nullable_to_non_nullable
as double,vocabularyScore: null == vocabularyScore ? _self.vocabularyScore : vocabularyScore // ignore: cast_nullable_to_non_nullable
as double,coherenceScore: null == coherenceScore ? _self.coherenceScore : coherenceScore // ignore: cast_nullable_to_non_nullable
as double,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AIWritingPractice].
extension AIWritingPracticePatterns on AIWritingPractice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AIWritingPractice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AIWritingPractice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AIWritingPractice value)  $default,){
final _that = this;
switch (_that) {
case _AIWritingPractice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AIWritingPractice value)?  $default,){
final _that = this;
switch (_that) {
case _AIWritingPractice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String odlId,  String topic,  String topicVi,  String prompt,  String promptVi,  int wordLimit,  String userText,  List<AIWritingFeedback> feedback,  double overallScore,  double grammarScore,  double vocabularyScore,  double coherenceScore,  bool isCompleted,  DateTime? submittedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AIWritingPractice() when $default != null:
return $default(_that.id,_that.odlId,_that.topic,_that.topicVi,_that.prompt,_that.promptVi,_that.wordLimit,_that.userText,_that.feedback,_that.overallScore,_that.grammarScore,_that.vocabularyScore,_that.coherenceScore,_that.isCompleted,_that.submittedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String odlId,  String topic,  String topicVi,  String prompt,  String promptVi,  int wordLimit,  String userText,  List<AIWritingFeedback> feedback,  double overallScore,  double grammarScore,  double vocabularyScore,  double coherenceScore,  bool isCompleted,  DateTime? submittedAt)  $default,) {final _that = this;
switch (_that) {
case _AIWritingPractice():
return $default(_that.id,_that.odlId,_that.topic,_that.topicVi,_that.prompt,_that.promptVi,_that.wordLimit,_that.userText,_that.feedback,_that.overallScore,_that.grammarScore,_that.vocabularyScore,_that.coherenceScore,_that.isCompleted,_that.submittedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String odlId,  String topic,  String topicVi,  String prompt,  String promptVi,  int wordLimit,  String userText,  List<AIWritingFeedback> feedback,  double overallScore,  double grammarScore,  double vocabularyScore,  double coherenceScore,  bool isCompleted,  DateTime? submittedAt)?  $default,) {final _that = this;
switch (_that) {
case _AIWritingPractice() when $default != null:
return $default(_that.id,_that.odlId,_that.topic,_that.topicVi,_that.prompt,_that.promptVi,_that.wordLimit,_that.userText,_that.feedback,_that.overallScore,_that.grammarScore,_that.vocabularyScore,_that.coherenceScore,_that.isCompleted,_that.submittedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AIWritingPractice implements AIWritingPractice {
  const _AIWritingPractice({required this.id, required this.odlId, required this.topic, required this.topicVi, this.prompt = '', this.promptVi = '', this.wordLimit = 0, this.userText = '', final  List<AIWritingFeedback> feedback = const <AIWritingFeedback>[], this.overallScore = 0.0, this.grammarScore = 0.0, this.vocabularyScore = 0.0, this.coherenceScore = 0.0, this.isCompleted = false, this.submittedAt}): _feedback = feedback;
  factory _AIWritingPractice.fromJson(Map<String, dynamic> json) => _$AIWritingPracticeFromJson(json);

@override final  String id;
@override final  String odlId;
@override final  String topic;
@override final  String topicVi;
@override@JsonKey() final  String prompt;
@override@JsonKey() final  String promptVi;
@override@JsonKey() final  int wordLimit;
@override@JsonKey() final  String userText;
 final  List<AIWritingFeedback> _feedback;
@override@JsonKey() List<AIWritingFeedback> get feedback {
  if (_feedback is EqualUnmodifiableListView) return _feedback;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_feedback);
}

@override@JsonKey() final  double overallScore;
@override@JsonKey() final  double grammarScore;
@override@JsonKey() final  double vocabularyScore;
@override@JsonKey() final  double coherenceScore;
@override@JsonKey() final  bool isCompleted;
@override final  DateTime? submittedAt;

/// Create a copy of AIWritingPractice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AIWritingPracticeCopyWith<_AIWritingPractice> get copyWith => __$AIWritingPracticeCopyWithImpl<_AIWritingPractice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AIWritingPracticeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AIWritingPractice&&(identical(other.id, id) || other.id == id)&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.topicVi, topicVi) || other.topicVi == topicVi)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.promptVi, promptVi) || other.promptVi == promptVi)&&(identical(other.wordLimit, wordLimit) || other.wordLimit == wordLimit)&&(identical(other.userText, userText) || other.userText == userText)&&const DeepCollectionEquality().equals(other._feedback, _feedback)&&(identical(other.overallScore, overallScore) || other.overallScore == overallScore)&&(identical(other.grammarScore, grammarScore) || other.grammarScore == grammarScore)&&(identical(other.vocabularyScore, vocabularyScore) || other.vocabularyScore == vocabularyScore)&&(identical(other.coherenceScore, coherenceScore) || other.coherenceScore == coherenceScore)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,odlId,topic,topicVi,prompt,promptVi,wordLimit,userText,const DeepCollectionEquality().hash(_feedback),overallScore,grammarScore,vocabularyScore,coherenceScore,isCompleted,submittedAt);

@override
String toString() {
  return 'AIWritingPractice(id: $id, odlId: $odlId, topic: $topic, topicVi: $topicVi, prompt: $prompt, promptVi: $promptVi, wordLimit: $wordLimit, userText: $userText, feedback: $feedback, overallScore: $overallScore, grammarScore: $grammarScore, vocabularyScore: $vocabularyScore, coherenceScore: $coherenceScore, isCompleted: $isCompleted, submittedAt: $submittedAt)';
}


}

/// @nodoc
abstract mixin class _$AIWritingPracticeCopyWith<$Res> implements $AIWritingPracticeCopyWith<$Res> {
  factory _$AIWritingPracticeCopyWith(_AIWritingPractice value, $Res Function(_AIWritingPractice) _then) = __$AIWritingPracticeCopyWithImpl;
@override @useResult
$Res call({
 String id, String odlId, String topic, String topicVi, String prompt, String promptVi, int wordLimit, String userText, List<AIWritingFeedback> feedback, double overallScore, double grammarScore, double vocabularyScore, double coherenceScore, bool isCompleted, DateTime? submittedAt
});




}
/// @nodoc
class __$AIWritingPracticeCopyWithImpl<$Res>
    implements _$AIWritingPracticeCopyWith<$Res> {
  __$AIWritingPracticeCopyWithImpl(this._self, this._then);

  final _AIWritingPractice _self;
  final $Res Function(_AIWritingPractice) _then;

/// Create a copy of AIWritingPractice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? odlId = null,Object? topic = null,Object? topicVi = null,Object? prompt = null,Object? promptVi = null,Object? wordLimit = null,Object? userText = null,Object? feedback = null,Object? overallScore = null,Object? grammarScore = null,Object? vocabularyScore = null,Object? coherenceScore = null,Object? isCompleted = null,Object? submittedAt = freezed,}) {
  return _then(_AIWritingPractice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,topicVi: null == topicVi ? _self.topicVi : topicVi // ignore: cast_nullable_to_non_nullable
as String,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,promptVi: null == promptVi ? _self.promptVi : promptVi // ignore: cast_nullable_to_non_nullable
as String,wordLimit: null == wordLimit ? _self.wordLimit : wordLimit // ignore: cast_nullable_to_non_nullable
as int,userText: null == userText ? _self.userText : userText // ignore: cast_nullable_to_non_nullable
as String,feedback: null == feedback ? _self._feedback : feedback // ignore: cast_nullable_to_non_nullable
as List<AIWritingFeedback>,overallScore: null == overallScore ? _self.overallScore : overallScore // ignore: cast_nullable_to_non_nullable
as double,grammarScore: null == grammarScore ? _self.grammarScore : grammarScore // ignore: cast_nullable_to_non_nullable
as double,vocabularyScore: null == vocabularyScore ? _self.vocabularyScore : vocabularyScore // ignore: cast_nullable_to_non_nullable
as double,coherenceScore: null == coherenceScore ? _self.coherenceScore : coherenceScore // ignore: cast_nullable_to_non_nullable
as double,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AIWritingFeedback {

 String get id; String get practiceId; String get type; String get original; String get suggestion; String get explanation; int get startIndex; int get endIndex;
/// Create a copy of AIWritingFeedback
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AIWritingFeedbackCopyWith<AIWritingFeedback> get copyWith => _$AIWritingFeedbackCopyWithImpl<AIWritingFeedback>(this as AIWritingFeedback, _$identity);

  /// Serializes this AIWritingFeedback to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AIWritingFeedback&&(identical(other.id, id) || other.id == id)&&(identical(other.practiceId, practiceId) || other.practiceId == practiceId)&&(identical(other.type, type) || other.type == type)&&(identical(other.original, original) || other.original == original)&&(identical(other.suggestion, suggestion) || other.suggestion == suggestion)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.startIndex, startIndex) || other.startIndex == startIndex)&&(identical(other.endIndex, endIndex) || other.endIndex == endIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,practiceId,type,original,suggestion,explanation,startIndex,endIndex);

@override
String toString() {
  return 'AIWritingFeedback(id: $id, practiceId: $practiceId, type: $type, original: $original, suggestion: $suggestion, explanation: $explanation, startIndex: $startIndex, endIndex: $endIndex)';
}


}

/// @nodoc
abstract mixin class $AIWritingFeedbackCopyWith<$Res>  {
  factory $AIWritingFeedbackCopyWith(AIWritingFeedback value, $Res Function(AIWritingFeedback) _then) = _$AIWritingFeedbackCopyWithImpl;
@useResult
$Res call({
 String id, String practiceId, String type, String original, String suggestion, String explanation, int startIndex, int endIndex
});




}
/// @nodoc
class _$AIWritingFeedbackCopyWithImpl<$Res>
    implements $AIWritingFeedbackCopyWith<$Res> {
  _$AIWritingFeedbackCopyWithImpl(this._self, this._then);

  final AIWritingFeedback _self;
  final $Res Function(AIWritingFeedback) _then;

/// Create a copy of AIWritingFeedback
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? practiceId = null,Object? type = null,Object? original = null,Object? suggestion = null,Object? explanation = null,Object? startIndex = null,Object? endIndex = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,practiceId: null == practiceId ? _self.practiceId : practiceId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as String,suggestion: null == suggestion ? _self.suggestion : suggestion // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,startIndex: null == startIndex ? _self.startIndex : startIndex // ignore: cast_nullable_to_non_nullable
as int,endIndex: null == endIndex ? _self.endIndex : endIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AIWritingFeedback].
extension AIWritingFeedbackPatterns on AIWritingFeedback {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AIWritingFeedback value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AIWritingFeedback() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AIWritingFeedback value)  $default,){
final _that = this;
switch (_that) {
case _AIWritingFeedback():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AIWritingFeedback value)?  $default,){
final _that = this;
switch (_that) {
case _AIWritingFeedback() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String practiceId,  String type,  String original,  String suggestion,  String explanation,  int startIndex,  int endIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AIWritingFeedback() when $default != null:
return $default(_that.id,_that.practiceId,_that.type,_that.original,_that.suggestion,_that.explanation,_that.startIndex,_that.endIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String practiceId,  String type,  String original,  String suggestion,  String explanation,  int startIndex,  int endIndex)  $default,) {final _that = this;
switch (_that) {
case _AIWritingFeedback():
return $default(_that.id,_that.practiceId,_that.type,_that.original,_that.suggestion,_that.explanation,_that.startIndex,_that.endIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String practiceId,  String type,  String original,  String suggestion,  String explanation,  int startIndex,  int endIndex)?  $default,) {final _that = this;
switch (_that) {
case _AIWritingFeedback() when $default != null:
return $default(_that.id,_that.practiceId,_that.type,_that.original,_that.suggestion,_that.explanation,_that.startIndex,_that.endIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AIWritingFeedback implements AIWritingFeedback {
  const _AIWritingFeedback({required this.id, required this.practiceId, required this.type, required this.original, this.suggestion = '', this.explanation = '', this.startIndex = 0, this.endIndex = 0});
  factory _AIWritingFeedback.fromJson(Map<String, dynamic> json) => _$AIWritingFeedbackFromJson(json);

@override final  String id;
@override final  String practiceId;
@override final  String type;
@override final  String original;
@override@JsonKey() final  String suggestion;
@override@JsonKey() final  String explanation;
@override@JsonKey() final  int startIndex;
@override@JsonKey() final  int endIndex;

/// Create a copy of AIWritingFeedback
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AIWritingFeedbackCopyWith<_AIWritingFeedback> get copyWith => __$AIWritingFeedbackCopyWithImpl<_AIWritingFeedback>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AIWritingFeedbackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AIWritingFeedback&&(identical(other.id, id) || other.id == id)&&(identical(other.practiceId, practiceId) || other.practiceId == practiceId)&&(identical(other.type, type) || other.type == type)&&(identical(other.original, original) || other.original == original)&&(identical(other.suggestion, suggestion) || other.suggestion == suggestion)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.startIndex, startIndex) || other.startIndex == startIndex)&&(identical(other.endIndex, endIndex) || other.endIndex == endIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,practiceId,type,original,suggestion,explanation,startIndex,endIndex);

@override
String toString() {
  return 'AIWritingFeedback(id: $id, practiceId: $practiceId, type: $type, original: $original, suggestion: $suggestion, explanation: $explanation, startIndex: $startIndex, endIndex: $endIndex)';
}


}

/// @nodoc
abstract mixin class _$AIWritingFeedbackCopyWith<$Res> implements $AIWritingFeedbackCopyWith<$Res> {
  factory _$AIWritingFeedbackCopyWith(_AIWritingFeedback value, $Res Function(_AIWritingFeedback) _then) = __$AIWritingFeedbackCopyWithImpl;
@override @useResult
$Res call({
 String id, String practiceId, String type, String original, String suggestion, String explanation, int startIndex, int endIndex
});




}
/// @nodoc
class __$AIWritingFeedbackCopyWithImpl<$Res>
    implements _$AIWritingFeedbackCopyWith<$Res> {
  __$AIWritingFeedbackCopyWithImpl(this._self, this._then);

  final _AIWritingFeedback _self;
  final $Res Function(_AIWritingFeedback) _then;

/// Create a copy of AIWritingFeedback
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? practiceId = null,Object? type = null,Object? original = null,Object? suggestion = null,Object? explanation = null,Object? startIndex = null,Object? endIndex = null,}) {
  return _then(_AIWritingFeedback(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,practiceId: null == practiceId ? _self.practiceId : practiceId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as String,suggestion: null == suggestion ? _self.suggestion : suggestion // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,startIndex: null == startIndex ? _self.startIndex : startIndex // ignore: cast_nullable_to_non_nullable
as int,endIndex: null == endIndex ? _self.endIndex : endIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AITutorMode {

 String get id; String get name; String get nameVi; String get description; String get descriptionVi; String get avatar; String get tone; String get focus;
/// Create a copy of AITutorMode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AITutorModeCopyWith<AITutorMode> get copyWith => _$AITutorModeCopyWithImpl<AITutorMode>(this as AITutorMode, _$identity);

  /// Serializes this AITutorMode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AITutorMode&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.focus, focus) || other.focus == focus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameVi,description,descriptionVi,avatar,tone,focus);

@override
String toString() {
  return 'AITutorMode(id: $id, name: $name, nameVi: $nameVi, description: $description, descriptionVi: $descriptionVi, avatar: $avatar, tone: $tone, focus: $focus)';
}


}

/// @nodoc
abstract mixin class $AITutorModeCopyWith<$Res>  {
  factory $AITutorModeCopyWith(AITutorMode value, $Res Function(AITutorMode) _then) = _$AITutorModeCopyWithImpl;
@useResult
$Res call({
 String id, String name, String nameVi, String description, String descriptionVi, String avatar, String tone, String focus
});




}
/// @nodoc
class _$AITutorModeCopyWithImpl<$Res>
    implements $AITutorModeCopyWith<$Res> {
  _$AITutorModeCopyWithImpl(this._self, this._then);

  final AITutorMode _self;
  final $Res Function(AITutorMode) _then;

/// Create a copy of AITutorMode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nameVi = null,Object? description = null,Object? descriptionVi = null,Object? avatar = null,Object? tone = null,Object? focus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameVi: null == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as String,focus: null == focus ? _self.focus : focus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AITutorMode].
extension AITutorModePatterns on AITutorMode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AITutorMode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AITutorMode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AITutorMode value)  $default,){
final _that = this;
switch (_that) {
case _AITutorMode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AITutorMode value)?  $default,){
final _that = this;
switch (_that) {
case _AITutorMode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String nameVi,  String description,  String descriptionVi,  String avatar,  String tone,  String focus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AITutorMode() when $default != null:
return $default(_that.id,_that.name,_that.nameVi,_that.description,_that.descriptionVi,_that.avatar,_that.tone,_that.focus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String nameVi,  String description,  String descriptionVi,  String avatar,  String tone,  String focus)  $default,) {final _that = this;
switch (_that) {
case _AITutorMode():
return $default(_that.id,_that.name,_that.nameVi,_that.description,_that.descriptionVi,_that.avatar,_that.tone,_that.focus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String nameVi,  String description,  String descriptionVi,  String avatar,  String tone,  String focus)?  $default,) {final _that = this;
switch (_that) {
case _AITutorMode() when $default != null:
return $default(_that.id,_that.name,_that.nameVi,_that.description,_that.descriptionVi,_that.avatar,_that.tone,_that.focus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AITutorMode implements AITutorMode {
  const _AITutorMode({required this.id, required this.name, required this.nameVi, required this.description, this.descriptionVi = '', this.avatar = '', this.tone = 'formal', this.focus = 'grammar'});
  factory _AITutorMode.fromJson(Map<String, dynamic> json) => _$AITutorModeFromJson(json);

@override final  String id;
@override final  String name;
@override final  String nameVi;
@override final  String description;
@override@JsonKey() final  String descriptionVi;
@override@JsonKey() final  String avatar;
@override@JsonKey() final  String tone;
@override@JsonKey() final  String focus;

/// Create a copy of AITutorMode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AITutorModeCopyWith<_AITutorMode> get copyWith => __$AITutorModeCopyWithImpl<_AITutorMode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AITutorModeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AITutorMode&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.focus, focus) || other.focus == focus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameVi,description,descriptionVi,avatar,tone,focus);

@override
String toString() {
  return 'AITutorMode(id: $id, name: $name, nameVi: $nameVi, description: $description, descriptionVi: $descriptionVi, avatar: $avatar, tone: $tone, focus: $focus)';
}


}

/// @nodoc
abstract mixin class _$AITutorModeCopyWith<$Res> implements $AITutorModeCopyWith<$Res> {
  factory _$AITutorModeCopyWith(_AITutorMode value, $Res Function(_AITutorMode) _then) = __$AITutorModeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String nameVi, String description, String descriptionVi, String avatar, String tone, String focus
});




}
/// @nodoc
class __$AITutorModeCopyWithImpl<$Res>
    implements _$AITutorModeCopyWith<$Res> {
  __$AITutorModeCopyWithImpl(this._self, this._then);

  final _AITutorMode _self;
  final $Res Function(_AITutorMode) _then;

/// Create a copy of AITutorMode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nameVi = null,Object? description = null,Object? descriptionVi = null,Object? avatar = null,Object? tone = null,Object? focus = null,}) {
  return _then(_AITutorMode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameVi: null == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as String,focus: null == focus ? _self.focus : focus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
