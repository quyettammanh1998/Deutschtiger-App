// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'interview_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InterviewGroup {

 int get order;@JsonKey(name: 'group_id') String get groupId;@JsonKey(name: 'group_name_vi') String get nameVi;@JsonKey(name: 'group_name_de') String get nameDe;@JsonKey(name: 'description_vi') String get descriptionVi; String get level;@JsonKey(name: 'video_count') int get videoCount; List<PathVideo> get videos;
/// Create a copy of InterviewGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InterviewGroupCopyWith<InterviewGroup> get copyWith => _$InterviewGroupCopyWithImpl<InterviewGroup>(this as InterviewGroup, _$identity);

  /// Serializes this InterviewGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InterviewGroup&&(identical(other.order, order) || other.order == order)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi)&&(identical(other.nameDe, nameDe) || other.nameDe == nameDe)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.level, level) || other.level == level)&&(identical(other.videoCount, videoCount) || other.videoCount == videoCount)&&const DeepCollectionEquality().equals(other.videos, videos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,order,groupId,nameVi,nameDe,descriptionVi,level,videoCount,const DeepCollectionEquality().hash(videos));

@override
String toString() {
  return 'InterviewGroup(order: $order, groupId: $groupId, nameVi: $nameVi, nameDe: $nameDe, descriptionVi: $descriptionVi, level: $level, videoCount: $videoCount, videos: $videos)';
}


}

/// @nodoc
abstract mixin class $InterviewGroupCopyWith<$Res>  {
  factory $InterviewGroupCopyWith(InterviewGroup value, $Res Function(InterviewGroup) _then) = _$InterviewGroupCopyWithImpl;
@useResult
$Res call({
 int order,@JsonKey(name: 'group_id') String groupId,@JsonKey(name: 'group_name_vi') String nameVi,@JsonKey(name: 'group_name_de') String nameDe,@JsonKey(name: 'description_vi') String descriptionVi, String level,@JsonKey(name: 'video_count') int videoCount, List<PathVideo> videos
});




}
/// @nodoc
class _$InterviewGroupCopyWithImpl<$Res>
    implements $InterviewGroupCopyWith<$Res> {
  _$InterviewGroupCopyWithImpl(this._self, this._then);

  final InterviewGroup _self;
  final $Res Function(InterviewGroup) _then;

/// Create a copy of InterviewGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? order = null,Object? groupId = null,Object? nameVi = null,Object? nameDe = null,Object? descriptionVi = null,Object? level = null,Object? videoCount = null,Object? videos = null,}) {
  return _then(_self.copyWith(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,nameVi: null == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String,nameDe: null == nameDe ? _self.nameDe : nameDe // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,videoCount: null == videoCount ? _self.videoCount : videoCount // ignore: cast_nullable_to_non_nullable
as int,videos: null == videos ? _self.videos : videos // ignore: cast_nullable_to_non_nullable
as List<PathVideo>,
  ));
}

}


