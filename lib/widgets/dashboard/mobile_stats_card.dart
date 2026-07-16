import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/design_tokens.dart';
import '../../l10n/app_localizations.dart';

/// Stats card widget - hiển thị số từ đã học, streak, thời gian học.
/// Mirrors web `mobile-stats-card.tsx`: icon-beside-label tiles with the
/// big number stacked below, thousands-separated counts, orange streak +
/// emerald online-time gradient tiles.
class MobileStatsCard extends StatelessWidget {
  const MobileStatsCard({
    super.key,
    required this.totalWordsLearned,
    required this.totalLookups,
    required this.streak,
    this.onlineSeconds = 0,
    this.onStreakTap,
    this.onDetailsTap,
    this.showDetails = true,
  });

  final int totalWordsLearned;
  final int totalLookups;
  final int streak;
  final int onlineSeconds;
  final VoidCallback? onStreakTap;
  final VoidCallback? onDetailsTap;
  final bool showDetails;

  /// Formats elapsed time with the active application locale.
  static String formatOnlineTime(AppLocalizations l10n, int seconds) {
    if (seconds < 60) return l10n.zeroMinutes;
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    if (h == 0) return l10n.minutesShort(m);
    if (m == 0) return l10n.hoursShort(h);
    return l10n.hoursMinutesShort(h, m);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final numberFormat = NumberFormat.decimalPattern(l10n.localeName);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade50, Colors.white],
              ),
            ),
          ),
          // Decorative blurred circle, top-right — matches web's soft glow.
          Positioned(
            right: -8,
            top: -8,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade100.withValues(alpha: 0.5),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats row — words & lookups: icon beside label, big number
                // stacked below (web layout, not the old icon-box-left tile).
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _StatItem(
                        icon: Icons.menu_book_rounded,
                        label: l10n.wordsLearned,
                        value: numberFormat.format(totalWordsLearned),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _StatItem(
                        icon: Icons.description_outlined,
                        label: l10n.lookupCount,
                        value: numberFormat.format(totalLookups),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Streak + Online time row
                Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        button: onStreakTap != null,
                        label: '${l10n.streak}: ${l10n.streakDays(streak)}',
                        onTap: onStreakTap,
                        child: ExcludeSemantics(
                          child: GestureDetector(
                            onTap: onStreakTap,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orange.shade50,
                                    Colors.amber.shade50,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        '🔥',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        l10n.streak,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: DesignTokens.mutedForeground,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        '$streak',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          height: 1,
                                          color: Colors.orange.shade500,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'ngày',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.orange.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Semantics(
                        label:
                            '${l10n.today}: ${formatOnlineTime(l10n, onlineSeconds)}',
                        child: ExcludeSemantics(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.teal.shade50,
                                  DesignTokens.emerald50,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: DesignTokens.emerald600,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      l10n.today,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: DesignTokens.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  formatOnlineTime(l10n, onlineSeconds),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                    color: DesignTokens.emerald600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                if (showDetails) ...[
                  const SizedBox(height: 12),
                  // View details button
                  Semantics(
                    button: onDetailsTap != null,
                    label: l10n.viewDetails,
                    onTap: onDetailsTap,
                    child: ExcludeSemantics(
                      child: GestureDetector(
                        onTap: onDetailsTap,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: DesignTokens.border),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.viewDetails,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: DesignTokens.foreground,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: DesignTokens.mutedForeground,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: $value',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: Colors.blue.shade500),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: DesignTokens.mutedForeground,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: DesignTokens.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
