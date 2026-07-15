// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReviewItem {

@JsonKey(name: 'card_review_id') String? get cardReviewId;@JsonKey(name: 'learning_item_id') String? get learningItemId;@JsonKey(name: 'source_flashcard_id') String? get sourceFlashcardId; int get state; DateTime? get due;@JsonKey(name: 'content_de') String? get contentDe;@JsonKey(name: 'content_vi') String? get contentVi;@JsonKey(name: 'audio_url') String? get audioUrl; String? get level;@JsonKey(name: 'word_de') String? get wordDe;@JsonKey(name: 'word_vi') String? get wordVi;@JsonKey(name: 'flashcard_audio_url') String? get flashcardAudioUrl; List<ReviewExample> get examples;
/// Create a copy of ReviewItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewItemCopyWith<ReviewItem> get copyWith => _$ReviewItemCopyWithImpl<ReviewItem>(this as ReviewItem, _$identity);

  /// Serializes this ReviewItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewItem&&(identical(other.cardReviewId, cardReviewId) || other.cardReviewId == cardReviewId)&&(identical(other.learningItemId, learningItemId) || other.learningItemId == learningItemId)&&(identical(other.sourceFlashcardId, sourceFlashcardId) || other.sourceFlashcardId == sourceFlashcardId)&&(identical(other.state, state) || other.state == state)&&(identical(other.due, due) || other.due == due)&&(identical(other.contentDe, contentDe) || other.contentDe == contentDe)&&(identical(other.contentVi, contentVi) || other.contentVi == contentVi)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.level, level) || other.level == level)&&(identical(other.wordDe, wordDe) || other.wordDe == wordDe)&&(identical(other.wordVi, wordVi) || other.wordVi == wordVi)&&(identical(other.flashcardAudioUrl, flashcardAudioUrl) || other.flashcardAudioUrl == flashcardAudioUrl)&&const DeepCollectionEquality().equals(other.examples, examples));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cardReviewId,learningItemId,sourceFlashcardId,state,due,contentDe,contentVi,audioUrl,level,wordDe,wordVi,flashcardAudioUrl,const DeepCollectionEquality().hash(examples));

@override
String toString() {
  return 'ReviewItem(cardReviewId: $cardReviewId, learningItemId: $learningItemId, sourceFlashcardId: $sourceFlashcardId, state: $state, due: $due, contentDe: $contentDe, contentVi: $contentVi, audioUrl: $audioUrl, level: $level, wordDe: $wordDe, wordVi: $wordVi, flashcardAudioUrl: $flashcardAudioUrl, examples: $examples)';
}


}

