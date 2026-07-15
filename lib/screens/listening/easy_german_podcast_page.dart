import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import 'package:deutschtiger/data/listening/podcast_models.dart';
import 'package:deutschtiger/view_models/listening/podcast_provider.dart';

/// Easy German Podcast Episode Index Page — danh sách toàn bộ tập, bind vào
/// index tĩnh + trạng thái hoàn thành từ backend.
class EasyGermanPodcastPage extends ConsumerStatefulWidget {
  const EasyGermanPodcastPage({super.key});

  @override
  ConsumerState<EasyGermanPodcastPage> createState() => _EasyGermanPodcastPageState();
}

class _EasyGermanPodcastPageState extends ConsumerState<EasyGermanPodcastPage> {
  String _searchQuery = '';
  String _filterCompleted = 'all'; // all, completed, in-progress

  @override
  Widget build(BuildContext context) {
    final indexAsync = ref.watch(podcastIndexProvider);
    final completedAsync = ref.watch(podcastCompletedIdsProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearchBar(),
            _buildFilterChips(),
            Expanded(
              child: indexAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => _buildError(),
                data: (episodes) {
                  final completed = completedAsync.maybeWhen(
                    data: (ids) => ids.toSet(),
                    orElse: () => <String>{},
                  );
                  return _buildEpisodeList(episodes, completed);
                },
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Easy German Podcast',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
                Text(
                  'Podcast tiếng Đức dễ - A2/B1',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
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
        child: TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'Tìm tập...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _searchQuery = ''),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          _FilterChip(
            label: 'Tất cả',
            isSelected: _filterCompleted == 'all',
            onTap: () => setState(() => _filterCompleted = 'all'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Đã nghe',
            isSelected: _filterCompleted == 'completed',
            onTap: () => setState(() => _filterCompleted = 'completed'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Chưa nghe',
            isSelected: _filterCompleted == 'in-progress',
            onTap: () => setState(() => _filterCompleted = 'in-progress'),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Không thể tải danh sách tập. Vui lòng thử lại sau.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => ref.invalidate(podcastIndexProvider),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodeList(List<PodcastEpisode> allEpisodes, Set<String> completedIds) {
    var episodes = allEpisodes;

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      episodes = episodes.where((e) => e.title.toLowerCase().contains(q)).toList();
    }

    if (_filterCompleted == 'completed') {
      episodes = episodes.where((e) => completedIds.contains(e.slug)).toList();
    } else if (_filterCompleted == 'in-progress') {
      episodes = episodes.where((e) => !completedIds.contains(e.slug)).toList();
    }

    if (episodes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Không tìm thấy tập nào',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        final episode = episodes[index];
        return _EpisodeCard(
          index: allEpisodes.indexOf(episode),
          episode: episode,
          completed: completedIds.contains(episode.slug),
          onTap: () => context.push('/listening/easy-german/episode/${episode.slug}'),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}

class _EpisodeCard extends StatelessWidget {
  const _EpisodeCard({
    required this.index,
    required this.episode,
    required this.completed,
    required this.onTap,
  });

  final int index;
  final PodcastEpisode episode;
  final bool completed;
  final VoidCallback onTap;

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.2),
                      AppColors.tigerOrange.withValues(alpha: 0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: completed
                      ? const Icon(Icons.check_circle, color: AppColors.success, size: 24)
                      : Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.tigerOrange,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      episode.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.timer, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          _formatDuration(episode.duration),
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.short_text, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          '${episode.segments} câu',
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.tigerOrange],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
