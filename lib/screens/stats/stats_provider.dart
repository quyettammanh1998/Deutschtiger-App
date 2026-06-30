import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/stats_repository.dart';
import '../domain/stats_models.dart';

final statsRepositoryProvider = Provider<StatsRepository>((ref) => StatsRepository());

final errorPatternsProvider = FutureProvider<List<ErrorPattern>>((ref) async {
  final repo = ref.watch(statsRepositoryProvider);
  return repo.getErrorPatterns();
});

final srsStatsProvider = FutureProvider<SRSStats>((ref) async {
  final repo = ref.watch(statsRepositoryProvider);
  return repo.getSRSStats();
});

final nearAchievementsProvider = FutureProvider<List<NearAchievement>>((ref) async {
  final repo = ref.watch(statsRepositoryProvider);
  return repo.getNearAchievements();
});

final streakInfoProvider = FutureProvider<StreakInfo>((ref) async {
  final repo = ref.watch(statsRepositoryProvider);
  return repo.getStreakInfo();
});

final timeStatsProvider = FutureProvider<TimeStats>((ref) async {
  final repo = ref.watch(statsRepositoryProvider);
  return repo.getTimeStats();
});

final topErrorsProvider = FutureProvider<List<ErrorPattern>>((ref) async {
  final repo = ref.watch(statsRepositoryProvider);
  return repo.getTopErrors(limit: 5);
});

final detailedAnalyticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(statsRepositoryProvider);
  return repo.getDetailedAnalytics();
});

class StatsNotifier extends StateNotifier<StatsState> {
  final StatsRepository _repo;
  
  StatsNotifier(this._repo) : super(StatsState());
  
  Future<void> loadAllStats() async {
    state = state.copyWith(isLoading: true);
    try {
      final results = await Future.wait([
        _repo.getErrorPatterns(),
        _repo.getSRSStats(),
        _repo.getStreakInfo(),
        _repo.getTimeStats(),
      ]);
      
      state = state.copyWith(
        errorPatterns: results[0] as List<ErrorPattern>,
        srsStats: results[1] as SRSStats,
        streakInfo: results[2] as StreakInfo,
        timeStats: results[3] as TimeStats,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

class StatsState {
  final List<ErrorPattern> errorPatterns;
  final SRSStats? srsStats;
  final StreakInfo? streakInfo;
  final TimeStats? timeStats;
  final bool isLoading;
  final String? error;
  
  StatsState({
    this.errorPatterns = const [],
    this.srsStats,
    this.streakInfo,
    this.timeStats,
    this.isLoading = false,
    this.error,
  });
  
  StatsState copyWith({
    List<ErrorPattern>? errorPatterns,
    SRSStats? srsStats,
    StreakInfo? streakInfo,
    TimeStats? timeStats,
    bool? isLoading,
    String? error,
  }) {
    return StatsState(
      errorPatterns: errorPatterns ?? this.errorPatterns,
      srsStats: srsStats ?? this.srsStats,
      streakInfo: streakInfo ?? this.streakInfo,
      timeStats: timeStats ?? this.timeStats,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final statsNotifierProvider = StateNotifierProvider<StatsNotifier, StatsState>((ref) {
  return StatsNotifier(ref.watch(statsRepositoryProvider));
});
