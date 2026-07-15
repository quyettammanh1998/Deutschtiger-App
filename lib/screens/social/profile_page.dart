import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:deutschtiger/core/theme/app_colors.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/social/friends_provider.dart';
import 'package:deutschtiger/view_models/social/public_profile_provider.dart';

/// Public user profile — `GET /api/v1/profiles/{userId}`
/// (`internal/feature/user/profile/profile_handler.go`). Mobile equivalent
/// of the web `/u/:id` route. Surfaces friend-request/block actions so
/// every user-user surface has a block entry point.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(publicProfileProvider(userId));
    final statusAsync = ref.watch(friendshipWithUserProvider(userId));

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: Text(l10n.socialProfileTitle),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'report') {
                await _openReportEmail(context, userId);
              } else if (value == 'block') {
                await _confirmAndBlock(context, ref, l10n, userId);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'report', child: Text(l10n.socialReportUser)),
              PopupMenuItem(
                value: 'block',
                child: Text(
                  l10n.socialBlockUser,
                  style: const TextStyle(color: AppColors.destructive),
                ),
              ),
            ],
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.socialLoadProfileError)),
        data: (profile) {
          final status = statusAsync.valueOrNull?.status ?? 'none';
          if (status == 'blocked') {
            return Center(child: Text(l10n.socialUserBlockedNotice));
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.muted,
                  backgroundImage: profile.avatarUrl != null
                      ? NetworkImage(profile.avatarUrl!)
                      : null,
                  child: profile.avatarUrl == null
                      ? Text(
                          profile.displayName.isNotEmpty
                              ? profile.displayName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  profile.displayName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              if (profile.activeTitle != null)
                Center(
                  child: Text(
                    profile.activeTitle!,
                    style: TextStyle(color: AppColors.mutedForeground),
                  ),
                ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatChip(label: l10n.socialLevelShort, value: '${profile.level}'),
                  _StatChip(label: 'XP', value: '${profile.totalXp}'),
                  _StatChip(
                    label: l10n.socialStreakShort,
                    value: '${profile.currentStreak}',
                  ),
                  _StatChip(
                    label: l10n.socialFriendsShort,
                    value: '${profile.friendsCount}',
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildActionRow(context, ref, l10n, status),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionRow(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String status,
  ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push('/social/chat/$userId'),
            icon: const Icon(Icons.chat_bubble_outline),
            label: Text(l10n.socialChatAction),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildFriendButton(context, ref, l10n, status),
        ),
      ],
    );
  }

  Widget _buildFriendButton(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String status,
  ) {
    switch (status) {
      case 'accepted':
        return ElevatedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.check),
          label: Text(l10n.socialTabFriends),
        );
      case 'pending_sent':
      case 'pending':
        return ElevatedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.hourglass_empty),
          label: Text(l10n.socialRequestSent),
        );
      case 'pending_received':
        return ElevatedButton.icon(
          onPressed: () async {
            final req = await ref.read(pendingFriendRequestsProvider.future);
            final match = req.where((r) => r.requesterId == userId).toList();
            if (match.isNotEmpty) {
              await ref.read(friendsActionsProvider).acceptRequest(match.first.id);
              ref.invalidate(friendshipWithUserProvider(userId));
            }
          },
          icon: const Icon(Icons.check),
          label: Text(l10n.socialAccept),
        );
      default:
        return ElevatedButton.icon(
          onPressed: () async {
            await ref.read(friendsActionsProvider).sendRequest(userId);
            ref.invalidate(friendshipWithUserProvider(userId));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.tigerOrange,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.person_add),
          label: Text(l10n.socialAddFriend),
        );
    }
  }

  Future<void> _confirmAndBlock(
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
              style: const TextStyle(color: AppColors.destructive),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(friendsActionsProvider).blockUser(userId);
    if (context.mounted) {
      ref.invalidate(friendshipWithUserProvider(userId));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.socialUserBlocked)));
    }
  }

  /// No backend report endpoint exists yet (see `docs/api-changelog.md`), so
  /// this opens a pre-filled support email instead of a silent no-op.
  Future<void> _openReportEmail(BuildContext context, String userId) async {
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.couldNotOpenLink)));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.openLinkError)));
      }
    }
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
      ],
    );
  }
}