/// Adds pattern-matching-related methods to [InterviewGroup].
extension InterviewGroupPatterns on InterviewGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InterviewGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InterviewGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InterviewGroup value)  $default,){
final _that = this;
switch (_that) {
case _InterviewGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InterviewGroup value)?  $default,){
final _that = this;
switch (_that) {
case _InterviewGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int order, @JsonKey(name: 'group_id')  String groupId, @JsonKey(name: 'group_name_vi')  String nameVi, @JsonKey(name: 'group_name_de')  String nameDe, @JsonKey(name: 'description_vi')  String descriptionVi,  String level, @JsonKey(name: 'video_count')  int videoCount,  List<PathVideo> videos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InterviewGroup() when $default != null:
return $default(_that.order,_that.groupId,_that.nameVi,_that.nameDe,_that.descriptionVi,_that.level,_that.videoCount,_that.videos);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int order, @JsonKey(name: 'group_id')  String groupId, @JsonKey(name: 'group_name_vi')  String nameVi, @JsonKey(name: 'group_name_de')  String nameDe, @JsonKey(name: 'description_vi')  String descriptionVi,  String level, @JsonKey(name: 'video_count')  int videoCount,  List<PathVideo> videos)  $default,) {final _that = this;
switch (_that) {
case _InterviewGroup():
return $default(_that.order,_that.groupId,_that.nameVi,_that.nameDe,_that.descriptionVi,_that.level,_that.videoCount,_that.videos);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int order, @JsonKey(name: 'group_id')  String groupId, @JsonKey(name: 'group_name_vi')  String nameVi, @JsonKey(name: 'group_name_de')  String nameDe, @JsonKey(name: 'description_vi')  String descriptionVi,  String level, @JsonKey(name: 'video_count')  int videoCount,  List<PathVideo> videos)?  $default,) {final _that = this;
switch (_that) {
case _InterviewGroup() when $default != null:
return $default(_that.order,_that.groupId,_that.nameVi,_that.nameDe,_that.descriptionVi,_that.level,_that.videoCount,_that.videos);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InterviewGroup implements InterviewGroup {
  const _InterviewGroup({this.order = 0, @JsonKey(name: 'group_id') this.groupId = '', @JsonKey(name: 'group_name_vi') this.nameVi = '', @JsonKey(name: 'group_name_de') this.nameDe = '', @JsonKey(name: 'description_vi') this.descriptionVi = '', this.level = '', @JsonKey(name: 'video_count') this.videoCount = 0, final  List<PathVideo> videos = const <PathVideo>[]}): _videos = videos;
  factory _InterviewGroup.fromJson(Map<String, dynamic> json) => _$InterviewGroupFromJson(json);

@override@JsonKey() final  int order;
@override@JsonKey(name: 'group_id') final  String groupId;
@override@JsonKey(name: 'group_name_vi') final  String nameVi;
@override@JsonKey(name: 'group_name_de') final  String nameDe;
@override@JsonKey(name: 'description_vi') final  String descriptionVi;
@override@JsonKey() final  String level;
@override@JsonKey(name: 'video_count') final  int videoCount;
 final  List<PathVideo> _videos;
@override@JsonKey() List<PathVideo> get videos {
  if (_videos is EqualUnmodifiableListView) return _videos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_videos);
}


/// Create a copy of InterviewGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InterviewGroupCopyWith<_InterviewGroup> get copyWith => __$InterviewGroupCopyWithImpl<_InterviewGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InterviewGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InterviewGroup&&(identical(other.order, order) || other.order == order)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi)&&(identical(other.nameDe, nameDe) || other.nameDe == nameDe)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.level, level) || other.level == level)&&(identical(other.videoCount, videoCount) || other.videoCount == videoCount)&&const DeepCollectionEquality().equals(other._videos, _videos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,order,groupId,nameVi,nameDe,descriptionVi,level,videoCount,const DeepCollectionEquality().hash(_videos));

@override
String toString() {
  return 'InterviewGroup(order: $order, groupId: $groupId, nameVi: $nameVi, nameDe: $nameDe, descriptionVi: $descriptionVi, level: $level, videoCount: $videoCount, videos: $videos)';
}


}

/// @nodoc
abstract mixin class _$InterviewGroupCopyWith<$Res> implements $InterviewGroupCopyWith<$Res> {
  factory _$InterviewGroupCopyWith(_InterviewGroup value, $Res Function(_InterviewGroup) _then) = __$InterviewGroupCopyWithImpl;
@override @useResult
$Res call({
 int order,@JsonKey(name: 'group_id') String groupId,@JsonKey(name: 'group_name_vi') String nameVi,@JsonKey(name: 'group_name_de') String nameDe,@JsonKey(name: 'description_vi') String descriptionVi, String level,@JsonKey(name: 'video_count') int videoCount, List<PathVideo> videos
});




}
/// @nodoc
class __$InterviewGroupCopyWithImpl<$Res>
    implements _$InterviewGroupCopyWith<$Res> {
  __$InterviewGroupCopyWithImpl(this._self, this._then);

  final _InterviewGroup _self;
  final $Res Function(_InterviewGroup) _then;

/// Create a copy of InterviewGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? order = null,Object? groupId = null,Object? nameVi = null,Object? nameDe = null,Object? descriptionVi = null,Object? level = null,Object? videoCount = null,Object? videos = null,}) {
  return _then(_InterviewGroup(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,nameVi: null == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String,nameDe: null == nameDe ? _self.nameDe : nameDe // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,videoCount: null == videoCount ? _self.videoCount : videoCount // ignore: cast_nullable_to_non_nullable
as int,videos: null == videos ? _self._videos : videos // ignore: cast_nullable_to_non_nullable
as List<PathVideo>,
  ));
}


}


