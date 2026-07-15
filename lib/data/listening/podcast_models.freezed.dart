// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'podcast_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PodcastEpisode {

 String get slug; String get title; int get duration; int get segments;
/// Create a copy of PodcastEpisode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastEpisodeCopyWith<PodcastEpisode> get copyWith => _$PodcastEpisodeCopyWithImpl<PodcastEpisode>(this as PodcastEpisode, _$identity);

  /// Serializes this PodcastEpisode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastEpisode&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.segments, segments) || other.segments == segments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,title,duration,segments);

@override
String toString() {
  return 'PodcastEpisode(slug: $slug, title: $title, duration: $duration, segments: $segments)';
}


}

/// @nodoc
abstract mixin class $PodcastEpisodeCopyWith<$Res>  {
  factory $PodcastEpisodeCopyWith(PodcastEpisode value, $Res Function(PodcastEpisode) _then) = _$PodcastEpisodeCopyWithImpl;
@useResult
$Res call({
 String slug, String title, int duration, int segments
});




}
/// @nodoc
class _$PodcastEpisodeCopyWithImpl<$Res>
    implements $PodcastEpisodeCopyWith<$Res> {
  _$PodcastEpisodeCopyWithImpl(this._self, this._then);

  final PodcastEpisode _self;
  final $Res Function(PodcastEpisode) _then;

/// Create a copy of PodcastEpisode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? title = null,Object? duration = null,Object? segments = null,}) {
  return _then(_self.copyWith(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,segments: null == segments ? _self.segments : segments // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PodcastEpisode].
extension PodcastEpisodePatterns on PodcastEpisode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastEpisode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastEpisode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastEpisode value)  $default,){
final _that = this;
switch (_that) {
case _PodcastEpisode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastEpisode value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastEpisode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String title,  int duration,  int segments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastEpisode() when $default != null:
return $default(_that.slug,_that.title,_that.duration,_that.segments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String title,  int duration,  int segments)  $default,) {final _that = this;
switch (_that) {
case _PodcastEpisode():
return $default(_that.slug,_that.title,_that.duration,_that.segments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String title,  int duration,  int segments)?  $default,) {final _that = this;
switch (_that) {
case _PodcastEpisode() when $default != null:
return $default(_that.slug,_that.title,_that.duration,_that.segments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PodcastEpisode implements PodcastEpisode {
  const _PodcastEpisode({required this.slug, required this.title, this.duration = 0, this.segments = 0});
  factory _PodcastEpisode.fromJson(Map<String, dynamic> json) => _$PodcastEpisodeFromJson(json);

@override final  String slug;
@override final  String title;
@override@JsonKey() final  int duration;
@override@JsonKey() final  int segments;

/// Create a copy of PodcastEpisode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastEpisodeCopyWith<_PodcastEpisode> get copyWith => __$PodcastEpisodeCopyWithImpl<_PodcastEpisode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PodcastEpisodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastEpisode&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.segments, segments) || other.segments == segments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,title,duration,segments);

@override
String toString() {
  return 'PodcastEpisode(slug: $slug, title: $title, duration: $duration, segments: $segments)';
}


}

/// @nodoc
abstract mixin class _$PodcastEpisodeCopyWith<$Res> implements $PodcastEpisodeCopyWith<$Res> {
  factory _$PodcastEpisodeCopyWith(_PodcastEpisode value, $Res Function(_PodcastEpisode) _then) = __$PodcastEpisodeCopyWithImpl;
@override @useResult
$Res call({
 String slug, String title, int duration, int segments
});




}
/// @nodoc
class __$PodcastEpisodeCopyWithImpl<$Res>
    implements _$PodcastEpisodeCopyWith<$Res> {
  __$PodcastEpisodeCopyWithImpl(this._self, this._then);

  final _PodcastEpisode _self;
  final $Res Function(_PodcastEpisode) _then;

/// Create a copy of PodcastEpisode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? title = null,Object? duration = null,Object? segments = null,}) {
  return _then(_PodcastEpisode(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,segments: null == segments ? _self.segments : segments // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PodcastWord {

@JsonKey(name: 'w') String get text;@JsonKey(name: 's') double get start;@JsonKey(name: 'e') double get end;
/// Create a copy of PodcastWord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastWordCopyWith<PodcastWord> get copyWith => _$PodcastWordCopyWithImpl<PodcastWord>(this as PodcastWord, _$identity);

  /// Serializes this PodcastWord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastWord&&(identical(other.text, text) || other.text == text)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,start,end);

@override
String toString() {
  return 'PodcastWord(text: $text, start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class $PodcastWordCopyWith<$Res>  {
  factory $PodcastWordCopyWith(PodcastWord value, $Res Function(PodcastWord) _then) = _$PodcastWordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'w') String text,@JsonKey(name: 's') double start,@JsonKey(name: 'e') double end
});




}
/// @nodoc
class _$PodcastWordCopyWithImpl<$Res>
    implements $PodcastWordCopyWith<$Res> {
  _$PodcastWordCopyWithImpl(this._self, this._then);

  final PodcastWord _self;
  final $Res Function(PodcastWord) _then;

/// Create a copy of PodcastWord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? start = null,Object? end = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as double,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PodcastWord].
extension PodcastWordPatterns on PodcastWord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastWord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastWord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastWord value)  $default,){
final _that = this;
switch (_that) {
case _PodcastWord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastWord value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastWord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'w')  String text, @JsonKey(name: 's')  double start, @JsonKey(name: 'e')  double end)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastWord() when $default != null:
return $default(_that.text,_that.start,_that.end);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'w')  String text, @JsonKey(name: 's')  double start, @JsonKey(name: 'e')  double end)  $default,) {final _that = this;
switch (_that) {
case _PodcastWord():
return $default(_that.text,_that.start,_that.end);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'w')  String text, @JsonKey(name: 's')  double start, @JsonKey(name: 'e')  double end)?  $default,) {final _that = this;
switch (_that) {
case _PodcastWord() when $default != null:
return $default(_that.text,_that.start,_that.end);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PodcastWord implements PodcastWord {
  const _PodcastWord({@JsonKey(name: 'w') this.text = '', @JsonKey(name: 's') this.start = 0.0, @JsonKey(name: 'e') this.end = 0.0});
  factory _PodcastWord.fromJson(Map<String, dynamic> json) => _$PodcastWordFromJson(json);

@override@JsonKey(name: 'w') final  String text;
@override@JsonKey(name: 's') final  double start;
@override@JsonKey(name: 'e') final  double end;

/// Create a copy of PodcastWord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastWordCopyWith<_PodcastWord> get copyWith => __$PodcastWordCopyWithImpl<_PodcastWord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PodcastWordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastWord&&(identical(other.text, text) || other.text == text)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,start,end);

@override
String toString() {
  return 'PodcastWord(text: $text, start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class _$PodcastWordCopyWith<$Res> implements $PodcastWordCopyWith<$Res> {
  factory _$PodcastWordCopyWith(_PodcastWord value, $Res Function(_PodcastWord) _then) = __$PodcastWordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'w') String text,@JsonKey(name: 's') double start,@JsonKey(name: 'e') double end
});




}
/// @nodoc
class __$PodcastWordCopyWithImpl<$Res>
    implements _$PodcastWordCopyWith<$Res> {
  __$PodcastWordCopyWithImpl(this._self, this._then);

  final _PodcastWord _self;
  final $Res Function(_PodcastWord) _then;

/// Create a copy of PodcastWord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? start = null,Object? end = null,}) {
  return _then(_PodcastWord(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as double,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$PodcastSentence {

 String get text;@JsonKey(name: 'text_vi') String get textVi; double get start; double get end; List<PodcastWord> get words;
/// Create a copy of PodcastSentence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastSentenceCopyWith<PodcastSentence> get copyWith => _$PodcastSentenceCopyWithImpl<PodcastSentence>(this as PodcastSentence, _$identity);

  /// Serializes this PodcastSentence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastSentence&&(identical(other.text, text) || other.text == text)&&(identical(other.textVi, textVi) || other.textVi == textVi)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&const DeepCollectionEquality().equals(other.words, words));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,textVi,start,end,const DeepCollectionEquality().hash(words));

@override
String toString() {
  return 'PodcastSentence(text: $text, textVi: $textVi, start: $start, end: $end, words: $words)';
}


}

/// @nodoc
abstract mixin class $PodcastSentenceCopyWith<$Res>  {
  factory $PodcastSentenceCopyWith(PodcastSentence value, $Res Function(PodcastSentence) _then) = _$PodcastSentenceCopyWithImpl;
@useResult
$Res call({
 String text,@JsonKey(name: 'text_vi') String textVi, double start, double end, List<PodcastWord> words
});




}
/// @nodoc
class _$PodcastSentenceCopyWithImpl<$Res>
    implements $PodcastSentenceCopyWith<$Res> {
  _$PodcastSentenceCopyWithImpl(this._self, this._then);

  final PodcastSentence _self;
  final $Res Function(PodcastSentence) _then;

/// Create a copy of PodcastSentence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? textVi = null,Object? start = null,Object? end = null,Object? words = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,textVi: null == textVi ? _self.textVi : textVi // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as double,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as double,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as List<PodcastWord>,
  ));
}

}


/// Adds pattern-matching-related methods to [PodcastSentence].
extension PodcastSentencePatterns on PodcastSentence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastSentence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastSentence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastSentence value)  $default,){
final _that = this;
switch (_that) {
case _PodcastSentence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastSentence value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastSentence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text, @JsonKey(name: 'text_vi')  String textVi,  double start,  double end,  List<PodcastWord> words)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastSentence() when $default != null:
return $default(_that.text,_that.textVi,_that.start,_that.end,_that.words);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text, @JsonKey(name: 'text_vi')  String textVi,  double start,  double end,  List<PodcastWord> words)  $default,) {final _that = this;
switch (_that) {
case _PodcastSentence():
return $default(_that.text,_that.textVi,_that.start,_that.end,_that.words);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text, @JsonKey(name: 'text_vi')  String textVi,  double start,  double end,  List<PodcastWord> words)?  $default,) {final _that = this;
switch (_that) {
case _PodcastSentence() when $default != null:
return $default(_that.text,_that.textVi,_that.start,_that.end,_that.words);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PodcastSentence implements PodcastSentence {
  const _PodcastSentence({this.text = '', @JsonKey(name: 'text_vi') this.textVi = '', this.start = 0.0, this.end = 0.0, final  List<PodcastWord> words = const <PodcastWord>[]}): _words = words;
  factory _PodcastSentence.fromJson(Map<String, dynamic> json) => _$PodcastSentenceFromJson(json);

@override@JsonKey() final  String text;
@override@JsonKey(name: 'text_vi') final  String textVi;
@override@JsonKey() final  double start;
@override@JsonKey() final  double end;
 final  List<PodcastWord> _words;
@override@JsonKey() List<PodcastWord> get words {
  if (_words is EqualUnmodifiableListView) return _words;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_words);
}


/// Create a copy of PodcastSentence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastSentenceCopyWith<_PodcastSentence> get copyWith => __$PodcastSentenceCopyWithImpl<_PodcastSentence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PodcastSentenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastSentence&&(identical(other.text, text) || other.text == text)&&(identical(other.textVi, textVi) || other.textVi == textVi)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&const DeepCollectionEquality().equals(other._words, _words));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,textVi,start,end,const DeepCollectionEquality().hash(_words));

@override
String toString() {
  return 'PodcastSentence(text: $text, textVi: $textVi, start: $start, end: $end, words: $words)';
}


}

/// @nodoc
abstract mixin class _$PodcastSentenceCopyWith<$Res> implements $PodcastSentenceCopyWith<$Res> {
  factory _$PodcastSentenceCopyWith(_PodcastSentence value, $Res Function(_PodcastSentence) _then) = __$PodcastSentenceCopyWithImpl;
@override @useResult
$Res call({
 String text,@JsonKey(name: 'text_vi') String textVi, double start, double end, List<PodcastWord> words
});




}
/// @nodoc
class __$PodcastSentenceCopyWithImpl<$Res>
    implements _$PodcastSentenceCopyWith<$Res> {
  __$PodcastSentenceCopyWithImpl(this._self, this._then);

  final _PodcastSentence _self;
  final $Res Function(_PodcastSentence) _then;

/// Create a copy of PodcastSentence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? textVi = null,Object? start = null,Object? end = null,Object? words = null,}) {
  return _then(_PodcastSentence(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,textVi: null == textVi ? _self.textVi : textVi // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as double,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as double,words: null == words ? _self._words : words // ignore: cast_nullable_to_non_nullable
as List<PodcastWord>,
  ));
}


}


