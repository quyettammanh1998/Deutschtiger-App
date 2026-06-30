// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExamHub {

 String get id; String get name; String get nameVi; String get type; String get description; String get descriptionVi; String get level; String get imageUrl; double get readinessScore; int get completedExams; int get totalExams; List<ExamSection> get sections;
/// Create a copy of ExamHub
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamHubCopyWith<ExamHub> get copyWith => _$ExamHubCopyWithImpl<ExamHub>(this as ExamHub, _$identity);

  /// Serializes this ExamHub to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamHub&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.level, level) || other.level == level)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.readinessScore, readinessScore) || other.readinessScore == readinessScore)&&(identical(other.completedExams, completedExams) || other.completedExams == completedExams)&&(identical(other.totalExams, totalExams) || other.totalExams == totalExams)&&const DeepCollectionEquality().equals(other.sections, sections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameVi,type,description,descriptionVi,level,imageUrl,readinessScore,completedExams,totalExams,const DeepCollectionEquality().hash(sections));

@override
String toString() {
  return 'ExamHub(id: $id, name: $name, nameVi: $nameVi, type: $type, description: $description, descriptionVi: $descriptionVi, level: $level, imageUrl: $imageUrl, readinessScore: $readinessScore, completedExams: $completedExams, totalExams: $totalExams, sections: $sections)';
}


}

/// @nodoc
abstract mixin class $ExamHubCopyWith<$Res>  {
  factory $ExamHubCopyWith(ExamHub value, $Res Function(ExamHub) _then) = _$ExamHubCopyWithImpl;
@useResult
$Res call({
 String id, String name, String nameVi, String type, String description, String descriptionVi, String level, String imageUrl, double readinessScore, int completedExams, int totalExams, List<ExamSection> sections
});




}
/// @nodoc
class _$ExamHubCopyWithImpl<$Res>
    implements $ExamHubCopyWith<$Res> {
  _$ExamHubCopyWithImpl(this._self, this._then);

  final ExamHub _self;
  final $Res Function(ExamHub) _then;

/// Create a copy of ExamHub
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nameVi = null,Object? type = null,Object? description = null,Object? descriptionVi = null,Object? level = null,Object? imageUrl = null,Object? readinessScore = null,Object? completedExams = null,Object? totalExams = null,Object? sections = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameVi: null == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,readinessScore: null == readinessScore ? _self.readinessScore : readinessScore // ignore: cast_nullable_to_non_nullable
as double,completedExams: null == completedExams ? _self.completedExams : completedExams // ignore: cast_nullable_to_non_nullable
as int,totalExams: null == totalExams ? _self.totalExams : totalExams // ignore: cast_nullable_to_non_nullable
as int,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<ExamSection>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamHub].
extension ExamHubPatterns on ExamHub {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamHub value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamHub() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamHub value)  $default,){
final _that = this;
switch (_that) {
case _ExamHub():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamHub value)?  $default,){
final _that = this;
switch (_that) {
case _ExamHub() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String nameVi,  String type,  String description,  String descriptionVi,  String level,  String imageUrl,  double readinessScore,  int completedExams,  int totalExams,  List<ExamSection> sections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamHub() when $default != null:
return $default(_that.id,_that.name,_that.nameVi,_that.type,_that.description,_that.descriptionVi,_that.level,_that.imageUrl,_that.readinessScore,_that.completedExams,_that.totalExams,_that.sections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String nameVi,  String type,  String description,  String descriptionVi,  String level,  String imageUrl,  double readinessScore,  int completedExams,  int totalExams,  List<ExamSection> sections)  $default,) {final _that = this;
switch (_that) {
case _ExamHub():
return $default(_that.id,_that.name,_that.nameVi,_that.type,_that.description,_that.descriptionVi,_that.level,_that.imageUrl,_that.readinessScore,_that.completedExams,_that.totalExams,_that.sections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String nameVi,  String type,  String description,  String descriptionVi,  String level,  String imageUrl,  double readinessScore,  int completedExams,  int totalExams,  List<ExamSection> sections)?  $default,) {final _that = this;
switch (_that) {
case _ExamHub() when $default != null:
return $default(_that.id,_that.name,_that.nameVi,_that.type,_that.description,_that.descriptionVi,_that.level,_that.imageUrl,_that.readinessScore,_that.completedExams,_that.totalExams,_that.sections);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamHub implements ExamHub {
  const _ExamHub({required this.id, required this.name, required this.nameVi, required this.type, this.description = '', this.descriptionVi = '', this.level = '', this.imageUrl = '', this.readinessScore = 0.0, this.completedExams = 0, this.totalExams = 0, final  List<ExamSection> sections = const <ExamSection>[]}): _sections = sections;
  factory _ExamHub.fromJson(Map<String, dynamic> json) => _$ExamHubFromJson(json);

@override final  String id;
@override final  String name;
@override final  String nameVi;
@override final  String type;
@override@JsonKey() final  String description;
@override@JsonKey() final  String descriptionVi;
@override@JsonKey() final  String level;
@override@JsonKey() final  String imageUrl;
@override@JsonKey() final  double readinessScore;
@override@JsonKey() final  int completedExams;
@override@JsonKey() final  int totalExams;
 final  List<ExamSection> _sections;
@override@JsonKey() List<ExamSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}


/// Create a copy of ExamHub
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamHubCopyWith<_ExamHub> get copyWith => __$ExamHubCopyWithImpl<_ExamHub>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamHubToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamHub&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionVi, descriptionVi) || other.descriptionVi == descriptionVi)&&(identical(other.level, level) || other.level == level)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.readinessScore, readinessScore) || other.readinessScore == readinessScore)&&(identical(other.completedExams, completedExams) || other.completedExams == completedExams)&&(identical(other.totalExams, totalExams) || other.totalExams == totalExams)&&const DeepCollectionEquality().equals(other._sections, _sections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameVi,type,description,descriptionVi,level,imageUrl,readinessScore,completedExams,totalExams,const DeepCollectionEquality().hash(_sections));

