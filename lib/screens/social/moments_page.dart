import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/core/theme/app_colors.dart';
import 'package:deutschtiger/data/social/moment_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/social/moments_provider.dart';

/// Moments feed — read + like only (`GET /moments/feed`,
/// `POST/DELETE /user/moments/{id}/like`). Comment list is read-only;
/// there is no compose UI for moments/comments in this phase (public UGC
/// write needs moderation first — see phase-03 spec).
class MomentsPage extends ConsumerWidget {
  const MomentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final feedAsync = ref.watch(momentsFeedProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: Text(
          l10n.socialMomentsTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.tigerOrange,
            fontSize: 18,
          ),
        ),
      ),
      body: feedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.socialLoadMomentsError)),
        data: (moments) {
          if (moments.isEmpty) {
            return _buildEmptyState(l10n);
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(momentsFeedProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: moments.length,
              itemBuilder: (context, index) => _MomentCard(
                moment: moments[index],
                onLike: () =>
                    ref.read(momentsFeedProvider.notifier).toggleLike(moments[index]),
                onOpenComments: () =>
                    _showComments(context, moments[index].id),
                onOpenProfile: () =>
                    context.push('/social/profile/${moments[index].userId}'),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dynamic_feed, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            l10n.socialNoMomentsYet,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _showComments(BuildContext context, String momentId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _CommentsSheet(momentId: momentId),
    );
  }
}

class _MomentCard extends StatelessWidget {
  const _MomentCard({
    required this.moment,
    required this.onLike,
    required this.onOpenComments,
    required this.onOpenProfile,
  });

  final Moment moment;
  final VoidCallback onLike;
  final VoidCallback onOpenComments;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: onOpenProfile,
            leading: CircleAvatar(
              backgroundImage: moment.avatarUrl.isNotEmpty
                  ? NetworkImage(moment.avatarUrl)
                  : null,
              backgroundColor: AppColors.muted,
              child: moment.avatarUrl.isEmpty
                  ? Text(
                      moment.displayName.isNotEmpty
                          ? moment.displayName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            title: Text(
              moment.displayName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              _formatTime(moment.createdAt),
              style: TextStyle(fontSize: 12, color: AppColors.mutedForeground),
            ),
          ),
          if (moment.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(moment.content, style: const TextStyle(fontSize: 14)),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    moment.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: moment.isLiked ? Colors.red : null,
                  ),
                  onPressed: onLike,
                ),
                Text('${moment.likeCount}', style: const TextStyle(fontSize: 13)),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: onOpenComments,
                ),
                Text('${moment.commentCount}', style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${time.day}/${time.month}';
  }
}

class _CommentsSheet extends ConsumerWidget {
  const _CommentsSheet({required this.momentId});

  final String momentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final commentsAsync = ref.watch(momentCommentsProvider(momentId));
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.socialCommentsTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: commentsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(l10n.socialLoadCommentsError)),
              data: (comments) {
                if (comments.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.socialNoCommentsYet,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  );
                }
                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final c = comments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: c.avatarUrl.isNotEmpty
                            ? NetworkImage(c.avatarUrl)
                            : null,
                        child: c.avatarUrl.isEmpty
                            ? Text(c.displayName.isNotEmpty ? c.displayName[0] : '?')
                            : null,
                      ),
                      title: Text(c.displayName),
                      subtitle: Text(c.content),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
