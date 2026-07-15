import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Thanh tiến trình + điểm dùng chung cho 4 mode luyện tập theo deck.
class PracticeProgressHeader extends StatelessWidget {
  const PracticeProgressHeader({
    super.key,
    required this.current,
    required this.total,
    required this.correct,
  });

  final int current;
  final int total;
  final int correct;

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? current / total : 0.0;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle, size: 18, color: AppColors.success),
                  const SizedBox(width: 4),
                  Text(
                    '$correct',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
                  ),
                ],
              ),
              Text(
                '${current.clamp(0, total)}/$total',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        ClipRRect(
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.tigerOrange),
          ),
        ),
      ],
    );
  }
}
