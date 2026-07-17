import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import 'package:deutschtiger/data/stats/stats_models.dart';

/// Thẻ "Độ nhớ từ vựng" — phân bố FSRS (mới/đang học/đang nhớ/thuộc lòng) +
/// xu hướng ôn tập N ngày qua. Mirror `MasteryOverview` (web).
class SRSStatsCard extends StatelessWidget {
  const SRSStatsCard({super.key, required this.mastery, required this.daily});

  final MasterySummary mastery;
  final List<SrsDailyStat> daily;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (mastery.total == 0) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.statsMasteryEmpty,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    final buckets = <(String label, int value, Color color)>[
      (l10n.statsMasteryNew, mastery.newCount, Colors.grey),
      (l10n.statsMasteryLearning, mastery.learning, AppColors.tigerOrange),
      (l10n.statsMasteryYoung, mastery.young, Colors.amber),
      (l10n.statsMasteryMature, mastery.mature, context.tokens.success),
    ];
    final maxReviews = daily
        .map((d) => d.reviewsCount)
        .fold<int>(0, (a, b) => a > b ? a : b)
        .clamp(1, 1 << 30);
    final hasTrend = daily.any((d) => d.reviewsCount > 0);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 10,
                child: Row(
                  children: buckets
                      .where((b) => b.$2 > 0)
                      .map(
                        (b) => Expanded(
                          flex: b.$2,
                          child: ColoredBox(color: b.$3),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: buckets
                  .map(
                    (b) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: b.$3,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${b.$1}: ${b.$2}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              l10n.statsMasteryTrendTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 12),
            if (hasTrend)
              SizedBox(
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: daily
                      .map(
                        (d) => Expanded(
                          child: FractionallySizedBox(
                            heightFactor:
                                (d.reviewsCount / maxReviews).clamp(0.03, 1.0),
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 1,
                              ),
                              decoration: BoxDecoration(
                                color: context.tokens.success.withValues(
                                  alpha: 0.7,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
            else
              Text(
                l10n.statsMasteryTrendEmpty,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }
}
