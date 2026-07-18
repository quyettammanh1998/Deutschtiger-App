import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:deutschtiger/core/icons/app_phosphor_icons.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/providers.dart';
import 'package:deutschtiger/view_models/social/friends_provider.dart';
import 'package:deutschtiger/view_models/social/public_profile_provider.dart';
import 'package:deutschtiger/widgets/common/app_card.dart';

import 'widgets/profile_achievements_grid.dart';
import 'widgets/profile_activity_timeline.dart';
import 'widgets/profile_cover_header.dart';
import 'widgets/profile_learning_journey.dart';
import 'widgets/profile_stats_row.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const Map<String, String> _kActivityLabels = {
  'dashboard': 'Đang online',
  'learning': 'Đang học từ vựng',
  'practicing': 'Đang luyện tập',
  'playing_matching': 'Đang chơi Matching',
  'playing_cloze': 'Đang chơi Cloze',
  'playing_listening': 'Đang chơi Listening',
  'playing_writing': 'Đang chơi Writing',
  'playing_word_sprint': 'Đang chơi Word Sprint',
  'watching_youtube': 'Đang xem YouTube',
  'chatting': 'Đang nhắn tin',
  'reviewing_flashcards': 'Đang ôn Flashcard',
  'taking_exam': 'Đang làm bài thi',
  'in_call': 'Đang gọi điện',
};

/// Public user profile — `GET /api/v1/profiles/{userId}`
/// (`internal/feature/user/profile/profile_handler.go`). Web parity:
/// `pages/social/profile-page.tsx` (`/u/:id`). Also backs `/profile` (own
/// profile view) — see [ownUserId] handling below.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final profileAsync = ref.watch(publicProfileProvider(userId));
    final currentUserId = ref.watch(myProfileProvider).valueOrNull?.id;
    final isOwnProfile = currentUserId != null && currentUserId == userId;
    final statusAsync = isOwnProfile
        ? null
        : ref.watch(friendshipWithUserProvider(userId));

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(l10n.socialLoadProfileError)),
          data: (profile) {
            final status = statusAsync?.valueOrNull?.status ?? 'none';
            if (!isOwnProfile && status == 'blocked') {
              return _BlockedBody(l10n: l10n, tokens: tokens);
            }
            final achievements = computeProfileAchievements(
              l10n,
              level: profile.level,
              totalXp: profile.totalXp,
              longestStreak: profile.longestStreak,
              totalReviews: profile.totalReviews,
              flashcardCount: profile.totalFlashcards,
            );
            final joinedDate = _formatJoinedDate(profile.createdAt);
            final activityLabel = profile.currentActivity != null
                ? _kActivityLabels[profile.currentActivity]
                : null;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(PhosphorIcons.arrowLeft),
                      onPressed: () => context.canPop()
                          ? context.pop()
                          : context.go('/home'),
                    ),
                    Text(
                      l10n.socialProfileTitle,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: tokens.foreground,
                      ),
                    ),
                    const Spacer(),
                    if (!isOwnProfile)
                      PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'report') {
                            await _openReportEmail(context, userId);
                          } else if (value == 'block') {
                            await _confirmAndBlock(context, ref, l10n, userId);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'report',
                            child: Text(l10n.socialReportUser),
                          ),
                          PopupMenuItem(
                            value: 'block',
                            child: Text(
                              l10n.socialBlockUser,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ProfileCoverHeader(
                        displayName: profile.displayName,
                        avatarUrl: profile.avatarUrl,
                        activeTitle: profile.activeTitle,
                        isPremium: profile.isPremium,
                        isOnline: profile.isOnline,
                        activityLabel: activityLabel,
                        joinedDate: joinedDate,
                      ),
                      const SizedBox(height: 12),
                      _ActionsRow(
                        isOwnProfile: isOwnProfile,
                        userId: userId,
                        status: status,
                        l10n: l10n,
                        tokens: tokens,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: tokens.border),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: ProfileStatsRow(
                          level: profile.level,
                          totalXp: profile.totalXp,
                          currentStreak: profile.currentStreak,
                          longestStreak: profile.longestStreak,
                          friendsCount: profile.friendsCount,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ProfileLearningJourney(
                  cefrLevel: profile.cefrLevel,
                  weeklyRank: profile.weeklyRank,
                  wordsLearned: profile.wordsLearned,
                  totalReviews: profile.totalReviews,
                ),
                const SizedBox(height: 12),
                ProfileAchievementsGrid(achievements: achievements),
                const SizedBox(height: 12),
                ProfileActivityTimeline(activities: profile.recentActivities),
              ],
            );
          },
        ),
      ),
    );
  }

  static String _formatJoinedDate(String iso) {
    final date = DateTime.tryParse(iso);
    if (date == null) return iso;
    const months = [
      'tháng 1', 'tháng 2', 'tháng 3', 'tháng 4', 'tháng 5', 'tháng 6',
      'tháng 7', 'tháng 8', 'tháng 9', 'tháng 10', 'tháng 11', 'tháng 12',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  static Future<void> _confirmAndBlock(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String userId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.socialBlockUser),
        content: Text(l10n.socialBlockUserConfirmGeneric),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.socialBlockUser,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(friendsActionsProvider).blockUser(userId);
    if (context.mounted) {
      ref.invalidate(friendshipWithUserProvider(userId));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.socialUserBlocked)));
    }
  }

  /// No backend report endpoint exists yet (see `docs/api-changelog.md`), so
  /// this opens a pre-filled support email instead of a silent no-op.
  static Future<void> _openReportEmail(
    BuildContext context,
    String userId,
  ) async {
    final l10n = AppLocalizations.of(context);
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@deutschtiger.com',
      query: 'subject=${Uri.encodeComponent(l10n.socialReportEmailSubject(userId))}',
    );
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.couldNotOpenLink)));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.openLinkError)));
      }
    }
  }
}

