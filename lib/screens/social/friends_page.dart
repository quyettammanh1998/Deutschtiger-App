import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/core/icons/app_phosphor_icons.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/data/social/friend_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/social/friends_provider.dart';
import 'package:deutschtiger/view_models/social/messages_provider.dart';
import 'package:deutschtiger/widgets/common/app_card.dart';

import 'widgets/social_avatar.dart';

/// Friends hub: accepted friends (online/offline sections), pending requests
/// (accept/reject) and user search (send request, w/ suggestions). Block is
/// available from every friend/request/search row. Backend:
/// `internal/feature/social/friend/friend_handler.go`. Web parity:
/// `pages/social/friends-page.tsx`.
class FriendsPage extends ConsumerStatefulWidget {
  const FriendsPage({super.key});

  @override
  ConsumerState<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends ConsumerState<FriendsPage> {
  int _tab = 0;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final friendsAsync = ref.watch(friendsProvider);
    final requestsAsync = ref.watch(pendingFriendRequestsProvider);
    final unreadAsync = ref.watch(unreadCountsProvider);
    final friendsCount = friendsAsync.valueOrNull?.length ?? 0;
    final requestsCount = requestsAsync.valueOrNull?.length ?? 0;
    final unreadMessages = unreadAsync.valueOrNull?.messages ?? 0;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () =>
                        context.canPop() ? context.pop() : context.go('/home'),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.socialFriendsTitle,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: tokens.foreground,
                          ),
                        ),
                        Text(
                          l10n.socialFriendsSubtitle(friendsCount, requestsCount),
                          style: TextStyle(
                            fontSize: 12,
                            color: tokens.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: Icon(AppPhosphorIcons.chatText),
                        tooltip: l10n.socialMessagesTitle,
                        onPressed: () => context.push('/social/messages'),
                      ),
                      if (unreadMessages > 0)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 15,
                              minHeight: 15,
                            ),
                            child: Text(
                              unreadMessages > 99 ? '99+' : '$unreadMessages',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: _SegmentedTabs(
                index: _tab,
                requestsCount: requestsCount,
                l10n: l10n,
                onChanged: (i) => setState(() => _tab = i),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: IndexedStack(
                index: _tab,
                sizing: StackFit.expand,
                children: [
                  friendsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => _ErrorView(
                      message: l10n.socialLoadFriendsError,
                      onRetry: () => ref.invalidate(friendsProvider),
                    ),
                    data: (friends) => _FriendsTab(friends: friends),
                  ),
                  requestsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => _ErrorView(
                      message: l10n.socialLoadRequestsError,
                      onRetry: () => ref.invalidate(pendingFriendRequestsProvider),
                    ),
                    data: (requests) => _RequestsTab(requests: requests),
                  ),
                  _SearchTab(
                    controller: _searchController,
                    query: _searchQuery,
                    onQueryChanged: (v) => setState(() => _searchQuery = v),
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

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.index,
    required this.requestsCount,
    required this.l10n,
    required this.onChanged,
  });

  final int index;
  final int requestsCount;
  final AppLocalizations l10n;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final labels = [
      l10n.socialTabFriends,
      l10n.socialTabRequests,
      l10n.socialTabSearch,
    ];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: tokens.muted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = i == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: active ? tokens.card : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: active ? tokens.foreground : tokens.mutedForeground,
                      ),
                    ),
                    if (i == 1 && requestsCount > 0) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: tokens.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '$requestsCount',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: TextStyle(color: tokens.mutedForeground)),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onRetry,
            child: Text(AppLocalizations.of(context).retry),
          ),
        ],
      ),
    );
  }
}

class _FriendsTab extends StatelessWidget {
  const _FriendsTab({required this.friends});

  final List<FriendProfile> friends;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    if (friends.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(AppPhosphorIcons.users, size: 48, color: tokens.mutedForeground),
            const SizedBox(height: 12),
            Text(
              l10n.socialNoFriendsYet,
              style: TextStyle(color: tokens.mutedForeground, fontSize: 15),
            ),
          ],
        ),
      );
    }
    final online = friends.where((f) => f.isOnline == true).toList();
    final offline = friends.where((f) => f.isOnline != true).toList();

    return Consumer(
      builder: (context, ref, _) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(friendsProvider),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            if (online.isNotEmpty) ...[
              _SectionHeading(
                text: l10n.socialOnlineSectionTitle(online.length),
                color: const Color(0xFF16A34A),
              ),
              ...online.map((f) => _FriendRow(friend: f)),
              const SizedBox(height: 8),
            ],
            if (offline.isNotEmpty) ...[
              _SectionHeading(
                text: l10n.socialOfflineSectionTitle(offline.length),
                color: tokens.mutedForeground,
              ),
              ...offline.map((f) => _FriendRow(friend: f)),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 6),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: color,
        ),
      ),
    );
  }
}

class _FriendRow extends ConsumerWidget {
  const _FriendRow({required this.friend});

