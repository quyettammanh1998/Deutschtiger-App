import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/core/theme/app_colors.dart';
import 'package:deutschtiger/data/social/friend_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/social/friends_provider.dart';

/// Friends hub: accepted friends, pending requests (accept/reject) and user
/// search (send request). Block is available from every friend/request/
/// search row. Backend: `internal/feature/social/friend/friend_handler.go`.
class FriendsPage extends ConsumerStatefulWidget {
  const FriendsPage({super.key});

  @override
  ConsumerState<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends ConsumerState<FriendsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final friendsAsync = ref.watch(friendsProvider);
    final requestsAsync = ref.watch(pendingFriendRequestsProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: Text(
          l10n.socialFriendsTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: l10n.socialMessagesTitle,
            onPressed: () => context.push('/social/messages'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.mutedForeground,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.tigerOrange,
                borderRadius: BorderRadius.circular(12),
              ),
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: l10n.socialTabFriends),
                Tab(
                  text: requestsAsync.maybeWhen(
                    data: (r) => r.isEmpty
                        ? l10n.socialTabRequests
                        : '${l10n.socialTabRequests} (${r.length})',
                    orElse: () => l10n.socialTabRequests,
                  ),
                ),
                Tab(text: l10n.socialTabSearch),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
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
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: TextStyle(color: Colors.grey[600])),
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

class _FriendsTab extends ConsumerWidget {
  const _FriendsTab({required this.friends});

  final List<FriendProfile> friends;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (friends.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              l10n.socialNoFriendsYet,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(friendsProvider),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: friends.length,
        itemBuilder: (context, index) => _FriendCard(friend: friends[index]),
      ),
    );
  }
}

class _FriendCard extends ConsumerWidget {
  const _FriendCard({required this.friend});

  final FriendProfile friend;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isOnline = friend.isOnline ?? false;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/social/profile/${friend.id}'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: friend.avatarUrl.isNotEmpty
                        ? NetworkImage(friend.avatarUrl)
                        : null,
                    backgroundColor: AppColors.muted,
                    child: friend.avatarUrl.isEmpty
                        ? Text(
                            friend.displayName.isNotEmpty
                                ? friend.displayName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: isOnline ? AppColors.success : Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friend.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          size: 14,
                          color: Colors.orange[600],
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${friend.currentStreak}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.star, size: 14, color: Colors.amber[600]),
                        const SizedBox(width: 2),
                        Text(
                          '${friend.totalXp} XP',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chat, color: AppColors.primary),
                tooltip: l10n.socialChatAction,
                onPressed: () => context.push('/social/chat/${friend.id}'),
              ),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'block') {
                    await _confirmAndBlock(context, ref, friend);
                  } else if (value == 'remove') {
                    if (friend.friendshipId != null) {
                      await ref
                          .read(friendsActionsProvider)
                          .removeFriend(friend.friendshipId!);
                    }
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'remove',
                    child: Text(l10n.socialRemoveFriend),
                  ),
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
        ),
      ),
    );
  }
}

Future<void> _confirmAndBlock(
  BuildContext context,
  WidgetRef ref,
  FriendProfile friend,
) async {
  final l10n = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.socialBlockUser),
      content: Text(l10n.socialBlockUserConfirm(friend.displayName)),
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
  if (confirmed != true || !context.mounted) return;
  await ref.read(friendsActionsProvider).blockUser(friend.id);
  if (context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.socialUserBlocked)));
  }
}

class _RequestsTab extends ConsumerWidget {
  const _RequestsTab({required this.requests});

  final List<FriendRequest> requests;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              l10n.socialNoPendingRequests,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
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
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.muted,
                    backgroundImage: request.requester.avatarUrl.isNotEmpty
                        ? NetworkImage(request.requester.avatarUrl)
                        : null,
                    child: request.requester.avatarUrl.isEmpty
                        ? Text(
                            request.requester.displayName.isNotEmpty
                                ? request.requester.displayName[0]
                                : '?',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.requester.displayName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          l10n.socialLevelLabel(request.requester.level),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => ref
                        .read(friendsActionsProvider)
                        .rejectRequest(request.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.destructive,
                      side: const BorderSide(color: AppColors.destructive),
                    ),
                    child: Text(l10n.socialDecline),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => ref
                        .read(friendsActionsProvider)
                        .acceptRequest(request.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tigerOrange,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(l10n.socialAccept),
                  ),
                ],
              ),
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
    final trimmed = query.trim();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: l10n.socialSearchHint,
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: onQueryChanged,
          ),
        ),
        Expanded(
          child: trimmed.isEmpty
              ? Center(
                  child: Text(
                    l10n.socialSearchPrompt,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              : Consumer(
                  builder: (context, ref, _) {
                    final resultsAsync = ref.watch(
                      friendSearchProvider(trimmed),
                    );
                    return resultsAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) =>
                          Center(child: Text(l10n.socialSearchError)),
                      data: (results) {
                        if (results.isEmpty) {
                          return Center(
                            child: Text(
                              l10n.socialSearchNoResults,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: results.length,
                          itemBuilder: (context, index) =>
                              _SearchResultCard(result: results[index]),
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

class _SearchResultCard extends ConsumerWidget {
  const _SearchResultCard({required this.result});

  final FriendProfile result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: ListTile(
        onTap: () => context.push('/social/profile/${result.id}'),
        leading: CircleAvatar(
          backgroundColor: AppColors.muted,
          backgroundImage: result.avatarUrl.isNotEmpty
              ? NetworkImage(result.avatarUrl)
              : null,
          child: result.avatarUrl.isEmpty
              ? Text(
                  result.displayName.isNotEmpty
                      ? result.displayName[0].toUpperCase()
                      : '?',
                )
              : null,
        ),
        title: Text(result.displayName),
        subtitle: Text(l10n.socialLevelLabel(result.level)),
        trailing: _buildActionButton(context, ref, l10n, result),
      ),
    );
  }

  Widget? _buildActionButton(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    FriendProfile result,
  ) {
    switch (result.friendshipStatus) {
      case 'accepted':
        return Text(
          l10n.socialTabFriends,
          style: TextStyle(color: AppColors.mutedForeground),
        );
      case 'pending_sent':
      case 'pending':
        return Text(
          l10n.socialRequestSent,
          style: TextStyle(color: AppColors.mutedForeground),
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
        return null;
      default:
        return TextButton(
          onPressed: () =>
              ref.read(friendsActionsProvider).sendRequest(result.id),
          child: Text(l10n.socialAddFriend),
        );
    }
  }
}
