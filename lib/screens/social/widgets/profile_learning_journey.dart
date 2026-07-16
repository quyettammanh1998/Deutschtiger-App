import 'package:flutter/material.dart';

import 'package:deutschtiger/core/icons/app_phosphor_icons.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/shared/widgets/level_badge.dart';
import 'package:deutschtiger/widgets/common/app_card.dart';

/// Web parity: `components/profile/profile-learning-journey.tsx` — 2×2 grid
/// (CEFR level, weekly rank, words learned, total reviews).
class ProfileLearningJourney extends StatelessWidget {
  const ProfileLearningJourney({
    super.key,
    required this.cefrLevel,
    required this.weeklyRank,
    required this.wordsLearned,
    required this.totalReviews,
  });

  final String? cefrLevel;
  final int? weeklyRank;
  final int wordsLearned;
  final int totalReviews;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return AppCard.card(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.socialLearningJourneyTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: tokens.foreground,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.35,
            children: [
              _JourneyCard(
                label: 'CEFR',
                icon: AppPhosphorIcons.graduationCap,
                iconColor: tokens.primary,
                child: cefrLevel != null
                    ? LevelBadge.fromString(cefrLevel, compact: true)
                    : Text(
                        '--',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: tokens.mutedForeground,
                        ),
                      ),
              ),
              _JourneyCard(
                label: l10n.socialWeeklyRankLabel,
                icon: AppPhosphorIcons.trophy,
                iconColor: const Color(0xFFF59E0B),
                child: Text(
                  weeklyRank != null ? '#$weeklyRank' : '--',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: tokens.foreground,
                  ),
                ),
              ),
              _JourneyCard(
                label: l10n.socialWordsLearnedLabel,
                icon: AppPhosphorIcons.bookOpen,
                iconColor: const Color(0xFF10B981),
                child: Text(
                  wordsLearned > 0 ? '$wordsLearned' : '--',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: tokens.foreground,
                  ),
                ),
              ),
              _JourneyCard(
                label: l10n.socialTotalReviewsLabel,
                icon: AppPhosphorIcons.arrowsClockwise,
                iconColor: const Color(0xFF3B82F6),
                child: Text(
                  totalReviews > 0 ? '$totalReviews' : '--',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: tokens.foreground,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _JourneyCard extends StatelessWidget {
  const _JourneyCard({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppCard.small(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(height: 4),
          child,
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: tokens.mutedForeground),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
