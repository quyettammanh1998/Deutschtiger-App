import 'package:flutter/material.dart';
import 'package:deutschtiger/features/social/domain/social_models.dart';

class MomentsFeed extends StatelessWidget {
  final List<SocialMoment> moments;

  const MomentsFeed({super.key, required this.moments});

  @override
  Widget build(BuildContext context) {
    if (moments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dynamic_feed, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No moments yet',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to share!',
              style: TextStyle(color: Colors.grey[500]),
            ),
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
  final SocialMoment moment;

  const _MomentCard({required this.moment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: moment.userAvatar.isNotEmpty
                  ? NetworkImage(moment.userAvatar)
                  : null,
              child: moment.userAvatar.isEmpty
                  ? Text(moment.username[0].toUpperCase())
                  : null,
            ),
            title: Text(
              moment.username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(_formatTime(moment.createdAt)),
            trailing: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {},
            ),
          ),
          if (moment.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(moment.content),
            ),
          if (moment.imageUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  moment.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    moment.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: moment.isLiked ? Colors.red : null,
                  ),
                  onPressed: () {},
                ),
                Text('${moment.likes}'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {},
                ),
                Text('${moment.comments}'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}';
  }
}