/// @nodoc
mixin _$PodcastEpisodeDetail {

 String get slug; String get title;@JsonKey(name: 'mp3_url') String get mp3Url; int get duration; List<PodcastSentence> get sentences;
/// Create a copy of PodcastEpisodeDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastEpisodeDetailCopyWith<PodcastEpisodeDetail> get copyWith => _$PodcastEpisodeDetailCopyWithImpl<PodcastEpisodeDetail>(this as PodcastEpisodeDetail, _$identity);

  /// Serializes this PodcastEpisodeDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastEpisodeDetail&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.mp3Url, mp3Url) || other.mp3Url == mp3Url)&&(identical(other.duration, duration) || other.duration == duration)&&const DeepCollectionEquality().equals(other.sentences, sentences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,title,mp3Url,duration,const DeepCollectionEquality().hash(sentences));

@override
String toString() {
  return 'PodcastEpisodeDetail(slug: $slug, title: $title, mp3Url: $mp3Url, duration: $duration, sentences: $sentences)';
}


}

/// @nodoc
abstract mixin class $PodcastEpisodeDetailCopyWith<$Res>  {
  factory $PodcastEpisodeDetailCopyWith(PodcastEpisodeDetail value, $Res Function(PodcastEpisodeDetail) _then) = _$PodcastEpisodeDetailCopyWithImpl;
@useResult
$Res call({
 String slug, String title,@JsonKey(name: 'mp3_url') String mp3Url, int duration, List<PodcastSentence> sentences
});




}
/// @nodoc
class _$PodcastEpisodeDetailCopyWithImpl<$Res>
    implements $PodcastEpisodeDetailCopyWith<$Res> {
  _$PodcastEpisodeDetailCopyWithImpl(this._self, this._then);

  final PodcastEpisodeDetail _self;
  final $Res Function(PodcastEpisodeDetail) _then;

/// Create a copy of PodcastEpisodeDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? title = null,Object? mp3Url = null,Object? duration = null,Object? sentences = null,}) {
  return _then(_self.copyWith(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,mp3Url: null == mp3Url ? _self.mp3Url : mp3Url // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,sentences: null == sentences ? _self.sentences : sentences // ignore: cast_nullable_to_non_nullable
as List<PodcastSentence>,
  ));
}

}


