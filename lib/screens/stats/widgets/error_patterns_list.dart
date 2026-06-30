import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/stats_models.dart';

class ErrorPatternsList extends StatelessWidget {
  final List<ErrorPattern> patterns;

  const ErrorPatternsList({super.key, required this.patterns});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: patterns.map((pattern) => _ErrorPatternCard(pattern: pattern)).toList(),
      ),
    );
  }
}

class _ErrorPatternCard extends StatelessWidget {
  final ErrorPattern pattern;

  const _ErrorPatternCard({required this.pattern});

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getErrorColor(pattern.errorRate).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    pattern.grammarCategoryVi,
                    style: TextStyle(
                      color: _getErrorColor(pattern.errorRate),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${pattern.errorRate.toStringAsFixed(1)}% error rate',
                  style: TextStyle(
                    color: _getErrorColor(pattern.errorRate),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: pattern.errorRate / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(_getErrorColor(pattern.errorRate)),
            ),
            const SizedBox(height: 8),
            Text(
              '${pattern.errorCount}/${pattern.totalAttempts} errors',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            if (pattern.exampleErrors.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Examples:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 4),
              ...pattern.exampleErrors.take(2).map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '• $e',
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
              )),
            ],
            if (pattern.suggestions.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: pattern.suggestions.take(2).map((s) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lightbulb, size: 14, color: AppColors.success),
                      const SizedBox(width: 4),
                      Text(
                        s,
                        style: const TextStyle(fontSize: 11, color: AppColors.success),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getErrorColor(double rate) {
    if (rate < 15) return AppColors.success;
    if (rate < 25) return Colors.orange;
    return AppColors.error;
  }
}