@override
String toString() {
  return 'ExamHub(id: $id, name: $name, nameVi: $nameVi, type: $type, description: $description, descriptionVi: $descriptionVi, level: $level, imageUrl: $imageUrl, readinessScore: $readinessScore, completedExams: $completedExams, totalExams: $totalExams, sections: $sections)';
}


}

/// @nodoc
abstract mixin class _$ExamHubCopyWith<$Res> implements $ExamHubCopyWith<$Res> {
  factory _$ExamHubCopyWith(_ExamHub value, $Res Function(_ExamHub) _then) = __$ExamHubCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String nameVi, String type, String description, String descriptionVi, String level, String imageUrl, double readinessScore, int completedExams, int totalExams, List<ExamSection> sections
});




}
/// @nodoc
class __$ExamHubCopyWithImpl<$Res>
    implements _$ExamHubCopyWith<$Res> {
  __$ExamHubCopyWithImpl(this._self, this._then);

  final _ExamHub _self;
  final $Res Function(_ExamHub) _then;

/// Create a copy of ExamHub
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nameVi = null,Object? type = null,Object? description = null,Object? descriptionVi = null,Object? level = null,Object? imageUrl = null,Object? readinessScore = null,Object? completedExams = null,Object? totalExams = null,Object? sections = null,}) {
  return _then(_ExamHub(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameVi: null == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,descriptionVi: null == descriptionVi ? _self.descriptionVi : descriptionVi // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,readinessScore: null == readinessScore ? _self.readinessScore : readinessScore // ignore: cast_nullable_to_non_nullable
as double,completedExams: null == completedExams ? _self.completedExams : completedExams // ignore: cast_nullable_to_non_nullable
as int,totalExams: null == totalExams ? _self.totalExams : totalExams // ignore: cast_nullable_to_non_nullable
as int,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<ExamSection>,
  ));
}


}


