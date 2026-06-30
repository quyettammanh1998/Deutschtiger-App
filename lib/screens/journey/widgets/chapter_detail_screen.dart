import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/journey_models.dart';
import '../journey_provider.dart';

class ChapterDetailScreen extends ConsumerWidget {
  final String chapterId;

  const ChapterDetailScreen({super.key, required this.chapterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapterAsync = ref.watch(journeyChapterProvider(chapterId));
    final itemsAsync = ref.watch(learningItemsProvider(chapterId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: chapterAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (chapter) => _ChapterContent(
          chapter: chapter,
          itemsAsync: itemsAsync,
        ),
      ),
    );
  }
}

class _ChapterContent extends StatelessWidget {
  final JourneyChapter chapter;
  final AsyncValue<List<LearningItem>> itemsAsync;

  const _ChapterContent({required this.chapter, required this.itemsAsync});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Custom app bar with gradient
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: AppColors.tigerOrange,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.tigerOrange, AppColors.rose600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          chapter.level,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        chapter.titleVi,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        chapter.descriptionVi,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark_border, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        // Stats row
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatColumn(
                  icon: Icons.book_outlined,
                  value: '${chapter.totalLessons}',
                  label: 'Lessons',
                ),
                _StatColumn(
                  icon: Icons.check_circle_outline,
                  value: '${chapter.completedLessons}',
                  label: 'Completed',
                ),
                _StatColumn(
                  icon: Icons.local_fire_department,
                  value: '${(chapter.progressPercent).toStringAsFixed(0)}%',
                  label: 'Progress',
                ),
              ],
            ),
          ),
        ),
        // Continue Learning button
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _ContinueLearningButton(chapter: chapter),
          ),
        ),
        // Lessons header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Lessons',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.grid_view, size: 18),
                  label: const Text('Grid'),
                ),
              ],
            ),
          ),
        ),
        // Lessons list
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _LessonTile(
                lesson: chapter.lessons[index],
                onTap: () {
                  context.push('/journey/chapter/${chapter.id}/lesson/${chapter.lessons[index].id}');
                },
              ),
              childCount: chapter.lessons.length.clamp(0, 10),
            ),
          ),
        ),
        // Vocabulary section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Vocabulary Preview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.push('/journey/browse'),
                  child: const Text('See All'),
                ),
              ],
            ),
          ),
        ),
        // Vocabulary items
        SliverToBoxAdapter(
          child: itemsAsync.when(
            loading: () => const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox.shrink(),
            data: (items) => _VocabularyPreview(items: items.take(8).toList()),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatColumn({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.tigerOrange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.tigerOrange, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.foreground,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class _ContinueLearningButton extends StatelessWidget {
  final JourneyChapter chapter;

  const _ContinueLearningButton({required this.chapter});

  @override
  Widget build(BuildContext context) {
    final nextLesson = chapter.lessons.firstWhere(
      (l) => !l.isCompleted && !l.isLocked,
      orElse: () => chapter.lessons.isNotEmpty ? chapter.lessons.first : JourneyLesson(
        id: '',
        chapterId: chapter.id,
        title: '',
        titleVi: '',
      ),
    );
    final hasNextLesson = nextLesson.id.isNotEmpty;

    return GestureDetector(
      onTap: hasNextLesson
          ? () => context.push('/journey/chapter/${chapter.id}/lesson/${nextLesson.id}')
          : null,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.tigerOrange, AppColors.rose600],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.tigerOrange.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                hasNextLesson ? Icons.play_arrow : Icons.check_circle,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasNextLesson ? 'Continue Learning' : 'Chapter Complete!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  if (hasNextLesson) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Next: ${nextLesson.titleVi}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  final JourneyLesson lesson;
  final VoidCallback? onTap;

  const _LessonTile({required this.lesson, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getTypeColor(lesson.type).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(_getTypeIcon(lesson.type), color: _getTypeColor(lesson.type)),
        ),
        title: Text(lesson.titleVi),
        subtitle: Row(
          children: [
            Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text('${lesson.durationMinutes} min', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(width: 12),
            Icon(Icons.star, size: 14, color: Colors.amber[600]),
            const SizedBox(width: 4),
            Text('+${lesson.xpReward} XP', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        trailing: lesson.isCompleted
            ? const Icon(Icons.check_circle, color: AppColors.success)
            : lesson.isLocked
                ? const Icon(Icons.lock, color: Colors.grey)
                : const Icon(Icons.play_arrow),
        onTap: lesson.isLocked ? null : onTap,
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'vocabulary':
        return AppColors.primary;
      case 'grammar':
        return Colors.purple;
      case 'dialogue':
        return Colors.orange;
      case 'exercise':
        return AppColors.success;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'vocabulary':
        return Icons.book;
      case 'grammar':
        return Icons.article;
      case 'dialogue':
        return Icons.chat;
      case 'exercise':
        return Icons.edit;
      default:
        return Icons.school;
    }
  }
}

class _VocabularyPreview extends StatelessWidget {
  final List<LearningItem> items;

  const _VocabularyPreview({required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _getLevelColor(item.level).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.level,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _getLevelColor(item.level),
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (item.isLearned)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, size: 10, color: Colors.white),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.word,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.foreground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.translation,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                if (item.pronunciation.isNotEmpty)
                  Text(
                    item.pronunciation,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'A1':
        return Colors.green;
      case 'A2':
        return Colors.lightGreen;
      case 'B1':
        return Colors.orange;
      case 'B2':
        return Colors.deepOrange;
      case 'C1':
        return Colors.red;
      case 'C2':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
