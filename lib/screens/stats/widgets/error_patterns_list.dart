import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/data/stats/stats_models.dart';
import 'error_pattern_labels.dart';

/// Danh sách xem trước lỗi hay gặp (top N) — hiển thị trên màn Thống kê.
/// Danh sách đầy đủ + sort nằm ở `ErrorPatternsPage`.
class ErrorPatternsList extends StatelessWidget {
  const ErrorPatternsList({super.key, required this.patterns});

  final List<ErrorPatternSummary> patterns;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: patterns
            .map((pattern) => _ErrorPatternCard(pattern: pattern))
            .toList(),
      ),
    );
  }
}

class _ErrorPatternCard extends StatelessWidget {
  const _ErrorPatternCard({required this.pattern});

  final ErrorPatternSummary pattern;

  @override
  Widget build(BuildContext context) {
    final config = errorTypeLabel(context, pattern.errorType);
    final hasExample =
        pattern.exampleOriginal != null || pattern.exampleCorrected != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: config.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    config.label,
                    style: TextStyle(
                      color: config.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${pattern.totalCount}',
                  style: TextStyle(
                    color: config.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (hasExample) ...[
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  children: [
                    if (pattern.exampleOriginal != null)
                      TextSpan(
                        text: pattern.exampleOriginal,
                        style: TextStyle(
                          color: Colors.grey[600],
                          decoration: TextDecoration.lineThrough,
                          fontSize: 13,
                        ),
                      ),
                    if (pattern.exampleOriginal != null &&
                        pattern.exampleCorrected != null)
                      const TextSpan(text: '  →  '),
                    if (pattern.exampleCorrected != null)
                      TextSpan(
                        text: pattern.exampleCorrected,
                        style: const TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
