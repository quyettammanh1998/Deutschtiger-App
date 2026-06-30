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
mixin _$PodcastSeries {

 String get id; String get title; String get titleVi; String get description; String get descriptionVi; String get imageUrl; String get level; String get language; int get totalEpisodes; int get completedEpisodes; List<PodcastEpisode> get episodes;
/// Create a copy of PodcastSeries
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastSeriesCopyWith<PodcastSeries> get copyWith => _$PodcastSeriesCopyWithImpl<PodcastSeries>(this as PodcastSeries, _$identity);

  /// Serializes this PodcastSeries to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastSeries&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.level, level) || other.level == level)&&(identical(other.language, language) || other.language == language)&&(identical(other.totalEpisodes, totalEpisodes) || other.totalEpisodes == totalEpisodes)&&(identical(other.completedEpisodes, completedEpisodes) || other.completedEpisodes == completedEpisodes)&&const DeepCollectionEquality().equals(other.episodes, episodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,titleVi,description,descriptionVi,imageUrl,level,language,totalEpisodes,completedEpisodes,const DeepCollectionEquality().hash(episodes));

@override
String toString() {
  return 'PodcastSeries(id: $id, title: $title, titleVi: $titleVi, description: $description, descriptionVi: $descriptionVi, imageUrl: $imageUrl, level: $level, language: $language, totalEpisodes: $totalEpisodes, completedEpisodes: $completedEpisodes, episodes: $episodes)';
}


}

/// @nodoc
abstract mixin class $PodcastSeriesCopyWith<$Res>  {
  factory $PodcastSeriesCopyWith(PodcastSeries value, $Res Function(PodcastSeries) _then) = _$PodcastSeriesCopyWithImpl;
@useResult
$Res call({
 String id, String title, String titleVi, String description, String descriptionVi, String imageUrl, String level, String language, int totalEpisodes, int completedEpisodes, List<PodcastEpisode> episodes
});




}
/// @nodoc
class _$PodcastSeriesCopyWithImpl<$Res>
    implements $PodcastSeriesCopyWith<$Res> {
  _$PodcastSeriesCopyWithImpl(this._self, this._then);

  final PodcastSeries _self;
  final $Res Function(PodcastSeries) _then;

/// Create a copy of PodcastSeries
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? titleVi = null,Object? description = null,Object? descriptionVi = null,Object? imageUrl = null,Object? level = null,Object? language = null,Object? totalEpisodes = null,Object? completedEpisodes = null,Object? episodes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,totalEpisodes: null == totalEpisodes ? _self.totalEpisodes : totalEpisodes // ignore: cast_nullable_to_non_nullable
as int,completedEpisodes: null == completedEpisodes ? _self.completedEpisodes : completedEpisodes // ignore: cast_nullable_to_non_nullable
as int,episodes: null == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<PodcastEpisode>,
  ));
}

}


