import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/dashboard_data.dart';

/// Danh sách nhiệm vụ hôm nay (read-only V1). Mỗi mission: icon, tiêu đề,
/// thanh tiến độ, XP thưởng; đánh dấu xong nếu completed.
class MissionList extends StatelessWidget {
  const MissionList({super.key, required this.missions});

  final List<Mission> missions;

  @override
  Widget build(BuildContext context) {
    if (missions.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nhiệm vụ hôm nay',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.foreground,
          ),
        ),
        const SizedBox(height: 10),
        for (final m in missions) ...[
          _MissionItem(mission: m),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _MissionItem extends StatelessWidget {
  const _MissionItem({required this.mission});
  final Mission mission;

  @override
  Widget build(BuildContext context) {
    final done = mission.isCompleted;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: done ? AppColors.success : AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: done
                  ? AppColors.success.withValues(alpha: 0.15)
                  : AppColors.orange50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              done ? Icons.check_circle : Icons.flag_outlined,
              color: done ? AppColors.success : AppColors.tigerOrange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission.titleVi,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                    decoration: done ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: mission.progressRatio,
                    minHeight: 6,
                    backgroundColor: AppColors.muted,
                    valueColor: AlwaysStoppedAnimation(
                      done ? AppColors.success : AppColors.tigerOrange,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${mission.currentProgress}/${mission.targetCount} · +${mission.xpReward} XP',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.mutedForeground,
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
