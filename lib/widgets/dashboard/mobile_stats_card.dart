import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// Stats card widget - hiển thị số từ đã học, streak, thời gian học.
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade50, Colors.white],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats row - words & lookups
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.menu_book_rounded,
                    iconColor: Colors.blue,
                    label: l10n.wordsLearned,
                    value: totalWordsLearned.toString(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatItem(
                    icon: Icons.search_rounded,
                    iconColor: Colors.blue,
                    label: l10n.lookupCount,
                    value: totalLookups.toString(),
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
                          child: Row(
                            children: [
                              const Text('🔥', style: TextStyle(fontSize: 18)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.streak,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.mutedForeground,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          l10n.streakDays(streak),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange.shade400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
                            colors: [Colors.green.shade50, Colors.teal.shade50],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.green.shade400,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.today,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                  Text(
                                    formatOnlineTime(l10n, onlineSeconds),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
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
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.viewDetails,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.foreground,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: AppColors.mutedForeground,
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
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: $value',
      child: ExcludeSemantics(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