/// @nodoc
abstract mixin class $ReviewItemCopyWith<$Res>  {
  factory $ReviewItemCopyWith(ReviewItem value, $Res Function(ReviewItem) _then) = _$ReviewItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'card_review_id') String? cardReviewId,@JsonKey(name: 'learning_item_id') String? learningItemId,@JsonKey(name: 'source_flashcard_id') String? sourceFlashcardId, int state, DateTime? due,@JsonKey(name: 'content_de') String? contentDe,@JsonKey(name: 'content_vi') String? contentVi,@JsonKey(name: 'audio_url') String? audioUrl, String? level,@JsonKey(name: 'word_de') String? wordDe,@JsonKey(name: 'word_vi') String? wordVi,@JsonKey(name: 'flashcard_audio_url') String? flashcardAudioUrl, List<ReviewExample> examples
});




}
/// @nodoc
class _$ReviewItemCopyWithImpl<$Res>
    implements $ReviewItemCopyWith<$Res> {
  _$ReviewItemCopyWithImpl(this._self, this._then);

  final ReviewItem _self;
  final $Res Function(ReviewItem) _then;

/// Create a copy of ReviewItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cardReviewId = freezed,Object? learningItemId = freezed,Object? sourceFlashcardId = freezed,Object? state = null,Object? due = freezed,Object? contentDe = freezed,Object? contentVi = freezed,Object? audioUrl = freezed,Object? level = freezed,Object? wordDe = freezed,Object? wordVi = freezed,Object? flashcardAudioUrl = freezed,Object? examples = null,}) {
  return _then(_self.copyWith(
cardReviewId: freezed == cardReviewId ? _self.cardReviewId : cardReviewId // ignore: cast_nullable_to_non_nullable
as String?,learningItemId: freezed == learningItemId ? _self.learningItemId : learningItemId // ignore: cast_nullable_to_non_nullable
as String?,sourceFlashcardId: freezed == sourceFlashcardId ? _self.sourceFlashcardId : sourceFlashcardId // ignore: cast_nullable_to_non_nullable
as String?,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as int,due: freezed == due ? _self.due : due // ignore: cast_nullable_to_non_nullable
as DateTime?,contentDe: freezed == contentDe ? _self.contentDe : contentDe // ignore: cast_nullable_to_non_nullable
as String?,contentVi: freezed == contentVi ? _self.contentVi : contentVi // ignore: cast_nullable_to_non_nullable
as String?,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String?,wordDe: freezed == wordDe ? _self.wordDe : wordDe // ignore: cast_nullable_to_non_nullable
as String?,wordVi: freezed == wordVi ? _self.wordVi : wordVi // ignore: cast_nullable_to_non_nullable
as String?,flashcardAudioUrl: freezed == flashcardAudioUrl ? _self.flashcardAudioUrl : flashcardAudioUrl // ignore: cast_nullable_to_non_nullable
as String?,examples: null == examples ? _self.examples : examples // ignore: cast_nullable_to_non_nullable
as List<ReviewExample>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewItem].
extension ReviewItemPatterns on ReviewItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewItem value)  $default,){
final _that = this;
switch (_that) {
case _ReviewItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewItem value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'card_review_id')  String? cardReviewId, @JsonKey(name: 'learning_item_id')  String? learningItemId, @JsonKey(name: 'source_flashcard_id')  String? sourceFlashcardId,  int state,  DateTime? due, @JsonKey(name: 'content_de')  String? contentDe, @JsonKey(name: 'content_vi')  String? contentVi, @JsonKey(name: 'audio_url')  String? audioUrl,  String? level, @JsonKey(name: 'word_de')  String? wordDe, @JsonKey(name: 'word_vi')  String? wordVi, @JsonKey(name: 'flashcard_audio_url')  String? flashcardAudioUrl,  List<ReviewExample> examples)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewItem() when $default != null:
return $default(_that.cardReviewId,_that.learningItemId,_that.sourceFlashcardId,_that.state,_that.due,_that.contentDe,_that.contentVi,_that.audioUrl,_that.level,_that.wordDe,_that.wordVi,_that.flashcardAudioUrl,_that.examples);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'card_review_id')  String? cardReviewId, @JsonKey(name: 'learning_item_id')  String? learningItemId, @JsonKey(name: 'source_flashcard_id')  String? sourceFlashcardId,  int state,  DateTime? due, @JsonKey(name: 'content_de')  String? contentDe, @JsonKey(name: 'content_vi')  String? contentVi, @JsonKey(name: 'audio_url')  String? audioUrl,  String? level, @JsonKey(name: 'word_de')  String? wordDe, @JsonKey(name: 'word_vi')  String? wordVi, @JsonKey(name: 'flashcard_audio_url')  String? flashcardAudioUrl,  List<ReviewExample> examples)  $default,) {final _that = this;
switch (_that) {
case _ReviewItem():
return $default(_that.cardReviewId,_that.learningItemId,_that.sourceFlashcardId,_that.state,_that.due,_that.contentDe,_that.contentVi,_that.audioUrl,_that.level,_that.wordDe,_that.wordVi,_that.flashcardAudioUrl,_that.examples);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'card_review_id')  String? cardReviewId, @JsonKey(name: 'learning_item_id')  String? learningItemId, @JsonKey(name: 'source_flashcard_id')  String? sourceFlashcardId,  int state,  DateTime? due, @JsonKey(name: 'content_de')  String? contentDe, @JsonKey(name: 'content_vi')  String? contentVi, @JsonKey(name: 'audio_url')  String? audioUrl,  String? level, @JsonKey(name: 'word_de')  String? wordDe, @JsonKey(name: 'word_vi')  String? wordVi, @JsonKey(name: 'flashcard_audio_url')  String? flashcardAudioUrl,  List<ReviewExample> examples)?  $default,) {final _that = this;
switch (_that) {
case _ReviewItem() when $default != null:
return $default(_that.cardReviewId,_that.learningItemId,_that.sourceFlashcardId,_that.state,_that.due,_that.contentDe,_that.contentVi,_that.audioUrl,_that.level,_that.wordDe,_that.wordVi,_that.flashcardAudioUrl,_that.examples);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewItem extends ReviewItem {
  const _ReviewItem({@JsonKey(name: 'card_review_id') this.cardReviewId, @JsonKey(name: 'learning_item_id') this.learningItemId, @JsonKey(name: 'source_flashcard_id') this.sourceFlashcardId, this.state = 0, this.due, @JsonKey(name: 'content_de') this.contentDe, @JsonKey(name: 'content_vi') this.contentVi, @JsonKey(name: 'audio_url') this.audioUrl, this.level, @JsonKey(name: 'word_de') this.wordDe, @JsonKey(name: 'word_vi') this.wordVi, @JsonKey(name: 'flashcard_audio_url') this.flashcardAudioUrl, final  List<ReviewExample> examples = const <ReviewExample>[]}): _examples = examples,super._();
  factory _ReviewItem.fromJson(Map<String, dynamic> json) => _$ReviewItemFromJson(json);

@override@JsonKey(name: 'card_review_id') final  String? cardReviewId;
@override@JsonKey(name: 'learning_item_id') final  String? learningItemId;
@override@JsonKey(name: 'source_flashcard_id') final  String? sourceFlashcardId;
@override@JsonKey() final  int state;
@override final  DateTime? due;
@override@JsonKey(name: 'content_de') final  String? contentDe;
@override@JsonKey(name: 'content_vi') final  String? contentVi;
@override@JsonKey(name: 'audio_url') final  String? audioUrl;
@override final  String? level;
@override@JsonKey(name: 'word_de') final  String? wordDe;
@override@JsonKey(name: 'word_vi') final  String? wordVi;
@override@JsonKey(name: 'flashcard_audio_url') final  String? flashcardAudioUrl;
 final  List<ReviewExample> _examples;
@override@JsonKey() List<ReviewExample> get examples {
  if (_examples is EqualUnmodifiableListView) return _examples;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_examples);
}


/// Create a copy of ReviewItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewItemCopyWith<_ReviewItem> get copyWith => __$ReviewItemCopyWithImpl<_ReviewItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewItem&&(identical(other.cardReviewId, cardReviewId) || other.cardReviewId == cardReviewId)&&(identical(other.learningItemId, learningItemId) || other.learningItemId == learningItemId)&&(identical(other.sourceFlashcardId, sourceFlashcardId) || other.sourceFlashcardId == sourceFlashcardId)&&(identical(other.state, state) || other.state == state)&&(identical(other.due, due) || other.due == due)&&(identical(other.contentDe, contentDe) || other.contentDe == contentDe)&&(identical(other.contentVi, contentVi) || other.contentVi == contentVi)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.level, level) || other.level == level)&&(identical(other.wordDe, wordDe) || other.wordDe == wordDe)&&(identical(other.wordVi, wordVi) || other.wordVi == wordVi)&&(identical(other.flashcardAudioUrl, flashcardAudioUrl) || other.flashcardAudioUrl == flashcardAudioUrl)&&const DeepCollectionEquality().equals(other._examples, _examples));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cardReviewId,learningItemId,sourceFlashcardId,state,due,contentDe,contentVi,audioUrl,level,wordDe,wordVi,flashcardAudioUrl,const DeepCollectionEquality().hash(_examples));

@override
String toString() {
  return 'ReviewItem(cardReviewId: $cardReviewId, learningItemId: $learningItemId, sourceFlashcardId: $sourceFlashcardId, state: $state, due: $due, contentDe: $contentDe, contentVi: $contentVi, audioUrl: $audioUrl, level: $level, wordDe: $wordDe, wordVi: $wordVi, flashcardAudioUrl: $flashcardAudioUrl, examples: $examples)';
}


}

/// @nodoc
abstract mixin class _$ReviewItemCopyWith<$Res> implements $ReviewItemCopyWith<$Res> {
  factory _$ReviewItemCopyWith(_ReviewItem value, $Res Function(_ReviewItem) _then) = __$ReviewItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'card_review_id') String? cardReviewId,@JsonKey(name: 'learning_item_id') String? learningItemId,@JsonKey(name: 'source_flashcard_id') String? sourceFlashcardId, int state, DateTime? due,@JsonKey(name: 'content_de') String? contentDe,@JsonKey(name: 'content_vi') String? contentVi,@JsonKey(name: 'audio_url') String? audioUrl, String? level,@JsonKey(name: 'word_de') String? wordDe,@JsonKey(name: 'word_vi') String? wordVi,@JsonKey(name: 'flashcard_audio_url') String? flashcardAudioUrl, List<ReviewExample> examples
});




}
/// @nodoc
class __$ReviewItemCopyWithImpl<$Res>
    implements _$ReviewItemCopyWith<$Res> {
  __$ReviewItemCopyWithImpl(this._self, this._then);

  final _ReviewItem _self;
  final $Res Function(_ReviewItem) _then;

/// Create a copy of ReviewItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cardReviewId = freezed,Object? learningItemId = freezed,Object? sourceFlashcardId = freezed,Object? state = null,Object? due = freezed,Object? contentDe = freezed,Object? contentVi = freezed,Object? audioUrl = freezed,Object? level = freezed,Object? wordDe = freezed,Object? wordVi = freezed,Object? flashcardAudioUrl = freezed,Object? examples = null,}) {
  return _then(_ReviewItem(
cardReviewId: freezed == cardReviewId ? _self.cardReviewId : cardReviewId // ignore: cast_nullable_to_non_nullable
as String?,learningItemId: freezed == learningItemId ? _self.learningItemId : learningItemId // ignore: cast_nullable_to_non_nullable
as String?,sourceFlashcardId: freezed == sourceFlashcardId ? _self.sourceFlashcardId : sourceFlashcardId // ignore: cast_nullable_to_non_nullable
as String?,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as int,due: freezed == due ? _self.due : due // ignore: cast_nullable_to_non_nullable
as DateTime?,contentDe: freezed == contentDe ? _self.contentDe : contentDe // ignore: cast_nullable_to_non_nullable
as String?,contentVi: freezed == contentVi ? _self.contentVi : contentVi // ignore: cast_nullable_to_non_nullable
as String?,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String?,wordDe: freezed == wordDe ? _self.wordDe : wordDe // ignore: cast_nullable_to_non_nullable
as String?,wordVi: freezed == wordVi ? _self.wordVi : wordVi // ignore: cast_nullable_to_non_nullable
as String?,flashcardAudioUrl: freezed == flashcardAudioUrl ? _self.flashcardAudioUrl : flashcardAudioUrl // ignore: cast_nullable_to_non_nullable
as String?,examples: null == examples ? _self._examples : examples // ignore: cast_nullable_to_non_nullable
as List<ReviewExample>,
  ));
}


}


