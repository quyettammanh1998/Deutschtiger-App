import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/stats/stats_models.dart';
import '../../../l10n/app_localizations.dart';

String _formatSeconds(int s) {
  if (s < 60) return '${s}s';
  final m = s ~/ 60;
  if (m < 60) return '${m}m';
  final h = m ~/ 60;
  final rm = m % 60;
  return rm > 0 ? '${h}h ${rm}m' : '${h}h';
}

const _weekdayShort = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

String _dayLabel(String isoDate) {
  final d = DateTime.tryParse(isoDate);
  if (d == null) return isoDate;
  return _weekdayShort[d.weekday % 7];
}

/// "Thời gian online 7 ngày" — teal/cyan bar chart. Mirror web
/// `stats-online-time-card.tsx`. Renders nothing when [data] is empty
/// (mirrors web's conditional block).
class StatsOnlineTimeCard extends StatelessWidget {
  const StatsOnlineTimeCard({super.key, required this.data});

  final List<WeeklyOnlineTimePoint> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final maxSeconds = data
        .map((p) => p.totalSeconds)
        .fold<int>(1, (a, b) => a > b ? a : b);
    final todaySeconds = data.last.totalSeconds;
    final weekSeconds = data.fold<int>(0, (a, b) => a + b.totalSeconds);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.statsOnlineTimeTitle,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: tokens.foreground,
                      ),
                    ),
                    Text(
                      l10n.statsOnlineTimeWeekTotal(_formatSeconds(weekSeconds)),
                      style: TextStyle(
                        fontSize: 11,
                        color: tokens.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF14B8A6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l10n.statsOnlineTimeToday(_formatSeconds(todaySeconds)),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F766E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 160,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: tokens.muted.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data
                  .map(
                    (p) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: FractionallySizedBox(
                                  heightFactor: p.totalSeconds > 0
                                      ? (p.totalSeconds / maxSeconds).clamp(
                                          0.1,
                                          1.0,
                                        )
                                      : 0.04,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      gradient: const LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Color(0xFF0D9488),
                                          Color(0xFF22D3EE),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _dayLabel(p.logDate),
                              style: TextStyle(
                                fontSize: 9,
                                color: tokens.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