/// @nodoc
mixin _$ExamSection {

 String get id; String get hubId; String get title; String get titleVi; String get type; double get score; int get totalQuestions; int get correctAnswers; bool get isCompleted;
/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamSectionCopyWith<ExamSection> get copyWith => _$ExamSectionCopyWithImpl<ExamSection>(this as ExamSection, _$identity);

  /// Serializes this ExamSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamSection&&(identical(other.id, id) || other.id == id)&&(identical(other.hubId, hubId) || other.hubId == hubId)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.type, type) || other.type == type)&&(identical(other.score, score) || other.score == score)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.correctAnswers, correctAnswers) || other.correctAnswers == correctAnswers)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hubId,title,titleVi,type,score,totalQuestions,correctAnswers,isCompleted);

@override
String toString() {
  return 'ExamSection(id: $id, hubId: $hubId, title: $title, titleVi: $titleVi, type: $type, score: $score, totalQuestions: $totalQuestions, correctAnswers: $correctAnswers, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class $ExamSectionCopyWith<$Res>  {
  factory $ExamSectionCopyWith(ExamSection value, $Res Function(ExamSection) _then) = _$ExamSectionCopyWithImpl;
@useResult
$Res call({
 String id, String hubId, String title, String titleVi, String type, double score, int totalQuestions, int correctAnswers, bool isCompleted
});




}
/// @nodoc
class _$ExamSectionCopyWithImpl<$Res>
    implements $ExamSectionCopyWith<$Res> {
  _$ExamSectionCopyWithImpl(this._self, this._then);

  final ExamSection _self;
  final $Res Function(ExamSection) _then;

/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hubId = null,Object? title = null,Object? titleVi = null,Object? type = null,Object? score = null,Object? totalQuestions = null,Object? correctAnswers = null,Object? isCompleted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hubId: null == hubId ? _self.hubId : hubId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,correctAnswers: null == correctAnswers ? _self.correctAnswers : correctAnswers // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamSection].
extension ExamSectionPatterns on ExamSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamSection value)  $default,){
final _that = this;
switch (_that) {
case _ExamSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamSection value)?  $default,){
final _that = this;
switch (_that) {
case _ExamSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String hubId,  String title,  String titleVi,  String type,  double score,  int totalQuestions,  int correctAnswers,  bool isCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamSection() when $default != null:
return $default(_that.id,_that.hubId,_that.title,_that.titleVi,_that.type,_that.score,_that.totalQuestions,_that.correctAnswers,_that.isCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String hubId,  String title,  String titleVi,  String type,  double score,  int totalQuestions,  int correctAnswers,  bool isCompleted)  $default,) {final _that = this;
switch (_that) {
case _ExamSection():
return $default(_that.id,_that.hubId,_that.title,_that.titleVi,_that.type,_that.score,_that.totalQuestions,_that.correctAnswers,_that.isCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String hubId,  String title,  String titleVi,  String type,  double score,  int totalQuestions,  int correctAnswers,  bool isCompleted)?  $default,) {final _that = this;
switch (_that) {
case _ExamSection() when $default != null:
return $default(_that.id,_that.hubId,_that.title,_that.titleVi,_that.type,_that.score,_that.totalQuestions,_that.correctAnswers,_that.isCompleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamSection implements ExamSection {
  const _ExamSection({required this.id, required this.hubId, required this.title, required this.titleVi, required this.type, this.score = 0.0, this.totalQuestions = 0, this.correctAnswers = 0, this.isCompleted = false});
  factory _ExamSection.fromJson(Map<String, dynamic> json) => _$ExamSectionFromJson(json);

@override final  String id;
@override final  String hubId;
@override final  String title;
@override final  String titleVi;
@override final  String type;
@override@JsonKey() final  double score;
@override@JsonKey() final  int totalQuestions;
@override@JsonKey() final  int correctAnswers;
@override@JsonKey() final  bool isCompleted;

/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamSectionCopyWith<_ExamSection> get copyWith => __$ExamSectionCopyWithImpl<_ExamSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamSection&&(identical(other.id, id) || other.id == id)&&(identical(other.hubId, hubId) || other.hubId == hubId)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.type, type) || other.type == type)&&(identical(other.score, score) || other.score == score)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.correctAnswers, correctAnswers) || other.correctAnswers == correctAnswers)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hubId,title,titleVi,type,score,totalQuestions,correctAnswers,isCompleted);

@override
String toString() {
  return 'ExamSection(id: $id, hubId: $hubId, title: $title, titleVi: $titleVi, type: $type, score: $score, totalQuestions: $totalQuestions, correctAnswers: $correctAnswers, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$ExamSectionCopyWith<$Res> implements $ExamSectionCopyWith<$Res> {
  factory _$ExamSectionCopyWith(_ExamSection value, $Res Function(_ExamSection) _then) = __$ExamSectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String hubId, String title, String titleVi, String type, double score, int totalQuestions, int correctAnswers, bool isCompleted
});




}
/// @nodoc
class __$ExamSectionCopyWithImpl<$Res>
    implements _$ExamSectionCopyWith<$Res> {
  __$ExamSectionCopyWithImpl(this._self, this._then);

  final _ExamSection _self;
  final $Res Function(_ExamSection) _then;

/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hubId = null,Object? title = null,Object? titleVi = null,Object? type = null,Object? score = null,Object? totalQuestions = null,Object? correctAnswers = null,Object? isCompleted = null,}) {
  return _then(_ExamSection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hubId: null == hubId ? _self.hubId : hubId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,correctAnswers: null == correctAnswers ? _self.correctAnswers : correctAnswers // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$WritingTopic {

 String get id; String get hubId; String get title; String get titleVi; String get prompt; String get promptVi; int get wordLimit; int get estimatedMinutes; int get attempts; double get bestScore; String get lastSubmission; String get lastFeedback; List<String> get sampleAnswers;
/// Create a copy of WritingTopic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WritingTopicCopyWith<WritingTopic> get copyWith => _$WritingTopicCopyWithImpl<WritingTopic>(this as WritingTopic, _$identity);

  /// Serializes this WritingTopic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WritingTopic&&(identical(other.id, id) || other.id == id)&&(identical(other.hubId, hubId) || other.hubId == hubId)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.promptVi, promptVi) || other.promptVi == promptVi)&&(identical(other.wordLimit, wordLimit) || other.wordLimit == wordLimit)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.bestScore, bestScore) || other.bestScore == bestScore)&&(identical(other.lastSubmission, lastSubmission) || other.lastSubmission == lastSubmission)&&(identical(other.lastFeedback, lastFeedback) || other.lastFeedback == lastFeedback)&&const DeepCollectionEquality().equals(other.sampleAnswers, sampleAnswers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hubId,title,titleVi,prompt,promptVi,wordLimit,estimatedMinutes,attempts,bestScore,lastSubmission,lastFeedback,const DeepCollectionEquality().hash(sampleAnswers));

@override
String toString() {
  return 'WritingTopic(id: $id, hubId: $hubId, title: $title, titleVi: $titleVi, prompt: $prompt, promptVi: $promptVi, wordLimit: $wordLimit, estimatedMinutes: $estimatedMinutes, attempts: $attempts, bestScore: $bestScore, lastSubmission: $lastSubmission, lastFeedback: $lastFeedback, sampleAnswers: $sampleAnswers)';
}


}

/// @nodoc
abstract mixin class $WritingTopicCopyWith<$Res>  {
  factory $WritingTopicCopyWith(WritingTopic value, $Res Function(WritingTopic) _then) = _$WritingTopicCopyWithImpl;
@useResult
$Res call({
 String id, String hubId, String title, String titleVi, String prompt, String promptVi, int wordLimit, int estimatedMinutes, int attempts, double bestScore, String lastSubmission, String lastFeedback, List<String> sampleAnswers
});




}
/// @nodoc
class _$WritingTopicCopyWithImpl<$Res>
    implements $WritingTopicCopyWith<$Res> {
  _$WritingTopicCopyWithImpl(this._self, this._then);

  final WritingTopic _self;
  final $Res Function(WritingTopic) _then;

/// Create a copy of WritingTopic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hubId = null,Object? title = null,Object? titleVi = null,Object? prompt = null,Object? promptVi = null,Object? wordLimit = null,Object? estimatedMinutes = null,Object? attempts = null,Object? bestScore = null,Object? lastSubmission = null,Object? lastFeedback = null,Object? sampleAnswers = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hubId: null == hubId ? _self.hubId : hubId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,promptVi: null == promptVi ? _self.promptVi : promptVi // ignore: cast_nullable_to_non_nullable
as String,wordLimit: null == wordLimit ? _self.wordLimit : wordLimit // ignore: cast_nullable_to_non_nullable
as int,estimatedMinutes: null == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,bestScore: null == bestScore ? _self.bestScore : bestScore // ignore: cast_nullable_to_non_nullable
as double,lastSubmission: null == lastSubmission ? _self.lastSubmission : lastSubmission // ignore: cast_nullable_to_non_nullable
as String,lastFeedback: null == lastFeedback ? _self.lastFeedback : lastFeedback // ignore: cast_nullable_to_non_nullable
as String,sampleAnswers: null == sampleAnswers ? _self.sampleAnswers : sampleAnswers // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [WritingTopic].
extension WritingTopicPatterns on WritingTopic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WritingTopic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WritingTopic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WritingTopic value)  $default,){
final _that = this;
switch (_that) {
case _WritingTopic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WritingTopic value)?  $default,){
final _that = this;
switch (_that) {
case _WritingTopic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String hubId,  String title,  String titleVi,  String prompt,  String promptVi,  int wordLimit,  int estimatedMinutes,  int attempts,  double bestScore,  String lastSubmission,  String lastFeedback,  List<String> sampleAnswers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WritingTopic() when $default != null:
return $default(_that.id,_that.hubId,_that.title,_that.titleVi,_that.prompt,_that.promptVi,_that.wordLimit,_that.estimatedMinutes,_that.attempts,_that.bestScore,_that.lastSubmission,_that.lastFeedback,_that.sampleAnswers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String hubId,  String title,  String titleVi,  String prompt,  String promptVi,  int wordLimit,  int estimatedMinutes,  int attempts,  double bestScore,  String lastSubmission,  String lastFeedback,  List<String> sampleAnswers)  $default,) {final _that = this;
switch (_that) {
case _WritingTopic():
return $default(_that.id,_that.hubId,_that.title,_that.titleVi,_that.prompt,_that.promptVi,_that.wordLimit,_that.estimatedMinutes,_that.attempts,_that.bestScore,_that.lastSubmission,_that.lastFeedback,_that.sampleAnswers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String hubId,  String title,  String titleVi,  String prompt,  String promptVi,  int wordLimit,  int estimatedMinutes,  int attempts,  double bestScore,  String lastSubmission,  String lastFeedback,  List<String> sampleAnswers)?  $default,) {final _that = this;
switch (_that) {
case _WritingTopic() when $default != null:
return $default(_that.id,_that.hubId,_that.title,_that.titleVi,_that.prompt,_that.promptVi,_that.wordLimit,_that.estimatedMinutes,_that.attempts,_that.bestScore,_that.lastSubmission,_that.lastFeedback,_that.sampleAnswers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WritingTopic implements WritingTopic {
  const _WritingTopic({required this.id, required this.hubId, required this.title, required this.titleVi, required this.prompt, required this.promptVi, this.wordLimit = 0, this.estimatedMinutes = 0, this.attempts = 0, this.bestScore = 0.0, this.lastSubmission = '', this.lastFeedback = '', final  List<String> sampleAnswers = const <String>[]}): _sampleAnswers = sampleAnswers;
  factory _WritingTopic.fromJson(Map<String, dynamic> json) => _$WritingTopicFromJson(json);

@override final  String id;
@override final  String hubId;
@override final  String title;
@override final  String titleVi;
@override final  String prompt;
@override final  String promptVi;
@override@JsonKey() final  int wordLimit;
@override@JsonKey() final  int estimatedMinutes;
@override@JsonKey() final  int attempts;
@override@JsonKey() final  double bestScore;
@override@JsonKey() final  String lastSubmission;
@override@JsonKey() final  String lastFeedback;
 final  List<String> _sampleAnswers;
@override@JsonKey() List<String> get sampleAnswers {
  if (_sampleAnswers is EqualUnmodifiableListView) return _sampleAnswers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sampleAnswers);
}


/// Create a copy of WritingTopic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WritingTopicCopyWith<_WritingTopic> get copyWith => __$WritingTopicCopyWithImpl<_WritingTopic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WritingTopicToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WritingTopic&&(identical(other.id, id) || other.id == id)&&(identical(other.hubId, hubId) || other.hubId == hubId)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.promptVi, promptVi) || other.promptVi == promptVi)&&(identical(other.wordLimit, wordLimit) || other.wordLimit == wordLimit)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.bestScore, bestScore) || other.bestScore == bestScore)&&(identical(other.lastSubmission, lastSubmission) || other.lastSubmission == lastSubmission)&&(identical(other.lastFeedback, lastFeedback) || other.lastFeedback == lastFeedback)&&const DeepCollectionEquality().equals(other._sampleAnswers, _sampleAnswers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hubId,title,titleVi,prompt,promptVi,wordLimit,estimatedMinutes,attempts,bestScore,lastSubmission,lastFeedback,const DeepCollectionEquality().hash(_sampleAnswers));

@override
String toString() {
  return 'WritingTopic(id: $id, hubId: $hubId, title: $title, titleVi: $titleVi, prompt: $prompt, promptVi: $promptVi, wordLimit: $wordLimit, estimatedMinutes: $estimatedMinutes, attempts: $attempts, bestScore: $bestScore, lastSubmission: $lastSubmission, lastFeedback: $lastFeedback, sampleAnswers: $sampleAnswers)';
}


}

/// @nodoc
abstract mixin class _$WritingTopicCopyWith<$Res> implements $WritingTopicCopyWith<$Res> {
  factory _$WritingTopicCopyWith(_WritingTopic value, $Res Function(_WritingTopic) _then) = __$WritingTopicCopyWithImpl;
@override @useResult
$Res call({
 String id, String hubId, String title, String titleVi, String prompt, String promptVi, int wordLimit, int estimatedMinutes, int attempts, double bestScore, String lastSubmission, String lastFeedback, List<String> sampleAnswers
});




}
/// @nodoc
class __$WritingTopicCopyWithImpl<$Res>
    implements _$WritingTopicCopyWith<$Res> {
  __$WritingTopicCopyWithImpl(this._self, this._then);

  final _WritingTopic _self;
  final $Res Function(_WritingTopic) _then;

/// Create a copy of WritingTopic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hubId = null,Object? title = null,Object? titleVi = null,Object? prompt = null,Object? promptVi = null,Object? wordLimit = null,Object? estimatedMinutes = null,Object? attempts = null,Object? bestScore = null,Object? lastSubmission = null,Object? lastFeedback = null,Object? sampleAnswers = null,}) {
  return _then(_WritingTopic(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hubId: null == hubId ? _self.hubId : hubId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,promptVi: null == promptVi ? _self.promptVi : promptVi // ignore: cast_nullable_to_non_nullable
as String,wordLimit: null == wordLimit ? _self.wordLimit : wordLimit // ignore: cast_nullable_to_non_nullable
as int,estimatedMinutes: null == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,bestScore: null == bestScore ? _self.bestScore : bestScore // ignore: cast_nullable_to_non_nullable
as double,lastSubmission: null == lastSubmission ? _self.lastSubmission : lastSubmission // ignore: cast_nullable_to_non_nullable
as String,lastFeedback: null == lastFeedback ? _self.lastFeedback : lastFeedback // ignore: cast_nullable_to_non_nullable
as String,sampleAnswers: null == sampleAnswers ? _self._sampleAnswers : sampleAnswers // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$SpeakingTopic {

 String get id; String get hubId; String get title; String get titleVi; String get prompt; String get promptVi; int get estimatedMinutes; int get attempts; double get bestScore; String get audioUrl; String get transcription;
/// Create a copy of SpeakingTopic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeakingTopicCopyWith<SpeakingTopic> get copyWith => _$SpeakingTopicCopyWithImpl<SpeakingTopic>(this as SpeakingTopic, _$identity);

  /// Serializes this SpeakingTopic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeakingTopic&&(identical(other.id, id) || other.id == id)&&(identical(other.hubId, hubId) || other.hubId == hubId)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.promptVi, promptVi) || other.promptVi == promptVi)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.bestScore, bestScore) || other.bestScore == bestScore)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.transcription, transcription) || other.transcription == transcription));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hubId,title,titleVi,prompt,promptVi,estimatedMinutes,attempts,bestScore,audioUrl,transcription);

@override
String toString() {
  return 'SpeakingTopic(id: $id, hubId: $hubId, title: $title, titleVi: $titleVi, prompt: $prompt, promptVi: $promptVi, estimatedMinutes: $estimatedMinutes, attempts: $attempts, bestScore: $bestScore, audioUrl: $audioUrl, transcription: $transcription)';
}


}

/// @nodoc
abstract mixin class $SpeakingTopicCopyWith<$Res>  {
  factory $SpeakingTopicCopyWith(SpeakingTopic value, $Res Function(SpeakingTopic) _then) = _$SpeakingTopicCopyWithImpl;
@useResult
$Res call({
 String id, String hubId, String title, String titleVi, String prompt, String promptVi, int estimatedMinutes, int attempts, double bestScore, String audioUrl, String transcription
});




}
/// @nodoc
class _$SpeakingTopicCopyWithImpl<$Res>
    implements $SpeakingTopicCopyWith<$Res> {
  _$SpeakingTopicCopyWithImpl(this._self, this._then);

  final SpeakingTopic _self;
  final $Res Function(SpeakingTopic) _then;

/// Create a copy of SpeakingTopic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hubId = null,Object? title = null,Object? titleVi = null,Object? prompt = null,Object? promptVi = null,Object? estimatedMinutes = null,Object? attempts = null,Object? bestScore = null,Object? audioUrl = null,Object? transcription = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hubId: null == hubId ? _self.hubId : hubId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,promptVi: null == promptVi ? _self.promptVi : promptVi // ignore: cast_nullable_to_non_nullable
as String,estimatedMinutes: null == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,bestScore: null == bestScore ? _self.bestScore : bestScore // ignore: cast_nullable_to_non_nullable
as double,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,transcription: null == transcription ? _self.transcription : transcription // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeakingTopic].
extension SpeakingTopicPatterns on SpeakingTopic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeakingTopic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeakingTopic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeakingTopic value)  $default,){
final _that = this;
switch (_that) {
case _SpeakingTopic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeakingTopic value)?  $default,){
final _that = this;
switch (_that) {
case _SpeakingTopic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String hubId,  String title,  String titleVi,  String prompt,  String promptVi,  int estimatedMinutes,  int attempts,  double bestScore,  String audioUrl,  String transcription)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeakingTopic() when $default != null:
return $default(_that.id,_that.hubId,_that.title,_that.titleVi,_that.prompt,_that.promptVi,_that.estimatedMinutes,_that.attempts,_that.bestScore,_that.audioUrl,_that.transcription);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String hubId,  String title,  String titleVi,  String prompt,  String promptVi,  int estimatedMinutes,  int attempts,  double bestScore,  String audioUrl,  String transcription)  $default,) {final _that = this;
switch (_that) {
case _SpeakingTopic():
return $default(_that.id,_that.hubId,_that.title,_that.titleVi,_that.prompt,_that.promptVi,_that.estimatedMinutes,_that.attempts,_that.bestScore,_that.audioUrl,_that.transcription);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String hubId,  String title,  String titleVi,  String prompt,  String promptVi,  int estimatedMinutes,  int attempts,  double bestScore,  String audioUrl,  String transcription)?  $default,) {final _that = this;
switch (_that) {
case _SpeakingTopic() when $default != null:
return $default(_that.id,_that.hubId,_that.title,_that.titleVi,_that.prompt,_that.promptVi,_that.estimatedMinutes,_that.attempts,_that.bestScore,_that.audioUrl,_that.transcription);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpeakingTopic implements SpeakingTopic {
  const _SpeakingTopic({required this.id, required this.hubId, required this.title, required this.titleVi, required this.prompt, required this.promptVi, this.estimatedMinutes = 0, this.attempts = 0, this.bestScore = 0.0, this.audioUrl = '', this.transcription = ''});
  factory _SpeakingTopic.fromJson(Map<String, dynamic> json) => _$SpeakingTopicFromJson(json);

@override final  String id;
@override final  String hubId;
@override final  String title;
@override final  String titleVi;
@override final  String prompt;
@override final  String promptVi;
@override@JsonKey() final  int estimatedMinutes;
@override@JsonKey() final  int attempts;
@override@JsonKey() final  double bestScore;
@override@JsonKey() final  String audioUrl;
@override@JsonKey() final  String transcription;

/// Create a copy of SpeakingTopic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeakingTopicCopyWith<_SpeakingTopic> get copyWith => __$SpeakingTopicCopyWithImpl<_SpeakingTopic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpeakingTopicToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeakingTopic&&(identical(other.id, id) || other.id == id)&&(identical(other.hubId, hubId) || other.hubId == hubId)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.promptVi, promptVi) || other.promptVi == promptVi)&&(identical(other.estimatedMinutes, estimatedMinutes) || other.estimatedMinutes == estimatedMinutes)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.bestScore, bestScore) || other.bestScore == bestScore)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.transcription, transcription) || other.transcription == transcription));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hubId,title,titleVi,prompt,promptVi,estimatedMinutes,attempts,bestScore,audioUrl,transcription);

@override
String toString() {
  return 'SpeakingTopic(id: $id, hubId: $hubId, title: $title, titleVi: $titleVi, prompt: $prompt, promptVi: $promptVi, estimatedMinutes: $estimatedMinutes, attempts: $attempts, bestScore: $bestScore, audioUrl: $audioUrl, transcription: $transcription)';
}


}

/// @nodoc
abstract mixin class _$SpeakingTopicCopyWith<$Res> implements $SpeakingTopicCopyWith<$Res> {
  factory _$SpeakingTopicCopyWith(_SpeakingTopic value, $Res Function(_SpeakingTopic) _then) = __$SpeakingTopicCopyWithImpl;
@override @useResult
$Res call({
 String id, String hubId, String title, String titleVi, String prompt, String promptVi, int estimatedMinutes, int attempts, double bestScore, String audioUrl, String transcription
});




}
/// @nodoc
class __$SpeakingTopicCopyWithImpl<$Res>
    implements _$SpeakingTopicCopyWith<$Res> {
  __$SpeakingTopicCopyWithImpl(this._self, this._then);

  final _SpeakingTopic _self;
  final $Res Function(_SpeakingTopic) _then;

/// Create a copy of SpeakingTopic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hubId = null,Object? title = null,Object? titleVi = null,Object? prompt = null,Object? promptVi = null,Object? estimatedMinutes = null,Object? attempts = null,Object? bestScore = null,Object? audioUrl = null,Object? transcription = null,}) {
  return _then(_SpeakingTopic(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hubId: null == hubId ? _self.hubId : hubId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,promptVi: null == promptVi ? _self.promptVi : promptVi // ignore: cast_nullable_to_non_nullable
as String,estimatedMinutes: null == estimatedMinutes ? _self.estimatedMinutes : estimatedMinutes // ignore: cast_nullable_to_non_nullable
as int,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,bestScore: null == bestScore ? _self.bestScore : bestScore // ignore: cast_nullable_to_non_nullable
as double,audioUrl: null == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String,transcription: null == transcription ? _self.transcription : transcription // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ExamReadiness {

 String get hubId; double get overallScore; double get readingScore; double get writingScore; double get listeningScore; double get speakingScore; List<String> get strengths; List<String> get weaknesses; List<String> get recommendations; DateTime? get lastAssessedAt;
/// Create a copy of ExamReadiness
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamReadinessCopyWith<ExamReadiness> get copyWith => _$ExamReadinessCopyWithImpl<ExamReadiness>(this as ExamReadiness, _$identity);

  /// Serializes this ExamReadiness to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamReadiness&&(identical(other.hubId, hubId) || other.hubId == hubId)&&(identical(other.overallScore, overallScore) || other.overallScore == overallScore)&&(identical(other.readingScore, readingScore) || other.readingScore == readingScore)&&(identical(other.writingScore, writingScore) || other.writingScore == writingScore)&&(identical(other.listeningScore, listeningScore) || other.listeningScore == listeningScore)&&(identical(other.speakingScore, speakingScore) || other.speakingScore == speakingScore)&&const DeepCollectionEquality().equals(other.strengths, strengths)&&const DeepCollectionEquality().equals(other.weaknesses, weaknesses)&&const DeepCollectionEquality().equals(other.recommendations, recommendations)&&(identical(other.lastAssessedAt, lastAssessedAt) || other.lastAssessedAt == lastAssessedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hubId,overallScore,readingScore,writingScore,listeningScore,speakingScore,const DeepCollectionEquality().hash(strengths),const DeepCollectionEquality().hash(weaknesses),const DeepCollectionEquality().hash(recommendations),lastAssessedAt);

@override
String toString() {
  return 'ExamReadiness(hubId: $hubId, overallScore: $overallScore, readingScore: $readingScore, writingScore: $writingScore, listeningScore: $listeningScore, speakingScore: $speakingScore, strengths: $strengths, weaknesses: $weaknesses, recommendations: $recommendations, lastAssessedAt: $lastAssessedAt)';
}


}

/// @nodoc
abstract mixin class $ExamReadinessCopyWith<$Res>  {
  factory $ExamReadinessCopyWith(ExamReadiness value, $Res Function(ExamReadiness) _then) = _$ExamReadinessCopyWithImpl;
@useResult
$Res call({
 String hubId, double overallScore, double readingScore, double writingScore, double listeningScore, double speakingScore, List<String> strengths, List<String> weaknesses, List<String> recommendations, DateTime? lastAssessedAt
});




}
/// @nodoc
class _$ExamReadinessCopyWithImpl<$Res>
    implements $ExamReadinessCopyWith<$Res> {
  _$ExamReadinessCopyWithImpl(this._self, this._then);

  final ExamReadiness _self;
  final $Res Function(ExamReadiness) _then;

/// Create a copy of ExamReadiness
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hubId = null,Object? overallScore = null,Object? readingScore = null,Object? writingScore = null,Object? listeningScore = null,Object? speakingScore = null,Object? strengths = null,Object? weaknesses = null,Object? recommendations = null,Object? lastAssessedAt = freezed,}) {
  return _then(_self.copyWith(
hubId: null == hubId ? _self.hubId : hubId // ignore: cast_nullable_to_non_nullable
as String,overallScore: null == overallScore ? _self.overallScore : overallScore // ignore: cast_nullable_to_non_nullable
as double,readingScore: null == readingScore ? _self.readingScore : readingScore // ignore: cast_nullable_to_non_nullable
as double,writingScore: null == writingScore ? _self.writingScore : writingScore // ignore: cast_nullable_to_non_nullable
as double,listeningScore: null == listeningScore ? _self.listeningScore : listeningScore // ignore: cast_nullable_to_non_nullable
as double,speakingScore: null == speakingScore ? _self.speakingScore : speakingScore // ignore: cast_nullable_to_non_nullable
as double,strengths: null == strengths ? _self.strengths : strengths // ignore: cast_nullable_to_non_nullable
as List<String>,weaknesses: null == weaknesses ? _self.weaknesses : weaknesses // ignore: cast_nullable_to_non_nullable
as List<String>,recommendations: null == recommendations ? _self.recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<String>,lastAssessedAt: freezed == lastAssessedAt ? _self.lastAssessedAt : lastAssessedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamReadiness].
extension ExamReadinessPatterns on ExamReadiness {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamReadiness value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamReadiness() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamReadiness value)  $default,){
final _that = this;
switch (_that) {
case _ExamReadiness():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamReadiness value)?  $default,){
final _that = this;
switch (_that) {
case _ExamReadiness() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String hubId,  double overallScore,  double readingScore,  double writingScore,  double listeningScore,  double speakingScore,  List<String> strengths,  List<String> weaknesses,  List<String> recommendations,  DateTime? lastAssessedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamReadiness() when $default != null:
return $default(_that.hubId,_that.overallScore,_that.readingScore,_that.writingScore,_that.listeningScore,_that.speakingScore,_that.strengths,_that.weaknesses,_that.recommendations,_that.lastAssessedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String hubId,  double overallScore,  double readingScore,  double writingScore,  double listeningScore,  double speakingScore,  List<String> strengths,  List<String> weaknesses,  List<String> recommendations,  DateTime? lastAssessedAt)  $default,) {final _that = this;
switch (_that) {
case _ExamReadiness():
return $default(_that.hubId,_that.overallScore,_that.readingScore,_that.writingScore,_that.listeningScore,_that.speakingScore,_that.strengths,_that.weaknesses,_that.recommendations,_that.lastAssessedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String hubId,  double overallScore,  double readingScore,  double writingScore,  double listeningScore,  double speakingScore,  List<String> strengths,  List<String> weaknesses,  List<String> recommendations,  DateTime? lastAssessedAt)?  $default,) {final _that = this;
switch (_that) {
case _ExamReadiness() when $default != null:
return $default(_that.hubId,_that.overallScore,_that.readingScore,_that.writingScore,_that.listeningScore,_that.speakingScore,_that.strengths,_that.weaknesses,_that.recommendations,_that.lastAssessedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamReadiness implements ExamReadiness {
  const _ExamReadiness({required this.hubId, this.overallScore = 0.0, this.readingScore = 0.0, this.writingScore = 0.0, this.listeningScore = 0.0, this.speakingScore = 0.0, final  List<String> strengths = const <String>[], final  List<String> weaknesses = const <String>[], final  List<String> recommendations = const <String>[], this.lastAssessedAt}): _strengths = strengths,_weaknesses = weaknesses,_recommendations = recommendations;
  factory _ExamReadiness.fromJson(Map<String, dynamic> json) => _$ExamReadinessFromJson(json);

@override final  String hubId;
@override@JsonKey() final  double overallScore;
@override@JsonKey() final  double readingScore;
@override@JsonKey() final  double writingScore;
@override@JsonKey() final  double listeningScore;
@override@JsonKey() final  double speakingScore;
 final  List<String> _strengths;
@override@JsonKey() List<String> get strengths {
  if (_strengths is EqualUnmodifiableListView) return _strengths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_strengths);
}

 final  List<String> _weaknesses;
@override@JsonKey() List<String> get weaknesses {
  if (_weaknesses is EqualUnmodifiableListView) return _weaknesses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weaknesses);
}

 final  List<String> _recommendations;
@override@JsonKey() List<String> get recommendations {
  if (_recommendations is EqualUnmodifiableListView) return _recommendations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recommendations);
}

@override final  DateTime? lastAssessedAt;

/// Create a copy of ExamReadiness
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamReadinessCopyWith<_ExamReadiness> get copyWith => __$ExamReadinessCopyWithImpl<_ExamReadiness>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamReadinessToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamReadiness&&(identical(other.hubId, hubId) || other.hubId == hubId)&&(identical(other.overallScore, overallScore) || other.overallScore == overallScore)&&(identical(other.readingScore, readingScore) || other.readingScore == readingScore)&&(identical(other.writingScore, writingScore) || other.writingScore == writingScore)&&(identical(other.listeningScore, listeningScore) || other.listeningScore == listeningScore)&&(identical(other.speakingScore, speakingScore) || other.speakingScore == speakingScore)&&const DeepCollectionEquality().equals(other._strengths, _strengths)&&const DeepCollectionEquality().equals(other._weaknesses, _weaknesses)&&const DeepCollectionEquality().equals(other._recommendations, _recommendations)&&(identical(other.lastAssessedAt, lastAssessedAt) || other.lastAssessedAt == lastAssessedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hubId,overallScore,readingScore,writingScore,listeningScore,speakingScore,const DeepCollectionEquality().hash(_strengths),const DeepCollectionEquality().hash(_weaknesses),const DeepCollectionEquality().hash(_recommendations),lastAssessedAt);

@override
String toString() {
  return 'ExamReadiness(hubId: $hubId, overallScore: $overallScore, readingScore: $readingScore, writingScore: $writingScore, listeningScore: $listeningScore, speakingScore: $speakingScore, strengths: $strengths, weaknesses: $weaknesses, recommendations: $recommendations, lastAssessedAt: $lastAssessedAt)';
}


}

/// @nodoc
abstract mixin class _$ExamReadinessCopyWith<$Res> implements $ExamReadinessCopyWith<$Res> {
  factory _$ExamReadinessCopyWith(_ExamReadiness value, $Res Function(_ExamReadiness) _then) = __$ExamReadinessCopyWithImpl;
@override @useResult
$Res call({
 String hubId, double overallScore, double readingScore, double writingScore, double listeningScore, double speakingScore, List<String> strengths, List<String> weaknesses, List<String> recommendations, DateTime? lastAssessedAt
});




}
/// @nodoc
class __$ExamReadinessCopyWithImpl<$Res>
    implements _$ExamReadinessCopyWith<$Res> {
  __$ExamReadinessCopyWithImpl(this._self, this._then);

  final _ExamReadiness _self;
  final $Res Function(_ExamReadiness) _then;

/// Create a copy of ExamReadiness
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hubId = null,Object? overallScore = null,Object? readingScore = null,Object? writingScore = null,Object? listeningScore = null,Object? speakingScore = null,Object? strengths = null,Object? weaknesses = null,Object? recommendations = null,Object? lastAssessedAt = freezed,}) {
  return _then(_ExamReadiness(
hubId: null == hubId ? _self.hubId : hubId // ignore: cast_nullable_to_non_nullable
as String,overallScore: null == overallScore ? _self.overallScore : overallScore // ignore: cast_nullable_to_non_nullable
as double,readingScore: null == readingScore ? _self.readingScore : readingScore // ignore: cast_nullable_to_non_nullable
as double,writingScore: null == writingScore ? _self.writingScore : writingScore // ignore: cast_nullable_to_non_nullable
as double,listeningScore: null == listeningScore ? _self.listeningScore : listeningScore // ignore: cast_nullable_to_non_nullable
as double,speakingScore: null == speakingScore ? _self.speakingScore : speakingScore // ignore: cast_nullable_to_non_nullable
as double,strengths: null == strengths ? _self._strengths : strengths // ignore: cast_nullable_to_non_nullable
as List<String>,weaknesses: null == weaknesses ? _self._weaknesses : weaknesses // ignore: cast_nullable_to_non_nullable
as List<String>,recommendations: null == recommendations ? _self._recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<String>,lastAssessedAt: freezed == lastAssessedAt ? _self.lastAssessedAt : lastAssessedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
