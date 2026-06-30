// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'affiliate_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReferralProgram {

 String get id; String get referralCode; int get totalReferrals; int get activeReferrals; double get totalEarnings; double get pendingEarnings; double get withdrawnAmount; List<ReferralTier> get tiers;
/// Create a copy of ReferralProgram
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferralProgramCopyWith<ReferralProgram> get copyWith => _$ReferralProgramCopyWithImpl<ReferralProgram>(this as ReferralProgram, _$identity);

  /// Serializes this ReferralProgram to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralProgram&&(identical(other.id, id) || other.id == id)&&(identical(other.referralCode, referralCode) || other.referralCode == referralCode)&&(identical(other.totalReferrals, totalReferrals) || other.totalReferrals == totalReferrals)&&(identical(other.activeReferrals, activeReferrals) || other.activeReferrals == activeReferrals)&&(identical(other.totalEarnings, totalEarnings) || other.totalEarnings == totalEarnings)&&(identical(other.pendingEarnings, pendingEarnings) || other.pendingEarnings == pendingEarnings)&&(identical(other.withdrawnAmount, withdrawnAmount) || other.withdrawnAmount == withdrawnAmount)&&const DeepCollectionEquality().equals(other.tiers, tiers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,referralCode,totalReferrals,activeReferrals,totalEarnings,pendingEarnings,withdrawnAmount,const DeepCollectionEquality().hash(tiers));

@override
String toString() {
  return 'ReferralProgram(id: $id, referralCode: $referralCode, totalReferrals: $totalReferrals, activeReferrals: $activeReferrals, totalEarnings: $totalEarnings, pendingEarnings: $pendingEarnings, withdrawnAmount: $withdrawnAmount, tiers: $tiers)';
}


}

