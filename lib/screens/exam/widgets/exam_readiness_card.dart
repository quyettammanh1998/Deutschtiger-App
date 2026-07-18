import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';
import 'package:deutschtiger/data/exam/exam_models.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class ExamReadinessCard extends StatelessWidget {
  final ExamReadiness readiness;

  const ExamReadinessCard({super.key, required this.readiness});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Stack(
                          children: [
                            CircularProgressIndicator(
                              value: readiness.overallScore / 100,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation(
                                _getOverallColor(context),
                              ),
                              strokeWidth: 8,
                            ),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${readiness.overallScore.toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: _getOverallColor(context),
                                    ),
                                  ),
                                  const Text(
                                    'Ready',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      _ScoreBar(
                        label: 'Reading',
                        score: readiness.readingScore,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 8),
                      _ScoreBar(
                        label: 'Listening',
                        score: readiness.listeningScore,
                        color: Colors.purple,
                      ),
                      const SizedBox(height: 8),
                      _ScoreBar(
                        label: 'Writing',
                        score: readiness.writingScore,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 8),
                      _ScoreBar(
                        label: 'Speaking',
                        score: readiness.speakingScore,
                        color: Colors.teal,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (readiness.strengths.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              PhosphorIcons.thumbsUp,
                              size: 16,
                              color: context.tokens.success,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Strengths',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...readiness.strengths
                            .take(2)
                            .map(
                              (s) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '• $s',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              PhosphorIcons.trendUp,
                              size: 16,
                              color: AppColors.error,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Needs Work',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...readiness.weaknesses
                            .take(2)
                            .map(
                              (w) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '• $w',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getOverallColor(BuildContext context) {
    if (readiness.overallScore >= 80) return context.tokens.success;
    if (readiness.overallScore >= 60) return Colors.orange;
    // `error` isn't a themed AppTokens member (only `destructive` is) — kept
    // as the fixed DesignTokens red already used for low-readiness scores.
    return AppColors.error;
  }
}

class _ScoreBar extends StatelessWidget {
  final String label;
  final double score;
  final Color color;

  const _ScoreBar({
    required this.label,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(label, style: const TextStyle(fontSize: 12)),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: score / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 35,
          child: Text(
            '${score.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