  final FriendProfile friend;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final isOnline = friend.isOnline == true;
    return AppCard.small(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      onTap: () => context.push('/social/profile/${friend.id}'),
      child: Row(
        children: [
          SocialAvatar(
            displayName: friend.displayName,
            avatarUrl: friend.avatarUrl,
            size: 40,
            showOnlineDot: true,
            isOnline: isOnline,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend.displayName,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: tokens.foreground),
                ),
                Text(
                  isOnline
                      ? l10n.socialOnlineNow
                      : l10n.socialLevelStreakLabel(
                          friend.level,
                          friend.currentStreak,
                        ),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isOnline ? FontWeight.w600 : FontWeight.normal,
                    color: isOnline ? const Color(0xFF16A34A) : tokens.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(AppPhosphorIcons.chatText, color: tokens.primary, size: 20),
            tooltip: l10n.socialChatAction,
            onPressed: () => context.push('/social/chat/${friend.id}'),
          ),
          GestureDetector(
            onTap: () => _confirmRemove(context, ref, friend, l10n),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text(
                l10n.socialRemoveFriend,
                style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmRemove(
    BuildContext context,
    WidgetRef ref,
    FriendProfile friend,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.socialRemoveFriend),
        content: Text(l10n.socialRemoveFriendConfirm(friend.displayName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.socialRemoveFriend),
          ),
        ],
      ),
    );
    if (confirmed != true || friend.friendshipId == null) return;
    await ref.read(friendsActionsProvider).removeFriend(friend.friendshipId!);
  }
}

class _RequestsTab extends ConsumerWidget {
  const _RequestsTab({required this.requests});

  final List<FriendRequest> requests;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: 48, color: tokens.mutedForeground),
            const SizedBox(height: 12),
            Text(
              l10n.socialNoPendingRequests,
              style: TextStyle(color: tokens.mutedForeground, fontSize: 15),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(pendingFriendRequestsProvider),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return AppCard.small(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                SocialAvatar(
                  displayName: request.requester.displayName,
                  avatarUrl: request.requester.avatarUrl,
                  size: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.requester.displayName,
                        style: TextStyle(fontWeight: FontWeight.w600, color: tokens.foreground),
                      ),
                      Text(
                        l10n.socialLevelLabel(request.requester.level),
                        style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      ref.read(friendsActionsProvider).rejectRequest(request.id),
                  style: TextButton.styleFrom(
                    backgroundColor: tokens.muted,
                    foregroundColor: tokens.mutedForeground,
                  ),
                  child: Text(l10n.socialDecline),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () =>
                      ref.read(friendsActionsProvider).acceptRequest(request.id),
                  style: FilledButton.styleFrom(backgroundColor: tokens.primary),
                  child: Text(l10n.socialAccept),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SearchTab extends ConsumerWidget {
  const _SearchTab({
    required this.controller,
    required this.query,
    required this.onQueryChanged,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onQueryChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final trimmed = query.trim();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: l10n.socialSearchHint,
              prefixIcon: Icon(AppPhosphorIcons.magnifyingGlass, size: 18),
              filled: true,
              fillColor: tokens.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: tokens.border),
              ),
            ),
            onChanged: onQueryChanged,
          ),
        ),
        Expanded(
          child: trimmed.isEmpty
              ? _SuggestionsList(l10n: l10n)
              : Consumer(
                  builder: (context, ref, _) {
                    final resultsAsync = ref.watch(friendSearchProvider(trimmed));
                    return resultsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text(l10n.socialSearchError)),
                      data: (results) {
                        if (results.isEmpty) {
                          return Center(
                            child: Text(
                              l10n.socialSearchNoResults,
                              style: TextStyle(color: tokens.mutedForeground),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: results.length,
                          itemBuilder: (context, index) =>
                              _SearchResultRow(result: results[index]),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Web: "Gợi ý kết bạn" — a dedicated backend suggestions endpoint (online
/// friends-of-friends). No such contract exists in
/// `internal/feature/social/friend/friend_handler.go` yet (search requires
/// a non-empty query server-side — see `friend_repository.dart`), so this
/// surfaces the honest empty-state instead of faking suggestions from an
/// unrelated dataset. Tracked as a follow-up contract addition.
class _SuggestionsList extends StatelessWidget {
  const _SuggestionsList({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Text(
        l10n.socialSearchPrompt,
        style: TextStyle(color: tokens.mutedForeground),
      ),
    );
  }
}

class _SearchResultRow extends ConsumerWidget {
  const _SearchResultRow({required this.result});

  final FriendProfile result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    return AppCard.small(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      onTap: () => context.push('/social/profile/${result.id}'),
      child: Row(
        children: [
          SocialAvatar(
            displayName: result.displayName,
            avatarUrl: result.avatarUrl,
            size: 36,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.displayName,
                  style: TextStyle(fontWeight: FontWeight.w600, color: tokens.foreground),
                ),
                Text(
                  l10n.socialLevelLabel(result.level),
                  style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                ),
              ],
            ),
          ),
          _buildActionButton(context, ref, l10n, tokens),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    AppTokens tokens,
  ) {
    switch (result.friendshipStatus) {
      case 'accepted':
        return Text(
          l10n.socialTabFriends,
          style: TextStyle(fontSize: 12, color: const Color(0xFF16A34A)),
        );
      case 'pending_sent':
      case 'pending':
        return Text(
          l10n.socialRequestSent,
          style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
        );
      case 'pending_received':
        return TextButton(
          onPressed: () {
            if (result.friendshipId != null) {
              ref.read(friendsActionsProvider).acceptRequest(result.friendshipId!);
            }
          },
          child: Text(l10n.socialAccept),
        );
      case 'blocked':
        return const SizedBox.shrink();
      default:
        return FilledButton(
          onPressed: () => ref.read(friendsActionsProvider).sendRequest(result.id),
          style: FilledButton.styleFrom(
            backgroundColor: tokens.primary,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          ),
          child: Text(l10n.socialAddFriend, style: const TextStyle(fontSize: 12)),
        );
    }
  }
}