/// Adds pattern-matching-related methods to [PodcastEpisodeDetail].
extension PodcastEpisodeDetailPatterns on PodcastEpisodeDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastEpisodeDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastEpisodeDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastEpisodeDetail value)  $default,){
final _that = this;
switch (_that) {
case _PodcastEpisodeDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastEpisodeDetail value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastEpisodeDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String title, @JsonKey(name: 'mp3_url')  String mp3Url,  int duration,  List<PodcastSentence> sentences)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastEpisodeDetail() when $default != null:
return $default(_that.slug,_that.title,_that.mp3Url,_that.duration,_that.sentences);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String title, @JsonKey(name: 'mp3_url')  String mp3Url,  int duration,  List<PodcastSentence> sentences)  $default,) {final _that = this;
switch (_that) {
case _PodcastEpisodeDetail():
return $default(_that.slug,_that.title,_that.mp3Url,_that.duration,_that.sentences);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String title, @JsonKey(name: 'mp3_url')  String mp3Url,  int duration,  List<PodcastSentence> sentences)?  $default,) {final _that = this;
switch (_that) {
case _PodcastEpisodeDetail() when $default != null:
return $default(_that.slug,_that.title,_that.mp3Url,_that.duration,_that.sentences);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PodcastEpisodeDetail implements PodcastEpisodeDetail {
  const _PodcastEpisodeDetail({required this.slug, required this.title, @JsonKey(name: 'mp3_url') this.mp3Url = '', this.duration = 0, final  List<PodcastSentence> sentences = const <PodcastSentence>[]}): _sentences = sentences;
  factory _PodcastEpisodeDetail.fromJson(Map<String, dynamic> json) => _$PodcastEpisodeDetailFromJson(json);

@override final  String slug;
@override final  String title;
@override@JsonKey(name: 'mp3_url') final  String mp3Url;
@override@JsonKey() final  int duration;
 final  List<PodcastSentence> _sentences;
@override@JsonKey() List<PodcastSentence> get sentences {
  if (_sentences is EqualUnmodifiableListView) return _sentences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sentences);
}


/// Create a copy of PodcastEpisodeDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastEpisodeDetailCopyWith<_PodcastEpisodeDetail> get copyWith => __$PodcastEpisodeDetailCopyWithImpl<_PodcastEpisodeDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PodcastEpisodeDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastEpisodeDetail&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.mp3Url, mp3Url) || other.mp3Url == mp3Url)&&(identical(other.duration, duration) || other.duration == duration)&&const DeepCollectionEquality().equals(other._sentences, _sentences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,title,mp3Url,duration,const DeepCollectionEquality().hash(_sentences));

@override
String toString() {
  return 'PodcastEpisodeDetail(slug: $slug, title: $title, mp3Url: $mp3Url, duration: $duration, sentences: $sentences)';
}


}

/// @nodoc
abstract mixin class _$PodcastEpisodeDetailCopyWith<$Res> implements $PodcastEpisodeDetailCopyWith<$Res> {
  factory _$PodcastEpisodeDetailCopyWith(_PodcastEpisodeDetail value, $Res Function(_PodcastEpisodeDetail) _then) = __$PodcastEpisodeDetailCopyWithImpl;
@override @useResult
$Res call({
 String slug, String title,@JsonKey(name: 'mp3_url') String mp3Url, int duration, List<PodcastSentence> sentences
});




}
/// @nodoc
class __$PodcastEpisodeDetailCopyWithImpl<$Res>
    implements _$PodcastEpisodeDetailCopyWith<$Res> {
  __$PodcastEpisodeDetailCopyWithImpl(this._self, this._then);

  final _PodcastEpisodeDetail _self;
  final $Res Function(_PodcastEpisodeDetail) _then;

/// Create a copy of PodcastEpisodeDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? title = null,Object? mp3Url = null,Object? duration = null,Object? sentences = null,}) {
  return _then(_PodcastEpisodeDetail(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,mp3Url: null == mp3Url ? _self.mp3Url : mp3Url // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,sentences: null == sentences ? _self._sentences : sentences // ignore: cast_nullable_to_non_nullable
as List<PodcastSentence>,
  ));
}


}


