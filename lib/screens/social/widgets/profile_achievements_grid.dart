import 'package:flutter/material.dart';

import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/widgets/common/app_card.dart';

/// One achievement entry — computed client-side from gamification stats,
/// mirroring web `profile-service.ts` `computeAchievements` (pure function,
/// no backend endpoint).
class ProfileAchievement {
  const ProfileAchievement({
    required this.id,
    required this.name,
    required this.description,
    required this.earned,
    required this.icon,
  });

  final String id;
  final String name;
  final String description;
  final bool earned;
  final String icon;
}

/// Pure port of web `computeAchievements(gam, totalReviews, flashcardCount)`.
List<ProfileAchievement> computeProfileAchievements(
  AppLocalizations l10n, {
  required int level,
  required int totalXp,
  required int longestStreak,
  required int totalReviews,
  required int flashcardCount,
}) {
  return [
    ProfileAchievement(
      id: 'first-practice',
      name: l10n.achievementFirstPracticeName,
      description: l10n.achievementFirstPracticeDesc,
      earned: totalReviews > 0,
      icon: '🎯',
    ),
    ProfileAchievement(
      id: 'streak-3',
      name: l10n.achievementStreak3Name,
      description: l10n.achievementStreak3Desc,
      earned: longestStreak >= 3,
      icon: '🔥',
    ),
    ProfileAchievement(
      id: 'streak-7',
      name: l10n.achievementStreak7Name,
      description: l10n.achievementStreak7Desc,
      earned: longestStreak >= 7,
      icon: '⭐',
    ),
    ProfileAchievement(
      id: 'streak-30',
      name: l10n.achievementStreak30Name,
      description: l10n.achievementStreak30Desc,
      earned: longestStreak >= 30,
      icon: '👑',
    ),
    ProfileAchievement(
      id: 'cards-10',
      name: l10n.achievementCards10Name,
      description: l10n.achievementCards10Desc,
      earned: flashcardCount >= 10,
      icon: '📚',
    ),
    ProfileAchievement(
      id: 'cards-50',
      name: l10n.achievementCards50Name,
      description: l10n.achievementCards50Desc,
      earned: flashcardCount >= 50,
      icon: '📖',
    ),
    ProfileAchievement(
      id: 'cards-100',
      name: l10n.achievementCards100Name,
      description: l10n.achievementCards100Desc,
      earned: flashcardCount >= 100,
      icon: '🏆',
    ),
    ProfileAchievement(
      id: 'xp-500',
      name: l10n.achievementXp500Name,
      description: l10n.achievementXp500Desc,
      earned: totalXp >= 500,
      icon: '💪',
    ),
    ProfileAchievement(
      id: 'xp-1000',
      name: l10n.achievementXp1000Name,
      description: l10n.achievementXp1000Desc,
      earned: totalXp >= 1000,
      icon: '🚀',
    ),
    ProfileAchievement(
      id: 'xp-5000',
      name: l10n.achievementXp5000Name,
      description: l10n.achievementXp5000Desc,
      earned: totalXp >= 5000,
      icon: '🌟',
    ),
    ProfileAchievement(
      id: 'level-5',
      name: l10n.achievementLevel5Name,
      description: l10n.achievementLevel5Desc,
      earned: level >= 5,
      icon: '🎖️',
    ),
    ProfileAchievement(
      id: 'level-10',
      name: l10n.achievementLevel10Name,
      description: l10n.achievementLevel10Desc,
      earned: level >= 10,
      icon: '🏅',
    ),
    ProfileAchievement(
      id: 'reviews-100',
      name: l10n.achievementReviews100Name,
      description: l10n.achievementReviews100Desc,
      earned: totalReviews >= 100,
      icon: '📝',
    ),
  ];
}

/// Web parity: `components/profile/profile-achievements-grid.tsx` — earned
/// count pill + progress bar + tap-to-expand-description tile grid.
class ProfileAchievementsGrid extends StatefulWidget {
  const ProfileAchievementsGrid({super.key, required this.achievements});

  final List<ProfileAchievement> achievements;

  @override
  State<ProfileAchievementsGrid> createState() =>
      _ProfileAchievementsGridState();
}

class _ProfileAchievementsGridState extends State<ProfileAchievementsGrid> {
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final earnedCount = widget.achievements.where((a) => a.earned).length;
    final total = widget.achievements.length;
    final progress = total > 0 ? earnedCount / total : 0.0;

    return AppCard.card(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.socialAchievementsTitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: tokens.foreground,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: tokens.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$earnedCount/$total',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: tokens.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: tokens.muted,
              valueColor: AlwaysStoppedAnimation(tokens.primary),
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.85,
            children: widget.achievements.map((a) {
              final isExpanded = _expandedId == a.id && a.earned;
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: a.earned
                    ? () => setState(
                        () => _expandedId = _expandedId == a.id ? null : a.id,
                      )
                    : null,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: a.earned ? tokens.primary.withValues(alpha: 0.1) : tokens.muted,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Opacity(
                    opacity: a.earned ? 1 : 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          a.earned ? a.icon : '🔒',
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(height: 4),
                        Flexible(
                          child: Text(
                            isExpanded ? a.description : a.name,
                            style: TextStyle(
                              fontSize: 9,
                              height: 1.1,
                              color: tokens.mutedForeground,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
