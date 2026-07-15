import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../view_models/providers.dart';
import 'widgets/leaderboard_tile.dart';

/// Màn Leaderboard — Phase 05 K4.
///
/// Read-only, liệt kê user theo XP / streak. Dùng DesignTokens cho toàn bộ
/// surface. Dữ liệu lấy từ BE thật:
///   - weekly  -> GET /leaderboard/weekly    (weekly_xp, current_streak)
///   - allTime -> GET /gamification/leaderboard (total_xp, level, current_streak)
class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.id,
    required this.displayName,
    this.avatarUrl,
    required this.xp,
    required this.streak,
    this.isCurrentUser = false,
  });

  final int rank;
  final String id;
  final String displayName;
  final String? avatarUrl;
  final int xp;
  final int streak;
  final bool isCurrentUser;

  /// Parses an entry from either backend response shape:
  ///   - `/leaderboard/weekly` -> user_id, display_name, avatar_url, weekly_xp, current_streak
  ///   - `/gamification/leaderboard` -> user_id, display_name, avatar_url, total_xp, current_streak
  factory LeaderboardEntry.fromJson(Map<String, dynamic> j, int rank) {
    return LeaderboardEntry(
      rank: rank,
      id: j['user_id'] as String? ?? j['id'] as String? ?? '',
      displayName:
          j['display_name'] as String? ?? j['displayName'] as String? ?? '',
      avatarUrl: j['avatar_url'] as String?,
      xp:
          (j['weekly_xp'] as num?)?.toInt() ??
          (j['total_xp'] as num?)?.toInt() ??
          (j['xp'] as num?)?.toInt() ??
          0,
      streak:
          (j['current_streak'] as num?)?.toInt() ??
          (j['streak'] as num?)?.toInt() ??
          0,
      isCurrentUser: j['is_current_user'] as bool? ?? false,
    );
  }
}

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

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(leaderboardTypeProvider);
    final leaderboard = ref.watch(leaderboardProvider(type));
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: DesignTokens.authBackground,
      appBar: AppBar(
        backgroundColor: DesignTokens.authBackground,
        title: Text(
          l10n.leaderboardTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: DesignTokens.tigerOrange,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: _TypeSelector(
              selected: type,
              onChanged: (t) =>
                  ref.read(leaderboardTypeProvider.notifier).setType(t),
            ),
          ),
          Expanded(
            child: leaderboard.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) =>
                  Center(child: Text(l10n.couldNotLoadLeaderboard)),
              data: (entries) => entries.isEmpty
                  ? Center(child: Text(l10n.noLeaderboardEntries))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingMd,
                      ),
                      itemCount: entries.length,
                      itemBuilder: (context, index) =>
                          LeaderboardTile(entry: entries[index]),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  const _TypeSelector({required this.selected, required this.onChanged});
  final LeaderboardType selected;
  final ValueChanged<LeaderboardType> onChanged;

  String _label(BuildContext context, LeaderboardType t) {
    final l10n = AppLocalizations.of(context);
    return switch (t) {
      LeaderboardType.weekly => l10n.thisWeek,
      LeaderboardType.allTime => l10n.allTime,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: DesignTokens.muted,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm + 4),
      ),
      child: Row(
        children: LeaderboardType.values.map((type) {
          final isSelected = type == selected;
          final label = _label(context, type);
          return Expanded(
            child: Semantics(
              button: true,
              selected: isSelected,
              label: label,
              child: Material(
                color: isSelected ? DesignTokens.card : Colors.transparent,
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                elevation: isSelected ? 1 : 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  onTap: () => onChanged(type),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: DesignTokens.spacingSm + 2,
                    ),
                    child: Text(
                      label,
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? DesignTokens.tigerOrange
                            : DesignTokens.mutedForeground,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
