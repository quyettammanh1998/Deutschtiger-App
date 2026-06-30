import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../data/journey_repository.dart';
import '../domain/journey_models.dart';
import '../presentation/journey_provider.dart';

/// Visual winding road map showing A1-C2 levels with chapters.
/// Tap chapter node to navigate to chapter detail.
class JourneyRoadmapScreen extends ConsumerWidget {
  const JourneyRoadmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chaptersAsync = ref.watch(journeyChaptersProvider);
    final progressAsync = ref.watch(journeyProgressProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Learning Roadmap'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_view_rounded),
            onPressed: () => context.push('/journey/browse'),
            tooltip: 'Browse All Items',
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress header
          progressAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (progress) => _ProgressBanner(progress: progress),
          ),
          // Roadmap content
          Expanded(
            child: chaptersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (chapters) => _RoadmapView(chapters: chapters),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBanner extends StatelessWidget {
  final JourneyProgress progress;

  const _ProgressBanner({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.tigerOrange, AppColors.rose600],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.tigerOrange.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Level badge
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Center(
              child: Text(
                progress.currentLevel,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${progress.totalXp} XP earned',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (progress.totalXp % 5000) / 5000,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${progress.totalLessonsCompleted} lessons completed',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Streak badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_fire_department, color: Colors.white, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${progress.streakDays}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoadmapView extends StatelessWidget {
  final List<JourneyChapter> chapters;

  const _RoadmapView({required this.chapters});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Winding road SVG-style path
          Stack(
            alignment: Alignment.topCenter,
            children: [
              // Road path (wavy line)
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width - 80, _calculateRoadHeight(chapters.length)),
                painter: _RoadPathPainter(
                  chapterCount: chapters.length,
                  completedCount: chapters.where((c) => c.isCompleted).length,
                ),
              ),
              // Chapter nodes
              Positioned.fill(
                child: Column(
                  children: [
                    for (int i = 0; i < chapters.length; i++) ...[
                      _ChapterRoadNode(
                        chapter: chapters[i],
                        index: i,
                        totalCount: chapters.length,
                      ),
                      if (i < chapters.length - 1) const SizedBox(height: 40),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  double _calculateRoadHeight(int count) {
    // Base height per node + spacing
    return count * 120.0 + (count - 1) * 40.0;
  }
}

class _RoadPathPainter extends CustomPainter {
  final int chapterCount;
  final int completedCount;

  _RoadPathPainter({required this.chapterCount, required this.completedCount});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final nodeSpacing = (size.height - 50) / (chapterCount - 1).clamp(1, 100);

    // Draw winding path
    path.moveTo(size.width / 2, 25);

    for (int i = 1; i < chapterCount; i++) {
      final y = i * nodeSpacing;
      final xOffset = (i % 2 == 0) ? 30.0 : -30.0;
      path.quadraticBezierTo(
        size.width / 2 + xOffset,
        y - nodeSpacing / 2,
        size.width / 2,
        y,
      );
    }

    // Gradient for completed portion
    final completedHeight = completedCount * nodeSpacing;
    final gradient = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.success, AppColors.success.withValues(alpha: 0.5)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, completedHeight));

    // Draw completed portion
    final completedPath = Path()..moveTo(size.width / 2, 25);
    for (int i = 1; i <= completedCount && i < chapterCount; i++) {
      final y = i * nodeSpacing;
      final xOffset = (i % 2 == 0) ? 30.0 : -30.0;
      completedPath.quadraticBezierTo(
        size.width / 2 + xOffset,
        y - nodeSpacing / 2,
        size.width / 2,
        y,
      );
    }
    canvas.drawPath(completedPath, gradient..strokeWidth = 12);

    // Draw remaining portion
    final remainingPath = Path()..moveTo(size.width / 2, completedCount > 0 ? completedCount * nodeSpacing : 25);
    for (int i = completedCount + 1; i < chapterCount; i++) {
      final y = i * nodeSpacing;
      final xOffset = (i % 2 == 0) ? 30.0 : -30.0;
      remainingPath.quadraticBezierTo(
        size.width / 2 + xOffset,
        y - nodeSpacing / 2,
        size.width / 2,
        y,
      );
    }
    canvas.drawPath(
      remainingPath,
      paint..color = Colors.grey.shade300,
    );
  }

  @override
  bool shouldRepaint(covariant _RoadPathPainter oldDelegate) =>
      oldDelegate.chapterCount != chapterCount ||
      oldDelegate.completedCount != completedCount;
}

class _ChapterRoadNode extends StatelessWidget {
  final JourneyChapter chapter;
  final int index;
  final int totalCount;

  const _ChapterRoadNode({
    required this.chapter,
    required this.index,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = chapter.isCompleted;
    final isLocked = chapter.isLocked;
    final isActive = !isLocked && !isCompleted && (index == 0 || _previousCompleted(index));

    return GestureDetector(
      onTap: isLocked ? null : () => context.push('/journey/chapter/${chapter.id}'),
      child: Row(
        children: [
          // Left connector (for alternating layout)
          if (index % 2 == 1) const Expanded(child: SizedBox()),
          // Node card
          _NodeCard(
            chapter: chapter,
            isCompleted: isCompleted,
            isLocked: isLocked,
            isActive: isActive,
          ),
          // Right connector (for alternating layout)
          if (index % 2 == 0) const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  bool _previousCompleted(int index) {
    // This would normally check actual data
    return index <= 1;
  }
}

class _NodeCard extends StatelessWidget {
  final JourneyChapter chapter;
  final bool isCompleted;
  final bool isLocked;
  final bool isActive;

  const _NodeCard({
    required this.chapter,
    required this.isCompleted,
    required this.isLocked,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final nodeColor = isLocked
        ? Colors.grey
        : isCompleted
            ? AppColors.success
            : isActive
                ? AppColors.tigerOrange
                : AppColors.primary;

    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLocked ? Colors.grey.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? nodeColor : Colors.grey.shade200,
          width: isActive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isActive ? nodeColor : Colors.black).withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Level badge + status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: nodeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLocked)
                      Icon(Icons.lock, size: 14, color: nodeColor)
                    else
                      Text(
                        chapter.level,
                        style: TextStyle(
                          color: nodeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                )
              else if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.tigerOrange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'START',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Title
          Text(
            chapter.titleVi,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isLocked ? Colors.grey : AppColors.foreground,
            ),
          ),
          const SizedBox(height: 8),
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MiniStat(icon: Icons.book_outlined, value: '${chapter.totalLessons}'),
              const SizedBox(width: 12),
              _MiniStat(icon: Icons.access_time, value: '${chapter.totalLessons * 8}m'),
            ],
          ),
          // Progress bar
          if (!isLocked && chapter.completedLessons > 0) ...[
            const SizedBox(height: 12),
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: chapter.progressPercent / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(nodeColor),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${chapter.completedLessons}/${chapter.totalLessons}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;

  const _MiniStat({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