class _BlockedBody extends StatelessWidget {
  const _BlockedBody({required this.l10n, required this.tokens});

  final AppLocalizations l10n;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        l10n.socialUserBlockedNotice,
        style: TextStyle(color: tokens.mutedForeground),
      ),
    );
  }
}

/// Web parity: own profile → "Cài đặt" pill; other profile → friend-action
/// button + "Nhắn tin".
class _ActionsRow extends ConsumerWidget {
  const _ActionsRow({
    required this.isOwnProfile,
    required this.userId,
    required this.status,
    required this.l10n,
    required this.tokens,
  });

  final bool isOwnProfile;
  final String userId;
  final String status;
  final AppLocalizations l10n;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isOwnProfile) {
      return Center(
        child: _PillButton(
          icon: AppPhosphorIcons.gearSix,
          label: l10n.settings,
          onTap: () => context.push('/settings'),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _FriendActionButton(userId: userId, status: status, l10n: l10n),
        const SizedBox(width: 8),
        _PillButton(
          icon: AppPhosphorIcons.chatText,
          label: l10n.socialChatAction,
          onTap: () => context.push('/social/chat/$userId'),
        ),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.gradient = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool gradient;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: gradient
                ? const LinearGradient(
                    colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                  )
                : null,
            color: gradient ? null : tokens.card,
            border: gradient ? null : Border.all(color: tokens.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: gradient ? Colors.white : tokens.primary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: gradient ? Colors.white : tokens.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FriendActionButton extends ConsumerWidget {
  const _FriendActionButton({
    required this.userId,
    required this.status,
    required this.l10n,
  });

  final String userId;
  final String status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    switch (status) {
      case 'accepted':
        return _PillButton(
          icon: PhosphorIcons.userMinus,
          label: l10n.socialRemoveFriend,
          onTap: () async {
            final friends = await ref.read(friendsProvider.future);
            final match = friends.where((f) => f.id == userId).toList();
            if (match.isNotEmpty && match.first.friendshipId != null) {
              await ref
                  .read(friendsActionsProvider)
                  .removeFriend(match.first.friendshipId!);
              ref.invalidate(friendshipWithUserProvider(userId));
            }
          },
        );
      case 'pending_sent':
      case 'pending':
        return _StaticPill(label: l10n.socialRequestSent, tokens: tokens);
      case 'pending_received':
        return _PillButton(
          icon: PhosphorIcons.check,
          label: l10n.socialAccept,
          onTap: () async {
            final req = await ref.read(pendingFriendRequestsProvider.future);
            final match = req.where((r) => r.requesterId == userId).toList();
            if (match.isNotEmpty) {
              await ref
                  .read(friendsActionsProvider)
                  .acceptRequest(match.first.id);
              ref.invalidate(friendshipWithUserProvider(userId));
            }
          },
        );
      case 'blocked':
        return const SizedBox.shrink();
      default:
        return _PillButton(
          icon: PhosphorIcons.userPlus,
          label: l10n.socialAddFriend,
          gradient: true,
          onTap: () async {
            await ref.read(friendsActionsProvider).sendRequest(userId);
            ref.invalidate(friendshipWithUserProvider(userId));
          },
        );
    }
  }
}

class _StaticPill extends StatelessWidget {
  const _StaticPill({required this.label, required this.tokens});

  final String label;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: tokens.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
      ),
    );
  }
}

/// `/profile` — renders the caller's own public-profile view (web reuses
/// `/u/:id`; Flutter keeps a dedicated `/profile` nav-tab path per
/// `plan.md` §Quyết định 3(e)). Resolves the current user id from
/// [myProfileProvider] before delegating to [ProfilePage].
class OwnProfilePage extends ConsumerWidget {
  const OwnProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(myProfileProvider);
    return profileAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        body: Center(
          child: Text(AppLocalizations.of(context).couldNotLoadProfile),
        ),
      ),
      data: (user) => ProfilePage(userId: user.id),
    );
  }
}
