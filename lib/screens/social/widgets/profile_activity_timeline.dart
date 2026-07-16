import 'package:flutter/material.dart';

import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/data/social/public_profile_model.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/widgets/common/app_card.dart';

const Map<String, String> _eventIcons = {
  'level_up': '⬆️',
  'streak_milestone': '🔥',
  'achievement_unlocked': '🏆',
  'mission_completed': '✅',
  'exam_high_score': '🎯',
  'game_completed': '🎮',
  'daily_review_completed': '📖',
  'vocabulary_learned': '📚',
  'video_completed': '🎬',
};

const Map<String, String> _gameNames = {
  'matching': 'Nối từ',
  'writing': 'Viết',
  'cloze': 'Điền từ',
  'listening': 'Nghe',
  'runner': 'Runner',
  'flashcards': 'Flashcard',
};

String _relativeTime(String iso, AppLocalizations l10n) {
  final date = DateTime.tryParse(iso);
  if (date == null) return iso;
  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 1) return l10n.justNow;
  if (diff.inMinutes < 60) return l10n.minutesAgo(diff.inMinutes);
  if (diff.inHours < 24) return l10n.hoursAgo(diff.inHours);
  if (diff.inDays < 30) return l10n.daysAgo(diff.inDays);
  return '${date.day}/${date.month}/${date.year}';
}

String _describe(SocialProfileActivity activity, AppLocalizations l10n) {
  final data = activity.eventData;
  switch (activity.eventType) {
    case 'level_up':
      return l10n.activityLevelUp('${data['new_level'] ?? data['level'] ?? '?'}');
    case 'streak_milestone':
      return l10n.activityStreakMilestone('${data['streak'] ?? '?'}');
    case 'achievement_unlocked':
      return '${data['name'] ?? l10n.activityAchievementUnlockedFallback}';
    case 'mission_completed':
      return '${data['title'] ?? l10n.activityMissionFallback}';
    case 'exam_high_score':
      return '${data['score'] ?? '?'}% - ${data['exam_name'] ?? l10n.activityExamFallback}';
    case 'game_completed':
      final game = _gameNames['${data['game']}'] ?? '${data['game']}';
      return '$game (${data['correct'] ?? '?'}/${data['total'] ?? '?'})';
    case 'daily_review_completed':
      return l10n.activityDailyReview('${data['correct'] ?? '?'}', '${data['total'] ?? '?'}');
    case 'vocabulary_learned':
      return l10n.activityVocabLearned('${data['count'] ?? '?'}');
    case 'video_completed':
      return '${data['title'] ?? l10n.activityVideoFallback}';
    default:
      return activity.eventType;
  }
}

/// Web parity: `components/profile/profile-activity-timeline.tsx` — recent
/// gamification/activity-feed events with emoji + relative time. Hidden
/// entirely when empty (matches web `if (activities.length === 0) return null`).
class ProfileActivityTimeline extends StatelessWidget {
  const ProfileActivityTimeline({super.key, required this.activities});

  final List<SocialProfileActivity> activities;

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) return const SizedBox.shrink();
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);

    return AppCard.card(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.socialActivityTimelineTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: tokens.foreground,
            ),
          ),
          const SizedBox(height: 10),
          ...activities.map(
            (act) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _eventIcons[act.eventType] ?? '📌',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _describe(act, l10n),
                          style: TextStyle(fontSize: 13, color: tokens.foreground),
                        ),
                        Text(
                          _relativeTime(act.createdAt, l10n),
                          style: TextStyle(
                            fontSize: 10,
                            color: tokens.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
