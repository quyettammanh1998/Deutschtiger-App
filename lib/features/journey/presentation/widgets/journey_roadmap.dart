import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/journey_models.dart';

class JourneyRoadmap extends StatelessWidget {
  final List<JourneyChapter> chapters;

  const JourneyRoadmap({super.key, required this.chapters});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (int i = 0; i < chapters.length; i++) ...[
            _ChapterNode(chapter: chapters[i], isLast: i == chapters.length - 1),
          ],
        ],
      ),
    );
  }
}

class _ChapterNode extends StatelessWidget {
  final JourneyChapter chapter;
  final bool isLast;

  const _ChapterNode({required this.chapter, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isCompleted = chapter.isCompleted;
    final isLocked = chapter.isLocked;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _getNodeColor(isCompleted, isLocked),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _getNodeColor(isCompleted, isLocked).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: isLocked
                    ? const Icon(Icons.lock, color: Colors.white, size: 24)
                    : Text(
                        chapter.level,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
              ),
            ),
            if (!isLast)
              Container(
                width: 3,
                height: 80,
                color: isCompleted ? AppColors.success : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: InkWell(
              onTap: isLocked ? null : () {},
              borderRadius: BorderRadius.circular(12),
              child: Opacity(
                opacity: isLocked ? 0.5 : 1.0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            chapter.titleVi,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          if (isCompleted)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.check, size: 14, color: AppColors.success),
                                  SizedBox(width: 4),
                                  Text(
                                    'Completed',
                                    style: TextStyle(color: AppColors.success, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        chapter.descriptionVi,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _InfoChip(
                            icon: Icons.school,
                            label: '${chapter.totalLessons} lessons',
                          ),
                          const SizedBox(width: 12),
                          _InfoChip(
                            icon: Icons.access_time,
                            label: '${chapter.totalLessons * 10} min',
                          ),
                        ],
                      ),
                      if (chapter.completedLessons > 0) ...[
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: chapter.progressPercent / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(
                            isCompleted ? AppColors.success : AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${chapter.completedLessons}/${chapter.totalLessons} completed (${chapter.progressPercent.toStringAsFixed(0)}%)',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getNodeColor(bool isCompleted, bool isLocked) {
    if (isLocked) return Colors.grey;
    if (isCompleted) return AppColors.success;
    return AppColors.primary;
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
