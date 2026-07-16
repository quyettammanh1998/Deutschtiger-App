import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/leaderboard/hall_of_fame_entry.dart';
import '../../../services/api_client.dart';
import '../../../view_models/providers.dart';
import '../leaderboard_screen.dart';

/// `GET /user/leaderboard/weekly-rank` — the requesting user's own weekly
/// rank row, used to append a "···" divider row when the user sits outside
/// the visible top-5 (mirrors web `useUserWeeklyRank`). Returns null when
/// the user has no weekly score yet (backend `omitempty`/absent row).
final myWeeklyRankProvider = FutureProvider<LeaderboardEntry?>((ref) async {
  final api = ref.watch(apiClientProvider);
  try {
    // Backend responds with a JSON `null` body (not 404) when the user has
    // no weekly score yet — the API client treats an empty body as an
    // error, so that case is folded into `null` here rather than surfaced.
    final json = await api.get<Map<String, dynamic>>(
      '/user/leaderboard/weekly-rank',
    );
    final rank = json['rank'] as int? ?? 0;
    if (rank <= 0) return null;
    return LeaderboardEntry.fromJson(json, rank).copyWithCurrentUser();
  } on ApiException {
    return null;
  }
});

/// `GET /user/leaderboard/friends` — the "Bạn bè" weekly board (self +
/// accepted friends). Not yet mounted on every backend deploy target; fails
/// open to an empty list like web's `weeklyLeaderboardService.getFriendsWeekly`.
final friendsWeeklyLeaderboardProvider = FutureProvider<List<LeaderboardEntry>>((
  ref,
) async {
  final api = ref.watch(apiClientProvider);
  try {
    final data = await api.get<List<dynamic>>('/user/leaderboard/friends');
    final myId = ref.watch(authServiceProvider).currentUser?.id;
    return data.asMap().entries.map((e) {
      final entry = LeaderboardEntry.fromJson(
        e.value as Map<String, dynamic>,
        e.key + 1,
      );
      return entry.id == myId ? entry.copyWithCurrentUser() : entry;
    }).toList();
  } on ApiException {
    return const [];
  }
});

/// `GET /leaderboard/hall-of-fame` — top-3 snapshot from last week's reset.
final hallOfFameProvider = FutureProvider<List<HallOfFameEntry>>((ref) async {
  final api = ref.watch(apiClientProvider);
  try {
    final data = await api.get<List<dynamic>>('/leaderboard/hall-of-fame');
    return data
        .map((e) => HallOfFameEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  } on ApiException {
    return const [];
  }
});

/// Marks an entry as belonging to the current user (own-rank rows are
/// fetched from a per-user endpoint that has no `is_current_user` flag).
extension _CurrentUserEntry on LeaderboardEntry {
  LeaderboardEntry copyWithCurrentUser() => LeaderboardEntry(
    rank: rank,
    id: id,
    displayName: displayName,
    avatarUrl: avatarUrl,
    xp: xp,
    streak: streak,
    isCurrentUser: true,
    weeklyXp: weeklyXp,
    examPoints: examPoints,
    missionCount: missionCount,
    vocabReviewed: vocabReviewed,
    readingCount: readingCount,
    speakWriteCount: speakWriteCount,
    wordsAdded: wordsAdded,
    isPremium: isPremium,
    isNewUserDampened: isNewUserDampened,
    lastWeekRank: lastWeekRank,
    totalXp: totalXp,
    level: level,
  );
}

/// Ms until next Monday 00:00 VN — mirror web `weeklyLeaderboardService.getTimeUntilReset`.
int _msUntilWeeklyReset() {
  final now = DateTime.now().toUtc().add(const Duration(hours: 7)); // VN = UTC+7
  final day = now.weekday; // 1=Mon..7=Sun
  final daysUntilMonday = day == 7 ? 1 : (day == 1 ? 7 : 8 - day);
  final nextMonday = DateTime(
    now.year,
    now.month,
    now.day,
  ).add(Duration(days: daysUntilMonday));
  return nextMonday.difference(now).inMilliseconds;
}

/// Formats the reset countdown as "Xd Yh" or "Xh Ym" — mirror web `formatCountdown`.
String weeklyResetCountdownLabel() {
  final ms = _msUntilWeeklyReset();
  final days = ms ~/ 86400000;
  final hours = (ms % 86400000) ~/ 3600000;
  if (days > 0) return '${days}d ${hours}h';
  final mins = (ms % 3600000) ~/ 60000;
  return '${hours}h ${mins}m';
}
