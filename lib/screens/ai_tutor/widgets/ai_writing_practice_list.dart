import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:deutschtiger/data/ai_tutor/ai_tutor_models.dart';

class AIWritingPracticeList extends StatelessWidget {
  final List<AIWritingPractice> practices;

  const AIWritingPracticeList({super.key, required this.practices});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: practices.length,
        itemBuilder: (context, index) => _PracticeCard(practice: practices[index]),
      ),
    );
  }
}

class _PracticeCard extends StatelessWidget {
  final AIWritingPractice practice;

  const _PracticeCard({required this.practice});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: practice.isCompleted
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            practice.isCompleted ? Icons.check_circle : Icons.edit,
                            size: 14,
                            color: practice.isCompleted ? AppColors.success : AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            practice.isCompleted
                                ? '${practice.overallScore.toStringAsFixed(0)}%'
                                : 'Start',
                            style: TextStyle(
                              fontSize: 12,
                              color: practice.isCompleted ? AppColors.success : AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${practice.wordLimit}w',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  practice.topicVi,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                if (practice.isCompleted)
                  Row(
                    children: [
                      _ScoreChip(label: 'G', score: practice.grammarScore, color: Colors.purple),
                      const SizedBox(width: 4),
                      _ScoreChip(label: 'V', score: practice.vocabularyScore, color: Colors.blue),
                      const SizedBox(width: 4),
                      _ScoreChip(label: 'C', score: practice.coherenceScore, color: Colors.orange),
                    ],
                  )
                else
                  Text(
                    practice.promptVi,
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  final String label;
  final double score;
  final Color color;

  const _ScoreChip({required this.label, required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label:${score.toStringAsFixed(0)}',
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
