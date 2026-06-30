import '../../data/affiliate/affiliate_models.dart';

class AffiliateRepository {
  Future<ReferralProgram> getProgram() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockProgram;
  }

  Future<List<Referral>> getReferrals() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockReferrals;
  }

  Future<List<ReferralActivity>> getActivities() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockActivities;
  }

  Future<void> claimReward(double amount) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<String> shareReferralCode() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return 'DEUTSCH15QTM';
  }

  static final ReferralProgram _mockProgram = ReferralProgram(
    id: 'program-1',
    referralCode: 'DEUTSCH15QTM',
    totalReferrals: 8,
    activeReferrals: 5,
    totalEarnings: 75.00,
    pendingEarnings: 12.50,
    withdrawnAmount: 50.00,
    tiers: const [
      ReferralTier(referrals: 1, reward: '50 XP bonus', bonus: 5.0, isUnlocked: true),
      ReferralTier(referrals: 3, reward: '1 Premium day + 100 XP', bonus: 10.0, isUnlocked: true),
      ReferralTier(referrals: 5, reward: '3 Premium days + 200 XP', bonus: 15.0, isUnlocked: true),
      ReferralTier(referrals: 10, reward: '1 Week Premium + 500 XP', bonus: 25.0, isUnlocked: false),
      ReferralTier(referrals: 20, reward: '1 Month Premium + 1000 XP', bonus: 50.0, isUnlocked: false),
    ],
  );

  static final List<Referral> _mockReferrals = [
    Referral(
      id: 'ref-1',
      referrerId: 'user1',
      refereeId: 'user10',
      refereeName: 'Maria K.',
      refereeEmail: 'maria@example.com',
      reward: 5.0,
      bonus: 5.0,
      status: 'completed',
      referredUserDaysActive: 45,
      referredAt: DateTime.now().subtract(const Duration(days: 60)),
      rewardClaimedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Referral(
      id: 'ref-2',
      referrerId: 'user1',
      refereeId: 'user11',
      refereeName: 'Hans W.',
      refereeEmail: 'hans@example.com',
      reward: 5.0,
      bonus: 0.0,
      status: 'completed',
      referredUserDaysActive: 30,
      referredAt: DateTime.now().subtract(const Duration(days: 45)),
      rewardClaimedAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Referral(
      id: 'ref-3',
      referrerId: 'user1',
      refereeId: 'user12',
      refereeName: 'Anna S.',
      refereeEmail: 'anna@example.com',
      reward: 2.5,
      bonus: 0.0,
      status: 'pending',
      referredUserDaysActive: 12,
      referredAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
    Referral(
      id: 'ref-4',
      referrerId: 'user1',
      refereeId: 'user13',
      refereeName: 'Peter M.',
      refereeEmail: 'peter@example.com',
      reward: 0.0,
      bonus: 0.0,
      status: 'pending',
      referredUserDaysActive: 2,
      referredAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  static final List<ReferralActivity> _mockActivities = [
    ReferralActivity(
      id: 'act-1',
      referralId: 'ref-1',
      type: 'referral_completed',
      description: 'Maria K. completed 30-day milestone',
      amount: 5.0,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    ReferralActivity(
      id: 'act-2',
      referralId: 'ref-1',
      type: 'tier_bonus',
      description: 'Tier 2 unlocked - 100 XP bonus',
      amount: 5.0,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    ReferralActivity(
      id: 'act-3',
      referralId: 'ref-2',
      type: 'referral_completed',
      description: 'Hans W. completed 30-day milestone',
      amount: 5.0,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    ReferralActivity(
      id: 'act-4',
      referralId: 'ref-3',
      type: 'milestone_partial',
      description: 'Anna S. - 12 days active',
      amount: 2.5,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];
}
