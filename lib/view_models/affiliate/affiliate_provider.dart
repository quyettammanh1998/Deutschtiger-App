import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/affiliate/affiliate_repository.dart';
import '../../data/affiliate/affiliate_models.dart';

final affiliateRepositoryProvider = Provider<AffiliateRepository>((ref) => AffiliateRepository());

final referralProgramProvider = FutureProvider<ReferralProgram>((ref) async {
  final repo = ref.watch(affiliateRepositoryProvider);
  return repo.getProgram();
});

final referralsProvider = FutureProvider<List<Referral>>((ref) async {
  final repo = ref.watch(affiliateRepositoryProvider);
  return repo.getReferrals();
});

final referralActivitiesProvider = FutureProvider<List<ReferralActivity>>((ref) async {
  final repo = ref.watch(affiliateRepositoryProvider);
  return repo.getActivities();
});

class AffiliateNotifier extends StateNotifier<AffiliateState> {
  final AffiliateRepository _repo;
  
  AffiliateNotifier(this._repo) : super(AffiliateState());
  
  Future<void> loadProgram() async {
    state = state.copyWith(isLoading: true);
    try {
      final program = await _repo.getProgram();
      final referrals = await _repo.getReferrals();
      final activities = await _repo.getActivities();
      
      state = state.copyWith(
        program: program,
        referrals: referrals,
        activities: activities,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
  
  Future<String> shareCode() async {
    final code = await _repo.shareReferralCode();
    state = state.copyWith(referralCode: code);
    return code;
  }
  
  Future<void> claimReward(double amount) async {
    await _repo.claimReward(amount);
    await loadProgram();
  }
}

class AffiliateState {
  final ReferralProgram? program;
  final List<Referral> referrals;
  final List<ReferralActivity> activities;
  final String? referralCode;
  final bool isLoading;
  final String? error;
  
  AffiliateState({
    this.program,
    this.referrals = const [],
    this.activities = const [],
    this.referralCode,
    this.isLoading = false,
    this.error,
  });
  
  AffiliateState copyWith({
    ReferralProgram? program,
    List<Referral>? referrals,
    List<ReferralActivity>? activities,
    String? referralCode,
    bool? isLoading,
    String? error,
  }) {
    return AffiliateState(
      program: program ?? this.program,
      referrals: referrals ?? this.referrals,
      activities: activities ?? this.activities,
      referralCode: referralCode ?? this.referralCode,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final affiliateNotifierProvider = StateNotifierProvider<AffiliateNotifier, AffiliateState>((ref) {
  return AffiliateNotifier(ref.watch(affiliateRepositoryProvider));
});
