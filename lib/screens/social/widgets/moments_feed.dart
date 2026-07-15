import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/data/social/moment_models.dart';

/// Compact read-only moments feed used by the Social hub's Moments tab.
/// Full feed (with like + comments) lives at `/social/moments`.
class MomentsFeed extends StatelessWidget {
  const MomentsFeed({super.key, required this.moments});

  final List<Moment> moments;

  @override
  Widget build(BuildContext context) {
    if (moments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dynamic_feed, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No moments yet', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: moments.length,
      itemBuilder: (context, index) => _MomentCard(moment: moments[index]),
    );
  }
}

class _MomentCard extends StatelessWidget {
  const _MomentCard({required this.moment});

  final Moment moment;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: () => context.push('/social/profile/${moment.userId}'),
            leading: CircleAvatar(
              backgroundImage: moment.avatarUrl.isNotEmpty
                  ? NetworkImage(moment.avatarUrl)
                  : null,
              child: moment.avatarUrl.isEmpty
                  ? Text(moment.displayName.isNotEmpty ? moment.displayName[0].toUpperCase() : '?')
                  : null,
            ),
            title: Text(moment.displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(_formatTime(moment.createdAt)),
          ),
          if (moment.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(moment.content),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Icon(
                  moment.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: moment.isLiked ? Colors.red : null,
                ),
                const SizedBox(width: 4),
                Text('${moment.likeCount}'),
                const SizedBox(width: 16),
                const Icon(Icons.chat_bubble_outline),
                const SizedBox(width: 4),
                Text('${moment.commentCount}'),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}';
  }
}
