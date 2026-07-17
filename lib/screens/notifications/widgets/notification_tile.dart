import 'package:flutter/material.dart';

import '../../../core/design_tokens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/notifications/notification_models.dart';
import '../../../l10n/app_localizations.dart';

/// One row in the notification center. Title text mirrors the web
/// `getNotificationText` mapping (`components/social/notification-list.tsx`)
/// plus the extra types the backend push summarizer knows about
/// (`summarizeNotification` in `internal/shared/notification`).
class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final AppNotification notification;
  final VoidCallback onTap;

  String _title(AppLocalizations l10n) {
    final data = notification.data;
    String str(String key) => data[key] as String? ?? '';
    switch (notification.type) {
      case 'friend_request':
        return l10n.notificationFriendRequest(
          str('requester_name').isEmpty ? l10n.notificationSomeone : str('requester_name'),
        );
      case 'friend_accepted':
        return l10n.notificationFriendAccepted(
          str('accepter_name').isEmpty ? l10n.notificationSomeone : str('accepter_name'),
        );
      case 'challenge_invite':
        return l10n.notificationChallengeInvite(
          str('challenger_name').isEmpty ? l10n.notificationSomeone : str('challenger_name'),
        );
      case 'comment_reply':
        return str('preview').isEmpty ? l10n.notificationNewComment : str('preview');
      case 'grading_done':
        return l10n.notificationGradingDone;
      case 'daily_review':
        return l10n.notificationDailyReview;
      default:
        return str('message').isEmpty ? l10n.notificationGeneric : str('message');
    }
  }

  String _timeAgo(AppLocalizations l10n) {
    final diff = DateTime.now().difference(notification.createdAt);
    if (diff.inMinutes < 1) return l10n.justNow;
    if (diff.inMinutes < 60) return l10n.minutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.hoursAgo(diff.inHours);
    return l10n.daysAgo(diff.inDays);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isRead = notification.isRead;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isRead ? null : DesignTokens.tigerOrange.withValues(alpha: 0.05),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingMd,
          vertical: DesignTokens.spacingSm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isRead ? Colors.transparent : DesignTokens.tigerOrange,
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_title(l10n), style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 2),
                  Text(
                    _timeAgo(l10n),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.tokens.mutedForeground,
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
