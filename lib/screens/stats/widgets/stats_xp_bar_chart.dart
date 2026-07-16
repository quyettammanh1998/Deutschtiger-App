import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/stats/stats_models.dart';
import '../../../l10n/app_localizations.dart';

/// "XP 7 ngày qua" card — day label + per-bar XP value. Mirror web
/// `stats-xp-bar-chart.tsx`.
class StatsXpBarChart extends StatelessWidget {
  const StatsXpBarChart({super.key, required this.entries});

  final List<XpDailyLogEntry> entries;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    if (entries.isEmpty) {
      return Text(
        l10n.statsMasteryTrendEmpty,
        style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
      );
    }
    final sorted = [...entries]..sort((a, b) => a.logDate.compareTo(b.logDate));
    final maxXp = sorted
        .map((e) => e.xpEarned)
        .fold<int>(1, (a, b) => a > b ? a : b);
    final weekTotal = sorted.fold<int>(0, (a, b) => a + b.xpEarned);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.statsXpChartWeekTotal(weekTotal),
              style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
            ),
            Text(
              l10n.statsXpChartMax(maxXp),
              style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 160,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: tokens.muted.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: sorted
                .map(
                  (e) => Expanded(
                    child: _Bar(entry: e, maxXp: maxXp, tokens: tokens),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.entry, required this.maxXp, required this.tokens});

  final XpDailyLogEntry entry;
  final int maxXp;
  final AppTokens tokens;

  static const _dayNames = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

  @override
  Widget build(BuildContext context) {
    final heightFactor = entry.xpEarned > 0
        ? (entry.xpEarned / maxXp).clamp(0.1, 1.0)
        : 0.04;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: heightFactor,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [tokens.primary, const Color(0xFFEC4899)],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _dayNames[entry.logDate.weekday % 7],
            style: TextStyle(fontSize: 9, color: tokens.mutedForeground),
          ),
          Text(
            '${entry.xpEarned}',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: tokens.primary,
            ),
          ),
        ],
      ),
    );
  }
}
