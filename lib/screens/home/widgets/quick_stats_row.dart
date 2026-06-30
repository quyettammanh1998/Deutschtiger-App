import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Hàng 3 ô thống kê nhanh: từ đã học · từ cần ôn · phút hôm nay.
class QuickStatsRow extends StatelessWidget {
  const QuickStatsRow({
    super.key,
    required this.wordsLearned,
    required this.dueReviewCount,
    required this.onlineMinutes,
  });

  final int wordsLearned;
  final int dueReviewCount;
  final int onlineMinutes;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatBox(
          icon: Icons.school_outlined,
          value: '$wordsLearned',
          label: 'Từ đã học',
        ),
        const SizedBox(width: 10),
        _StatBox(
          icon: Icons.refresh,
          value: '$dueReviewCount',
          label: 'Cần ôn',
          highlight: dueReviewCount > 0,
        ),
        const SizedBox(width: 10),
        _StatBox(
          icon: Icons.timer_outlined,
          value: '$onlineMinutes',
          label: 'Phút hôm nay',
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
    this.highlight = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: highlight ? AppColors.tigerOrange : AppColors.border,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.tigerOrange),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
