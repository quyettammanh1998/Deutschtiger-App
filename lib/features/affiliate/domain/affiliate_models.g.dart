// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'affiliate_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReferralProgram _$ReferralProgramFromJson(Map<String, dynamic> json) =>
    _ReferralProgram(
      id: json['id'] as String,
      referralCode: json['referralCode'] as String? ?? '',
      totalReferrals: (json['totalReferrals'] as num?)?.toInt() ?? 0,
      activeReferrals: (json['activeReferrals'] as num?)?.toInt() ?? 0,
      totalEarnings: (json['totalEarnings'] as num?)?.toDouble() ?? 0,
      pendingEarnings: (json['pendingEarnings'] as num?)?.toDouble() ?? 0,
      withdrawnAmount: (json['withdrawnAmount'] as num?)?.toDouble() ?? 0,
      tiers:
          (json['tiers'] as List<dynamic>?)
              ?.map((e) => ReferralTier.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ReferralTier>[],
    );

Map<String, dynamic> _$ReferralProgramToJson(_ReferralProgram instance) =>
    <String, dynamic>{
      'id': instance.id,
      'referralCode': instance.referralCode,
      'totalReferrals': instance.totalReferrals,
      'activeReferrals': instance.activeReferrals,
      'totalEarnings': instance.totalEarnings,
      'pendingEarnings': instance.pendingEarnings,
      'withdrawnAmount': instance.withdrawnAmount,
      'tiers': instance.tiers,
    };

_ReferralTier _$ReferralTierFromJson(Map<String, dynamic> json) =>
    _ReferralTier(
      referrals: (json['referrals'] as num).toInt(),
      reward: json['reward'] as String,
      bonus: (json['bonus'] as num?)?.toDouble() ?? 0.0,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
    );

Map<String, dynamic> _$ReferralTierToJson(_ReferralTier instance) =>
    <String, dynamic>{
      'referrals': instance.referrals,
      'reward': instance.reward,
      'bonus': instance.bonus,
      'isUnlocked': instance.isUnlocked,
    };

_Referral _$ReferralFromJson(Map<String, dynamic> json) => _Referral(
  id: json['id'] as String,
  referrerId: json['referrerId'] as String,
  refereeId: json['refereeId'] as String,
  refereeName: json['refereeName'] as String,
  refereeEmail: json['refereeEmail'] as String? ?? '',
  reward: (json['reward'] as num?)?.toDouble() ?? 0,
  bonus: (json['bonus'] as num?)?.toDouble() ?? 0,
  status: json['status'] as String? ?? 'pending',
  referredUserDaysActive:
      (json['referredUserDaysActive'] as num?)?.toInt() ?? 0,
  referredAt: json['referredAt'] == null
      ? null
      : DateTime.parse(json['referredAt'] as String),
  rewardClaimedAt: json['rewardClaimedAt'] == null
      ? null
      : DateTime.parse(json['rewardClaimedAt'] as String),
);

Map<String, dynamic> _$ReferralToJson(_Referral instance) => <String, dynamic>{
  'id': instance.id,
  'referrerId': instance.referrerId,
  'refereeId': instance.refereeId,
  'refereeName': instance.refereeName,
  'refereeEmail': instance.refereeEmail,
  'reward': instance.reward,
  'bonus': instance.bonus,
  'status': instance.status,
  'referredUserDaysActive': instance.referredUserDaysActive,
  'referredAt': instance.referredAt?.toIso8601String(),
  'rewardClaimedAt': instance.rewardClaimedAt?.toIso8601String(),
};

_ReferralActivity _$ReferralActivityFromJson(Map<String, dynamic> json) =>
    _ReferralActivity(
      id: json['id'] as String,
      referralId: json['referralId'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ReferralActivityToJson(_ReferralActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'referralId': instance.referralId,
      'type': instance.type,
      'description': instance.description,
      'amount': instance.amount,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
