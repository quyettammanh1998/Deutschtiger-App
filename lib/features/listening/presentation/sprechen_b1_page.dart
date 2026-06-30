import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/podcast_models.dart';
import 'podcast_provider.dart';

/// Sprechen B1 Page - Lists 145 B1 video lessons.
class SprechenB1Page extends ConsumerStatefulWidget {
  const SprechenB1Page({super.key});

  @override
  ConsumerState<SprechenB1Page> createState() => _SprechenB1PageState();
}

class _SprechenB1PageState extends ConsumerState<SprechenB1Page> {
  String _searchQuery = '';
  String _filterCompleted = 'all';
  bool _showOnlyIncomplete = false;

  @override
  Widget build(BuildContext context) {
    final seriesAsync = ref.watch(podcastSeriesProvider);

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildFilterChips(),
            Expanded(
              child: seriesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (series) {
                  final sprechenB1 = series.firstWhere(
                    (s) => s.id == 'sprechen-b1',
                    orElse: () => const PodcastSeries(
                      id: 'sprechen-b1',
                      title: 'Sprechen Deutsch B1',
                      titleVi: 'Giao Tiếp Tiếng Đức B1',
                      totalEpisodes: 0,
                      episodes: [],
                    ),
                  );
                  return _buildLessonList(sprechenB1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
                  'Sprechen Deutsch B1',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'B1',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '145 bài học',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.tigerOrange],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white),
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
            hintText: 'Tìm bài học...',
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
            label: 'Đã học',
            isSelected: _filterCompleted == 'completed',
            onTap: () => setState(() => _filterCompleted = 'completed'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Chưa học',
            isSelected: _filterCompleted == 'in-progress',
            onTap: () => setState(() => _filterCompleted = 'in-progress'),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonList(PodcastSeries series) {
    // Generate 145 B1 lessons
    final lessons = _generateB1Lessons();

    var filteredLessons = lessons;

    if (_searchQuery.isNotEmpty) {
      filteredLessons = filteredLessons
          .where((l) =>
              l['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              l['titleVi']!.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_filterCompleted == 'completed') {
      filteredLessons = filteredLessons.where((l) => l['completed'] == true).toList();
    } else if (_filterCompleted == 'in-progress') {
      filteredLessons = filteredLessons.where((l) => l['completed'] == false).toList();
    }

    if (filteredLessons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Không tìm thấy bài học',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: filteredLessons.length,
      itemBuilder: (context, index) {
        final lesson = filteredLessons[index];
        return _LessonCard(
          lessonNumber: lesson['number'] as int,
          title: lesson['title'] as String,
          titleVi: lesson['titleVi'] as String,
          isCompleted: lesson['completed'] as bool,
          onTap: () {
            context.push(
              '/listening/easy-german/episode/eg-ep-${lesson['number']}',
              extra: {
                'seriesId': 'sprechen-b1',
                'episode': PodcastEpisode(
                  id: 'sprechen-b1-${lesson['number']}',
                  seriesId: 'sprechen-b1',
                  episodeNumber: lesson['number'].toString(),
                  title: lesson['title'] as String,
                  titleVi: lesson['titleVi'] as String,
                  durationSeconds: 1200,
                  isCompleted: lesson['completed'] as bool,
                ),
              },
            );
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> _generateB1Lessons() {
    final topics = [
      {'title': 'At the Airport', 'titleVi': 'Ở sân bay'},
      {'title': 'Job Interview', 'titleVi': 'Phỏng vấn xin việc'},
      {'title': 'Making Reservations', 'titleVi': 'Đặt chỗ'},
      {'title': 'At the Doctor', 'titleVi': 'Ở bác sĩ'},
      {'title': 'Weather Discussion', 'titleVi': 'Thảo luận về thời tiết'},
      {'title': 'Travel Plans', 'titleVi': 'Kế hoạch du lịch'},
      {'title': 'Shopping Experience', 'titleVi': 'Kinh nghiệm mua sắm'},
      {'title': 'At the Restaurant', 'titleVi': 'Ở nhà hàng'},
      {'title': 'Public Transport', 'titleVi': 'Giao thông công cộng'},
      {'title': 'Renting an Apartment', 'titleVi': 'Thuê căn hộ'},
      {'title': 'Banking Services', 'titleVi': 'Dịch vụ ngân hàng'},
      {'title': 'Health and Fitness', 'titleVi': 'Sức khỏe và thể hình'},
      {'title': 'Education System', 'titleVi': 'Hệ thống giáo dục'},
      {'title': 'Career Development', 'titleVi': 'Phát triển sự nghiệp'},
      {'title': 'Cultural Events', 'titleVi': 'Sự kiện văn hóa'},
    ];

    return List.generate(145, (i) {
      final topicIndex = i % topics.length;
      final lessonNum = i + 1;
      return {
        'number': lessonNum,
        'title': 'Lesson $lessonNum: ${topics[topicIndex]['title']}',
        'titleVi': 'Bài $lessonNum: ${topics[topicIndex]['titleVi']}',
        'completed': lessonNum <= 25,
      };
    });
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

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
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
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

class _LessonCard extends StatelessWidget {
  const _LessonCard({
    required this.lessonNumber,
    required this.title,
    required this.titleVi,
    required this.isCompleted,
    required this.onTap,
  });

  final int lessonNumber;
  final String title;
  final String titleVi;
  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lesson number
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.withValues(alpha: 0.2),
                          Colors.orange.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '$lessonNumber',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Title
                  Text(
                    titleVi,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.foreground,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Completion badge
            if (isCompleted)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