/// @nodoc
mixin _$PathVideo {

@JsonKey(name: 'video_id') String get videoId; String get title;@JsonKey(name: 'duration_seconds') int get durationSeconds;
/// Create a copy of PathVideo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PathVideoCopyWith<PathVideo> get copyWith => _$PathVideoCopyWithImpl<PathVideo>(this as PathVideo, _$identity);

  /// Serializes this PathVideo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PathVideo&&(identical(other.videoId, videoId) || other.videoId == videoId)&&(identical(other.title, title) || other.title == title)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,videoId,title,durationSeconds);

@override
String toString() {
  return 'PathVideo(videoId: $videoId, title: $title, durationSeconds: $durationSeconds)';
}


}

/// @nodoc
abstract mixin class $PathVideoCopyWith<$Res>  {
  factory $PathVideoCopyWith(PathVideo value, $Res Function(PathVideo) _then) = _$PathVideoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'video_id') String videoId, String title,@JsonKey(name: 'duration_seconds') int durationSeconds
});




}
/// @nodoc
class _$PathVideoCopyWithImpl<$Res>
    implements $PathVideoCopyWith<$Res> {
  _$PathVideoCopyWithImpl(this._self, this._then);

  final PathVideo _self;
  final $Res Function(PathVideo) _then;

/// Create a copy of PathVideo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? videoId = null,Object? title = null,Object? durationSeconds = null,}) {
  return _then(_self.copyWith(
videoId: null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PathVideo].
extension PathVideoPatterns on PathVideo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PathVideo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PathVideo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PathVideo value)  $default,){
final _that = this;
switch (_that) {
case _PathVideo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PathVideo value)?  $default,){
final _that = this;
switch (_that) {
case _PathVideo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'video_id')  String videoId,  String title, @JsonKey(name: 'duration_seconds')  int durationSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PathVideo() when $default != null:
return $default(_that.videoId,_that.title,_that.durationSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'video_id')  String videoId,  String title, @JsonKey(name: 'duration_seconds')  int durationSeconds)  $default,) {final _that = this;
switch (_that) {
case _PathVideo():
return $default(_that.videoId,_that.title,_that.durationSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'video_id')  String videoId,  String title, @JsonKey(name: 'duration_seconds')  int durationSeconds)?  $default,) {final _that = this;
switch (_that) {
case _PathVideo() when $default != null:
return $default(_that.videoId,_that.title,_that.durationSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PathVideo implements PathVideo {
  const _PathVideo({@JsonKey(name: 'video_id') this.videoId = '', this.title = '', @JsonKey(name: 'duration_seconds') this.durationSeconds = 0});
  factory _PathVideo.fromJson(Map<String, dynamic> json) => _$PathVideoFromJson(json);

@override@JsonKey(name: 'video_id') final  String videoId;
@override@JsonKey() final  String title;
@override@JsonKey(name: 'duration_seconds') final  int durationSeconds;

/// Create a copy of PathVideo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PathVideoCopyWith<_PathVideo> get copyWith => __$PathVideoCopyWithImpl<_PathVideo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PathVideoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PathVideo&&(identical(other.videoId, videoId) || other.videoId == videoId)&&(identical(other.title, title) || other.title == title)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,videoId,title,durationSeconds);

@override
String toString() {
  return 'PathVideo(videoId: $videoId, title: $title, durationSeconds: $durationSeconds)';
}


}

/// @nodoc
abstract mixin class _$PathVideoCopyWith<$Res> implements $PathVideoCopyWith<$Res> {
  factory _$PathVideoCopyWith(_PathVideo value, $Res Function(_PathVideo) _then) = __$PathVideoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'video_id') String videoId, String title,@JsonKey(name: 'duration_seconds') int durationSeconds
});




}
/// @nodoc
class __$PathVideoCopyWithImpl<$Res>
    implements _$PathVideoCopyWith<$Res> {
  __$PathVideoCopyWithImpl(this._self, this._then);

  final _PathVideo _self;
  final $Res Function(_PathVideo) _then;

/// Create a copy of PathVideo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? videoId = null,Object? title = null,Object? durationSeconds = null,}) {
  return _then(_PathVideo(
videoId: null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$InterviewVideo {

 String get id;@JsonKey(name: 'group_id') String get groupId;@JsonKey(name: 'video_id') String get videoId; String get title; String get status;@JsonKey(name: 'watch_count') int get watchCount;
/// Create a copy of InterviewVideo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InterviewVideoCopyWith<InterviewVideo> get copyWith => _$InterviewVideoCopyWithImpl<InterviewVideo>(this as InterviewVideo, _$identity);

  /// Serializes this InterviewVideo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InterviewVideo&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.videoId, videoId) || other.videoId == videoId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.watchCount, watchCount) || other.watchCount == watchCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,videoId,title,status,watchCount);

@override
String toString() {
  return 'InterviewVideo(id: $id, groupId: $groupId, videoId: $videoId, title: $title, status: $status, watchCount: $watchCount)';
}


}

/// @nodoc
abstract mixin class $InterviewVideoCopyWith<$Res>  {
  factory $InterviewVideoCopyWith(InterviewVideo value, $Res Function(InterviewVideo) _then) = _$InterviewVideoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'group_id') String groupId,@JsonKey(name: 'video_id') String videoId, String title, String status,@JsonKey(name: 'watch_count') int watchCount
});




}
/// @nodoc
class _$InterviewVideoCopyWithImpl<$Res>
    implements $InterviewVideoCopyWith<$Res> {
  _$InterviewVideoCopyWithImpl(this._self, this._then);

  final InterviewVideo _self;
  final $Res Function(InterviewVideo) _then;

/// Create a copy of InterviewVideo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groupId = null,Object? videoId = null,Object? title = null,Object? status = null,Object? watchCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,videoId: null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,watchCount: null == watchCount ? _self.watchCount : watchCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [InterviewVideo].
extension InterviewVideoPatterns on InterviewVideo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InterviewVideo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InterviewVideo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InterviewVideo value)  $default,){
final _that = this;
switch (_that) {
case _InterviewVideo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InterviewVideo value)?  $default,){
final _that = this;
switch (_that) {
case _InterviewVideo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'group_id')  String groupId, @JsonKey(name: 'video_id')  String videoId,  String title,  String status, @JsonKey(name: 'watch_count')  int watchCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InterviewVideo() when $default != null:
return $default(_that.id,_that.groupId,_that.videoId,_that.title,_that.status,_that.watchCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'group_id')  String groupId, @JsonKey(name: 'video_id')  String videoId,  String title,  String status, @JsonKey(name: 'watch_count')  int watchCount)  $default,) {final _that = this;
switch (_that) {
case _InterviewVideo():
return $default(_that.id,_that.groupId,_that.videoId,_that.title,_that.status,_that.watchCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'group_id')  String groupId, @JsonKey(name: 'video_id')  String videoId,  String title,  String status, @JsonKey(name: 'watch_count')  int watchCount)?  $default,) {final _that = this;
switch (_that) {
case _InterviewVideo() when $default != null:
return $default(_that.id,_that.groupId,_that.videoId,_that.title,_that.status,_that.watchCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InterviewVideo extends InterviewVideo {
  const _InterviewVideo({required this.id, @JsonKey(name: 'group_id') this.groupId = '', @JsonKey(name: 'video_id') this.videoId = '', this.title = '', this.status = 'pending', @JsonKey(name: 'watch_count') this.watchCount = 0}): super._();
  factory _InterviewVideo.fromJson(Map<String, dynamic> json) => _$InterviewVideoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'group_id') final  String groupId;
@override@JsonKey(name: 'video_id') final  String videoId;
@override@JsonKey() final  String title;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'watch_count') final  int watchCount;

/// Create a copy of InterviewVideo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InterviewVideoCopyWith<_InterviewVideo> get copyWith => __$InterviewVideoCopyWithImpl<_InterviewVideo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InterviewVideoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InterviewVideo&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.videoId, videoId) || other.videoId == videoId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.watchCount, watchCount) || other.watchCount == watchCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,videoId,title,status,watchCount);

@override
String toString() {
  return 'InterviewVideo(id: $id, groupId: $groupId, videoId: $videoId, title: $title, status: $status, watchCount: $watchCount)';
}


}

/// @nodoc
abstract mixin class _$InterviewVideoCopyWith<$Res> implements $InterviewVideoCopyWith<$Res> {
  factory _$InterviewVideoCopyWith(_InterviewVideo value, $Res Function(_InterviewVideo) _then) = __$InterviewVideoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'group_id') String groupId,@JsonKey(name: 'video_id') String videoId, String title, String status,@JsonKey(name: 'watch_count') int watchCount
});




}
/// @nodoc
class __$InterviewVideoCopyWithImpl<$Res>
    implements _$InterviewVideoCopyWith<$Res> {
  __$InterviewVideoCopyWithImpl(this._self, this._then);

  final _InterviewVideo _self;
  final $Res Function(_InterviewVideo) _then;

/// Create a copy of InterviewVideo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groupId = null,Object? videoId = null,Object? title = null,Object? status = null,Object? watchCount = null,}) {
  return _then(_InterviewVideo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,videoId: null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,watchCount: null == watchCount ? _self.watchCount : watchCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$InterviewGroupProgress {

@JsonKey(name: 'group_id') String get groupId; int get total; int get completed; int get percentage;
/// Create a copy of InterviewGroupProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InterviewGroupProgressCopyWith<InterviewGroupProgress> get copyWith => _$InterviewGroupProgressCopyWithImpl<InterviewGroupProgress>(this as InterviewGroupProgress, _$identity);

  /// Serializes this InterviewGroupProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InterviewGroupProgress&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.total, total) || other.total == total)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,total,completed,percentage);

@override
String toString() {
  return 'InterviewGroupProgress(groupId: $groupId, total: $total, completed: $completed, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class $InterviewGroupProgressCopyWith<$Res>  {
  factory $InterviewGroupProgressCopyWith(InterviewGroupProgress value, $Res Function(InterviewGroupProgress) _then) = _$InterviewGroupProgressCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'group_id') String groupId, int total, int completed, int percentage
});




}
/// @nodoc
class _$InterviewGroupProgressCopyWithImpl<$Res>
    implements $InterviewGroupProgressCopyWith<$Res> {
  _$InterviewGroupProgressCopyWithImpl(this._self, this._then);

  final InterviewGroupProgress _self;
  final $Res Function(InterviewGroupProgress) _then;

/// Create a copy of InterviewGroupProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupId = null,Object? total = null,Object? completed = null,Object? percentage = null,}) {
  return _then(_self.copyWith(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [InterviewGroupProgress].
extension InterviewGroupProgressPatterns on InterviewGroupProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InterviewGroupProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InterviewGroupProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InterviewGroupProgress value)  $default,){
final _that = this;
switch (_that) {
case _InterviewGroupProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InterviewGroupProgress value)?  $default,){
final _that = this;
switch (_that) {
case _InterviewGroupProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'group_id')  String groupId,  int total,  int completed,  int percentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InterviewGroupProgress() when $default != null:
return $default(_that.groupId,_that.total,_that.completed,_that.percentage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'group_id')  String groupId,  int total,  int completed,  int percentage)  $default,) {final _that = this;
switch (_that) {
case _InterviewGroupProgress():
return $default(_that.groupId,_that.total,_that.completed,_that.percentage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'group_id')  String groupId,  int total,  int completed,  int percentage)?  $default,) {final _that = this;
switch (_that) {
case _InterviewGroupProgress() when $default != null:
return $default(_that.groupId,_that.total,_that.completed,_that.percentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InterviewGroupProgress implements InterviewGroupProgress {
  const _InterviewGroupProgress({@JsonKey(name: 'group_id') this.groupId = '', this.total = 0, this.completed = 0, this.percentage = 0});
  factory _InterviewGroupProgress.fromJson(Map<String, dynamic> json) => _$InterviewGroupProgressFromJson(json);

@override@JsonKey(name: 'group_id') final  String groupId;
@override@JsonKey() final  int total;
@override@JsonKey() final  int completed;
@override@JsonKey() final  int percentage;

/// Create a copy of InterviewGroupProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InterviewGroupProgressCopyWith<_InterviewGroupProgress> get copyWith => __$InterviewGroupProgressCopyWithImpl<_InterviewGroupProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InterviewGroupProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InterviewGroupProgress&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.total, total) || other.total == total)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,total,completed,percentage);

@override
String toString() {
  return 'InterviewGroupProgress(groupId: $groupId, total: $total, completed: $completed, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class _$InterviewGroupProgressCopyWith<$Res> implements $InterviewGroupProgressCopyWith<$Res> {
  factory _$InterviewGroupProgressCopyWith(_InterviewGroupProgress value, $Res Function(_InterviewGroupProgress) _then) = __$InterviewGroupProgressCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'group_id') String groupId, int total, int completed, int percentage
});




}
/// @nodoc
class __$InterviewGroupProgressCopyWithImpl<$Res>
    implements _$InterviewGroupProgressCopyWith<$Res> {
  __$InterviewGroupProgressCopyWithImpl(this._self, this._then);

  final _InterviewGroupProgress _self;
  final $Res Function(_InterviewGroupProgress) _then;

/// Create a copy of InterviewGroupProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupId = null,Object? total = null,Object? completed = null,Object? percentage = null,}) {
  return _then(_InterviewGroupProgress(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
