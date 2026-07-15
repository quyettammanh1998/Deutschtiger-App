import 'package:flutter/foundation.dart';

import 'package:deutschtiger/services/api_client.dart';

/// A single row from `GET /user/affiliate/leaderboard`.
///
/// Backend response fields (see `affiliate_handler.go` GetLeaderboard):
/// `rank`, `referrer_id`, `display_name`, `total_earned`, `conversions`.
/// The mock UI previously showed a `currentStreak` (days) field that has no
/// backend equivalent — it has been dropped rather than fabricated.
class AffiliateLeaderboardEntry {
  final int rank;
  final String referrerId;
  final String displayName;
  final int totalEarned;
  final int conversions;
  final bool isCurrentUser;

  const AffiliateLeaderboardEntry({
    required this.rank,
    required this.referrerId,
    required this.displayName,
    required this.totalEarned,
    required this.conversions,
    this.isCurrentUser = false,
  });

  factory AffiliateLeaderboardEntry.fromJson(
    Map<String, dynamic> json, {
    int myRank = 0,
  }) {
    final rank = json['rank'] as int? ?? 0;
    final displayName = json['display_name'] as String?;
    return AffiliateLeaderboardEntry(
      rank: rank,
      referrerId: json['referrer_id'] as String? ?? '',
      displayName: (displayName != null && displayName.trim().isNotEmpty)
          ? displayName
          : 'User',
      totalEarned: json['total_earned'] as int? ?? 0,
      conversions: json['conversions'] as int? ?? 0,
      isCurrentUser: myRank > 0 && rank == myRank,
    );
  }

  AffiliateLeaderboardEntry copyWith({int? rank, bool? isCurrentUser}) {
    return AffiliateLeaderboardEntry(
      rank: rank ?? this.rank,
      referrerId: referrerId,
      displayName: displayName,
      totalEarned: totalEarned,
      conversions: conversions,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }
}

/// Full leaderboard payload: top entries plus the requesting user's own rank.
class AffiliateLeaderboardResult {
  final List<AffiliateLeaderboardEntry> entries;
  final int myRank;
  final int myEarned;
  final String period;

  const AffiliateLeaderboardResult({
    required this.entries,
    required this.myRank,
    required this.myEarned,
    required this.period,
  });

  static const empty = AffiliateLeaderboardResult(
    entries: [],
    myRank: 0,
    myEarned: 0,
    period: 'all',
  );
}

/// Repository for `GET /user/affiliate/leaderboard?period=all|monthly|weekly`.
class AffiliateLeaderboardRepository {
  AffiliateLeaderboardRepository(this._api);

  final ApiClient _api;

  Future<AffiliateLeaderboardResult> getLeaderboard({String period = 'all'}) async {
    try {
      final json = await _api.get<Map<String, dynamic>>(
        '/user/affiliate/leaderboard',
        query: {'period': period},
      );
      final myRank = json['my_rank'] as int? ?? 0;
      final entries = (json['entries'] as List<dynamic>? ?? [])
          .map((e) => AffiliateLeaderboardEntry.fromJson(
                e as Map<String, dynamic>,
                myRank: myRank,
              ))
          .toList();
      return AffiliateLeaderboardResult(
        entries: entries,
        myRank: myRank,
        myEarned: json['my_earned'] as int? ?? 0,
        period: json['period'] as String? ?? period,
      );
    } catch (e) {
      debugPrint('getLeaderboard error: $e');
      return AffiliateLeaderboardResult.empty;
    }
  }
}
