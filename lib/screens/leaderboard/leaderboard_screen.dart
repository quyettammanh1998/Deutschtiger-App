import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../core/release/release_feature_flags.dart';
import '../../data/leaderboard/leaderboard_entry.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/back_button.dart';
import '../../view_models/providers.dart';
import 'widgets/leaderboard_hall_of_fame.dart';
import 'widgets/leaderboard_header_row.dart';
import 'widgets/leaderboard_list_body.dart';
import 'widgets/leaderboard_providers.dart';
import 'widgets/leaderboard_score_detail_sheet.dart';

export '../../data/leaderboard/leaderboard_entry.dart' show LeaderboardEntry;

/// Màn Leaderboard — Phase 05 K4 (v1); rebuilt Phase 12 (wave A) cho khớp
/// web `weekly-leaderboard.tsx` (podium + crown, tabs Toàn cầu/Bạn bè, hall
/// of fame, countdown, rank delta, breakdown chips, detail sheet).
///
/// Dữ liệu lấy từ BE thật:
///   - weekly  -> GET /leaderboard/weekly    (composite weekly_score)
///   - allTime -> GET /gamification/leaderboard (dùng cho bảng ở /stats,
///     KHÔNG dùng cho tabs màn này — web leaderboard page chỉ có 2 tab
///     Toàn cầu/Bạn bè, cả hai đều là bảng tuần).
/// [LeaderboardEntry] itself lives in `data/leaderboard/leaderboard_entry.dart`
/// (re-exported here so existing imports keep working).
enum LeaderboardType { weekly, allTime }

class LeaderboardTypeNotifier extends Notifier<LeaderboardType> {
  @override
  LeaderboardType build() => LeaderboardType.weekly;
  void setType(LeaderboardType type) => state = type;
}

final leaderboardTypeProvider =
    NotifierProvider<LeaderboardTypeNotifier, LeaderboardType>(
      LeaderboardTypeNotifier.new,
    );

/// Maps each visible UI scope to a distinct backend data scope.
String leaderboardPathFor(LeaderboardType type) => switch (type) {
  LeaderboardType.weekly => '/leaderboard/weekly',
  LeaderboardType.allTime => '/gamification/leaderboard',
};

final leaderboardProvider =
    FutureProvider.family<List<LeaderboardEntry>, LeaderboardType>((
      ref,
      type,
    ) async {
      final api = ref.watch(apiClientProvider);
      final data = await api.get<List<dynamic>>(leaderboardPathFor(type));
      return data
          .asMap()
          .entries
          .map(
            (e) => LeaderboardEntry.fromJson(
              e.value as Map<String, dynamic>,
              e.key + 1,
            ),
          )
          .toList();
    });

/// Tab "Toàn cầu" | "Bạn bè" trên trang leaderboard đầy đủ — độc lập với
/// [LeaderboardType] (dùng cho home compact widget + bảng /stats).
enum LeaderboardTab { global, friends }

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  LeaderboardTab _tab = LeaderboardTab.global;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final isFriends = _tab == LeaderboardTab.friends;
    final entries = ref.watch(
      isFriends
          ? friendsWeeklyLeaderboardProvider
          : leaderboardProvider(LeaderboardType.weekly),
    );
    final myRank = ref.watch(myWeeklyRankProvider);
    final hallOfFame = ref.watch(hallOfFameProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppBackButton(onPressed: () => context.pop()),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.leaderboardTitle,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: tokens.foreground,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.leaderboardSubtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: tokens.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 16),
                    LeaderboardHeaderRow(showCountdown: !isFriends),
                    const SizedBox(height: 12),
                    if (ReleaseFeatureFlags.social)
                      LeaderboardTabSelector(
                        selected: _tab,
                        onChanged: (t) => setState(() => _tab = t),
                      ),
                    if (!isFriends) ...[
                      const SizedBox(height: 4),
                      hallOfFame.maybeWhen(
                        data: (list) => LeaderboardHallOfFame(entries: list),
                        orElse: () => const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            entries.when(
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (_, _) => SliverToBoxAdapter(
                child: LeaderboardScopeEmpty(text: l10n.couldNotLoadLeaderboard),
              ),
              data: (list) {
                if (isFriends && list.length <= 1) {
                  return const SliverToBoxAdapter(
                    child: LeaderboardFriendsEmpty(),
                  );
                }
                if (list.isEmpty) {
                  return SliverToBoxAdapter(
                    child: LeaderboardScopeEmpty(text: l10n.noLeaderboardEntries),
                  );
                }
                return SliverToBoxAdapter(
                  child: LeaderboardListBody(
                    entries: list,
                    showOwnRank: !isFriends,
                    myRank: myRank.valueOrNull,
                    onShowDetails: (e) => showLeaderboardDetailSheet(context, e),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
