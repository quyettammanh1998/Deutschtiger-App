// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SocialMoment {

 String get id; String get odlId; String get userId; String get username; String get userAvatar; String get content; String get imageUrl; int get likes; int get comments; bool get isLiked; List<String> get likedByUsers; DateTime? get createdAt;
/// Create a copy of SocialMoment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SocialMomentCopyWith<SocialMoment> get copyWith => _$SocialMomentCopyWithImpl<SocialMoment>(this as SocialMoment, _$identity);

  /// Serializes this SocialMoment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SocialMoment&&(identical(other.id, id) || other.id == id)&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar)&&(identical(other.content, content) || other.content == content)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&const DeepCollectionEquality().equals(other.likedByUsers, likedByUsers)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,odlId,userId,username,userAvatar,content,imageUrl,likes,comments,isLiked,const DeepCollectionEquality().hash(likedByUsers),createdAt);

@override
String toString() {
  return 'SocialMoment(id: $id, odlId: $odlId, userId: $userId, username: $username, userAvatar: $userAvatar, content: $content, imageUrl: $imageUrl, likes: $likes, comments: $comments, isLiked: $isLiked, likedByUsers: $likedByUsers, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SocialMomentCopyWith<$Res>  {
  factory $SocialMomentCopyWith(SocialMoment value, $Res Function(SocialMoment) _then) = _$SocialMomentCopyWithImpl;
@useResult
$Res call({
 String id, String odlId, String userId, String username, String userAvatar, String content, String imageUrl, int likes, int comments, bool isLiked, List<String> likedByUsers, DateTime? createdAt
});




}
/// @nodoc
class _$SocialMomentCopyWithImpl<$Res>
    implements $SocialMomentCopyWith<$Res> {
  _$SocialMomentCopyWithImpl(this._self, this._then);

  final SocialMoment _self;
  final $Res Function(SocialMoment) _then;

/// Create a copy of SocialMoment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? odlId = null,Object? userId = null,Object? username = null,Object? userAvatar = null,Object? content = null,Object? imageUrl = null,Object? likes = null,Object? comments = null,Object? isLiked = null,Object? likedByUsers = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,userAvatar: null == userAvatar ? _self.userAvatar : userAvatar // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,likedByUsers: null == likedByUsers ? _self.likedByUsers : likedByUsers // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SocialMoment].
extension SocialMomentPatterns on SocialMoment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SocialMoment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SocialMoment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SocialMoment value)  $default,){
final _that = this;
switch (_that) {
case _SocialMoment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SocialMoment value)?  $default,){
final _that = this;
switch (_that) {
case _SocialMoment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String odlId,  String userId,  String username,  String userAvatar,  String content,  String imageUrl,  int likes,  int comments,  bool isLiked,  List<String> likedByUsers,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SocialMoment() when $default != null:
return $default(_that.id,_that.odlId,_that.userId,_that.username,_that.userAvatar,_that.content,_that.imageUrl,_that.likes,_that.comments,_that.isLiked,_that.likedByUsers,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String odlId,  String userId,  String username,  String userAvatar,  String content,  String imageUrl,  int likes,  int comments,  bool isLiked,  List<String> likedByUsers,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _SocialMoment():
return $default(_that.id,_that.odlId,_that.userId,_that.username,_that.userAvatar,_that.content,_that.imageUrl,_that.likes,_that.comments,_that.isLiked,_that.likedByUsers,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String odlId,  String userId,  String username,  String userAvatar,  String content,  String imageUrl,  int likes,  int comments,  bool isLiked,  List<String> likedByUsers,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SocialMoment() when $default != null:
return $default(_that.id,_that.odlId,_that.userId,_that.username,_that.userAvatar,_that.content,_that.imageUrl,_that.likes,_that.comments,_that.isLiked,_that.likedByUsers,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SocialMoment implements SocialMoment {
  const _SocialMoment({required this.id, required this.odlId, required this.userId, required this.username, this.userAvatar = '', required this.content, this.imageUrl = '', this.likes = 0, this.comments = 0, this.isLiked = false, final  List<String> likedByUsers = const <String>[], this.createdAt}): _likedByUsers = likedByUsers;
  factory _SocialMoment.fromJson(Map<String, dynamic> json) => _$SocialMomentFromJson(json);

@override final  String id;
@override final  String odlId;
@override final  String userId;
@override final  String username;
@override@JsonKey() final  String userAvatar;
@override final  String content;
@override@JsonKey() final  String imageUrl;
@override@JsonKey() final  int likes;
@override@JsonKey() final  int comments;
@override@JsonKey() final  bool isLiked;
 final  List<String> _likedByUsers;
@override@JsonKey() List<String> get likedByUsers {
  if (_likedByUsers is EqualUnmodifiableListView) return _likedByUsers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_likedByUsers);
}

@override final  DateTime? createdAt;

/// Create a copy of SocialMoment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SocialMomentCopyWith<_SocialMoment> get copyWith => __$SocialMomentCopyWithImpl<_SocialMoment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SocialMomentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SocialMoment&&(identical(other.id, id) || other.id == id)&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar)&&(identical(other.content, content) || other.content == content)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&const DeepCollectionEquality().equals(other._likedByUsers, _likedByUsers)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,odlId,userId,username,userAvatar,content,imageUrl,likes,comments,isLiked,const DeepCollectionEquality().hash(_likedByUsers),createdAt);

@override
String toString() {
  return 'SocialMoment(id: $id, odlId: $odlId, userId: $userId, username: $username, userAvatar: $userAvatar, content: $content, imageUrl: $imageUrl, likes: $likes, comments: $comments, isLiked: $isLiked, likedByUsers: $likedByUsers, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SocialMomentCopyWith<$Res> implements $SocialMomentCopyWith<$Res> {
  factory _$SocialMomentCopyWith(_SocialMoment value, $Res Function(_SocialMoment) _then) = __$SocialMomentCopyWithImpl;
@override @useResult
$Res call({
 String id, String odlId, String userId, String username, String userAvatar, String content, String imageUrl, int likes, int comments, bool isLiked, List<String> likedByUsers, DateTime? createdAt
});




}
/// @nodoc
class __$SocialMomentCopyWithImpl<$Res>
    implements _$SocialMomentCopyWith<$Res> {
  __$SocialMomentCopyWithImpl(this._self, this._then);

  final _SocialMoment _self;
  final $Res Function(_SocialMoment) _then;

/// Create a copy of SocialMoment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? odlId = null,Object? userId = null,Object? username = null,Object? userAvatar = null,Object? content = null,Object? imageUrl = null,Object? likes = null,Object? comments = null,Object? isLiked = null,Object? likedByUsers = null,Object? createdAt = freezed,}) {
  return _then(_SocialMoment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,userAvatar: null == userAvatar ? _self.userAvatar : userAvatar // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,likedByUsers: null == likedByUsers ? _self._likedByUsers : likedByUsers // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$MomentComment {

 String get id; String get momentId; String get odlId; String get userId; String get username; String get userAvatar; String get content; int get likes; bool get isLiked; DateTime? get createdAt;
/// Create a copy of MomentComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MomentCommentCopyWith<MomentComment> get copyWith => _$MomentCommentCopyWithImpl<MomentComment>(this as MomentComment, _$identity);

  /// Serializes this MomentComment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MomentComment&&(identical(other.id, id) || other.id == id)&&(identical(other.momentId, momentId) || other.momentId == momentId)&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar)&&(identical(other.content, content) || other.content == content)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,momentId,odlId,userId,username,userAvatar,content,likes,isLiked,createdAt);

@override
String toString() {
  return 'MomentComment(id: $id, momentId: $momentId, odlId: $odlId, userId: $userId, username: $username, userAvatar: $userAvatar, content: $content, likes: $likes, isLiked: $isLiked, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MomentCommentCopyWith<$Res>  {
  factory $MomentCommentCopyWith(MomentComment value, $Res Function(MomentComment) _then) = _$MomentCommentCopyWithImpl;
@useResult
$Res call({
 String id, String momentId, String odlId, String userId, String username, String userAvatar, String content, int likes, bool isLiked, DateTime? createdAt
});




}
/// @nodoc
class _$MomentCommentCopyWithImpl<$Res>
    implements $MomentCommentCopyWith<$Res> {
  _$MomentCommentCopyWithImpl(this._self, this._then);

  final MomentComment _self;
  final $Res Function(MomentComment) _then;

/// Create a copy of MomentComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? momentId = null,Object? odlId = null,Object? userId = null,Object? username = null,Object? userAvatar = null,Object? content = null,Object? likes = null,Object? isLiked = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,momentId: null == momentId ? _self.momentId : momentId // ignore: cast_nullable_to_non_nullable
as String,odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,userAvatar: null == userAvatar ? _self.userAvatar : userAvatar // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MomentComment].
extension MomentCommentPatterns on MomentComment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MomentComment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MomentComment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MomentComment value)  $default,){
final _that = this;
switch (_that) {
case _MomentComment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MomentComment value)?  $default,){
final _that = this;
switch (_that) {
case _MomentComment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String momentId,  String odlId,  String userId,  String username,  String userAvatar,  String content,  int likes,  bool isLiked,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MomentComment() when $default != null:
return $default(_that.id,_that.momentId,_that.odlId,_that.userId,_that.username,_that.userAvatar,_that.content,_that.likes,_that.isLiked,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String momentId,  String odlId,  String userId,  String username,  String userAvatar,  String content,  int likes,  bool isLiked,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _MomentComment():
return $default(_that.id,_that.momentId,_that.odlId,_that.userId,_that.username,_that.userAvatar,_that.content,_that.likes,_that.isLiked,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String momentId,  String odlId,  String userId,  String username,  String userAvatar,  String content,  int likes,  bool isLiked,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MomentComment() when $default != null:
return $default(_that.id,_that.momentId,_that.odlId,_that.userId,_that.username,_that.userAvatar,_that.content,_that.likes,_that.isLiked,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MomentComment implements MomentComment {
  const _MomentComment({required this.id, required this.momentId, required this.odlId, required this.userId, required this.username, this.userAvatar = '', required this.content, this.likes = 0, this.isLiked = false, this.createdAt});
  factory _MomentComment.fromJson(Map<String, dynamic> json) => _$MomentCommentFromJson(json);

@override final  String id;
@override final  String momentId;
@override final  String odlId;
@override final  String userId;
@override final  String username;
@override@JsonKey() final  String userAvatar;
@override final  String content;
@override@JsonKey() final  int likes;
@override@JsonKey() final  bool isLiked;
@override final  DateTime? createdAt;

/// Create a copy of MomentComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MomentCommentCopyWith<_MomentComment> get copyWith => __$MomentCommentCopyWithImpl<_MomentComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MomentCommentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MomentComment&&(identical(other.id, id) || other.id == id)&&(identical(other.momentId, momentId) || other.momentId == momentId)&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar)&&(identical(other.content, content) || other.content == content)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,momentId,odlId,userId,username,userAvatar,content,likes,isLiked,createdAt);

@override
String toString() {
  return 'MomentComment(id: $id, momentId: $momentId, odlId: $odlId, userId: $userId, username: $username, userAvatar: $userAvatar, content: $content, likes: $likes, isLiked: $isLiked, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MomentCommentCopyWith<$Res> implements $MomentCommentCopyWith<$Res> {
  factory _$MomentCommentCopyWith(_MomentComment value, $Res Function(_MomentComment) _then) = __$MomentCommentCopyWithImpl;
@override @useResult
$Res call({
 String id, String momentId, String odlId, String userId, String username, String userAvatar, String content, int likes, bool isLiked, DateTime? createdAt
});




}
/// @nodoc
class __$MomentCommentCopyWithImpl<$Res>
    implements _$MomentCommentCopyWith<$Res> {
  __$MomentCommentCopyWithImpl(this._self, this._then);

  final _MomentComment _self;
  final $Res Function(_MomentComment) _then;

/// Create a copy of MomentComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? momentId = null,Object? odlId = null,Object? userId = null,Object? username = null,Object? userAvatar = null,Object? content = null,Object? likes = null,Object? isLiked = null,Object? createdAt = freezed,}) {
  return _then(_MomentComment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,momentId: null == momentId ? _self.momentId : momentId // ignore: cast_nullable_to_non_nullable
as String,odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,userAvatar: null == userAvatar ? _self.userAvatar : userAvatar // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$StudyGroup {

 String get id; String get name; String get description; String get imageUrl; String get level; int get memberCount; int get maxMembers; List<String> get memberIds; List<StudyGroupPost> get posts; bool get isJoined; DateTime? get createdAt;
/// Create a copy of StudyGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudyGroupCopyWith<StudyGroup> get copyWith => _$StudyGroupCopyWithImpl<StudyGroup>(this as StudyGroup, _$identity);

  /// Serializes this StudyGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudyGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.level, level) || other.level == level)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.maxMembers, maxMembers) || other.maxMembers == maxMembers)&&const DeepCollectionEquality().equals(other.memberIds, memberIds)&&const DeepCollectionEquality().equals(other.posts, posts)&&(identical(other.isJoined, isJoined) || other.isJoined == isJoined)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,imageUrl,level,memberCount,maxMembers,const DeepCollectionEquality().hash(memberIds),const DeepCollectionEquality().hash(posts),isJoined,createdAt);

@override
String toString() {
  return 'StudyGroup(id: $id, name: $name, description: $description, imageUrl: $imageUrl, level: $level, memberCount: $memberCount, maxMembers: $maxMembers, memberIds: $memberIds, posts: $posts, isJoined: $isJoined, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $StudyGroupCopyWith<$Res>  {
  factory $StudyGroupCopyWith(StudyGroup value, $Res Function(StudyGroup) _then) = _$StudyGroupCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String imageUrl, String level, int memberCount, int maxMembers, List<String> memberIds, List<StudyGroupPost> posts, bool isJoined, DateTime? createdAt
});




}
/// @nodoc
class _$StudyGroupCopyWithImpl<$Res>
    implements $StudyGroupCopyWith<$Res> {
  _$StudyGroupCopyWithImpl(this._self, this._then);

  final StudyGroup _self;
  final $Res Function(StudyGroup) _then;

/// Create a copy of StudyGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? imageUrl = null,Object? level = null,Object? memberCount = null,Object? maxMembers = null,Object? memberIds = null,Object? posts = null,Object? isJoined = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,maxMembers: null == maxMembers ? _self.maxMembers : maxMembers // ignore: cast_nullable_to_non_nullable
as int,memberIds: null == memberIds ? _self.memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as List<String>,posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<StudyGroupPost>,isJoined: null == isJoined ? _self.isJoined : isJoined // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StudyGroup].
extension StudyGroupPatterns on StudyGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudyGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudyGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudyGroup value)  $default,){
final _that = this;
switch (_that) {
case _StudyGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudyGroup value)?  $default,){
final _that = this;
switch (_that) {
case _StudyGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String imageUrl,  String level,  int memberCount,  int maxMembers,  List<String> memberIds,  List<StudyGroupPost> posts,  bool isJoined,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudyGroup() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.imageUrl,_that.level,_that.memberCount,_that.maxMembers,_that.memberIds,_that.posts,_that.isJoined,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String imageUrl,  String level,  int memberCount,  int maxMembers,  List<String> memberIds,  List<StudyGroupPost> posts,  bool isJoined,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _StudyGroup():
return $default(_that.id,_that.name,_that.description,_that.imageUrl,_that.level,_that.memberCount,_that.maxMembers,_that.memberIds,_that.posts,_that.isJoined,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  String imageUrl,  String level,  int memberCount,  int maxMembers,  List<String> memberIds,  List<StudyGroupPost> posts,  bool isJoined,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StudyGroup() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.imageUrl,_that.level,_that.memberCount,_that.maxMembers,_that.memberIds,_that.posts,_that.isJoined,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudyGroup implements StudyGroup {
  const _StudyGroup({required this.id, required this.name, this.description = '', this.imageUrl = '', this.level = '', this.memberCount = 0, this.maxMembers = 50, final  List<String> memberIds = const <String>[], final  List<StudyGroupPost> posts = const <StudyGroupPost>[], this.isJoined = false, this.createdAt}): _memberIds = memberIds,_posts = posts;
  factory _StudyGroup.fromJson(Map<String, dynamic> json) => _$StudyGroupFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  String imageUrl;
@override@JsonKey() final  String level;
@override@JsonKey() final  int memberCount;
@override@JsonKey() final  int maxMembers;
 final  List<String> _memberIds;
@override@JsonKey() List<String> get memberIds {
  if (_memberIds is EqualUnmodifiableListView) return _memberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memberIds);
}

 final  List<StudyGroupPost> _posts;
@override@JsonKey() List<StudyGroupPost> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

@override@JsonKey() final  bool isJoined;
@override final  DateTime? createdAt;

/// Create a copy of StudyGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudyGroupCopyWith<_StudyGroup> get copyWith => __$StudyGroupCopyWithImpl<_StudyGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudyGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudyGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.level, level) || other.level == level)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.maxMembers, maxMembers) || other.maxMembers == maxMembers)&&const DeepCollectionEquality().equals(other._memberIds, _memberIds)&&const DeepCollectionEquality().equals(other._posts, _posts)&&(identical(other.isJoined, isJoined) || other.isJoined == isJoined)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,imageUrl,level,memberCount,maxMembers,const DeepCollectionEquality().hash(_memberIds),const DeepCollectionEquality().hash(_posts),isJoined,createdAt);

@override
String toString() {
  return 'StudyGroup(id: $id, name: $name, description: $description, imageUrl: $imageUrl, level: $level, memberCount: $memberCount, maxMembers: $maxMembers, memberIds: $memberIds, posts: $posts, isJoined: $isJoined, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StudyGroupCopyWith<$Res> implements $StudyGroupCopyWith<$Res> {
  factory _$StudyGroupCopyWith(_StudyGroup value, $Res Function(_StudyGroup) _then) = __$StudyGroupCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String imageUrl, String level, int memberCount, int maxMembers, List<String> memberIds, List<StudyGroupPost> posts, bool isJoined, DateTime? createdAt
});




}
/// @nodoc
class __$StudyGroupCopyWithImpl<$Res>
    implements _$StudyGroupCopyWith<$Res> {
  __$StudyGroupCopyWithImpl(this._self, this._then);

  final _StudyGroup _self;
  final $Res Function(_StudyGroup) _then;

/// Create a copy of StudyGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? imageUrl = null,Object? level = null,Object? memberCount = null,Object? maxMembers = null,Object? memberIds = null,Object? posts = null,Object? isJoined = null,Object? createdAt = freezed,}) {
  return _then(_StudyGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,maxMembers: null == maxMembers ? _self.maxMembers : maxMembers // ignore: cast_nullable_to_non_nullable
as int,memberIds: null == memberIds ? _self._memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as List<String>,posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<StudyGroupPost>,isJoined: null == isJoined ? _self.isJoined : isJoined // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$StudyGroupPost {

 String get id; String get groupId; String get odlId; String get userId; String get username; String get content; int get likes; int get comments; DateTime? get createdAt;
/// Create a copy of StudyGroupPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudyGroupPostCopyWith<StudyGroupPost> get copyWith => _$StudyGroupPostCopyWithImpl<StudyGroupPost>(this as StudyGroupPost, _$identity);

  /// Serializes this StudyGroupPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudyGroupPost&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.content, content) || other.content == content)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,odlId,userId,username,content,likes,comments,createdAt);

@override
String toString() {
  return 'StudyGroupPost(id: $id, groupId: $groupId, odlId: $odlId, userId: $userId, username: $username, content: $content, likes: $likes, comments: $comments, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $StudyGroupPostCopyWith<$Res>  {
  factory $StudyGroupPostCopyWith(StudyGroupPost value, $Res Function(StudyGroupPost) _then) = _$StudyGroupPostCopyWithImpl;
@useResult
$Res call({
 String id, String groupId, String odlId, String userId, String username, String content, int likes, int comments, DateTime? createdAt
});




}
/// @nodoc
class _$StudyGroupPostCopyWithImpl<$Res>
    implements $StudyGroupPostCopyWith<$Res> {
  _$StudyGroupPostCopyWithImpl(this._self, this._then);

  final StudyGroupPost _self;
  final $Res Function(StudyGroupPost) _then;

/// Create a copy of StudyGroupPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groupId = null,Object? odlId = null,Object? userId = null,Object? username = null,Object? content = null,Object? likes = null,Object? comments = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StudyGroupPost].
extension StudyGroupPostPatterns on StudyGroupPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudyGroupPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudyGroupPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudyGroupPost value)  $default,){
final _that = this;
switch (_that) {
case _StudyGroupPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudyGroupPost value)?  $default,){
final _that = this;
switch (_that) {
case _StudyGroupPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String groupId,  String odlId,  String userId,  String username,  String content,  int likes,  int comments,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudyGroupPost() when $default != null:
return $default(_that.id,_that.groupId,_that.odlId,_that.userId,_that.username,_that.content,_that.likes,_that.comments,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String groupId,  String odlId,  String userId,  String username,  String content,  int likes,  int comments,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _StudyGroupPost():
return $default(_that.id,_that.groupId,_that.odlId,_that.userId,_that.username,_that.content,_that.likes,_that.comments,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String groupId,  String odlId,  String userId,  String username,  String content,  int likes,  int comments,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StudyGroupPost() when $default != null:
return $default(_that.id,_that.groupId,_that.odlId,_that.userId,_that.username,_that.content,_that.likes,_that.comments,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudyGroupPost implements StudyGroupPost {
  const _StudyGroupPost({required this.id, required this.groupId, required this.odlId, required this.userId, required this.username, required this.content, this.likes = 0, this.comments = 0, this.createdAt});
  factory _StudyGroupPost.fromJson(Map<String, dynamic> json) => _$StudyGroupPostFromJson(json);

@override final  String id;
@override final  String groupId;
@override final  String odlId;
@override final  String userId;
@override final  String username;
@override final  String content;
@override@JsonKey() final  int likes;
@override@JsonKey() final  int comments;
@override final  DateTime? createdAt;

/// Create a copy of StudyGroupPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudyGroupPostCopyWith<_StudyGroupPost> get copyWith => __$StudyGroupPostCopyWithImpl<_StudyGroupPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudyGroupPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudyGroupPost&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.content, content) || other.content == content)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,odlId,userId,username,content,likes,comments,createdAt);

@override
String toString() {
  return 'StudyGroupPost(id: $id, groupId: $groupId, odlId: $odlId, userId: $userId, username: $username, content: $content, likes: $likes, comments: $comments, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StudyGroupPostCopyWith<$Res> implements $StudyGroupPostCopyWith<$Res> {
  factory _$StudyGroupPostCopyWith(_StudyGroupPost value, $Res Function(_StudyGroupPost) _then) = __$StudyGroupPostCopyWithImpl;
@override @useResult
$Res call({
 String id, String groupId, String odlId, String userId, String username, String content, int likes, int comments, DateTime? createdAt
});




}
/// @nodoc
class __$StudyGroupPostCopyWithImpl<$Res>
    implements _$StudyGroupPostCopyWith<$Res> {
  __$StudyGroupPostCopyWithImpl(this._self, this._then);

  final _StudyGroupPost _self;
  final $Res Function(_StudyGroupPost) _then;

/// Create a copy of StudyGroupPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groupId = null,Object? odlId = null,Object? userId = null,Object? username = null,Object? content = null,Object? likes = null,Object? comments = null,Object? createdAt = freezed,}) {
  return _then(_StudyGroupPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Challenge {

 String get id; String get title; String get titleVi; String get challengerId; String get challengerName; String get challengerAvatar; String get challengedId; String get challengedName; String get challengedAvatar; String get type; int get xpReward; String get status; DateTime? get createdAt; DateTime? get acceptedAt; DateTime? get completedAt;
/// Create a copy of Challenge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChallengeCopyWith<Challenge> get copyWith => _$ChallengeCopyWithImpl<Challenge>(this as Challenge, _$identity);

  /// Serializes this Challenge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Challenge&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.challengerId, challengerId) || other.challengerId == challengerId)&&(identical(other.challengerName, challengerName) || other.challengerName == challengerName)&&(identical(other.challengerAvatar, challengerAvatar) || other.challengerAvatar == challengerAvatar)&&(identical(other.challengedId, challengedId) || other.challengedId == challengedId)&&(identical(other.challengedName, challengedName) || other.challengedName == challengedName)&&(identical(other.challengedAvatar, challengedAvatar) || other.challengedAvatar == challengedAvatar)&&(identical(other.type, type) || other.type == type)&&(identical(other.xpReward, xpReward) || other.xpReward == xpReward)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.acceptedAt, acceptedAt) || other.acceptedAt == acceptedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,titleVi,challengerId,challengerName,challengerAvatar,challengedId,challengedName,challengedAvatar,type,xpReward,status,createdAt,acceptedAt,completedAt);

@override
String toString() {
  return 'Challenge(id: $id, title: $title, titleVi: $titleVi, challengerId: $challengerId, challengerName: $challengerName, challengerAvatar: $challengerAvatar, challengedId: $challengedId, challengedName: $challengedName, challengedAvatar: $challengedAvatar, type: $type, xpReward: $xpReward, status: $status, createdAt: $createdAt, acceptedAt: $acceptedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $ChallengeCopyWith<$Res>  {
  factory $ChallengeCopyWith(Challenge value, $Res Function(Challenge) _then) = _$ChallengeCopyWithImpl;
@useResult
$Res call({
 String id, String title, String titleVi, String challengerId, String challengerName, String challengerAvatar, String challengedId, String challengedName, String challengedAvatar, String type, int xpReward, String status, DateTime? createdAt, DateTime? acceptedAt, DateTime? completedAt
});




}
/// @nodoc
class _$ChallengeCopyWithImpl<$Res>
    implements $ChallengeCopyWith<$Res> {
  _$ChallengeCopyWithImpl(this._self, this._then);

  final Challenge _self;
  final $Res Function(Challenge) _then;

/// Create a copy of Challenge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? titleVi = null,Object? challengerId = null,Object? challengerName = null,Object? challengerAvatar = null,Object? challengedId = null,Object? challengedName = null,Object? challengedAvatar = null,Object? type = null,Object? xpReward = null,Object? status = null,Object? createdAt = freezed,Object? acceptedAt = freezed,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,challengerId: null == challengerId ? _self.challengerId : challengerId // ignore: cast_nullable_to_non_nullable
as String,challengerName: null == challengerName ? _self.challengerName : challengerName // ignore: cast_nullable_to_non_nullable
as String,challengerAvatar: null == challengerAvatar ? _self.challengerAvatar : challengerAvatar // ignore: cast_nullable_to_non_nullable
as String,challengedId: null == challengedId ? _self.challengedId : challengedId // ignore: cast_nullable_to_non_nullable
as String,challengedName: null == challengedName ? _self.challengedName : challengedName // ignore: cast_nullable_to_non_nullable
as String,challengedAvatar: null == challengedAvatar ? _self.challengedAvatar : challengedAvatar // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,xpReward: null == xpReward ? _self.xpReward : xpReward // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acceptedAt: freezed == acceptedAt ? _self.acceptedAt : acceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Challenge].
extension ChallengePatterns on Challenge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Challenge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Challenge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Challenge value)  $default,){
final _that = this;
switch (_that) {
case _Challenge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Challenge value)?  $default,){
final _that = this;
switch (_that) {
case _Challenge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String titleVi,  String challengerId,  String challengerName,  String challengerAvatar,  String challengedId,  String challengedName,  String challengedAvatar,  String type,  int xpReward,  String status,  DateTime? createdAt,  DateTime? acceptedAt,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Challenge() when $default != null:
return $default(_that.id,_that.title,_that.titleVi,_that.challengerId,_that.challengerName,_that.challengerAvatar,_that.challengedId,_that.challengedName,_that.challengedAvatar,_that.type,_that.xpReward,_that.status,_that.createdAt,_that.acceptedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String titleVi,  String challengerId,  String challengerName,  String challengerAvatar,  String challengedId,  String challengedName,  String challengedAvatar,  String type,  int xpReward,  String status,  DateTime? createdAt,  DateTime? acceptedAt,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _Challenge():
return $default(_that.id,_that.title,_that.titleVi,_that.challengerId,_that.challengerName,_that.challengerAvatar,_that.challengedId,_that.challengedName,_that.challengedAvatar,_that.type,_that.xpReward,_that.status,_that.createdAt,_that.acceptedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String titleVi,  String challengerId,  String challengerName,  String challengerAvatar,  String challengedId,  String challengedName,  String challengedAvatar,  String type,  int xpReward,  String status,  DateTime? createdAt,  DateTime? acceptedAt,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _Challenge() when $default != null:
return $default(_that.id,_that.title,_that.titleVi,_that.challengerId,_that.challengerName,_that.challengerAvatar,_that.challengedId,_that.challengedName,_that.challengedAvatar,_that.type,_that.xpReward,_that.status,_that.createdAt,_that.acceptedAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Challenge implements Challenge {
  const _Challenge({required this.id, required this.title, required this.titleVi, required this.challengerId, required this.challengerName, required this.challengerAvatar, required this.challengedId, required this.challengedName, required this.challengedAvatar, required this.type, this.xpReward = 0, this.status = 'pending', this.createdAt, this.acceptedAt, this.completedAt});
  factory _Challenge.fromJson(Map<String, dynamic> json) => _$ChallengeFromJson(json);

@override final  String id;
@override final  String title;
@override final  String titleVi;
@override final  String challengerId;
@override final  String challengerName;
@override final  String challengerAvatar;
@override final  String challengedId;
@override final  String challengedName;
@override final  String challengedAvatar;
@override final  String type;
@override@JsonKey() final  int xpReward;
@override@JsonKey() final  String status;
@override final  DateTime? createdAt;
@override final  DateTime? acceptedAt;
@override final  DateTime? completedAt;

/// Create a copy of Challenge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChallengeCopyWith<_Challenge> get copyWith => __$ChallengeCopyWithImpl<_Challenge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChallengeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Challenge&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.challengerId, challengerId) || other.challengerId == challengerId)&&(identical(other.challengerName, challengerName) || other.challengerName == challengerName)&&(identical(other.challengerAvatar, challengerAvatar) || other.challengerAvatar == challengerAvatar)&&(identical(other.challengedId, challengedId) || other.challengedId == challengedId)&&(identical(other.challengedName, challengedName) || other.challengedName == challengedName)&&(identical(other.challengedAvatar, challengedAvatar) || other.challengedAvatar == challengedAvatar)&&(identical(other.type, type) || other.type == type)&&(identical(other.xpReward, xpReward) || other.xpReward == xpReward)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.acceptedAt, acceptedAt) || other.acceptedAt == acceptedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,titleVi,challengerId,challengerName,challengerAvatar,challengedId,challengedName,challengedAvatar,type,xpReward,status,createdAt,acceptedAt,completedAt);

@override
String toString() {
  return 'Challenge(id: $id, title: $title, titleVi: $titleVi, challengerId: $challengerId, challengerName: $challengerName, challengerAvatar: $challengerAvatar, challengedId: $challengedId, challengedName: $challengedName, challengedAvatar: $challengedAvatar, type: $type, xpReward: $xpReward, status: $status, createdAt: $createdAt, acceptedAt: $acceptedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$ChallengeCopyWith<$Res> implements $ChallengeCopyWith<$Res> {
  factory _$ChallengeCopyWith(_Challenge value, $Res Function(_Challenge) _then) = __$ChallengeCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String titleVi, String challengerId, String challengerName, String challengerAvatar, String challengedId, String challengedName, String challengedAvatar, String type, int xpReward, String status, DateTime? createdAt, DateTime? acceptedAt, DateTime? completedAt
});




}
/// @nodoc
class __$ChallengeCopyWithImpl<$Res>
    implements _$ChallengeCopyWith<$Res> {
  __$ChallengeCopyWithImpl(this._self, this._then);

  final _Challenge _self;
  final $Res Function(_Challenge) _then;

/// Create a copy of Challenge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? titleVi = null,Object? challengerId = null,Object? challengerName = null,Object? challengerAvatar = null,Object? challengedId = null,Object? challengedName = null,Object? challengedAvatar = null,Object? type = null,Object? xpReward = null,Object? status = null,Object? createdAt = freezed,Object? acceptedAt = freezed,Object? completedAt = freezed,}) {
  return _then(_Challenge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,challengerId: null == challengerId ? _self.challengerId : challengerId // ignore: cast_nullable_to_non_nullable
as String,challengerName: null == challengerName ? _self.challengerName : challengerName // ignore: cast_nullable_to_non_nullable
as String,challengerAvatar: null == challengerAvatar ? _self.challengerAvatar : challengerAvatar // ignore: cast_nullable_to_non_nullable
as String,challengedId: null == challengedId ? _self.challengedId : challengedId // ignore: cast_nullable_to_non_nullable
as String,challengedName: null == challengedName ? _self.challengedName : challengedName // ignore: cast_nullable_to_non_nullable
as String,challengedAvatar: null == challengedAvatar ? _self.challengedAvatar : challengedAvatar // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,xpReward: null == xpReward ? _self.xpReward : xpReward // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acceptedAt: freezed == acceptedAt ? _self.acceptedAt : acceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Duel {

 String get id; String get player1Id; String get player1Name; String get player1Avatar; String get player2Id; String get player2Name; String get player2Avatar; int get player1Score; int get player2Score; int get player1Correct; int get player2Correct; String get status; int get currentQuestion; DateTime? get startedAt; DateTime? get completedAt;
/// Create a copy of Duel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DuelCopyWith<Duel> get copyWith => _$DuelCopyWithImpl<Duel>(this as Duel, _$identity);

  /// Serializes this Duel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Duel&&(identical(other.id, id) || other.id == id)&&(identical(other.player1Id, player1Id) || other.player1Id == player1Id)&&(identical(other.player1Name, player1Name) || other.player1Name == player1Name)&&(identical(other.player1Avatar, player1Avatar) || other.player1Avatar == player1Avatar)&&(identical(other.player2Id, player2Id) || other.player2Id == player2Id)&&(identical(other.player2Name, player2Name) || other.player2Name == player2Name)&&(identical(other.player2Avatar, player2Avatar) || other.player2Avatar == player2Avatar)&&(identical(other.player1Score, player1Score) || other.player1Score == player1Score)&&(identical(other.player2Score, player2Score) || other.player2Score == player2Score)&&(identical(other.player1Correct, player1Correct) || other.player1Correct == player1Correct)&&(identical(other.player2Correct, player2Correct) || other.player2Correct == player2Correct)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentQuestion, currentQuestion) || other.currentQuestion == currentQuestion)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,player1Id,player1Name,player1Avatar,player2Id,player2Name,player2Avatar,player1Score,player2Score,player1Correct,player2Correct,status,currentQuestion,startedAt,completedAt);

@override
String toString() {
  return 'Duel(id: $id, player1Id: $player1Id, player1Name: $player1Name, player1Avatar: $player1Avatar, player2Id: $player2Id, player2Name: $player2Name, player2Avatar: $player2Avatar, player1Score: $player1Score, player2Score: $player2Score, player1Correct: $player1Correct, player2Correct: $player2Correct, status: $status, currentQuestion: $currentQuestion, startedAt: $startedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $DuelCopyWith<$Res>  {
  factory $DuelCopyWith(Duel value, $Res Function(Duel) _then) = _$DuelCopyWithImpl;
@useResult
$Res call({
 String id, String player1Id, String player1Name, String player1Avatar, String player2Id, String player2Name, String player2Avatar, int player1Score, int player2Score, int player1Correct, int player2Correct, String status, int currentQuestion, DateTime? startedAt, DateTime? completedAt
});




}
/// @nodoc
class _$DuelCopyWithImpl<$Res>
    implements $DuelCopyWith<$Res> {
  _$DuelCopyWithImpl(this._self, this._then);

  final Duel _self;
  final $Res Function(Duel) _then;

/// Create a copy of Duel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? player1Id = null,Object? player1Name = null,Object? player1Avatar = null,Object? player2Id = null,Object? player2Name = null,Object? player2Avatar = null,Object? player1Score = null,Object? player2Score = null,Object? player1Correct = null,Object? player2Correct = null,Object? status = null,Object? currentQuestion = null,Object? startedAt = freezed,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,player1Id: null == player1Id ? _self.player1Id : player1Id // ignore: cast_nullable_to_non_nullable
as String,player1Name: null == player1Name ? _self.player1Name : player1Name // ignore: cast_nullable_to_non_nullable
as String,player1Avatar: null == player1Avatar ? _self.player1Avatar : player1Avatar // ignore: cast_nullable_to_non_nullable
as String,player2Id: null == player2Id ? _self.player2Id : player2Id // ignore: cast_nullable_to_non_nullable
as String,player2Name: null == player2Name ? _self.player2Name : player2Name // ignore: cast_nullable_to_non_nullable
as String,player2Avatar: null == player2Avatar ? _self.player2Avatar : player2Avatar // ignore: cast_nullable_to_non_nullable
as String,player1Score: null == player1Score ? _self.player1Score : player1Score // ignore: cast_nullable_to_non_nullable
as int,player2Score: null == player2Score ? _self.player2Score : player2Score // ignore: cast_nullable_to_non_nullable
as int,player1Correct: null == player1Correct ? _self.player1Correct : player1Correct // ignore: cast_nullable_to_non_nullable
as int,player2Correct: null == player2Correct ? _self.player2Correct : player2Correct // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,currentQuestion: null == currentQuestion ? _self.currentQuestion : currentQuestion // ignore: cast_nullable_to_non_nullable
as int,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Duel].
extension DuelPatterns on Duel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Duel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Duel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Duel value)  $default,){
final _that = this;
switch (_that) {
case _Duel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Duel value)?  $default,){
final _that = this;
switch (_that) {
case _Duel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String player1Id,  String player1Name,  String player1Avatar,  String player2Id,  String player2Name,  String player2Avatar,  int player1Score,  int player2Score,  int player1Correct,  int player2Correct,  String status,  int currentQuestion,  DateTime? startedAt,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Duel() when $default != null:
return $default(_that.id,_that.player1Id,_that.player1Name,_that.player1Avatar,_that.player2Id,_that.player2Name,_that.player2Avatar,_that.player1Score,_that.player2Score,_that.player1Correct,_that.player2Correct,_that.status,_that.currentQuestion,_that.startedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String player1Id,  String player1Name,  String player1Avatar,  String player2Id,  String player2Name,  String player2Avatar,  int player1Score,  int player2Score,  int player1Correct,  int player2Correct,  String status,  int currentQuestion,  DateTime? startedAt,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _Duel():
return $default(_that.id,_that.player1Id,_that.player1Name,_that.player1Avatar,_that.player2Id,_that.player2Name,_that.player2Avatar,_that.player1Score,_that.player2Score,_that.player1Correct,_that.player2Correct,_that.status,_that.currentQuestion,_that.startedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String player1Id,  String player1Name,  String player1Avatar,  String player2Id,  String player2Name,  String player2Avatar,  int player1Score,  int player2Score,  int player1Correct,  int player2Correct,  String status,  int currentQuestion,  DateTime? startedAt,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _Duel() when $default != null:
return $default(_that.id,_that.player1Id,_that.player1Name,_that.player1Avatar,_that.player2Id,_that.player2Name,_that.player2Avatar,_that.player1Score,_that.player2Score,_that.player1Correct,_that.player2Correct,_that.status,_that.currentQuestion,_that.startedAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Duel implements Duel {
  const _Duel({required this.id, required this.player1Id, required this.player1Name, required this.player1Avatar, required this.player2Id, required this.player2Name, required this.player2Avatar, this.player1Score = 0, this.player2Score = 0, this.player1Correct = 0, this.player2Correct = 0, this.status = 'waiting', this.currentQuestion = 0, this.startedAt, this.completedAt});
  factory _Duel.fromJson(Map<String, dynamic> json) => _$DuelFromJson(json);

@override final  String id;
@override final  String player1Id;
@override final  String player1Name;
@override final  String player1Avatar;
@override final  String player2Id;
@override final  String player2Name;
@override final  String player2Avatar;
@override@JsonKey() final  int player1Score;
@override@JsonKey() final  int player2Score;
@override@JsonKey() final  int player1Correct;
@override@JsonKey() final  int player2Correct;
@override@JsonKey() final  String status;
@override@JsonKey() final  int currentQuestion;
@override final  DateTime? startedAt;
@override final  DateTime? completedAt;

/// Create a copy of Duel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DuelCopyWith<_Duel> get copyWith => __$DuelCopyWithImpl<_Duel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DuelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Duel&&(identical(other.id, id) || other.id == id)&&(identical(other.player1Id, player1Id) || other.player1Id == player1Id)&&(identical(other.player1Name, player1Name) || other.player1Name == player1Name)&&(identical(other.player1Avatar, player1Avatar) || other.player1Avatar == player1Avatar)&&(identical(other.player2Id, player2Id) || other.player2Id == player2Id)&&(identical(other.player2Name, player2Name) || other.player2Name == player2Name)&&(identical(other.player2Avatar, player2Avatar) || other.player2Avatar == player2Avatar)&&(identical(other.player1Score, player1Score) || other.player1Score == player1Score)&&(identical(other.player2Score, player2Score) || other.player2Score == player2Score)&&(identical(other.player1Correct, player1Correct) || other.player1Correct == player1Correct)&&(identical(other.player2Correct, player2Correct) || other.player2Correct == player2Correct)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentQuestion, currentQuestion) || other.currentQuestion == currentQuestion)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,player1Id,player1Name,player1Avatar,player2Id,player2Name,player2Avatar,player1Score,player2Score,player1Correct,player2Correct,status,currentQuestion,startedAt,completedAt);

@override
String toString() {
  return 'Duel(id: $id, player1Id: $player1Id, player1Name: $player1Name, player1Avatar: $player1Avatar, player2Id: $player2Id, player2Name: $player2Name, player2Avatar: $player2Avatar, player1Score: $player1Score, player2Score: $player2Score, player1Correct: $player1Correct, player2Correct: $player2Correct, status: $status, currentQuestion: $currentQuestion, startedAt: $startedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$DuelCopyWith<$Res> implements $DuelCopyWith<$Res> {
  factory _$DuelCopyWith(_Duel value, $Res Function(_Duel) _then) = __$DuelCopyWithImpl;
@override @useResult
$Res call({
 String id, String player1Id, String player1Name, String player1Avatar, String player2Id, String player2Name, String player2Avatar, int player1Score, int player2Score, int player1Correct, int player2Correct, String status, int currentQuestion, DateTime? startedAt, DateTime? completedAt
});




}
/// @nodoc
class __$DuelCopyWithImpl<$Res>
    implements _$DuelCopyWith<$Res> {
  __$DuelCopyWithImpl(this._self, this._then);

  final _Duel _self;
  final $Res Function(_Duel) _then;

/// Create a copy of Duel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? player1Id = null,Object? player1Name = null,Object? player1Avatar = null,Object? player2Id = null,Object? player2Name = null,Object? player2Avatar = null,Object? player1Score = null,Object? player2Score = null,Object? player1Correct = null,Object? player2Correct = null,Object? status = null,Object? currentQuestion = null,Object? startedAt = freezed,Object? completedAt = freezed,}) {
  return _then(_Duel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,player1Id: null == player1Id ? _self.player1Id : player1Id // ignore: cast_nullable_to_non_nullable
as String,player1Name: null == player1Name ? _self.player1Name : player1Name // ignore: cast_nullable_to_non_nullable
as String,player1Avatar: null == player1Avatar ? _self.player1Avatar : player1Avatar // ignore: cast_nullable_to_non_nullable
as String,player2Id: null == player2Id ? _self.player2Id : player2Id // ignore: cast_nullable_to_non_nullable
as String,player2Name: null == player2Name ? _self.player2Name : player2Name // ignore: cast_nullable_to_non_nullable
as String,player2Avatar: null == player2Avatar ? _self.player2Avatar : player2Avatar // ignore: cast_nullable_to_non_nullable
as String,player1Score: null == player1Score ? _self.player1Score : player1Score // ignore: cast_nullable_to_non_nullable
as int,player2Score: null == player2Score ? _self.player2Score : player2Score // ignore: cast_nullable_to_non_nullable
as int,player1Correct: null == player1Correct ? _self.player1Correct : player1Correct // ignore: cast_nullable_to_non_nullable
as int,player2Correct: null == player2Correct ? _self.player2Correct : player2Correct // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,currentQuestion: null == currentQuestion ? _self.currentQuestion : currentQuestion // ignore: cast_nullable_to_non_nullable
as int,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Friend {

 String get id; String get odlId; String get userId; String get username; String get avatar; int get level; int get totalXp; int get streakDays; String get status; DateTime? get lastActiveAt;
/// Create a copy of Friend
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FriendCopyWith<Friend> get copyWith => _$FriendCopyWithImpl<Friend>(this as Friend, _$identity);

  /// Serializes this Friend to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Friend&&(identical(other.id, id) || other.id == id)&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.level, level) || other.level == level)&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,odlId,userId,username,avatar,level,totalXp,streakDays,status,lastActiveAt);

@override
String toString() {
  return 'Friend(id: $id, odlId: $odlId, userId: $userId, username: $username, avatar: $avatar, level: $level, totalXp: $totalXp, streakDays: $streakDays, status: $status, lastActiveAt: $lastActiveAt)';
}


}

/// @nodoc
abstract mixin class $FriendCopyWith<$Res>  {
  factory $FriendCopyWith(Friend value, $Res Function(Friend) _then) = _$FriendCopyWithImpl;
@useResult
$Res call({
 String id, String odlId, String userId, String username, String avatar, int level, int totalXp, int streakDays, String status, DateTime? lastActiveAt
});




}
/// @nodoc
class _$FriendCopyWithImpl<$Res>
    implements $FriendCopyWith<$Res> {
  _$FriendCopyWithImpl(this._self, this._then);

  final Friend _self;
  final $Res Function(Friend) _then;

/// Create a copy of Friend
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? odlId = null,Object? userId = null,Object? username = null,Object? avatar = null,Object? level = null,Object? totalXp = null,Object? streakDays = null,Object? status = null,Object? lastActiveAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Friend].
extension FriendPatterns on Friend {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Friend value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Friend() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Friend value)  $default,){
final _that = this;
switch (_that) {
case _Friend():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Friend value)?  $default,){
final _that = this;
switch (_that) {
case _Friend() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String odlId,  String userId,  String username,  String avatar,  int level,  int totalXp,  int streakDays,  String status,  DateTime? lastActiveAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Friend() when $default != null:
return $default(_that.id,_that.odlId,_that.userId,_that.username,_that.avatar,_that.level,_that.totalXp,_that.streakDays,_that.status,_that.lastActiveAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String odlId,  String userId,  String username,  String avatar,  int level,  int totalXp,  int streakDays,  String status,  DateTime? lastActiveAt)  $default,) {final _that = this;
switch (_that) {
case _Friend():
return $default(_that.id,_that.odlId,_that.userId,_that.username,_that.avatar,_that.level,_that.totalXp,_that.streakDays,_that.status,_that.lastActiveAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String odlId,  String userId,  String username,  String avatar,  int level,  int totalXp,  int streakDays,  String status,  DateTime? lastActiveAt)?  $default,) {final _that = this;
switch (_that) {
case _Friend() when $default != null:
return $default(_that.id,_that.odlId,_that.userId,_that.username,_that.avatar,_that.level,_that.totalXp,_that.streakDays,_that.status,_that.lastActiveAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Friend implements Friend {
  const _Friend({required this.id, required this.odlId, required this.userId, required this.username, this.avatar = '', this.level = 0, this.totalXp = 0, this.streakDays = 0, this.status = 'offline', this.lastActiveAt});
  factory _Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);

@override final  String id;
@override final  String odlId;
@override final  String userId;
@override final  String username;
@override@JsonKey() final  String avatar;
@override@JsonKey() final  int level;
@override@JsonKey() final  int totalXp;
@override@JsonKey() final  int streakDays;
@override@JsonKey() final  String status;
@override final  DateTime? lastActiveAt;

/// Create a copy of Friend
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FriendCopyWith<_Friend> get copyWith => __$FriendCopyWithImpl<_Friend>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FriendToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Friend&&(identical(other.id, id) || other.id == id)&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.level, level) || other.level == level)&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,odlId,userId,username,avatar,level,totalXp,streakDays,status,lastActiveAt);

@override
String toString() {
  return 'Friend(id: $id, odlId: $odlId, userId: $userId, username: $username, avatar: $avatar, level: $level, totalXp: $totalXp, streakDays: $streakDays, status: $status, lastActiveAt: $lastActiveAt)';
}


}

/// @nodoc
abstract mixin class _$FriendCopyWith<$Res> implements $FriendCopyWith<$Res> {
  factory _$FriendCopyWith(_Friend value, $Res Function(_Friend) _then) = __$FriendCopyWithImpl;
@override @useResult
$Res call({
 String id, String odlId, String userId, String username, String avatar, int level, int totalXp, int streakDays, String status, DateTime? lastActiveAt
});




}
/// @nodoc
class __$FriendCopyWithImpl<$Res>
    implements _$FriendCopyWith<$Res> {
  __$FriendCopyWithImpl(this._self, this._then);

  final _Friend _self;
  final $Res Function(_Friend) _then;

/// Create a copy of Friend
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? odlId = null,Object? userId = null,Object? username = null,Object? avatar = null,Object? level = null,Object? totalXp = null,Object? streakDays = null,Object? status = null,Object? lastActiveAt = freezed,}) {
  return _then(_Friend(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ChatMessage {

 String get id; String get conversationId; String get senderId; String get receiverId; String get content; bool get isRead; DateTime? get sentAt; DateTime? get readAt;
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<ChatMessage> get copyWith => _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.receiverId, receiverId) || other.receiverId == receiverId)&&(identical(other.content, content) || other.content == content)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.readAt, readAt) || other.readAt == readAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,senderId,receiverId,content,isRead,sentAt,readAt);

@override
String toString() {
  return 'ChatMessage(id: $id, conversationId: $conversationId, senderId: $senderId, receiverId: $receiverId, content: $content, isRead: $isRead, sentAt: $sentAt, readAt: $readAt)';
}


}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res>  {
  factory $ChatMessageCopyWith(ChatMessage value, $Res Function(ChatMessage) _then) = _$ChatMessageCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, String senderId, String receiverId, String content, bool isRead, DateTime? sentAt, DateTime? readAt
});




}
/// @nodoc
class _$ChatMessageCopyWithImpl<$Res>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? senderId = null,Object? receiverId = null,Object? content = null,Object? isRead = null,Object? sentAt = freezed,Object? readAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,receiverId: null == receiverId ? _self.receiverId : receiverId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  String senderId,  String receiverId,  String content,  bool isRead,  DateTime? sentAt,  DateTime? readAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.conversationId,_that.senderId,_that.receiverId,_that.content,_that.isRead,_that.sentAt,_that.readAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  String senderId,  String receiverId,  String content,  bool isRead,  DateTime? sentAt,  DateTime? readAt)  $default,) {final _that = this;
switch (_that) {
case _ChatMessage():
return $default(_that.id,_that.conversationId,_that.senderId,_that.receiverId,_that.content,_that.isRead,_that.sentAt,_that.readAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  String senderId,  String receiverId,  String content,  bool isRead,  DateTime? sentAt,  DateTime? readAt)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.conversationId,_that.senderId,_that.receiverId,_that.content,_that.isRead,_that.sentAt,_that.readAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessage implements ChatMessage {
  const _ChatMessage({required this.id, required this.conversationId, required this.senderId, required this.receiverId, required this.content, this.isRead = false, this.sentAt, this.readAt});
  factory _ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

@override final  String id;
@override final  String conversationId;
@override final  String senderId;
@override final  String receiverId;
@override final  String content;
@override@JsonKey() final  bool isRead;
@override final  DateTime? sentAt;
@override final  DateTime? readAt;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageCopyWith<_ChatMessage> get copyWith => __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.receiverId, receiverId) || other.receiverId == receiverId)&&(identical(other.content, content) || other.content == content)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.readAt, readAt) || other.readAt == readAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,senderId,receiverId,content,isRead,sentAt,readAt);

@override
String toString() {
  return 'ChatMessage(id: $id, conversationId: $conversationId, senderId: $senderId, receiverId: $receiverId, content: $content, isRead: $isRead, sentAt: $sentAt, readAt: $readAt)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(_ChatMessage value, $Res Function(_ChatMessage) _then) = __$ChatMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, String senderId, String receiverId, String content, bool isRead, DateTime? sentAt, DateTime? readAt
});




}
/// @nodoc
class __$ChatMessageCopyWithImpl<$Res>
    implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? senderId = null,Object? receiverId = null,Object? content = null,Object? isRead = null,Object? sentAt = freezed,Object? readAt = freezed,}) {
  return _then(_ChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,receiverId: null == receiverId ? _self.receiverId : receiverId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ChatConversation {

 String get id; String get participantId; String get participantName; String get participantAvatar; int get unreadCount; List<ChatMessage> get messages; DateTime? get lastMessageAt;
/// Create a copy of ChatConversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatConversationCopyWith<ChatConversation> get copyWith => _$ChatConversationCopyWithImpl<ChatConversation>(this as ChatConversation, _$identity);

  /// Serializes this ChatConversation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatConversation&&(identical(other.id, id) || other.id == id)&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.participantName, participantName) || other.participantName == participantName)&&(identical(other.participantAvatar, participantAvatar) || other.participantAvatar == participantAvatar)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,participantId,participantName,participantAvatar,unreadCount,const DeepCollectionEquality().hash(messages),lastMessageAt);

@override
String toString() {
  return 'ChatConversation(id: $id, participantId: $participantId, participantName: $participantName, participantAvatar: $participantAvatar, unreadCount: $unreadCount, messages: $messages, lastMessageAt: $lastMessageAt)';
}


}

/// @nodoc
abstract mixin class $ChatConversationCopyWith<$Res>  {
  factory $ChatConversationCopyWith(ChatConversation value, $Res Function(ChatConversation) _then) = _$ChatConversationCopyWithImpl;
@useResult
$Res call({
 String id, String participantId, String participantName, String participantAvatar, int unreadCount, List<ChatMessage> messages, DateTime? lastMessageAt
});




}
/// @nodoc
class _$ChatConversationCopyWithImpl<$Res>
    implements $ChatConversationCopyWith<$Res> {
  _$ChatConversationCopyWithImpl(this._self, this._then);

  final ChatConversation _self;
  final $Res Function(ChatConversation) _then;

/// Create a copy of ChatConversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? participantId = null,Object? participantName = null,Object? participantAvatar = null,Object? unreadCount = null,Object? messages = null,Object? lastMessageAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,participantName: null == participantName ? _self.participantName : participantName // ignore: cast_nullable_to_non_nullable
as String,participantAvatar: null == participantAvatar ? _self.participantAvatar : participantAvatar // ignore: cast_nullable_to_non_nullable
as String,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatConversation].
extension ChatConversationPatterns on ChatConversation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatConversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatConversation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatConversation value)  $default,){
final _that = this;
switch (_that) {
case _ChatConversation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatConversation value)?  $default,){
final _that = this;
switch (_that) {
case _ChatConversation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String participantId,  String participantName,  String participantAvatar,  int unreadCount,  List<ChatMessage> messages,  DateTime? lastMessageAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatConversation() when $default != null:
return $default(_that.id,_that.participantId,_that.participantName,_that.participantAvatar,_that.unreadCount,_that.messages,_that.lastMessageAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String participantId,  String participantName,  String participantAvatar,  int unreadCount,  List<ChatMessage> messages,  DateTime? lastMessageAt)  $default,) {final _that = this;
switch (_that) {
case _ChatConversation():
return $default(_that.id,_that.participantId,_that.participantName,_that.participantAvatar,_that.unreadCount,_that.messages,_that.lastMessageAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String participantId,  String participantName,  String participantAvatar,  int unreadCount,  List<ChatMessage> messages,  DateTime? lastMessageAt)?  $default,) {final _that = this;
switch (_that) {
case _ChatConversation() when $default != null:
return $default(_that.id,_that.participantId,_that.participantName,_that.participantAvatar,_that.unreadCount,_that.messages,_that.lastMessageAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatConversation implements ChatConversation {
  const _ChatConversation({required this.id, required this.participantId, required this.participantName, this.participantAvatar = '', this.unreadCount = 0, final  List<ChatMessage> messages = const <ChatMessage>[], this.lastMessageAt}): _messages = messages;
  factory _ChatConversation.fromJson(Map<String, dynamic> json) => _$ChatConversationFromJson(json);

@override final  String id;
@override final  String participantId;
@override final  String participantName;
@override@JsonKey() final  String participantAvatar;
@override@JsonKey() final  int unreadCount;
 final  List<ChatMessage> _messages;
@override@JsonKey() List<ChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override final  DateTime? lastMessageAt;

/// Create a copy of ChatConversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatConversationCopyWith<_ChatConversation> get copyWith => __$ChatConversationCopyWithImpl<_ChatConversation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatConversationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatConversation&&(identical(other.id, id) || other.id == id)&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.participantName, participantName) || other.participantName == participantName)&&(identical(other.participantAvatar, participantAvatar) || other.participantAvatar == participantAvatar)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,participantId,participantName,participantAvatar,unreadCount,const DeepCollectionEquality().hash(_messages),lastMessageAt);

@override
String toString() {
  return 'ChatConversation(id: $id, participantId: $participantId, participantName: $participantName, participantAvatar: $participantAvatar, unreadCount: $unreadCount, messages: $messages, lastMessageAt: $lastMessageAt)';
}


}

/// @nodoc
abstract mixin class _$ChatConversationCopyWith<$Res> implements $ChatConversationCopyWith<$Res> {
  factory _$ChatConversationCopyWith(_ChatConversation value, $Res Function(_ChatConversation) _then) = __$ChatConversationCopyWithImpl;
@override @useResult
$Res call({
 String id, String participantId, String participantName, String participantAvatar, int unreadCount, List<ChatMessage> messages, DateTime? lastMessageAt
});




}
/// @nodoc
class __$ChatConversationCopyWithImpl<$Res>
    implements _$ChatConversationCopyWith<$Res> {
  __$ChatConversationCopyWithImpl(this._self, this._then);

  final _ChatConversation _self;
  final $Res Function(_ChatConversation) _then;

/// Create a copy of ChatConversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? participantId = null,Object? participantName = null,Object? participantAvatar = null,Object? unreadCount = null,Object? messages = null,Object? lastMessageAt = freezed,}) {
  return _then(_ChatConversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,participantName: null == participantName ? _self.participantName : participantName // ignore: cast_nullable_to_non_nullable
as String,participantAvatar: null == participantAvatar ? _self.participantAvatar : participantAvatar // ignore: cast_nullable_to_non_nullable
as String,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