/// @nodoc
abstract mixin class $ReferralProgramCopyWith<$Res>  {
  factory $ReferralProgramCopyWith(ReferralProgram value, $Res Function(ReferralProgram) _then) = _$ReferralProgramCopyWithImpl;
@useResult
$Res call({
 String id, String referralCode, int totalReferrals, int activeReferrals, double totalEarnings, double pendingEarnings, double withdrawnAmount, List<ReferralTier> tiers
});




}
/// @nodoc
class _$ReferralProgramCopyWithImpl<$Res>
    implements $ReferralProgramCopyWith<$Res> {
  _$ReferralProgramCopyWithImpl(this._self, this._then);

  final ReferralProgram _self;
  final $Res Function(ReferralProgram) _then;

/// Create a copy of ReferralProgram
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? referralCode = null,Object? totalReferrals = null,Object? activeReferrals = null,Object? totalEarnings = null,Object? pendingEarnings = null,Object? withdrawnAmount = null,Object? tiers = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,referralCode: null == referralCode ? _self.referralCode : referralCode // ignore: cast_nullable_to_non_nullable
as String,totalReferrals: null == totalReferrals ? _self.totalReferrals : totalReferrals // ignore: cast_nullable_to_non_nullable
as int,activeReferrals: null == activeReferrals ? _self.activeReferrals : activeReferrals // ignore: cast_nullable_to_non_nullable
as int,totalEarnings: null == totalEarnings ? _self.totalEarnings : totalEarnings // ignore: cast_nullable_to_non_nullable
as double,pendingEarnings: null == pendingEarnings ? _self.pendingEarnings : pendingEarnings // ignore: cast_nullable_to_non_nullable
as double,withdrawnAmount: null == withdrawnAmount ? _self.withdrawnAmount : withdrawnAmount // ignore: cast_nullable_to_non_nullable
as double,tiers: null == tiers ? _self.tiers : tiers // ignore: cast_nullable_to_non_nullable
as List<ReferralTier>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReferralProgram].
extension ReferralProgramPatterns on ReferralProgram {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReferralProgram value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReferralProgram() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReferralProgram value)  $default,){
final _that = this;
switch (_that) {
case _ReferralProgram():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReferralProgram value)?  $default,){
final _that = this;
switch (_that) {
case _ReferralProgram() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String referralCode,  int totalReferrals,  int activeReferrals,  double totalEarnings,  double pendingEarnings,  double withdrawnAmount,  List<ReferralTier> tiers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReferralProgram() when $default != null:
return $default(_that.id,_that.referralCode,_that.totalReferrals,_that.activeReferrals,_that.totalEarnings,_that.pendingEarnings,_that.withdrawnAmount,_that.tiers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String referralCode,  int totalReferrals,  int activeReferrals,  double totalEarnings,  double pendingEarnings,  double withdrawnAmount,  List<ReferralTier> tiers)  $default,) {final _that = this;
switch (_that) {
case _ReferralProgram():
return $default(_that.id,_that.referralCode,_that.totalReferrals,_that.activeReferrals,_that.totalEarnings,_that.pendingEarnings,_that.withdrawnAmount,_that.tiers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String referralCode,  int totalReferrals,  int activeReferrals,  double totalEarnings,  double pendingEarnings,  double withdrawnAmount,  List<ReferralTier> tiers)?  $default,) {final _that = this;
switch (_that) {
case _ReferralProgram() when $default != null:
return $default(_that.id,_that.referralCode,_that.totalReferrals,_that.activeReferrals,_that.totalEarnings,_that.pendingEarnings,_that.withdrawnAmount,_that.tiers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReferralProgram implements ReferralProgram {
  const _ReferralProgram({required this.id, this.referralCode = '', this.totalReferrals = 0, this.activeReferrals = 0, this.totalEarnings = 0, this.pendingEarnings = 0, this.withdrawnAmount = 0, final  List<ReferralTier> tiers = const <ReferralTier>[]}): _tiers = tiers;
  factory _ReferralProgram.fromJson(Map<String, dynamic> json) => _$ReferralProgramFromJson(json);

@override final  String id;
@override@JsonKey() final  String referralCode;
@override@JsonKey() final  int totalReferrals;
@override@JsonKey() final  int activeReferrals;
@override@JsonKey() final  double totalEarnings;
@override@JsonKey() final  double pendingEarnings;
@override@JsonKey() final  double withdrawnAmount;
 final  List<ReferralTier> _tiers;
@override@JsonKey() List<ReferralTier> get tiers {
  if (_tiers is EqualUnmodifiableListView) return _tiers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tiers);
}


/// Create a copy of ReferralProgram
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReferralProgramCopyWith<_ReferralProgram> get copyWith => __$ReferralProgramCopyWithImpl<_ReferralProgram>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReferralProgramToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReferralProgram&&(identical(other.id, id) || other.id == id)&&(identical(other.referralCode, referralCode) || other.referralCode == referralCode)&&(identical(other.totalReferrals, totalReferrals) || other.totalReferrals == totalReferrals)&&(identical(other.activeReferrals, activeReferrals) || other.activeReferrals == activeReferrals)&&(identical(other.totalEarnings, totalEarnings) || other.totalEarnings == totalEarnings)&&(identical(other.pendingEarnings, pendingEarnings) || other.pendingEarnings == pendingEarnings)&&(identical(other.withdrawnAmount, withdrawnAmount) || other.withdrawnAmount == withdrawnAmount)&&const DeepCollectionEquality().equals(other._tiers, _tiers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,referralCode,totalReferrals,activeReferrals,totalEarnings,pendingEarnings,withdrawnAmount,const DeepCollectionEquality().hash(_tiers));

@override
String toString() {
  return 'ReferralProgram(id: $id, referralCode: $referralCode, totalReferrals: $totalReferrals, activeReferrals: $activeReferrals, totalEarnings: $totalEarnings, pendingEarnings: $pendingEarnings, withdrawnAmount: $withdrawnAmount, tiers: $tiers)';
}


}

/// @nodoc
abstract mixin class _$ReferralProgramCopyWith<$Res> implements $ReferralProgramCopyWith<$Res> {
  factory _$ReferralProgramCopyWith(_ReferralProgram value, $Res Function(_ReferralProgram) _then) = __$ReferralProgramCopyWithImpl;
@override @useResult
$Res call({
 String id, String referralCode, int totalReferrals, int activeReferrals, double totalEarnings, double pendingEarnings, double withdrawnAmount, List<ReferralTier> tiers
});




}
/// @nodoc
class __$ReferralProgramCopyWithImpl<$Res>
    implements _$ReferralProgramCopyWith<$Res> {
  __$ReferralProgramCopyWithImpl(this._self, this._then);

  final _ReferralProgram _self;
  final $Res Function(_ReferralProgram) _then;

/// Create a copy of ReferralProgram
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? referralCode = null,Object? totalReferrals = null,Object? activeReferrals = null,Object? totalEarnings = null,Object? pendingEarnings = null,Object? withdrawnAmount = null,Object? tiers = null,}) {
  return _then(_ReferralProgram(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,referralCode: null == referralCode ? _self.referralCode : referralCode // ignore: cast_nullable_to_non_nullable
as String,totalReferrals: null == totalReferrals ? _self.totalReferrals : totalReferrals // ignore: cast_nullable_to_non_nullable
as int,activeReferrals: null == activeReferrals ? _self.activeReferrals : activeReferrals // ignore: cast_nullable_to_non_nullable
as int,totalEarnings: null == totalEarnings ? _self.totalEarnings : totalEarnings // ignore: cast_nullable_to_non_nullable
as double,pendingEarnings: null == pendingEarnings ? _self.pendingEarnings : pendingEarnings // ignore: cast_nullable_to_non_nullable
as double,withdrawnAmount: null == withdrawnAmount ? _self.withdrawnAmount : withdrawnAmount // ignore: cast_nullable_to_non_nullable
as double,tiers: null == tiers ? _self._tiers : tiers // ignore: cast_nullable_to_non_nullable
as List<ReferralTier>,
  ));
}


}


/// @nodoc
mixin _$ReferralTier {

 int get referrals; String get reward; double get bonus; bool get isUnlocked;
/// Create a copy of ReferralTier
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferralTierCopyWith<ReferralTier> get copyWith => _$ReferralTierCopyWithImpl<ReferralTier>(this as ReferralTier, _$identity);

  /// Serializes this ReferralTier to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralTier&&(identical(other.referrals, referrals) || other.referrals == referrals)&&(identical(other.reward, reward) || other.reward == reward)&&(identical(other.bonus, bonus) || other.bonus == bonus)&&(identical(other.isUnlocked, isUnlocked) || other.isUnlocked == isUnlocked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,referrals,reward,bonus,isUnlocked);

@override
String toString() {
  return 'ReferralTier(referrals: $referrals, reward: $reward, bonus: $bonus, isUnlocked: $isUnlocked)';
}


}

/// @nodoc
abstract mixin class $ReferralTierCopyWith<$Res>  {
  factory $ReferralTierCopyWith(ReferralTier value, $Res Function(ReferralTier) _then) = _$ReferralTierCopyWithImpl;
@useResult
$Res call({
 int referrals, String reward, double bonus, bool isUnlocked
});




}
/// @nodoc
class _$ReferralTierCopyWithImpl<$Res>
    implements $ReferralTierCopyWith<$Res> {
  _$ReferralTierCopyWithImpl(this._self, this._then);

  final ReferralTier _self;
  final $Res Function(ReferralTier) _then;

/// Create a copy of ReferralTier
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? referrals = null,Object? reward = null,Object? bonus = null,Object? isUnlocked = null,}) {
  return _then(_self.copyWith(
referrals: null == referrals ? _self.referrals : referrals // ignore: cast_nullable_to_non_nullable
as int,reward: null == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as String,bonus: null == bonus ? _self.bonus : bonus // ignore: cast_nullable_to_non_nullable
as double,isUnlocked: null == isUnlocked ? _self.isUnlocked : isUnlocked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReferralTier].
extension ReferralTierPatterns on ReferralTier {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReferralTier value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReferralTier() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReferralTier value)  $default,){
final _that = this;
switch (_that) {
case _ReferralTier():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReferralTier value)?  $default,){
final _that = this;
switch (_that) {
case _ReferralTier() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int referrals,  String reward,  double bonus,  bool isUnlocked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReferralTier() when $default != null:
return $default(_that.referrals,_that.reward,_that.bonus,_that.isUnlocked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int referrals,  String reward,  double bonus,  bool isUnlocked)  $default,) {final _that = this;
switch (_that) {
case _ReferralTier():
return $default(_that.referrals,_that.reward,_that.bonus,_that.isUnlocked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int referrals,  String reward,  double bonus,  bool isUnlocked)?  $default,) {final _that = this;
switch (_that) {
case _ReferralTier() when $default != null:
return $default(_that.referrals,_that.reward,_that.bonus,_that.isUnlocked);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReferralTier implements ReferralTier {
  const _ReferralTier({required this.referrals, required this.reward, this.bonus = 0.0, this.isUnlocked = false});
  factory _ReferralTier.fromJson(Map<String, dynamic> json) => _$ReferralTierFromJson(json);

@override final  int referrals;
@override final  String reward;
@override@JsonKey() final  double bonus;
@override@JsonKey() final  bool isUnlocked;

/// Create a copy of ReferralTier
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReferralTierCopyWith<_ReferralTier> get copyWith => __$ReferralTierCopyWithImpl<_ReferralTier>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReferralTierToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReferralTier&&(identical(other.referrals, referrals) || other.referrals == referrals)&&(identical(other.reward, reward) || other.reward == reward)&&(identical(other.bonus, bonus) || other.bonus == bonus)&&(identical(other.isUnlocked, isUnlocked) || other.isUnlocked == isUnlocked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,referrals,reward,bonus,isUnlocked);

@override
String toString() {
  return 'ReferralTier(referrals: $referrals, reward: $reward, bonus: $bonus, isUnlocked: $isUnlocked)';
}


}

/// @nodoc
abstract mixin class _$ReferralTierCopyWith<$Res> implements $ReferralTierCopyWith<$Res> {
  factory _$ReferralTierCopyWith(_ReferralTier value, $Res Function(_ReferralTier) _then) = __$ReferralTierCopyWithImpl;
@override @useResult
$Res call({
 int referrals, String reward, double bonus, bool isUnlocked
});




}
/// @nodoc
class __$ReferralTierCopyWithImpl<$Res>
    implements _$ReferralTierCopyWith<$Res> {
  __$ReferralTierCopyWithImpl(this._self, this._then);

  final _ReferralTier _self;
  final $Res Function(_ReferralTier) _then;

/// Create a copy of ReferralTier
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? referrals = null,Object? reward = null,Object? bonus = null,Object? isUnlocked = null,}) {
  return _then(_ReferralTier(
referrals: null == referrals ? _self.referrals : referrals // ignore: cast_nullable_to_non_nullable
as int,reward: null == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as String,bonus: null == bonus ? _self.bonus : bonus // ignore: cast_nullable_to_non_nullable
as double,isUnlocked: null == isUnlocked ? _self.isUnlocked : isUnlocked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Referral {

 String get id; String get referrerId; String get refereeId; String get refereeName; String get refereeEmail; double get reward; double get bonus; String get status; int get referredUserDaysActive; DateTime? get referredAt; DateTime? get rewardClaimedAt;
/// Create a copy of Referral
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferralCopyWith<Referral> get copyWith => _$ReferralCopyWithImpl<Referral>(this as Referral, _$identity);

  /// Serializes this Referral to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Referral&&(identical(other.id, id) || other.id == id)&&(identical(other.referrerId, referrerId) || other.referrerId == referrerId)&&(identical(other.refereeId, refereeId) || other.refereeId == refereeId)&&(identical(other.refereeName, refereeName) || other.refereeName == refereeName)&&(identical(other.refereeEmail, refereeEmail) || other.refereeEmail == refereeEmail)&&(identical(other.reward, reward) || other.reward == reward)&&(identical(other.bonus, bonus) || other.bonus == bonus)&&(identical(other.status, status) || other.status == status)&&(identical(other.referredUserDaysActive, referredUserDaysActive) || other.referredUserDaysActive == referredUserDaysActive)&&(identical(other.referredAt, referredAt) || other.referredAt == referredAt)&&(identical(other.rewardClaimedAt, rewardClaimedAt) || other.rewardClaimedAt == rewardClaimedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,referrerId,refereeId,refereeName,refereeEmail,reward,bonus,status,referredUserDaysActive,referredAt,rewardClaimedAt);

@override
String toString() {
  return 'Referral(id: $id, referrerId: $referrerId, refereeId: $refereeId, refereeName: $refereeName, refereeEmail: $refereeEmail, reward: $reward, bonus: $bonus, status: $status, referredUserDaysActive: $referredUserDaysActive, referredAt: $referredAt, rewardClaimedAt: $rewardClaimedAt)';
}


}

/// @nodoc
abstract mixin class $ReferralCopyWith<$Res>  {
  factory $ReferralCopyWith(Referral value, $Res Function(Referral) _then) = _$ReferralCopyWithImpl;
@useResult
$Res call({
 String id, String referrerId, String refereeId, String refereeName, String refereeEmail, double reward, double bonus, String status, int referredUserDaysActive, DateTime? referredAt, DateTime? rewardClaimedAt
});




}
/// @nodoc
class _$ReferralCopyWithImpl<$Res>
    implements $ReferralCopyWith<$Res> {
  _$ReferralCopyWithImpl(this._self, this._then);

  final Referral _self;
  final $Res Function(Referral) _then;

/// Create a copy of Referral
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? referrerId = null,Object? refereeId = null,Object? refereeName = null,Object? refereeEmail = null,Object? reward = null,Object? bonus = null,Object? status = null,Object? referredUserDaysActive = null,Object? referredAt = freezed,Object? rewardClaimedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,referrerId: null == referrerId ? _self.referrerId : referrerId // ignore: cast_nullable_to_non_nullable
as String,refereeId: null == refereeId ? _self.refereeId : refereeId // ignore: cast_nullable_to_non_nullable
as String,refereeName: null == refereeName ? _self.refereeName : refereeName // ignore: cast_nullable_to_non_nullable
as String,refereeEmail: null == refereeEmail ? _self.refereeEmail : refereeEmail // ignore: cast_nullable_to_non_nullable
as String,reward: null == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as double,bonus: null == bonus ? _self.bonus : bonus // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,referredUserDaysActive: null == referredUserDaysActive ? _self.referredUserDaysActive : referredUserDaysActive // ignore: cast_nullable_to_non_nullable
as int,referredAt: freezed == referredAt ? _self.referredAt : referredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rewardClaimedAt: freezed == rewardClaimedAt ? _self.rewardClaimedAt : rewardClaimedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Referral].
extension ReferralPatterns on Referral {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Referral value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Referral() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Referral value)  $default,){
final _that = this;
switch (_that) {
case _Referral():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Referral value)?  $default,){
final _that = this;
switch (_that) {
case _Referral() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String referrerId,  String refereeId,  String refereeName,  String refereeEmail,  double reward,  double bonus,  String status,  int referredUserDaysActive,  DateTime? referredAt,  DateTime? rewardClaimedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Referral() when $default != null:
return $default(_that.id,_that.referrerId,_that.refereeId,_that.refereeName,_that.refereeEmail,_that.reward,_that.bonus,_that.status,_that.referredUserDaysActive,_that.referredAt,_that.rewardClaimedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String referrerId,  String refereeId,  String refereeName,  String refereeEmail,  double reward,  double bonus,  String status,  int referredUserDaysActive,  DateTime? referredAt,  DateTime? rewardClaimedAt)  $default,) {final _that = this;
switch (_that) {
case _Referral():
return $default(_that.id,_that.referrerId,_that.refereeId,_that.refereeName,_that.refereeEmail,_that.reward,_that.bonus,_that.status,_that.referredUserDaysActive,_that.referredAt,_that.rewardClaimedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String referrerId,  String refereeId,  String refereeName,  String refereeEmail,  double reward,  double bonus,  String status,  int referredUserDaysActive,  DateTime? referredAt,  DateTime? rewardClaimedAt)?  $default,) {final _that = this;
switch (_that) {
case _Referral() when $default != null:
return $default(_that.id,_that.referrerId,_that.refereeId,_that.refereeName,_that.refereeEmail,_that.reward,_that.bonus,_that.status,_that.referredUserDaysActive,_that.referredAt,_that.rewardClaimedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Referral implements Referral {
  const _Referral({required this.id, required this.referrerId, required this.refereeId, required this.refereeName, this.refereeEmail = '', this.reward = 0, this.bonus = 0, this.status = 'pending', this.referredUserDaysActive = 0, this.referredAt, this.rewardClaimedAt});
  factory _Referral.fromJson(Map<String, dynamic> json) => _$ReferralFromJson(json);

@override final  String id;
@override final  String referrerId;
@override final  String refereeId;
@override final  String refereeName;
@override@JsonKey() final  String refereeEmail;
@override@JsonKey() final  double reward;
@override@JsonKey() final  double bonus;
@override@JsonKey() final  String status;
@override@JsonKey() final  int referredUserDaysActive;
@override final  DateTime? referredAt;
@override final  DateTime? rewardClaimedAt;

/// Create a copy of Referral
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReferralCopyWith<_Referral> get copyWith => __$ReferralCopyWithImpl<_Referral>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReferralToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Referral&&(identical(other.id, id) || other.id == id)&&(identical(other.referrerId, referrerId) || other.referrerId == referrerId)&&(identical(other.refereeId, refereeId) || other.refereeId == refereeId)&&(identical(other.refereeName, refereeName) || other.refereeName == refereeName)&&(identical(other.refereeEmail, refereeEmail) || other.refereeEmail == refereeEmail)&&(identical(other.reward, reward) || other.reward == reward)&&(identical(other.bonus, bonus) || other.bonus == bonus)&&(identical(other.status, status) || other.status == status)&&(identical(other.referredUserDaysActive, referredUserDaysActive) || other.referredUserDaysActive == referredUserDaysActive)&&(identical(other.referredAt, referredAt) || other.referredAt == referredAt)&&(identical(other.rewardClaimedAt, rewardClaimedAt) || other.rewardClaimedAt == rewardClaimedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,referrerId,refereeId,refereeName,refereeEmail,reward,bonus,status,referredUserDaysActive,referredAt,rewardClaimedAt);

@override
String toString() {
  return 'Referral(id: $id, referrerId: $referrerId, refereeId: $refereeId, refereeName: $refereeName, refereeEmail: $refereeEmail, reward: $reward, bonus: $bonus, status: $status, referredUserDaysActive: $referredUserDaysActive, referredAt: $referredAt, rewardClaimedAt: $rewardClaimedAt)';
}


}

/// @nodoc
abstract mixin class _$ReferralCopyWith<$Res> implements $ReferralCopyWith<$Res> {
  factory _$ReferralCopyWith(_Referral value, $Res Function(_Referral) _then) = __$ReferralCopyWithImpl;
@override @useResult
$Res call({
 String id, String referrerId, String refereeId, String refereeName, String refereeEmail, double reward, double bonus, String status, int referredUserDaysActive, DateTime? referredAt, DateTime? rewardClaimedAt
});




}
/// @nodoc
class __$ReferralCopyWithImpl<$Res>
    implements _$ReferralCopyWith<$Res> {
  __$ReferralCopyWithImpl(this._self, this._then);

  final _Referral _self;
  final $Res Function(_Referral) _then;

/// Create a copy of Referral
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? referrerId = null,Object? refereeId = null,Object? refereeName = null,Object? refereeEmail = null,Object? reward = null,Object? bonus = null,Object? status = null,Object? referredUserDaysActive = null,Object? referredAt = freezed,Object? rewardClaimedAt = freezed,}) {
  return _then(_Referral(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,referrerId: null == referrerId ? _self.referrerId : referrerId // ignore: cast_nullable_to_non_nullable
as String,refereeId: null == refereeId ? _self.refereeId : refereeId // ignore: cast_nullable_to_non_nullable
as String,refereeName: null == refereeName ? _self.refereeName : refereeName // ignore: cast_nullable_to_non_nullable
as String,refereeEmail: null == refereeEmail ? _self.refereeEmail : refereeEmail // ignore: cast_nullable_to_non_nullable
as String,reward: null == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as double,bonus: null == bonus ? _self.bonus : bonus // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,referredUserDaysActive: null == referredUserDaysActive ? _self.referredUserDaysActive : referredUserDaysActive // ignore: cast_nullable_to_non_nullable
as int,referredAt: freezed == referredAt ? _self.referredAt : referredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rewardClaimedAt: freezed == rewardClaimedAt ? _self.rewardClaimedAt : rewardClaimedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ReferralActivity {

 String get id; String get referralId; String get type; String get description; double get amount; DateTime? get createdAt;
/// Create a copy of ReferralActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferralActivityCopyWith<ReferralActivity> get copyWith => _$ReferralActivityCopyWithImpl<ReferralActivity>(this as ReferralActivity, _$identity);

  /// Serializes this ReferralActivity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralActivity&&(identical(other.id, id) || other.id == id)&&(identical(other.referralId, referralId) || other.referralId == referralId)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,referralId,type,description,amount,createdAt);

@override
String toString() {
  return 'ReferralActivity(id: $id, referralId: $referralId, type: $type, description: $description, amount: $amount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ReferralActivityCopyWith<$Res>  {
  factory $ReferralActivityCopyWith(ReferralActivity value, $Res Function(ReferralActivity) _then) = _$ReferralActivityCopyWithImpl;
@useResult
$Res call({
 String id, String referralId, String type, String description, double amount, DateTime? createdAt
});




}
/// @nodoc
class _$ReferralActivityCopyWithImpl<$Res>
    implements $ReferralActivityCopyWith<$Res> {
  _$ReferralActivityCopyWithImpl(this._self, this._then);

  final ReferralActivity _self;
  final $Res Function(ReferralActivity) _then;

/// Create a copy of ReferralActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? referralId = null,Object? type = null,Object? description = null,Object? amount = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,referralId: null == referralId ? _self.referralId : referralId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReferralActivity].
extension ReferralActivityPatterns on ReferralActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReferralActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReferralActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReferralActivity value)  $default,){
final _that = this;
switch (_that) {
case _ReferralActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReferralActivity value)?  $default,){
final _that = this;
switch (_that) {
case _ReferralActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String referralId,  String type,  String description,  double amount,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReferralActivity() when $default != null:
return $default(_that.id,_that.referralId,_that.type,_that.description,_that.amount,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String referralId,  String type,  String description,  double amount,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ReferralActivity():
return $default(_that.id,_that.referralId,_that.type,_that.description,_that.amount,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String referralId,  String type,  String description,  double amount,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ReferralActivity() when $default != null:
return $default(_that.id,_that.referralId,_that.type,_that.description,_that.amount,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReferralActivity implements ReferralActivity {
  const _ReferralActivity({required this.id, required this.referralId, required this.type, required this.description, this.amount = 0.0, this.createdAt});
  factory _ReferralActivity.fromJson(Map<String, dynamic> json) => _$ReferralActivityFromJson(json);

@override final  String id;
@override final  String referralId;
@override final  String type;
@override final  String description;
@override@JsonKey() final  double amount;
@override final  DateTime? createdAt;

/// Create a copy of ReferralActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReferralActivityCopyWith<_ReferralActivity> get copyWith => __$ReferralActivityCopyWithImpl<_ReferralActivity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReferralActivityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReferralActivity&&(identical(other.id, id) || other.id == id)&&(identical(other.referralId, referralId) || other.referralId == referralId)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,referralId,type,description,amount,createdAt);

@override
String toString() {
  return 'ReferralActivity(id: $id, referralId: $referralId, type: $type, description: $description, amount: $amount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ReferralActivityCopyWith<$Res> implements $ReferralActivityCopyWith<$Res> {
  factory _$ReferralActivityCopyWith(_ReferralActivity value, $Res Function(_ReferralActivity) _then) = __$ReferralActivityCopyWithImpl;
@override @useResult
$Res call({
 String id, String referralId, String type, String description, double amount, DateTime? createdAt
});




}
/// @nodoc
class __$ReferralActivityCopyWithImpl<$Res>
    implements _$ReferralActivityCopyWith<$Res> {
  __$ReferralActivityCopyWithImpl(this._self, this._then);

  final _ReferralActivity _self;
  final $Res Function(_ReferralActivity) _then;

/// Create a copy of ReferralActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? referralId = null,Object? type = null,Object? description = null,Object? amount = null,Object? createdAt = freezed,}) {
  return _then(_ReferralActivity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,referralId: null == referralId ? _self.referralId : referralId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
