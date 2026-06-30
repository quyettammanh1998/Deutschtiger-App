// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journey_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JourneyChapter {

 String get id; String get level; String get title; String get titleVi; String get description; String get descriptionVi; int get order; int get totalLessons; int get completedLessons; double get progressPercent; List<JourneyLesson> get lessons; bool get isLocked; bool get isCompleted;
/// Create a copy of JourneyChapter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JourneyChapterCopyWith<JourneyChapter> get copyWith => _$JourneyChapterCopyWithImpl<JourneyChapter>(this as JourneyChapter, _$identity);

  /// Serializes this JourneyChapter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JourneyChapter&&(identical(other.id, id) || other.id == id)&&(identical(other.level, level) || other.level == level)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.order, order) || other.order == order)&&(identical(other.totalLessons, totalLessons) || other.totalLessons == totalLessons)&&(identical(other.completedLessons, completedLessons) || other.completedLessons == completedLessons)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&const DeepCollectionEquality().equals(other.lessons, lessons)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,level,title,titleVi,description,descriptionVi,order,totalLessons,completedLessons,progressPercent,const DeepCollectionEquality().hash(lessons),isLocked,isCompleted);

@override
String toString() {
  return 'JourneyChapter(id: $id, level: $level, title: $title, titleVi: $titleVi, description: $description, descriptionVi: $descriptionVi, order: $order, totalLessons: $totalLessons, completedLessons: $completedLessons, progressPercent: $progressPercent, lessons: $lessons, isLocked: $isLocked, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class $JourneyChapterCopyWith<$Res>  {
  factory $JourneyChapterCopyWith(JourneyChapter value, $Res Function(JourneyChapter) _then) = _$JourneyChapterCopyWithImpl;
@useResult
$Res call({
 String id, String level, String title, String titleVi, String description, String descriptionVi, int order, int totalLessons, int completedLessons, double progressPercent, List<JourneyLesson> lessons, bool isLocked, bool isCompleted
});




}
/// @nodoc
class _$JourneyChapterCopyWithImpl<$Res>
    implements $JourneyChapterCopyWith<$Res> {
  _$JourneyChapterCopyWithImpl(this._self, this._then);

  final JourneyChapter _self;
  final $Res Function(JourneyChapter) _then;

/// Create a copy of JourneyChapter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? level = null,Object? title = null,Object? titleVi = null,Object? description = null,Object? descriptionVi = null,Object? order = null,Object? totalLessons = null,Object? completedLessons = null,Object? progressPercent = null,Object? lessons = null,Object? isLocked = null,Object? isCompleted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,totalLessons: null == totalLessons ? _self.totalLessons : totalLessons // ignore: cast_nullable_to_non_nullable
as int,completedLessons: null == completedLessons ? _self.completedLessons : completedLessons // ignore: cast_nullable_to_non_nullable
as int,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as double,lessons: null == lessons ? _self.lessons : lessons // ignore: cast_nullable_to_non_nullable
as List<JourneyLesson>,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [JourneyChapter].
extension JourneyChapterPatterns on JourneyChapter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JourneyChapter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JourneyChapter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JourneyChapter value)  $default,){
final _that = this;
switch (_that) {
case _JourneyChapter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JourneyChapter value)?  $default,){
final _that = this;
switch (_that) {
case _JourneyChapter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String level,  String title,  String titleVi,  String description,  String descriptionVi,  int order,  int totalLessons,  int completedLessons,  double progressPercent,  List<JourneyLesson> lessons,  bool isLocked,  bool isCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JourneyChapter() when $default != null:
return $default(_that.id,_that.level,_that.title,_that.titleVi,_that.description,_that.descriptionVi,_that.order,_that.totalLessons,_that.completedLessons,_that.progressPercent,_that.lessons,_that.isLocked,_that.isCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String level,  String title,  String titleVi,  String description,  String descriptionVi,  int order,  int totalLessons,  int completedLessons,  double progressPercent,  List<JourneyLesson> lessons,  bool isLocked,  bool isCompleted)  $default,) {final _that = this;
switch (_that) {
case _JourneyChapter():
return $default(_that.id,_that.level,_that.title,_that.titleVi,_that.description,_that.descriptionVi,_that.order,_that.totalLessons,_that.completedLessons,_that.progressPercent,_that.lessons,_that.isLocked,_that.isCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String level,  String title,  String titleVi,  String description,  String descriptionVi,  int order,  int totalLessons,  int completedLessons,  double progressPercent,  List<JourneyLesson> lessons,  bool isLocked,  bool isCompleted)?  $default,) {final _that = this;
switch (_that) {
case _JourneyChapter() when $default != null:
return $default(_that.id,_that.level,_that.title,_that.titleVi,_that.description,_that.descriptionVi,_that.order,_that.totalLessons,_that.completedLessons,_that.progressPercent,_that.lessons,_that.isLocked,_that.isCompleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JourneyChapter implements JourneyChapter {
  const _JourneyChapter({required this.id, required this.level, required this.title, required this.titleVi, this.description = '', this.descriptionVi = '', this.order = 0, this.totalLessons = 0, this.completedLessons = 0, this.progressPercent = 0.0, final  List<JourneyLesson> lessons = const <JourneyLesson>[], this.isLocked = false, this.isCompleted = false}): _lessons = lessons;
  factory _JourneyChapter.fromJson(Map<String, dynamic> json) => _$JourneyChapterFromJson(json);

@override final  String id;
@override final  String level;
@override final  String title;
@override final  String titleVi;
@override@JsonKey() final  String description;
@override@JsonKey() final  String descriptionVi;
@override@JsonKey() final  int order;
@override@JsonKey() final  int totalLessons;
@override@JsonKey() final  int completedLessons;
@override@JsonKey() final  double progressPercent;
 final  List<JourneyLesson> _lessons;
@override@JsonKey() List<JourneyLesson> get lessons {
  if (_lessons is EqualUnmodifiableListView) return _lessons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lessons);
}

@override@JsonKey() final  bool isLocked;
@override@JsonKey() final  bool isCompleted;

/// Create a copy of JourneyChapter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JourneyChapterCopyWith<_JourneyChapter> get copyWith => __$JourneyChapterCopyWithImpl<_JourneyChapter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JourneyChapterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JourneyChapter&&(identical(other.id, id) || other.id == id)&&(identical(other.level, level) || other.level == level)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.order, order) || other.order == order)&&(identical(other.totalLessons, totalLessons) || other.totalLessons == totalLessons)&&(identical(other.completedLessons, completedLessons) || other.completedLessons == completedLessons)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&const DeepCollectionEquality().equals(other._lessons, _lessons)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,level,title,titleVi,description,descriptionVi,order,totalLessons,completedLessons,progressPercent,const DeepCollectionEquality().hash(_lessons),isLocked,isCompleted);

@override
String toString() {
  return 'JourneyChapter(id: $id, level: $level, title: $title, titleVi: $titleVi, description: $description, descriptionVi: $descriptionVi, order: $order, totalLessons: $totalLessons, completedLessons: $completedLessons, progressPercent: $progressPercent, lessons: $lessons, isLocked: $isLocked, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$JourneyChapterCopyWith<$Res> implements $JourneyChapterCopyWith<$Res> {
  factory _$JourneyChapterCopyWith(_JourneyChapter value, $Res Function(_JourneyChapter) _then) = __$JourneyChapterCopyWithImpl;
@override @useResult
$Res call({
 String id, String level, String title, String titleVi, String description, String descriptionVi, int order, int totalLessons, int completedLessons, double progressPercent, List<JourneyLesson> lessons, bool isLocked, bool isCompleted
});




}
/// @nodoc
class __$JourneyChapterCopyWithImpl<$Res>
    implements _$JourneyChapterCopyWith<$Res> {
  __$JourneyChapterCopyWithImpl(this._self, this._then);

  final _JourneyChapter _self;
  final $Res Function(_JourneyChapter) _then;

/// Create a copy of JourneyChapter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? level = null,Object? title = null,Object? titleVi = null,Object? description = null,Object? descriptionVi = null,Object? order = null,Object? totalLessons = null,Object? completedLessons = null,Object? progressPercent = null,Object? lessons = null,Object? isLocked = null,Object? isCompleted = null,}) {
  return _then(_JourneyChapter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,totalLessons: null == totalLessons ? _self.totalLessons : totalLessons // ignore: cast_nullable_to_non_nullable
as int,completedLessons: null == completedLessons ? _self.completedLessons : completedLessons // ignore: cast_nullable_to_non_nullable
as int,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as double,lessons: null == lessons ? _self._lessons : lessons // ignore: cast_nullable_to_non_nullable
as List<JourneyLesson>,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$JourneyLesson {

 String get id; String get chapterId; String get title; String get titleVi; String get description; String get descriptionVi; String get type; int get order; int get durationMinutes; int get xpReward; bool get isCompleted; bool get isLocked;
/// Create a copy of JourneyLesson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JourneyLessonCopyWith<JourneyLesson> get copyWith => _$JourneyLessonCopyWithImpl<JourneyLesson>(this as JourneyLesson, _$identity);

  /// Serializes this JourneyLesson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JourneyLesson&&(identical(other.id, id) || other.id == id)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.type, type) || other.type == type)&&(identical(other.order, order) || other.order == order)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.xpReward, xpReward) || other.xpReward == xpReward)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,chapterId,title,titleVi,description,descriptionVi,type,order,durationMinutes,xpReward,isCompleted,isLocked);

@override
String toString() {
  return 'JourneyLesson(id: $id, chapterId: $chapterId, title: $title, titleVi: $titleVi, description: $description, descriptionVi: $descriptionVi, type: $type, order: $order, durationMinutes: $durationMinutes, xpReward: $xpReward, isCompleted: $isCompleted, isLocked: $isLocked)';
}


}

/// @nodoc
abstract mixin class $JourneyLessonCopyWith<$Res>  {
  factory $JourneyLessonCopyWith(JourneyLesson value, $Res Function(JourneyLesson) _then) = _$JourneyLessonCopyWithImpl;
@useResult
$Res call({
 String id, String chapterId, String title, String titleVi, String description, String descriptionVi, String type, int order, int durationMinutes, int xpReward, bool isCompleted, bool isLocked
});




}
/// @nodoc
class _$JourneyLessonCopyWithImpl<$Res>
    implements $JourneyLessonCopyWith<$Res> {
  _$JourneyLessonCopyWithImpl(this._self, this._then);

  final JourneyLesson _self;
  final $Res Function(JourneyLesson) _then;

/// Create a copy of JourneyLesson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? chapterId = null,Object? title = null,Object? titleVi = null,Object? description = null,Object? descriptionVi = null,Object? type = null,Object? order = null,Object? durationMinutes = null,Object? xpReward = null,Object? isCompleted = null,Object? isLocked = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,xpReward: null == xpReward ? _self.xpReward : xpReward // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [JourneyLesson].
extension JourneyLessonPatterns on JourneyLesson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JourneyLesson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JourneyLesson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JourneyLesson value)  $default,){
final _that = this;
switch (_that) {
case _JourneyLesson():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JourneyLesson value)?  $default,){
final _that = this;
switch (_that) {
case _JourneyLesson() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String chapterId,  String title,  String titleVi,  String description,  String descriptionVi,  String type,  int order,  int durationMinutes,  int xpReward,  bool isCompleted,  bool isLocked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JourneyLesson() when $default != null:
return $default(_that.id,_that.chapterId,_that.title,_that.titleVi,_that.description,_that.descriptionVi,_that.type,_that.order,_that.durationMinutes,_that.xpReward,_that.isCompleted,_that.isLocked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String chapterId,  String title,  String titleVi,  String description,  String descriptionVi,  String type,  int order,  int durationMinutes,  int xpReward,  bool isCompleted,  bool isLocked)  $default,) {final _that = this;
switch (_that) {
case _JourneyLesson():
return $default(_that.id,_that.chapterId,_that.title,_that.titleVi,_that.description,_that.descriptionVi,_that.type,_that.order,_that.durationMinutes,_that.xpReward,_that.isCompleted,_that.isLocked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String chapterId,  String title,  String titleVi,  String description,  String descriptionVi,  String type,  int order,  int durationMinutes,  int xpReward,  bool isCompleted,  bool isLocked)?  $default,) {final _that = this;
switch (_that) {
case _JourneyLesson() when $default != null:
return $default(_that.id,_that.chapterId,_that.title,_that.titleVi,_that.description,_that.descriptionVi,_that.type,_that.order,_that.durationMinutes,_that.xpReward,_that.isCompleted,_that.isLocked);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JourneyLesson implements JourneyLesson {
  const _JourneyLesson({required this.id, required this.chapterId, required this.title, required this.titleVi, this.description = '', this.descriptionVi = '', this.type = '', this.order = 0, this.durationMinutes = 0, this.xpReward = 0, this.isCompleted = false, this.isLocked = false});
  factory _JourneyLesson.fromJson(Map<String, dynamic> json) => _$JourneyLessonFromJson(json);

@override final  String id;
@override final  String chapterId;
@override final  String title;
@override final  String titleVi;
@override@JsonKey() final  String description;
@override@JsonKey() final  String descriptionVi;
@override@JsonKey() final  String type;
@override@JsonKey() final  int order;
@override@JsonKey() final  int durationMinutes;
@override@JsonKey() final  int xpReward;
@override@JsonKey() final  bool isCompleted;
@override@JsonKey() final  bool isLocked;

/// Create a copy of JourneyLesson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JourneyLessonCopyWith<_JourneyLesson> get copyWith => __$JourneyLessonCopyWithImpl<_JourneyLesson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JourneyLessonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JourneyLesson&&(identical(other.id, id) || other.id == id)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.type, type) || other.type == type)&&(identical(other.order, order) || other.order == order)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.xpReward, xpReward) || other.xpReward == xpReward)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,chapterId,title,titleVi,description,descriptionVi,type,order,durationMinutes,xpReward,isCompleted,isLocked);

@override
String toString() {
  return 'JourneyLesson(id: $id, chapterId: $chapterId, title: $title, titleVi: $titleVi, description: $description, descriptionVi: $descriptionVi, type: $type, order: $order, durationMinutes: $durationMinutes, xpReward: $xpReward, isCompleted: $isCompleted, isLocked: $isLocked)';
}


}

/// @nodoc
abstract mixin class _$JourneyLessonCopyWith<$Res> implements $JourneyLessonCopyWith<$Res> {
  factory _$JourneyLessonCopyWith(_JourneyLesson value, $Res Function(_JourneyLesson) _then) = __$JourneyLessonCopyWithImpl;
@override @useResult
$Res call({
 String id, String chapterId, String title, String titleVi, String description, String descriptionVi, String type, int order, int durationMinutes, int xpReward, bool isCompleted, bool isLocked
});




}
/// @nodoc
class __$JourneyLessonCopyWithImpl<$Res>
    implements _$JourneyLessonCopyWith<$Res> {
  __$JourneyLessonCopyWithImpl(this._self, this._then);

  final _JourneyLesson _self;
  final $Res Function(_JourneyLesson) _then;

/// Create a copy of JourneyLesson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? chapterId = null,Object? title = null,Object? titleVi = null,Object? description = null,Object? descriptionVi = null,Object? type = null,Object? order = null,Object? durationMinutes = null,Object? xpReward = null,Object? isCompleted = null,Object? isLocked = null,}) {
  return _then(_JourneyLesson(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,xpReward: null == xpReward ? _self.xpReward : xpReward // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$LearningItem {

 String get id; String get word; String get translation; String get pronunciation; String get level; String get category; String get example; String get exampleTranslation; List<String> get synonyms; List<String> get antonyms; bool get isLearned; int get reviewCount; int get correctCount;
/// Create a copy of LearningItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LearningItemCopyWith<LearningItem> get copyWith => _$LearningItemCopyWithImpl<LearningItem>(this as LearningItem, _$identity);

  /// Serializes this LearningItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LearningItem&&(identical(other.id, id) || other.id == id)&&(identical(other.word, word) || other.word == word)&&(identical(other.translation, translation) || other.translation == translation)&&(identical(other.pronunciation, pronunciation) || other.pronunciation == pronunciation)&&(identical(other.level, level) || other.level == level)&&(identical(other.category, category) || other.category == category)&&(identical(other.example, example) || other.example == example)&&(identical(other.exampleTranslation, exampleTranslation) || other.exampleTranslation == exampleTranslation)&&const DeepCollectionEquality().equals(other.synonyms, synonyms)&&const DeepCollectionEquality().equals(other.antonyms, antonyms)&&(identical(other.isLearned, isLearned) || other.isLearned == isLearned)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,word,translation,pronunciation,level,category,example,exampleTranslation,const DeepCollectionEquality().hash(synonyms),const DeepCollectionEquality().hash(antonyms),isLearned,reviewCount,correctCount);

@override
String toString() {
  return 'LearningItem(id: $id, word: $word, translation: $translation, pronunciation: $pronunciation, level: $level, category: $category, example: $example, exampleTranslation: $exampleTranslation, synonyms: $synonyms, antonyms: $antonyms, isLearned: $isLearned, reviewCount: $reviewCount, correctCount: $correctCount)';
}


}

/// @nodoc
abstract mixin class $LearningItemCopyWith<$Res>  {
  factory $LearningItemCopyWith(LearningItem value, $Res Function(LearningItem) _then) = _$LearningItemCopyWithImpl;
@useResult
$Res call({
 String id, String word, String translation, String pronunciation, String level, String category, String example, String exampleTranslation, List<String> synonyms, List<String> antonyms, bool isLearned, int reviewCount, int correctCount
});




}
/// @nodoc
class _$LearningItemCopyWithImpl<$Res>
    implements $LearningItemCopyWith<$Res> {
  _$LearningItemCopyWithImpl(this._self, this._then);

  final LearningItem _self;
  final $Res Function(LearningItem) _then;

/// Create a copy of LearningItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? word = null,Object? translation = null,Object? pronunciation = null,Object? level = null,Object? category = null,Object? example = null,Object? exampleTranslation = null,Object? synonyms = null,Object? antonyms = null,Object? isLearned = null,Object? reviewCount = null,Object? correctCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,translation: null == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String,pronunciation: null == pronunciation ? _self.pronunciation : pronunciation // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,example: null == example ? _self.example : example // ignore: cast_nullable_to_non_nullable
as String,exampleTranslation: null == exampleTranslation ? _self.exampleTranslation : exampleTranslation // ignore: cast_nullable_to_non_nullable
as String,synonyms: null == synonyms ? _self.synonyms : synonyms // ignore: cast_nullable_to_non_nullable
as List<String>,antonyms: null == antonyms ? _self.antonyms : antonyms // ignore: cast_nullable_to_non_nullable
as List<String>,isLearned: null == isLearned ? _self.isLearned : isLearned // ignore: cast_nullable_to_non_nullable
as bool,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LearningItem].
extension LearningItemPatterns on LearningItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LearningItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LearningItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LearningItem value)  $default,){
final _that = this;
switch (_that) {
case _LearningItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LearningItem value)?  $default,){
final _that = this;
switch (_that) {
case _LearningItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String word,  String translation,  String pronunciation,  String level,  String category,  String example,  String exampleTranslation,  List<String> synonyms,  List<String> antonyms,  bool isLearned,  int reviewCount,  int correctCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LearningItem() when $default != null:
return $default(_that.id,_that.word,_that.translation,_that.pronunciation,_that.level,_that.category,_that.example,_that.exampleTranslation,_that.synonyms,_that.antonyms,_that.isLearned,_that.reviewCount,_that.correctCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String word,  String translation,  String pronunciation,  String level,  String category,  String example,  String exampleTranslation,  List<String> synonyms,  List<String> antonyms,  bool isLearned,  int reviewCount,  int correctCount)  $default,) {final _that = this;
switch (_that) {
case _LearningItem():
return $default(_that.id,_that.word,_that.translation,_that.pronunciation,_that.level,_that.category,_that.example,_that.exampleTranslation,_that.synonyms,_that.antonyms,_that.isLearned,_that.reviewCount,_that.correctCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String word,  String translation,  String pronunciation,  String level,  String category,  String example,  String exampleTranslation,  List<String> synonyms,  List<String> antonyms,  bool isLearned,  int reviewCount,  int correctCount)?  $default,) {final _that = this;
switch (_that) {
case _LearningItem() when $default != null:
return $default(_that.id,_that.word,_that.translation,_that.pronunciation,_that.level,_that.category,_that.example,_that.exampleTranslation,_that.synonyms,_that.antonyms,_that.isLearned,_that.reviewCount,_that.correctCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LearningItem implements LearningItem {
  const _LearningItem({required this.id, required this.word, required this.translation, this.pronunciation = '', this.level = '', this.category = '', this.example = '', this.exampleTranslation = '', final  List<String> synonyms = const <String>[], final  List<String> antonyms = const <String>[], this.isLearned = false, this.reviewCount = 0, this.correctCount = 0}): _synonyms = synonyms,_antonyms = antonyms;
  factory _LearningItem.fromJson(Map<String, dynamic> json) => _$LearningItemFromJson(json);

@override final  String id;
@override final  String word;
@override final  String translation;
@override@JsonKey() final  String pronunciation;
@override@JsonKey() final  String level;
@override@JsonKey() final  String category;
@override@JsonKey() final  String example;
@override@JsonKey() final  String exampleTranslation;
 final  List<String> _synonyms;
@override@JsonKey() List<String> get synonyms {
  if (_synonyms is EqualUnmodifiableListView) return _synonyms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_synonyms);
}

 final  List<String> _antonyms;
@override@JsonKey() List<String> get antonyms {
  if (_antonyms is EqualUnmodifiableListView) return _antonyms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_antonyms);
}

@override@JsonKey() final  bool isLearned;
@override@JsonKey() final  int reviewCount;
@override@JsonKey() final  int correctCount;

/// Create a copy of LearningItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LearningItemCopyWith<_LearningItem> get copyWith => __$LearningItemCopyWithImpl<_LearningItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LearningItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LearningItem&&(identical(other.id, id) || other.id == id)&&(identical(other.word, word) || other.word == word)&&(identical(other.translation, translation) || other.translation == translation)&&(identical(other.pronunciation, pronunciation) || other.pronunciation == pronunciation)&&(identical(other.level, level) || other.level == level)&&(identical(other.category, category) || other.category == category)&&(identical(other.example, example) || other.example == example)&&(identical(other.exampleTranslation, exampleTranslation) || other.exampleTranslation == exampleTranslation)&&const DeepCollectionEquality().equals(other._synonyms, _synonyms)&&const DeepCollectionEquality().equals(other._antonyms, _antonyms)&&(identical(other.isLearned, isLearned) || other.isLearned == isLearned)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,word,translation,pronunciation,level,category,example,exampleTranslation,const DeepCollectionEquality().hash(_synonyms),const DeepCollectionEquality().hash(_antonyms),isLearned,reviewCount,correctCount);

@override
String toString() {
  return 'LearningItem(id: $id, word: $word, translation: $translation, pronunciation: $pronunciation, level: $level, category: $category, example: $example, exampleTranslation: $exampleTranslation, synonyms: $synonyms, antonyms: $antonyms, isLearned: $isLearned, reviewCount: $reviewCount, correctCount: $correctCount)';
}


}

/// @nodoc
abstract mixin class _$LearningItemCopyWith<$Res> implements $LearningItemCopyWith<$Res> {
  factory _$LearningItemCopyWith(_LearningItem value, $Res Function(_LearningItem) _then) = __$LearningItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String word, String translation, String pronunciation, String level, String category, String example, String exampleTranslation, List<String> synonyms, List<String> antonyms, bool isLearned, int reviewCount, int correctCount
});




}
/// @nodoc
class __$LearningItemCopyWithImpl<$Res>
    implements _$LearningItemCopyWith<$Res> {
  __$LearningItemCopyWithImpl(this._self, this._then);

  final _LearningItem _self;
  final $Res Function(_LearningItem) _then;

/// Create a copy of LearningItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? word = null,Object? translation = null,Object? pronunciation = null,Object? level = null,Object? category = null,Object? example = null,Object? exampleTranslation = null,Object? synonyms = null,Object? antonyms = null,Object? isLearned = null,Object? reviewCount = null,Object? correctCount = null,}) {
  return _then(_LearningItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,translation: null == translation ? _self.translation : translation // ignore: cast_nullable_to_non_nullable
as String,pronunciation: null == pronunciation ? _self.pronunciation : pronunciation // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,example: null == example ? _self.example : example // ignore: cast_nullable_to_non_nullable
as String,exampleTranslation: null == exampleTranslation ? _self.exampleTranslation : exampleTranslation // ignore: cast_nullable_to_non_nullable
as String,synonyms: null == synonyms ? _self._synonyms : synonyms // ignore: cast_nullable_to_non_nullable
as List<String>,antonyms: null == antonyms ? _self._antonyms : antonyms // ignore: cast_nullable_to_non_nullable
as List<String>,isLearned: null == isLearned ? _self.isLearned : isLearned // ignore: cast_nullable_to_non_nullable
as bool,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$JourneyProgress {

 String get odlId; String get currentLevel; int get totalXp; int get streakDays; List<String> get completedLessonIds; List<String> get bookmarkedLessonIds; int get totalLessonsCompleted; int get totalTimeSpentMinutes; DateTime? get lastActivityAt;
/// Create a copy of JourneyProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JourneyProgressCopyWith<JourneyProgress> get copyWith => _$JourneyProgressCopyWithImpl<JourneyProgress>(this as JourneyProgress, _$identity);

  /// Serializes this JourneyProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JourneyProgress&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.currentLevel, currentLevel) || other.currentLevel == currentLevel)&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&const DeepCollectionEquality().equals(other.completedLessonIds, completedLessonIds)&&const DeepCollectionEquality().equals(other.bookmarkedLessonIds, bookmarkedLessonIds)&&(identical(other.totalLessonsCompleted, totalLessonsCompleted) || other.totalLessonsCompleted == totalLessonsCompleted)&&(identical(other.totalTimeSpentMinutes, totalTimeSpentMinutes) || other.totalTimeSpentMinutes == totalTimeSpentMinutes)&&(identical(other.lastActivityAt, lastActivityAt) || other.lastActivityAt == lastActivityAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,odlId,currentLevel,totalXp,streakDays,const DeepCollectionEquality().hash(completedLessonIds),const DeepCollectionEquality().hash(bookmarkedLessonIds),totalLessonsCompleted,totalTimeSpentMinutes,lastActivityAt);

@override
String toString() {
  return 'JourneyProgress(odlId: $odlId, currentLevel: $currentLevel, totalXp: $totalXp, streakDays: $streakDays, completedLessonIds: $completedLessonIds, bookmarkedLessonIds: $bookmarkedLessonIds, totalLessonsCompleted: $totalLessonsCompleted, totalTimeSpentMinutes: $totalTimeSpentMinutes, lastActivityAt: $lastActivityAt)';
}


}

/// @nodoc
abstract mixin class $JourneyProgressCopyWith<$Res>  {
  factory $JourneyProgressCopyWith(JourneyProgress value, $Res Function(JourneyProgress) _then) = _$JourneyProgressCopyWithImpl;
@useResult
$Res call({
 String odlId, String currentLevel, int totalXp, int streakDays, List<String> completedLessonIds, List<String> bookmarkedLessonIds, int totalLessonsCompleted, int totalTimeSpentMinutes, DateTime? lastActivityAt
});




}
/// @nodoc
class _$JourneyProgressCopyWithImpl<$Res>
    implements $JourneyProgressCopyWith<$Res> {
  _$JourneyProgressCopyWithImpl(this._self, this._then);

  final JourneyProgress _self;
  final $Res Function(JourneyProgress) _then;

/// Create a copy of JourneyProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? odlId = null,Object? currentLevel = null,Object? totalXp = null,Object? streakDays = null,Object? completedLessonIds = null,Object? bookmarkedLessonIds = null,Object? totalLessonsCompleted = null,Object? totalTimeSpentMinutes = null,Object? lastActivityAt = freezed,}) {
  return _then(_self.copyWith(
odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,currentLevel: null == currentLevel ? _self.currentLevel : currentLevel // ignore: cast_nullable_to_non_nullable
as String,totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,completedLessonIds: null == completedLessonIds ? _self.completedLessonIds : completedLessonIds // ignore: cast_nullable_to_non_nullable
as List<String>,bookmarkedLessonIds: null == bookmarkedLessonIds ? _self.bookmarkedLessonIds : bookmarkedLessonIds // ignore: cast_nullable_to_non_nullable
as List<String>,totalLessonsCompleted: null == totalLessonsCompleted ? _self.totalLessonsCompleted : totalLessonsCompleted // ignore: cast_nullable_to_non_nullable
as int,totalTimeSpentMinutes: null == totalTimeSpentMinutes ? _self.totalTimeSpentMinutes : totalTimeSpentMinutes // ignore: cast_nullable_to_non_nullable
as int,lastActivityAt: freezed == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [JourneyProgress].
extension JourneyProgressPatterns on JourneyProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JourneyProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JourneyProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JourneyProgress value)  $default,){
final _that = this;
switch (_that) {
case _JourneyProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JourneyProgress value)?  $default,){
final _that = this;
switch (_that) {
case _JourneyProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String odlId,  String currentLevel,  int totalXp,  int streakDays,  List<String> completedLessonIds,  List<String> bookmarkedLessonIds,  int totalLessonsCompleted,  int totalTimeSpentMinutes,  DateTime? lastActivityAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JourneyProgress() when $default != null:
return $default(_that.odlId,_that.currentLevel,_that.totalXp,_that.streakDays,_that.completedLessonIds,_that.bookmarkedLessonIds,_that.totalLessonsCompleted,_that.totalTimeSpentMinutes,_that.lastActivityAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String odlId,  String currentLevel,  int totalXp,  int streakDays,  List<String> completedLessonIds,  List<String> bookmarkedLessonIds,  int totalLessonsCompleted,  int totalTimeSpentMinutes,  DateTime? lastActivityAt)  $default,) {final _that = this;
switch (_that) {
case _JourneyProgress():
return $default(_that.odlId,_that.currentLevel,_that.totalXp,_that.streakDays,_that.completedLessonIds,_that.bookmarkedLessonIds,_that.totalLessonsCompleted,_that.totalTimeSpentMinutes,_that.lastActivityAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String odlId,  String currentLevel,  int totalXp,  int streakDays,  List<String> completedLessonIds,  List<String> bookmarkedLessonIds,  int totalLessonsCompleted,  int totalTimeSpentMinutes,  DateTime? lastActivityAt)?  $default,) {final _that = this;
switch (_that) {
case _JourneyProgress() when $default != null:
return $default(_that.odlId,_that.currentLevel,_that.totalXp,_that.streakDays,_that.completedLessonIds,_that.bookmarkedLessonIds,_that.totalLessonsCompleted,_that.totalTimeSpentMinutes,_that.lastActivityAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JourneyProgress implements JourneyProgress {
  const _JourneyProgress({required this.odlId, this.currentLevel = '', this.totalXp = 0, this.streakDays = 0, final  List<String> completedLessonIds = const <String>[], final  List<String> bookmarkedLessonIds = const <String>[], this.totalLessonsCompleted = 0, this.totalTimeSpentMinutes = 0, this.lastActivityAt}): _completedLessonIds = completedLessonIds,_bookmarkedLessonIds = bookmarkedLessonIds;
  factory _JourneyProgress.fromJson(Map<String, dynamic> json) => _$JourneyProgressFromJson(json);

@override final  String odlId;
@override@JsonKey() final  String currentLevel;
@override@JsonKey() final  int totalXp;
@override@JsonKey() final  int streakDays;
 final  List<String> _completedLessonIds;
@override@JsonKey() List<String> get completedLessonIds {
  if (_completedLessonIds is EqualUnmodifiableListView) return _completedLessonIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedLessonIds);
}

 final  List<String> _bookmarkedLessonIds;
@override@JsonKey() List<String> get bookmarkedLessonIds {
  if (_bookmarkedLessonIds is EqualUnmodifiableListView) return _bookmarkedLessonIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookmarkedLessonIds);
}

@override@JsonKey() final  int totalLessonsCompleted;
@override@JsonKey() final  int totalTimeSpentMinutes;
@override final  DateTime? lastActivityAt;

/// Create a copy of JourneyProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JourneyProgressCopyWith<_JourneyProgress> get copyWith => __$JourneyProgressCopyWithImpl<_JourneyProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JourneyProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JourneyProgress&&(identical(other.odlId, odlId) || other.odlId == odlId)&&(identical(other.currentLevel, currentLevel) || other.currentLevel == currentLevel)&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&const DeepCollectionEquality().equals(other._completedLessonIds, _completedLessonIds)&&const DeepCollectionEquality().equals(other._bookmarkedLessonIds, _bookmarkedLessonIds)&&(identical(other.totalLessonsCompleted, totalLessonsCompleted) || other.totalLessonsCompleted == totalLessonsCompleted)&&(identical(other.totalTimeSpentMinutes, totalTimeSpentMinutes) || other.totalTimeSpentMinutes == totalTimeSpentMinutes)&&(identical(other.lastActivityAt, lastActivityAt) || other.lastActivityAt == lastActivityAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,odlId,currentLevel,totalXp,streakDays,const DeepCollectionEquality().hash(_completedLessonIds),const DeepCollectionEquality().hash(_bookmarkedLessonIds),totalLessonsCompleted,totalTimeSpentMinutes,lastActivityAt);

@override
String toString() {
  return 'JourneyProgress(odlId: $odlId, currentLevel: $currentLevel, totalXp: $totalXp, streakDays: $streakDays, completedLessonIds: $completedLessonIds, bookmarkedLessonIds: $bookmarkedLessonIds, totalLessonsCompleted: $totalLessonsCompleted, totalTimeSpentMinutes: $totalTimeSpentMinutes, lastActivityAt: $lastActivityAt)';
}


}

/// @nodoc
abstract mixin class _$JourneyProgressCopyWith<$Res> implements $JourneyProgressCopyWith<$Res> {
  factory _$JourneyProgressCopyWith(_JourneyProgress value, $Res Function(_JourneyProgress) _then) = __$JourneyProgressCopyWithImpl;
@override @useResult
$Res call({
 String odlId, String currentLevel, int totalXp, int streakDays, List<String> completedLessonIds, List<String> bookmarkedLessonIds, int totalLessonsCompleted, int totalTimeSpentMinutes, DateTime? lastActivityAt
});




}
/// @nodoc
class __$JourneyProgressCopyWithImpl<$Res>
    implements _$JourneyProgressCopyWith<$Res> {
  __$JourneyProgressCopyWithImpl(this._self, this._then);

  final _JourneyProgress _self;
  final $Res Function(_JourneyProgress) _then;

/// Create a copy of JourneyProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? odlId = null,Object? currentLevel = null,Object? totalXp = null,Object? streakDays = null,Object? completedLessonIds = null,Object? bookmarkedLessonIds = null,Object? totalLessonsCompleted = null,Object? totalTimeSpentMinutes = null,Object? lastActivityAt = freezed,}) {
  return _then(_JourneyProgress(
odlId: null == odlId ? _self.odlId : odlId // ignore: cast_nullable_to_non_nullable
as String,currentLevel: null == currentLevel ? _self.currentLevel : currentLevel // ignore: cast_nullable_to_non_nullable
as String,totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,completedLessonIds: null == completedLessonIds ? _self._completedLessonIds : completedLessonIds // ignore: cast_nullable_to_non_nullable
as List<String>,bookmarkedLessonIds: null == bookmarkedLessonIds ? _self._bookmarkedLessonIds : bookmarkedLessonIds // ignore: cast_nullable_to_non_nullable
as List<String>,totalLessonsCompleted: null == totalLessonsCompleted ? _self.totalLessonsCompleted : totalLessonsCompleted // ignore: cast_nullable_to_non_nullable
as int,totalTimeSpentMinutes: null == totalTimeSpentMinutes ? _self.totalTimeSpentMinutes : totalTimeSpentMinutes // ignore: cast_nullable_to_non_nullable
as int,lastActivityAt: freezed == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