/// Adds pattern-matching-related methods to [PodcastSeries].
extension PodcastSeriesPatterns on PodcastSeries {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastSeries value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastSeries() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastSeries value)  $default,){
final _that = this;
switch (_that) {
case _PodcastSeries():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastSeries value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastSeries() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String titleVi,  String description,  String descriptionVi,  String imageUrl,  String level,  String language,  int totalEpisodes,  int completedEpisodes,  List<PodcastEpisode> episodes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastSeries() when $default != null:
return $default(_that.id,_that.title,_that.titleVi,_that.description,_that.descriptionVi,_that.imageUrl,_that.level,_that.language,_that.totalEpisodes,_that.completedEpisodes,_that.episodes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String titleVi,  String description,  String descriptionVi,  String imageUrl,  String level,  String language,  int totalEpisodes,  int completedEpisodes,  List<PodcastEpisode> episodes)  $default,) {final _that = this;
switch (_that) {
case _PodcastSeries():
return $default(_that.id,_that.title,_that.titleVi,_that.description,_that.descriptionVi,_that.imageUrl,_that.level,_that.language,_that.totalEpisodes,_that.completedEpisodes,_that.episodes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String titleVi,  String description,  String descriptionVi,  String imageUrl,  String level,  String language,  int totalEpisodes,  int completedEpisodes,  List<PodcastEpisode> episodes)?  $default,) {final _that = this;
switch (_that) {
case _PodcastSeries() when $default != null:
return $default(_that.id,_that.title,_that.titleVi,_that.description,_that.descriptionVi,_that.imageUrl,_that.level,_that.language,_that.totalEpisodes,_that.completedEpisodes,_that.episodes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PodcastSeries implements PodcastSeries {
  const _PodcastSeries({required this.id, required this.title, required this.titleVi, this.description = '', this.descriptionVi = '', this.imageUrl = '', this.level = '', this.language = '', this.totalEpisodes = 0, this.completedEpisodes = 0, final  List<PodcastEpisode> episodes = const <PodcastEpisode>[]}): _episodes = episodes;
  factory _PodcastSeries.fromJson(Map<String, dynamic> json) => _$PodcastSeriesFromJson(json);

@override final  String id;
@override final  String title;
@override final  String titleVi;
@override@JsonKey() final  String description;
@override@JsonKey() final  String descriptionVi;
@override@JsonKey() final  String imageUrl;
@override@JsonKey() final  String level;
@override@JsonKey() final  String language;
@override@JsonKey() final  int totalEpisodes;
@override@JsonKey() final  int completedEpisodes;
 final  List<PodcastEpisode> _episodes;
@override@JsonKey() List<PodcastEpisode> get episodes {
  if (_episodes is EqualUnmodifiableListView) return _episodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_episodes);
}


/// Create a copy of PodcastSeries
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastSeriesCopyWith<_PodcastSeries> get copyWith => __$PodcastSeriesCopyWithImpl<_PodcastSeries>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PodcastSeriesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastSeries&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.level, level) || other.level == level)&&(identical(other.language, language) || other.language == language)&&(identical(other.totalEpisodes, totalEpisodes) || other.totalEpisodes == totalEpisodes)&&(identical(other.completedEpisodes, completedEpisodes) || other.completedEpisodes == completedEpisodes)&&const DeepCollectionEquality().equals(other._episodes, _episodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,titleVi,description,descriptionVi,imageUrl,level,language,totalEpisodes,completedEpisodes,const DeepCollectionEquality().hash(_episodes));

@override
String toString() {
  return 'PodcastSeries(id: $id, title: $title, titleVi: $titleVi, description: $description, descriptionVi: $descriptionVi, imageUrl: $imageUrl, level: $level, language: $language, totalEpisodes: $totalEpisodes, completedEpisodes: $completedEpisodes, episodes: $episodes)';
}


}

/// @nodoc
abstract mixin class _$PodcastSeriesCopyWith<$Res> implements $PodcastSeriesCopyWith<$Res> {
  factory _$PodcastSeriesCopyWith(_PodcastSeries value, $Res Function(_PodcastSeries) _then) = __$PodcastSeriesCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String titleVi, String description, String descriptionVi, String imageUrl, String level, String language, int totalEpisodes, int completedEpisodes, List<PodcastEpisode> episodes
});




}
/// @nodoc
class __$PodcastSeriesCopyWithImpl<$Res>
    implements _$PodcastSeriesCopyWith<$Res> {
  __$PodcastSeriesCopyWithImpl(this._self, this._then);

  final _PodcastSeries _self;
  final $Res Function(_PodcastSeries) _then;

/// Create a copy of PodcastSeries
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? titleVi = null,Object? description = null,Object? descriptionVi = null,Object? imageUrl = null,Object? level = null,Object? language = null,Object? totalEpisodes = null,Object? completedEpisodes = null,Object? episodes = null,}) {
  return _then(_PodcastSeries(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,totalEpisodes: null == totalEpisodes ? _self.totalEpisodes : totalEpisodes // ignore: cast_nullable_to_non_nullable
as int,completedEpisodes: null == completedEpisodes ? _self.completedEpisodes : completedEpisodes // ignore: cast_nullable_to_non_nullable
as int,episodes: null == episodes ? _self._episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<PodcastEpisode>,
  ));
}


}


/// @nodoc
mixin _$PodcastEpisode {

 String get id; String get seriesId; String get episodeNumber; String get title; String get titleVi; String get description; String get descriptionVi; String get audioUrl; int get durationSeconds; String get transcript; String get transcriptUrl; bool get isCompleted; int get listenCount; double get progressPercent; DateTime? get lastListenedAt;
/// Create a copy of PodcastEpisode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastEpisodeCopyWith<PodcastEpisode> get copyWith => _$PodcastEpisodeCopyWithImpl<PodcastEpisode>(this as PodcastEpisode, _$identity);

  /// Serializes this PodcastEpisode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastEpisode&&(identical(other.id, id) || other.id == id)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.transcript, transcript) || other.transcript == transcript)&&(identical(other.transcriptUrl, transcriptUrl) || other.transcriptUrl == transcriptUrl)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.listenCount, listenCount) || other.listenCount == listenCount)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.lastListenedAt, lastListenedAt) || other.lastListenedAt == lastListenedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seriesId,episodeNumber,title,titleVi,description,descriptionVi,audioUrl,durationSeconds,transcript,transcriptUrl,isCompleted,listenCount,progressPercent,lastListenedAt);

@override
String toString() {
  return 'PodcastEpisode(id: $id, seriesId: $seriesId, episodeNumber: $episodeNumber, title: $title, titleVi: $titleVi, description: $description, descriptionVi: $descriptionVi, audioUrl: $audioUrl, durationSeconds: $durationSeconds, transcript: $transcript, transcriptUrl: $transcriptUrl, isCompleted: $isCompleted, listenCount: $listenCount, progressPercent: $progressPercent, lastListenedAt: $lastListenedAt)';
}


}

