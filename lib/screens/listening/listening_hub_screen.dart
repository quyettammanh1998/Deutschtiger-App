import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import 'package:deutschtiger/view_models/listening/podcast_provider.dart';

/// Listening Hub — entry point cho các nguồn luyện nghe.
///
/// Phạm vi hiện tại chỉ có Easy German Podcast (live). Sprechen B1/B2 (video
/// YouTube) chưa được wire trong app này — điều hướng tới màn "sắp ra mắt".
class ListeningHubScreen extends ConsumerWidget {
  const ListeningHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexAsync = ref.watch(podcastIndexProvider);
    final completedAsync = ref.watch(podcastCompletedIdsProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  _buildStats(
                    total: indexAsync.maybeWhen(data: (v) => v.length, orElse: () => 0),
                    completed: completedAsync.maybeWhen(data: (v) => v.length, orElse: () => 0),
                  ),
                  const SizedBox(height: 16),
                  _SourceCard(
                    icon: Icons.podcasts,
                    title: 'Easy German Podcast',
                    subtitle: 'Podcast tiếng Đức đời thường — A2/B1',
                    gradient: const [AppColors.primary, AppColors.tigerOrange],
                    trailing: indexAsync.maybeWhen(
                      data: (episodes) => '${episodes.length} tập',
                      orElse: () => null,
                    ),
                    onTap: () => context.push('/listening/easy-german'),
                  ),
                  const SizedBox(height: 12),
                  _SourceCard(
                    icon: Icons.chat_bubble_outline,
                    title: 'Sprechen B1',
                    subtitle: 'Video luyện nghe — sắp ra mắt',
                    gradient: [Colors.orange.shade400, Colors.orange.shade600],
                    onTap: () => context.push('/listening/sprechen-b1'),
                  ),
                  const SizedBox(height: 12),
                  _SourceCard(
                    icon: Icons.work_outline,
                    title: 'Sprechen B2',
                    subtitle: 'Video luyện nghe — sắp ra mắt',
                    gradient: [Colors.red.shade400, Colors.red.shade600],
                    onTap: () => context.push('/listening/sprechen-b2'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.foreground),
              onPressed: () => context.pop(),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Luyện nghe',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
                Text(
                  'Podcast tiếng Đức',
                  style: TextStyle(fontSize: 13, color: AppColors.mutedForeground),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats({required int total, required int completed}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.tigerOrange.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatBadge(
            icon: Icons.headphones,
            value: '$completed',
            label: 'Đã nghe',
            color: Colors.blue,
          ),
          _StatBadge(
            icon: Icons.library_music,
            value: '$total',
            label: 'Tổng số tập',
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.foreground,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                Text(
                  trailing!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                const SizedBox(width: 8),
              ],
              const Icon(Icons.chevron_right, color: AppColors.mutedForeground),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.mutedForeground),
        ),
      ],
    );
  }
}
