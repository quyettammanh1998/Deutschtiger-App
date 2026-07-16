import 'package:flutter/material.dart';

import '../../../data/stats/stats_models.dart';
import '../../../l10n/app_localizations.dart';

/// "Thống kê ôn tập" — 4 gradient cards (today/week/accuracy/due). Mirror
/// web `review-stats.tsx`.
class StatsReviewCards extends StatelessWidget {
  const StatsReviewCards({super.key, required this.stats});

  final FlashcardReviewStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cards = [
      (
        l10n.statsReviewToday,
        '${stats.totalReviewsToday}',
        l10n.statsReviewTodayNote,
        const [Color(0xFF8B5CF6), Color(0xFF9333EA)],
      ),
      (
        l10n.statsReviewWeek,
        '${stats.totalReviewsWeek}',
        l10n.statsReviewWeekNote,
        const [Color(0xFF22C55E), Color(0xFF10B981)],
      ),
      (
        l10n.statsReviewAccuracy,
        '${stats.averageAccuracy}%',
        l10n.statsReviewAccuracyNote,
        const [Color(0xFF6366F1), Color(0xFF2563EB)],
      ),
      (
        l10n.statsReviewDue,
        '${stats.dueCardsCount}',
        l10n.statsReviewDueNote,
        const [Color(0xFFF43F5E), Color(0xFFDB2777)],
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth > 520 ? 4 : 2;
        return GridView.count(
          crossAxisCount: cols,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.6,
          children: cards
              .map(
                (c) => Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: c.$4,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.$1,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        c.$2,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        c.$3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