/// @nodoc
abstract mixin class $PodcastEpisodeCopyWith<$Res>  {
  factory $PodcastEpisodeCopyWith(PodcastEpisode value, $Res Function(PodcastEpisode) _then) = _$PodcastEpisodeCopyWithImpl;
@useResult
$Res call({
 String id, String seriesId, String episodeNumber, String title, String titleVi, String description, String descriptionVi, String audioUrl, int durationSeconds, String transcript, String transcriptUrl, bool isCompleted, int listenCount, double progressPercent, DateTime? lastListenedAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seriesId = null,Object? episodeNumber = null,Object? title = null,Object? titleVi = null,Object? description = null,Object? descriptionVi = null,Object? audioUrl = null,Object? durationSeconds = null,Object? transcript = null,Object? transcriptUrl = null,Object? isCompleted = null,Object? listenCount = null,Object? progressPercent = null,Object? lastListenedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seriesId: null == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as String,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String,transcriptUrl: null == transcriptUrl ? _self.transcriptUrl : transcriptUrl // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,listenCount: null == listenCount ? _self.listenCount : listenCount // ignore: cast_nullable_to_non_nullable
as int,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as double,lastListenedAt: freezed == lastListenedAt ? _self.lastListenedAt : lastListenedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String seriesId,  String episodeNumber,  String title,  String titleVi,  String description,  String descriptionVi,  String audioUrl,  int durationSeconds,  String transcript,  String transcriptUrl,  bool isCompleted,  int listenCount,  double progressPercent,  DateTime? lastListenedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastEpisode() when $default != null:
return $default(_that.id,_that.seriesId,_that.episodeNumber,_that.title,_that.titleVi,_that.description,_that.descriptionVi,_that.audioUrl,_that.durationSeconds,_that.transcript,_that.transcriptUrl,_that.isCompleted,_that.listenCount,_that.progressPercent,_that.lastListenedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String seriesId,  String episodeNumber,  String title,  String titleVi,  String description,  String descriptionVi,  String audioUrl,  int durationSeconds,  String transcript,  String transcriptUrl,  bool isCompleted,  int listenCount,  double progressPercent,  DateTime? lastListenedAt)  $default,) {final _that = this;
switch (_that) {
case _PodcastEpisode():
return $default(_that.id,_that.seriesId,_that.episodeNumber,_that.title,_that.titleVi,_that.description,_that.descriptionVi,_that.audioUrl,_that.durationSeconds,_that.transcript,_that.transcriptUrl,_that.isCompleted,_that.listenCount,_that.progressPercent,_that.lastListenedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String seriesId,  String episodeNumber,  String title,  String titleVi,  String description,  String descriptionVi,  String audioUrl,  int durationSeconds,  String transcript,  String transcriptUrl,  bool isCompleted,  int listenCount,  double progressPercent,  DateTime? lastListenedAt)?  $default,) {final _that = this;
switch (_that) {
case _PodcastEpisode() when $default != null:
return $default(_that.id,_that.seriesId,_that.episodeNumber,_that.title,_that.titleVi,_that.description,_that.descriptionVi,_that.audioUrl,_that.durationSeconds,_that.transcript,_that.transcriptUrl,_that.isCompleted,_that.listenCount,_that.progressPercent,_that.lastListenedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PodcastEpisode implements PodcastEpisode {
  const _PodcastEpisode({required this.id, required this.seriesId, required this.episodeNumber, required this.title, required this.titleVi, this.description = '', this.descriptionVi = '', this.audioUrl = '', this.durationSeconds = 0, this.transcript = '', this.transcriptUrl = '', this.isCompleted = false, this.listenCount = 0, this.progressPercent = 0.0, this.lastListenedAt});
  factory _PodcastEpisode.fromJson(Map<String, dynamic> json) => _$PodcastEpisodeFromJson(json);

@override final  String id;
@override final  String seriesId;
@override final  String episodeNumber;
@override final  String title;
@override final  String titleVi;
@override@JsonKey() final  String description;
@override@JsonKey() final  String descriptionVi;
@override@JsonKey() final  String audioUrl;
@override@JsonKey() final  int durationSeconds;
@override@JsonKey() final  String transcript;
@override@JsonKey() final  String transcriptUrl;
@override@JsonKey() final  bool isCompleted;
@override@JsonKey() final  int listenCount;
@override@JsonKey() final  double progressPercent;
@override final  DateTime? lastListenedAt;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastEpisode&&(identical(other.id, id) || other.id == id)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.transcript, transcript) || other.transcript == transcript)&&(identical(other.transcriptUrl, transcriptUrl) || other.transcriptUrl == transcriptUrl)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.listenCount, listenCount) || other.listenCount == listenCount)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.lastListenedAt, lastListenedAt) || other.lastListenedAt == lastListenedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,seriesId,episodeNumber,title,titleVi,description,descriptionVi,audioUrl,durationSeconds,transcript,transcriptUrl,isCompleted,listenCount,progressPercent,lastListenedAt);

@override
String toString() {
  return 'PodcastEpisode(id: $id, seriesId: $seriesId, episodeNumber: $episodeNumber, title: $title, titleVi: $titleVi, description: $description, descriptionVi: $descriptionVi, audioUrl: $audioUrl, durationSeconds: $durationSeconds, transcript: $transcript, transcriptUrl: $transcriptUrl, isCompleted: $isCompleted, listenCount: $listenCount, progressPercent: $progressPercent, lastListenedAt: $lastListenedAt)';
}


}

