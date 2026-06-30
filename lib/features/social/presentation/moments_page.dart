import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/social_models.dart';
import '../presentation/social_provider.dart';

class MomentsPage extends ConsumerStatefulWidget {
  const MomentsPage({super.key});

  @override
  ConsumerState<MomentsPage> createState() => _MomentsPageState();
}

class _MomentsPageState extends ConsumerState<MomentsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(socialNotifierProvider.notifier).loadMoments());
  }

  @override
  Widget build(BuildContext context) {
    final socialState = ref.watch(socialNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        title: const Text(
          'Moments',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.tigerOrange, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: socialState.isLoading && socialState.moments.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : socialState.error != null && socialState.moments.isEmpty
              ? Center(child: Text('Error: ${socialState.error}'))
              : socialState.moments.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: () => ref.read(socialNotifierProvider.notifier).loadMoments(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: socialState.moments.length,
                        itemBuilder: (context, index) => _MomentCard(
                          moment: socialState.moments[index],
                          onLike: () => ref.read(socialNotifierProvider.notifier).likeMoment(
                                socialState.moments[index].id,
                              ),
                        ),
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.tigerOrange,
        onPressed: () => _showCreateMomentSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
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

  void _showCreateMomentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _CreateMomentSheet(),
    );
  }
}

class _MomentCard extends StatelessWidget {
  final SocialMoment moment;
  final VoidCallback onLike;

  const _MomentCard({required this.moment, required this.onLike});

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
            leading: CircleAvatar(
              backgroundImage: moment.userAvatar.isNotEmpty
                  ? NetworkImage(moment.userAvatar)
                  : null,
              backgroundColor: AppColors.muted,
              child: moment.userAvatar.isEmpty
                  ? Text(moment.username[0].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold))
                  : null,
            ),
            title: Text(
              moment.username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(_formatTime(moment.createdAt), style: TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
            trailing: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {},
            ),
          ),
          if (moment.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(moment.content, style: const TextStyle(fontSize: 14)),
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
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: AppColors.muted,
                    child: const Center(child: Icon(Icons.image, size: 48, color: AppColors.mutedForeground)),
                  ),
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
                  onPressed: onLike,
                ),
                Text('${moment.likes}', style: const TextStyle(fontSize: 13)),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {},
                ),
                Text('${moment.comments}', style: const TextStyle(fontSize: 13)),
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

class _CreateMomentSheet extends ConsumerStatefulWidget {
  const _CreateMomentSheet();

  @override
  ConsumerState<_CreateMomentSheet> createState() => _CreateMomentSheetState();
}

class _CreateMomentSheetState extends ConsumerState<_CreateMomentSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Share your progress',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'What did you learn today?',
              hintStyle: TextStyle(color: AppColors.mutedForeground),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.tigerOrange),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.emoji_emotions),
                onPressed: () {},
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    ref.read(socialNotifierProvider.notifier).createMoment(_controller.text);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tigerOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Post'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
