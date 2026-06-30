import 'package:freezed_annotation/freezed_annotation.dart';

part 'affiliate_models.freezed.dart';
part 'affiliate_models.g.dart';

/// Referral program info
@freezed
abstract class ReferralProgram with _$ReferralProgram {
  const factory ReferralProgram({
    required String id,
    @Default('') String referralCode,
    @Default(0) int totalReferrals,
    @Default(0) int activeReferrals,
    @Default(0) double totalEarnings,
    @Default(0) double pendingEarnings,
    @Default(0) double withdrawnAmount,
    @Default(<ReferralTier>[]) List<ReferralTier> tiers,
  }) = _ReferralProgram;

  factory ReferralProgram.fromJson(Map<String, dynamic> json) =>
      _$ReferralProgramFromJson(json);
}

/// Referral tier (milestone rewards)
@freezed
abstract class ReferralTier with _$ReferralTier {
  const factory ReferralTier({
    required int referrals,
    required String reward,
    @Default(0.0) double bonus,
    @Default(false) bool isUnlocked,
  }) = _ReferralTier;

  factory ReferralTier.fromJson(Map<String, dynamic> json) =>
      _$ReferralTierFromJson(json);
}

/// Referral record
@freezed
abstract class Referral with _$Referral {
  const factory Referral({
    required String id,
    required String referrerId,
    required String refereeId,
    required String refereeName,
    @Default('') String refereeEmail,
    @Default(0) double reward,
    @Default(0) double bonus,
    @Default('pending') String status,
    @Default(0) int referredUserDaysActive,
    DateTime? referredAt,
    DateTime? rewardClaimedAt,
  }) = _Referral;

  factory Referral.fromJson(Map<String, dynamic> json) =>
      _$ReferralFromJson(json);
}

/// Referral activity/history
@freezed
abstract class ReferralActivity with _$ReferralActivity {
  const factory ReferralActivity({
    required String id,
    required String referralId,
    required String type,
    required String description,
    @Default(0.0) double amount,
    DateTime? createdAt,
  }) = _ReferralActivity;

  factory ReferralActivity.fromJson(Map<String, dynamic> json) =>
      _$ReferralActivityFromJson(json);
}