/// @nodoc
abstract mixin class _$PodcastEpisodeCopyWith<$Res> implements $PodcastEpisodeCopyWith<$Res> {
  factory _$PodcastEpisodeCopyWith(_PodcastEpisode value, $Res Function(_PodcastEpisode) _then) = __$PodcastEpisodeCopyWithImpl;
@override @useResult
$Res call({
 String id, String seriesId, String episodeNumber, String title, String titleVi, String description, String descriptionVi, String audioUrl, int durationSeconds, String transcript, String transcriptUrl, bool isCompleted, int listenCount, double progressPercent, DateTime? lastListenedAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seriesId = null,Object? episodeNumber = null,Object? title = null,Object? titleVi = null,Object? description = null,Object? descriptionVi = null,Object? audioUrl = null,Object? durationSeconds = null,Object? transcript = null,Object? transcriptUrl = null,Object? isCompleted = null,Object? listenCount = null,Object? progressPercent = null,Object? lastListenedAt = freezed,}) {
  return _then(_PodcastEpisode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seriesId: null == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as String,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String,transcriptUrl: null == transcriptUrl ? _self.transcriptUrl : transcriptUrl // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,listenCount: null == listenCount ? _self.listenCount : listenCount // ignore: cast_nullable_to_non_nullable
as int,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as double,lastListenedAt: freezed == lastListenedAt ? _self.lastListenedAt : lastListenedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Audiobook {

 String get id; String get title; String get titleVi; String get author; String get description; String get imageUrl; String get level; int get totalChapters; int get completedChapters; List<AudiobookChapter> get chapters;
/// Create a copy of Audiobook
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudiobookCopyWith<Audiobook> get copyWith => _$AudiobookCopyWithImpl<Audiobook>(this as Audiobook, _$identity);

  /// Serializes this Audiobook to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Audiobook&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.author, author) || other.author == author)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.level, level) || other.level == level)&&(identical(other.totalChapters, totalChapters) || other.totalChapters == totalChapters)&&(identical(other.completedChapters, completedChapters) || other.completedChapters == completedChapters)&&const DeepCollectionEquality().equals(other.chapters, chapters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,titleVi,author,description,imageUrl,level,totalChapters,completedChapters,const DeepCollectionEquality().hash(chapters));

@override
String toString() {
  return 'Audiobook(id: $id, title: $title, titleVi: $titleVi, author: $author, description: $description, imageUrl: $imageUrl, level: $level, totalChapters: $totalChapters, completedChapters: $completedChapters, chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class $AudiobookCopyWith<$Res>  {
  factory $AudiobookCopyWith(Audiobook value, $Res Function(Audiobook) _then) = _$AudiobookCopyWithImpl;
@useResult
$Res call({
 String id, String title, String titleVi, String author, String description, String imageUrl, String level, int totalChapters, int completedChapters, List<AudiobookChapter> chapters
});




}
/// @nodoc
class _$AudiobookCopyWithImpl<$Res>
    implements $AudiobookCopyWith<$Res> {
  _$AudiobookCopyWithImpl(this._self, this._then);

  final Audiobook _self;
  final $Res Function(Audiobook) _then;

/// Create a copy of Audiobook
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? titleVi = null,Object? author = null,Object? description = null,Object? imageUrl = null,Object? level = null,Object? totalChapters = null,Object? completedChapters = null,Object? chapters = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,totalChapters: null == totalChapters ? _self.totalChapters : totalChapters // ignore: cast_nullable_to_non_nullable
as int,completedChapters: null == completedChapters ? _self.completedChapters : completedChapters // ignore: cast_nullable_to_non_nullable
as int,chapters: null == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<AudiobookChapter>,
  ));
}

}


/// Adds pattern-matching-related methods to [Audiobook].
extension AudiobookPatterns on Audiobook {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Audiobook value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Audiobook() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Audiobook value)  $default,){
final _that = this;
switch (_that) {
case _Audiobook():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Audiobook value)?  $default,){
final _that = this;
switch (_that) {
case _Audiobook() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String titleVi,  String author,  String description,  String imageUrl,  String level,  int totalChapters,  int completedChapters,  List<AudiobookChapter> chapters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Audiobook() when $default != null:
return $default(_that.id,_that.title,_that.titleVi,_that.author,_that.description,_that.imageUrl,_that.level,_that.totalChapters,_that.completedChapters,_that.chapters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String titleVi,  String author,  String description,  String imageUrl,  String level,  int totalChapters,  int completedChapters,  List<AudiobookChapter> chapters)  $default,) {final _that = this;
switch (_that) {
case _Audiobook():
return $default(_that.id,_that.title,_that.titleVi,_that.author,_that.description,_that.imageUrl,_that.level,_that.totalChapters,_that.completedChapters,_that.chapters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String titleVi,  String author,  String description,  String imageUrl,  String level,  int totalChapters,  int completedChapters,  List<AudiobookChapter> chapters)?  $default,) {final _that = this;
switch (_that) {
case _Audiobook() when $default != null:
return $default(_that.id,_that.title,_that.titleVi,_that.author,_that.description,_that.imageUrl,_that.level,_that.totalChapters,_that.completedChapters,_that.chapters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Audiobook implements Audiobook {
  const _Audiobook({required this.id, required this.title, required this.titleVi, this.author = '', this.description = '', this.imageUrl = '', this.level = '', this.totalChapters = 0, this.completedChapters = 0, final  List<AudiobookChapter> chapters = const <AudiobookChapter>[]}): _chapters = chapters;
  factory _Audiobook.fromJson(Map<String, dynamic> json) => _$AudiobookFromJson(json);

@override final  String id;
@override final  String title;
@override final  String titleVi;
@override@JsonKey() final  String author;
@override@JsonKey() final  String description;
@override@JsonKey() final  String imageUrl;
@override@JsonKey() final  String level;
@override@JsonKey() final  int totalChapters;
@override@JsonKey() final  int completedChapters;
 final  List<AudiobookChapter> _chapters;
@override@JsonKey() List<AudiobookChapter> get chapters {
  if (_chapters is EqualUnmodifiableListView) return _chapters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chapters);
}


/// Create a copy of Audiobook
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudiobookCopyWith<_Audiobook> get copyWith => __$AudiobookCopyWithImpl<_Audiobook>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AudiobookToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Audiobook&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.author, author) || other.author == author)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.level, level) || other.level == level)&&(identical(other.totalChapters, totalChapters) || other.totalChapters == totalChapters)&&(identical(other.completedChapters, completedChapters) || other.completedChapters == completedChapters)&&const DeepCollectionEquality().equals(other._chapters, _chapters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,titleVi,author,description,imageUrl,level,totalChapters,completedChapters,const DeepCollectionEquality().hash(_chapters));

@override
String toString() {
  return 'Audiobook(id: $id, title: $title, titleVi: $titleVi, author: $author, description: $description, imageUrl: $imageUrl, level: $level, totalChapters: $totalChapters, completedChapters: $completedChapters, chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class _$AudiobookCopyWith<$Res> implements $AudiobookCopyWith<$Res> {
  factory _$AudiobookCopyWith(_Audiobook value, $Res Function(_Audiobook) _then) = __$AudiobookCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String titleVi, String author, String description, String imageUrl, String level, int totalChapters, int completedChapters, List<AudiobookChapter> chapters
});




}
/// @nodoc
class __$AudiobookCopyWithImpl<$Res>
    implements _$AudiobookCopyWith<$Res> {
  __$AudiobookCopyWithImpl(this._self, this._then);

  final _Audiobook _self;
  final $Res Function(_Audiobook) _then;

/// Create a copy of Audiobook
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? titleVi = null,Object? author = null,Object? description = null,Object? imageUrl = null,Object? level = null,Object? totalChapters = null,Object? completedChapters = null,Object? chapters = null,}) {
  return _then(_Audiobook(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,totalChapters: null == totalChapters ? _self.totalChapters : totalChapters // ignore: cast_nullable_to_non_nullable
as int,completedChapters: null == completedChapters ? _self.completedChapters : completedChapters // ignore: cast_nullable_to_non_nullable
as int,chapters: null == chapters ? _self._chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<AudiobookChapter>,
  ));
}


}


