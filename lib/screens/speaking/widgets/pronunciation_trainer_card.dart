import 'package:flutter/material.dart';
import '../../../../core/theme/app_tokens.dart';
import 'package:deutschtiger/data/speaking/speaking_models.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class PronunciationTrainerCard extends StatelessWidget {
  final PronunciationTrainer trainer;

  const PronunciationTrainerCard({super.key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _getTrainerColor(
                        context,
                        trainer.type,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        trainer.targetSound,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _getTrainerColor(context, trainer.type),
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
                          trainer.nameVi,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trainer.descriptionVi,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Words to practice:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: trainer.exercises.take(5).map((exercise) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(exercise.word),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (trainer.totalAttempts > 0) ...[
                    Icon(PhosphorIcons.repeat, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${trainer.totalAttempts} attempts',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      PhosphorIcons.checkCircle,
                      size: 16,
                      color: context.tokens.success,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${(trainer.correctAttempts / trainer.totalAttempts * 100).toStringAsFixed(0)}% accuracy',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(PhosphorIcons.microphone, size: 18),
                    label: const Text('Start'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getTrainerColor(context, trainer.type),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTrainerColor(BuildContext context, String type) {
    switch (type) {
      case 'umlaut':
        return Colors.purple;
      case 'r-sound':
        return Colors.blue;
      case 'ich-ach':
        return Colors.orange;
      case 'sp-st':
        return Colors.teal;
      default:
        return context.tokens.primary;
    }
  }
}