/// @nodoc
mixin _$ReviewExample {

 String get de; String get vi;@JsonKey(name: 'audio_url') String? get audioUrl;
/// Create a copy of ReviewExample
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewExampleCopyWith<ReviewExample> get copyWith => _$ReviewExampleCopyWithImpl<ReviewExample>(this as ReviewExample, _$identity);

  /// Serializes this ReviewExample to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewExample&&(identical(other.de, de) || other.de == de)&&(identical(other.vi, vi) || other.vi == vi)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,de,vi,audioUrl);

@override
String toString() {
  return 'ReviewExample(de: $de, vi: $vi, audioUrl: $audioUrl)';
}


}

/// @nodoc
abstract mixin class $ReviewExampleCopyWith<$Res>  {
  factory $ReviewExampleCopyWith(ReviewExample value, $Res Function(ReviewExample) _then) = _$ReviewExampleCopyWithImpl;
@useResult
$Res call({
 String de, String vi,@JsonKey(name: 'audio_url') String? audioUrl
});




}
/// @nodoc
class _$ReviewExampleCopyWithImpl<$Res>
    implements $ReviewExampleCopyWith<$Res> {
  _$ReviewExampleCopyWithImpl(this._self, this._then);

  final ReviewExample _self;
  final $Res Function(ReviewExample) _then;

/// Create a copy of ReviewExample
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? de = null,Object? vi = null,Object? audioUrl = freezed,}) {
  return _then(_self.copyWith(
de: null == de ? _self.de : de // ignore: cast_nullable_to_non_nullable
as String,vi: null == vi ? _self.vi : vi // ignore: cast_nullable_to_non_nullable
as String,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewExample].
extension ReviewExamplePatterns on ReviewExample {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewExample value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewExample() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewExample value)  $default,){
final _that = this;
switch (_that) {
case _ReviewExample():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewExample value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewExample() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String de,  String vi, @JsonKey(name: 'audio_url')  String? audioUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewExample() when $default != null:
return $default(_that.de,_that.vi,_that.audioUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String de,  String vi, @JsonKey(name: 'audio_url')  String? audioUrl)  $default,) {final _that = this;
switch (_that) {
case _ReviewExample():
return $default(_that.de,_that.vi,_that.audioUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String de,  String vi, @JsonKey(name: 'audio_url')  String? audioUrl)?  $default,) {final _that = this;
switch (_that) {
case _ReviewExample() when $default != null:
return $default(_that.de,_that.vi,_that.audioUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewExample implements ReviewExample {
  const _ReviewExample({this.de = '', this.vi = '', @JsonKey(name: 'audio_url') this.audioUrl});
  factory _ReviewExample.fromJson(Map<String, dynamic> json) => _$ReviewExampleFromJson(json);

@override@JsonKey() final  String de;
@override@JsonKey() final  String vi;
@override@JsonKey(name: 'audio_url') final  String? audioUrl;

/// Create a copy of ReviewExample
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewExampleCopyWith<_ReviewExample> get copyWith => __$ReviewExampleCopyWithImpl<_ReviewExample>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewExampleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewExample&&(identical(other.de, de) || other.de == de)&&(identical(other.vi, vi) || other.vi == vi)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,de,vi,audioUrl);

@override
String toString() {
  return 'ReviewExample(de: $de, vi: $vi, audioUrl: $audioUrl)';
}


}

/// @nodoc
abstract mixin class _$ReviewExampleCopyWith<$Res> implements $ReviewExampleCopyWith<$Res> {
  factory _$ReviewExampleCopyWith(_ReviewExample value, $Res Function(_ReviewExample) _then) = __$ReviewExampleCopyWithImpl;
@override @useResult
$Res call({
 String de, String vi,@JsonKey(name: 'audio_url') String? audioUrl
});




}
/// @nodoc
class __$ReviewExampleCopyWithImpl<$Res>
    implements _$ReviewExampleCopyWith<$Res> {
  __$ReviewExampleCopyWithImpl(this._self, this._then);

  final _ReviewExample _self;
  final $Res Function(_ReviewExample) _then;

/// Create a copy of ReviewExample
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? de = null,Object? vi = null,Object? audioUrl = freezed,}) {
  return _then(_ReviewExample(
de: null == de ? _self.de : de // ignore: cast_nullable_to_non_nullable
as String,vi: null == vi ? _self.vi : vi // ignore: cast_nullable_to_non_nullable
as String,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
