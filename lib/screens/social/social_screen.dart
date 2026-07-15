import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/core/theme/app_colors.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/screens/social/widgets/friends_list.dart';
import 'package:deutschtiger/screens/social/widgets/moments_feed.dart';
import 'package:deutschtiger/view_models/social/friends_provider.dart';
import 'package:deutschtiger/view_models/social/messages_provider.dart';
import 'package:deutschtiger/view_models/social/moments_provider.dart';

/// Social hub. Only the live surfaces (Moments feed, Friends) are tabs here;
/// Groups/Challenges/Duels stay gated (see `docs/flutter-live-data-inventory.md`)
/// and are not linked from this hub. Messages and Announcements are
/// entry-point actions in the app bar.
class SocialScreen extends ConsumerWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unreadAsync = ref.watch(unreadCountsProvider);
    final unreadMessages = unreadAsync.valueOrNull?.messages ?? 0;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.socialHubTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.socialTabMoments),
              Tab(text: l10n.socialTabFriends),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.campaign_outlined),
              tooltip: l10n.socialAnnouncementsTitle,
              onPressed: () => context.push('/social/announcements'),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  tooltip: l10n.socialMessagesTitle,
                  onPressed: () => context.push('/social/messages'),
                ),
                if (unreadMessages > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.tigerOrange,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        unreadMessages > 99 ? '99+' : '$unreadMessages',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 9),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        body: const TabBarView(
          children: [_MomentsTab(), _FriendsTab()],
        ),
      ),
    );
  }
}

class _MomentsTab extends ConsumerWidget {
  const _MomentsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final momentsAsync = ref.watch(momentsFeedProvider);
    return momentsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(AppLocalizations.of(context).socialLoadMomentsError)),
      data: (moments) => RefreshIndicator(
        onRefresh: () => ref.read(momentsFeedProvider.notifier).refresh(),
        child: MomentsFeed(moments: moments),
      ),
    );
  }
}

class _FriendsTab extends ConsumerWidget {
  const _FriendsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);
    return friendsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(AppLocalizations.of(context).socialLoadFriendsError)),
      data: (friends) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(friendsProvider),
        child: FriendsList(friends: friends),
      ),
    );
  }
}