/// @nodoc
mixin _$PodcastLeaderboardEntry {

@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'display_name') String get displayName;@JsonKey(name: 'avatar_url') String get avatarUrl;@JsonKey(name: 'completed_count') int get completedCount; int get rank;
/// Create a copy of PodcastLeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastLeaderboardEntryCopyWith<PodcastLeaderboardEntry> get copyWith => _$PodcastLeaderboardEntryCopyWithImpl<PodcastLeaderboardEntry>(this as PodcastLeaderboardEntry, _$identity);

  /// Serializes this PodcastLeaderboardEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastLeaderboardEntry&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.rank, rank) || other.rank == rank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,avatarUrl,completedCount,rank);

@override
String toString() {
  return 'PodcastLeaderboardEntry(userId: $userId, displayName: $displayName, avatarUrl: $avatarUrl, completedCount: $completedCount, rank: $rank)';
}


}

/// @nodoc
abstract mixin class $PodcastLeaderboardEntryCopyWith<$Res>  {
  factory $PodcastLeaderboardEntryCopyWith(PodcastLeaderboardEntry value, $Res Function(PodcastLeaderboardEntry) _then) = _$PodcastLeaderboardEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'avatar_url') String avatarUrl,@JsonKey(name: 'completed_count') int completedCount, int rank
});




}
/// @nodoc
class _$PodcastLeaderboardEntryCopyWithImpl<$Res>
    implements $PodcastLeaderboardEntryCopyWith<$Res> {
  _$PodcastLeaderboardEntryCopyWithImpl(this._self, this._then);

  final PodcastLeaderboardEntry _self;
  final $Res Function(PodcastLeaderboardEntry) _then;

/// Create a copy of PodcastLeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? displayName = null,Object? avatarUrl = null,Object? completedCount = null,Object? rank = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PodcastLeaderboardEntry].
extension PodcastLeaderboardEntryPatterns on PodcastLeaderboardEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastLeaderboardEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastLeaderboardEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastLeaderboardEntry value)  $default,){
final _that = this;
switch (_that) {
case _PodcastLeaderboardEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastLeaderboardEntry value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastLeaderboardEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'avatar_url')  String avatarUrl, @JsonKey(name: 'completed_count')  int completedCount,  int rank)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastLeaderboardEntry() when $default != null:
return $default(_that.userId,_that.displayName,_that.avatarUrl,_that.completedCount,_that.rank);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'avatar_url')  String avatarUrl, @JsonKey(name: 'completed_count')  int completedCount,  int rank)  $default,) {final _that = this;
switch (_that) {
case _PodcastLeaderboardEntry():
return $default(_that.userId,_that.displayName,_that.avatarUrl,_that.completedCount,_that.rank);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'avatar_url')  String avatarUrl, @JsonKey(name: 'completed_count')  int completedCount,  int rank)?  $default,) {final _that = this;
switch (_that) {
case _PodcastLeaderboardEntry() when $default != null:
return $default(_that.userId,_that.displayName,_that.avatarUrl,_that.completedCount,_that.rank);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PodcastLeaderboardEntry implements PodcastLeaderboardEntry {
  const _PodcastLeaderboardEntry({@JsonKey(name: 'user_id') this.userId = '', @JsonKey(name: 'display_name') this.displayName = '', @JsonKey(name: 'avatar_url') this.avatarUrl = '', @JsonKey(name: 'completed_count') this.completedCount = 0, this.rank = 0});
  factory _PodcastLeaderboardEntry.fromJson(Map<String, dynamic> json) => _$PodcastLeaderboardEntryFromJson(json);

@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'display_name') final  String displayName;
@override@JsonKey(name: 'avatar_url') final  String avatarUrl;
@override@JsonKey(name: 'completed_count') final  int completedCount;
@override@JsonKey() final  int rank;

/// Create a copy of PodcastLeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastLeaderboardEntryCopyWith<_PodcastLeaderboardEntry> get copyWith => __$PodcastLeaderboardEntryCopyWithImpl<_PodcastLeaderboardEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PodcastLeaderboardEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastLeaderboardEntry&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.rank, rank) || other.rank == rank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,displayName,avatarUrl,completedCount,rank);

@override
String toString() {
  return 'PodcastLeaderboardEntry(userId: $userId, displayName: $displayName, avatarUrl: $avatarUrl, completedCount: $completedCount, rank: $rank)';
}


}

/// @nodoc
abstract mixin class _$PodcastLeaderboardEntryCopyWith<$Res> implements $PodcastLeaderboardEntryCopyWith<$Res> {
  factory _$PodcastLeaderboardEntryCopyWith(_PodcastLeaderboardEntry value, $Res Function(_PodcastLeaderboardEntry) _then) = __$PodcastLeaderboardEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'avatar_url') String avatarUrl,@JsonKey(name: 'completed_count') int completedCount, int rank
});




}
/// @nodoc
class __$PodcastLeaderboardEntryCopyWithImpl<$Res>
    implements _$PodcastLeaderboardEntryCopyWith<$Res> {
  __$PodcastLeaderboardEntryCopyWithImpl(this._self, this._then);

  final _PodcastLeaderboardEntry _self;
  final $Res Function(_PodcastLeaderboardEntry) _then;

/// Create a copy of PodcastLeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? displayName = null,Object? avatarUrl = null,Object? completedCount = null,Object? rank = null,}) {
  return _then(_PodcastLeaderboardEntry(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