/// @nodoc
mixin _$AudiobookChapter {

 String get id; String get audiobookId; String get chapterNumber; String get title; String get titleVi; String get audioUrl; int get durationSeconds; bool get isCompleted;
/// Create a copy of AudiobookChapter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudiobookChapterCopyWith<AudiobookChapter> get copyWith => _$AudiobookChapterCopyWithImpl<AudiobookChapter>(this as AudiobookChapter, _$identity);

  /// Serializes this AudiobookChapter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudiobookChapter&&(identical(other.id, id) || other.id == id)&&(identical(other.audiobookId, audiobookId) || other.audiobookId == audiobookId)&&(identical(other.chapterNumber, chapterNumber) || other.chapterNumber == chapterNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,audiobookId,chapterNumber,title,titleVi,audioUrl,durationSeconds,isCompleted);

@override
String toString() {
  return 'AudiobookChapter(id: $id, audiobookId: $audiobookId, chapterNumber: $chapterNumber, title: $title, titleVi: $titleVi, audioUrl: $audioUrl, durationSeconds: $durationSeconds, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class $AudiobookChapterCopyWith<$Res>  {
  factory $AudiobookChapterCopyWith(AudiobookChapter value, $Res Function(AudiobookChapter) _then) = _$AudiobookChapterCopyWithImpl;
@useResult
$Res call({
 String id, String audiobookId, String chapterNumber, String title, String titleVi, String audioUrl, int durationSeconds, bool isCompleted
});




}
/// @nodoc
class _$AudiobookChapterCopyWithImpl<$Res>
    implements $AudiobookChapterCopyWith<$Res> {
  _$AudiobookChapterCopyWithImpl(this._self, this._then);

  final AudiobookChapter _self;
  final $Res Function(AudiobookChapter) _then;

/// Create a copy of AudiobookChapter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? audiobookId = null,Object? chapterNumber = null,Object? title = null,Object? titleVi = null,Object? audioUrl = null,Object? durationSeconds = null,Object? isCompleted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,audiobookId: null == audiobookId ? _self.audiobookId : audiobookId // ignore: cast_nullable_to_non_nullable
as String,chapterNumber: null == chapterNumber ? _self.chapterNumber : chapterNumber // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AudiobookChapter].
extension AudiobookChapterPatterns on AudiobookChapter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudiobookChapter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudiobookChapter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudiobookChapter value)  $default,){
final _that = this;
switch (_that) {
case _AudiobookChapter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudiobookChapter value)?  $default,){
final _that = this;
switch (_that) {
case _AudiobookChapter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String audiobookId,  String chapterNumber,  String title,  String titleVi,  String audioUrl,  int durationSeconds,  bool isCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudiobookChapter() when $default != null:
return $default(_that.id,_that.audiobookId,_that.chapterNumber,_that.title,_that.titleVi,_that.audioUrl,_that.durationSeconds,_that.isCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String audiobookId,  String chapterNumber,  String title,  String titleVi,  String audioUrl,  int durationSeconds,  bool isCompleted)  $default,) {final _that = this;
switch (_that) {
case _AudiobookChapter():
return $default(_that.id,_that.audiobookId,_that.chapterNumber,_that.title,_that.titleVi,_that.audioUrl,_that.durationSeconds,_that.isCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String audiobookId,  String chapterNumber,  String title,  String titleVi,  String audioUrl,  int durationSeconds,  bool isCompleted)?  $default,) {final _that = this;
switch (_that) {
case _AudiobookChapter() when $default != null:
return $default(_that.id,_that.audiobookId,_that.chapterNumber,_that.title,_that.titleVi,_that.audioUrl,_that.durationSeconds,_that.isCompleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AudiobookChapter implements AudiobookChapter {
  const _AudiobookChapter({required this.id, required this.audiobookId, required this.chapterNumber, required this.title, required this.titleVi, this.audioUrl = '', this.durationSeconds = 0, this.isCompleted = false});
  factory _AudiobookChapter.fromJson(Map<String, dynamic> json) => _$AudiobookChapterFromJson(json);

@override final  String id;
@override final  String audiobookId;
@override final  String chapterNumber;
@override final  String title;
@override final  String titleVi;
@override@JsonKey() final  String audioUrl;
@override@JsonKey() final  int durationSeconds;
@override@JsonKey() final  bool isCompleted;

/// Create a copy of AudiobookChapter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudiobookChapterCopyWith<_AudiobookChapter> get copyWith => __$AudiobookChapterCopyWithImpl<_AudiobookChapter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AudiobookChapterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudiobookChapter&&(identical(other.id, id) || other.id == id)&&(identical(other.audiobookId, audiobookId) || other.audiobookId == audiobookId)&&(identical(other.chapterNumber, chapterNumber) || other.chapterNumber == chapterNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,audiobookId,chapterNumber,title,titleVi,audioUrl,durationSeconds,isCompleted);

@override
String toString() {
  return 'AudiobookChapter(id: $id, audiobookId: $audiobookId, chapterNumber: $chapterNumber, title: $title, titleVi: $titleVi, audioUrl: $audioUrl, durationSeconds: $durationSeconds, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$AudiobookChapterCopyWith<$Res> implements $AudiobookChapterCopyWith<$Res> {
  factory _$AudiobookChapterCopyWith(_AudiobookChapter value, $Res Function(_AudiobookChapter) _then) = __$AudiobookChapterCopyWithImpl;
@override @useResult
$Res call({
 String id, String audiobookId, String chapterNumber, String title, String titleVi, String audioUrl, int durationSeconds, bool isCompleted
});




}
/// @nodoc
class __$AudiobookChapterCopyWithImpl<$Res>
    implements _$AudiobookChapterCopyWith<$Res> {
  __$AudiobookChapterCopyWithImpl(this._self, this._then);

  final _AudiobookChapter _self;
  final $Res Function(_AudiobookChapter) _then;

/// Create a copy of AudiobookChapter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? audiobookId = null,Object? chapterNumber = null,Object? title = null,Object? titleVi = null,Object? audioUrl = null,Object? durationSeconds = null,Object? isCompleted = null,}) {
  return _then(_AudiobookChapter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,audiobookId: null == audiobookId ? _self.audiobookId : audiobookId // ignore: cast_nullable_to_non_nullable
as String,chapterNumber: null == chapterNumber ? _self.chapterNumber : chapterNumber // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Dictation {

 String get id; String get title; String get titleVi; String get level; int get difficulty; int get totalSentences; int get correctAnswers; bool get isCompleted;
/// Create a copy of Dictation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DictationCopyWith<Dictation> get copyWith => _$DictationCopyWithImpl<Dictation>(this as Dictation, _$identity);

  /// Serializes this Dictation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Dictation&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.level, level) || other.level == level)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.totalSentences, totalSentences) || other.totalSentences == totalSentences)&&(identical(other.correctAnswers, correctAnswers) || other.correctAnswers == correctAnswers)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,titleVi,level,difficulty,totalSentences,correctAnswers,isCompleted);

@override
String toString() {
  return 'Dictation(id: $id, title: $title, titleVi: $titleVi, level: $level, difficulty: $difficulty, totalSentences: $totalSentences, correctAnswers: $correctAnswers, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class $DictationCopyWith<$Res>  {
  factory $DictationCopyWith(Dictation value, $Res Function(Dictation) _then) = _$DictationCopyWithImpl;
@useResult
$Res call({
 String id, String title, String titleVi, String level, int difficulty, int totalSentences, int correctAnswers, bool isCompleted
});




}
/// @nodoc
class _$DictationCopyWithImpl<$Res>
    implements $DictationCopyWith<$Res> {
  _$DictationCopyWithImpl(this._self, this._then);

  final Dictation _self;
  final $Res Function(Dictation) _then;

/// Create a copy of Dictation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? titleVi = null,Object? level = null,Object? difficulty = null,Object? totalSentences = null,Object? correctAnswers = null,Object? isCompleted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int,totalSentences: null == totalSentences ? _self.totalSentences : totalSentences // ignore: cast_nullable_to_non_nullable
as int,correctAnswers: null == correctAnswers ? _self.correctAnswers : correctAnswers // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Dictation].
extension DictationPatterns on Dictation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Dictation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Dictation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Dictation value)  $default,){
final _that = this;
switch (_that) {
case _Dictation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Dictation value)?  $default,){
final _that = this;
switch (_that) {
case _Dictation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String titleVi,  String level,  int difficulty,  int totalSentences,  int correctAnswers,  bool isCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Dictation() when $default != null:
return $default(_that.id,_that.title,_that.titleVi,_that.level,_that.difficulty,_that.totalSentences,_that.correctAnswers,_that.isCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String titleVi,  String level,  int difficulty,  int totalSentences,  int correctAnswers,  bool isCompleted)  $default,) {final _that = this;
switch (_that) {
case _Dictation():
return $default(_that.id,_that.title,_that.titleVi,_that.level,_that.difficulty,_that.totalSentences,_that.correctAnswers,_that.isCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String titleVi,  String level,  int difficulty,  int totalSentences,  int correctAnswers,  bool isCompleted)?  $default,) {final _that = this;
switch (_that) {
case _Dictation() when $default != null:
return $default(_that.id,_that.title,_that.titleVi,_that.level,_that.difficulty,_that.totalSentences,_that.correctAnswers,_that.isCompleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Dictation implements Dictation {
  const _Dictation({required this.id, required this.title, required this.titleVi, this.level = '', this.difficulty = 0, this.totalSentences = 0, this.correctAnswers = 0, this.isCompleted = false});
  factory _Dictation.fromJson(Map<String, dynamic> json) => _$DictationFromJson(json);

@override final  String id;
@override final  String title;
@override final  String titleVi;
@override@JsonKey() final  String level;
@override@JsonKey() final  int difficulty;
@override@JsonKey() final  int totalSentences;
@override@JsonKey() final  int correctAnswers;
@override@JsonKey() final  bool isCompleted;

/// Create a copy of Dictation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DictationCopyWith<_Dictation> get copyWith => __$DictationCopyWithImpl<_Dictation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DictationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Dictation&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.level, level) || other.level == level)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.totalSentences, totalSentences) || other.totalSentences == totalSentences)&&(identical(other.correctAnswers, correctAnswers) || other.correctAnswers == correctAnswers)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,titleVi,level,difficulty,totalSentences,correctAnswers,isCompleted);

@override
String toString() {
  return 'Dictation(id: $id, title: $title, titleVi: $titleVi, level: $level, difficulty: $difficulty, totalSentences: $totalSentences, correctAnswers: $correctAnswers, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$DictationCopyWith<$Res> implements $DictationCopyWith<$Res> {
  factory _$DictationCopyWith(_Dictation value, $Res Function(_Dictation) _then) = __$DictationCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String titleVi, String level, int difficulty, int totalSentences, int correctAnswers, bool isCompleted
});




}
/// @nodoc
class __$DictationCopyWithImpl<$Res>
    implements _$DictationCopyWith<$Res> {
  __$DictationCopyWithImpl(this._self, this._then);

  final _Dictation _self;
  final $Res Function(_Dictation) _then;

/// Create a copy of Dictation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? titleVi = null,Object? level = null,Object? difficulty = null,Object? totalSentences = null,Object? correctAnswers = null,Object? isCompleted = null,}) {
  return _then(_Dictation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int,totalSentences: null == totalSentences ? _self.totalSentences : totalSentences // ignore: cast_nullable_to_non_nullable
as int,correctAnswers: null == correctAnswers ? _self.correctAnswers : correctAnswers // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$DictationSentence {

 String get id; String get dictationId; String get sentence; List<String> get blanks; int get attempts; int get correctAttempts;
/// Create a copy of DictationSentence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DictationSentenceCopyWith<DictationSentence> get copyWith => _$DictationSentenceCopyWithImpl<DictationSentence>(this as DictationSentence, _$identity);

  /// Serializes this DictationSentence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DictationSentence&&(identical(other.id, id) || other.id == id)&&(identical(other.dictationId, dictationId) || other.dictationId == dictationId)&&(identical(other.sentence, sentence) || other.sentence == sentence)&&const DeepCollectionEquality().equals(other.blanks, blanks)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.correctAttempts, correctAttempts) || other.correctAttempts == correctAttempts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dictationId,sentence,const DeepCollectionEquality().hash(blanks),attempts,correctAttempts);

@override
String toString() {
  return 'DictationSentence(id: $id, dictationId: $dictationId, sentence: $sentence, blanks: $blanks, attempts: $attempts, correctAttempts: $correctAttempts)';
}


}

/// @nodoc
abstract mixin class $DictationSentenceCopyWith<$Res>  {
  factory $DictationSentenceCopyWith(DictationSentence value, $Res Function(DictationSentence) _then) = _$DictationSentenceCopyWithImpl;
@useResult
$Res call({
 String id, String dictationId, String sentence, List<String> blanks, int attempts, int correctAttempts
});




}
/// @nodoc
class _$DictationSentenceCopyWithImpl<$Res>
    implements $DictationSentenceCopyWith<$Res> {
  _$DictationSentenceCopyWithImpl(this._self, this._then);

  final DictationSentence _self;
  final $Res Function(DictationSentence) _then;

/// Create a copy of DictationSentence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? dictationId = null,Object? sentence = null,Object? blanks = null,Object? attempts = null,Object? correctAttempts = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dictationId: null == dictationId ? _self.dictationId : dictationId // ignore: cast_nullable_to_non_nullable
as String,sentence: null == sentence ? _self.sentence : sentence // ignore: cast_nullable_to_non_nullable
as String,blanks: null == blanks ? _self.blanks : blanks // ignore: cast_nullable_to_non_nullable
as List<String>,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,correctAttempts: null == correctAttempts ? _self.correctAttempts : correctAttempts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DictationSentence].
extension DictationSentencePatterns on DictationSentence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DictationSentence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DictationSentence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DictationSentence value)  $default,){
final _that = this;
switch (_that) {
case _DictationSentence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DictationSentence value)?  $default,){
final _that = this;
switch (_that) {
case _DictationSentence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String dictationId,  String sentence,  List<String> blanks,  int attempts,  int correctAttempts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DictationSentence() when $default != null:
return $default(_that.id,_that.dictationId,_that.sentence,_that.blanks,_that.attempts,_that.correctAttempts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String dictationId,  String sentence,  List<String> blanks,  int attempts,  int correctAttempts)  $default,) {final _that = this;
switch (_that) {
case _DictationSentence():
return $default(_that.id,_that.dictationId,_that.sentence,_that.blanks,_that.attempts,_that.correctAttempts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String dictationId,  String sentence,  List<String> blanks,  int attempts,  int correctAttempts)?  $default,) {final _that = this;
switch (_that) {
case _DictationSentence() when $default != null:
return $default(_that.id,_that.dictationId,_that.sentence,_that.blanks,_that.attempts,_that.correctAttempts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DictationSentence implements DictationSentence {
  const _DictationSentence({required this.id, required this.dictationId, required this.sentence, required final  List<String> blanks, this.attempts = 0, this.correctAttempts = 0}): _blanks = blanks;
  factory _DictationSentence.fromJson(Map<String, dynamic> json) => _$DictationSentenceFromJson(json);

@override final  String id;
@override final  String dictationId;
@override final  String sentence;
 final  List<String> _blanks;
@override List<String> get blanks {
  if (_blanks is EqualUnmodifiableListView) return _blanks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blanks);
}

@override@JsonKey() final  int attempts;
@override@JsonKey() final  int correctAttempts;

/// Create a copy of DictationSentence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DictationSentenceCopyWith<_DictationSentence> get copyWith => __$DictationSentenceCopyWithImpl<_DictationSentence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DictationSentenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DictationSentence&&(identical(other.id, id) || other.id == id)&&(identical(other.dictationId, dictationId) || other.dictationId == dictationId)&&(identical(other.sentence, sentence) || other.sentence == sentence)&&const DeepCollectionEquality().equals(other._blanks, _blanks)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.correctAttempts, correctAttempts) || other.correctAttempts == correctAttempts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dictationId,sentence,const DeepCollectionEquality().hash(_blanks),attempts,correctAttempts);

@override
String toString() {
  return 'DictationSentence(id: $id, dictationId: $dictationId, sentence: $sentence, blanks: $blanks, attempts: $attempts, correctAttempts: $correctAttempts)';
}


}

/// @nodoc
abstract mixin class _$DictationSentenceCopyWith<$Res> implements $DictationSentenceCopyWith<$Res> {
  factory _$DictationSentenceCopyWith(_DictationSentence value, $Res Function(_DictationSentence) _then) = __$DictationSentenceCopyWithImpl;
@override @useResult
$Res call({
 String id, String dictationId, String sentence, List<String> blanks, int attempts, int correctAttempts
});




}
/// @nodoc
class __$DictationSentenceCopyWithImpl<$Res>
    implements _$DictationSentenceCopyWith<$Res> {
  __$DictationSentenceCopyWithImpl(this._self, this._then);

  final _DictationSentence _self;
  final $Res Function(_DictationSentence) _then;

/// Create a copy of DictationSentence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? dictationId = null,Object? sentence = null,Object? blanks = null,Object? attempts = null,Object? correctAttempts = null,}) {
  return _then(_DictationSentence(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dictationId: null == dictationId ? _self.dictationId : dictationId // ignore: cast_nullable_to_non_nullable
as String,sentence: null == sentence ? _self.sentence : sentence // ignore: cast_nullable_to_non_nullable
as String,blanks: null == blanks ? _self._blanks : blanks // ignore: cast_nullable_to_non_nullable
as List<String>,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,correctAttempts: null == correctAttempts ? _self.correctAttempts : correctAttempts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
