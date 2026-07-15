import 'package:flutter/material.dart';

import '../../../../core/identity/app_user.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

/// Lưới 2x2 thống kê học tập: Level · Tổng XP · Streak hiện tại · Từ đã học.
class ProfileStatsGrid extends StatelessWidget {
  const ProfileStatsGrid({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final items = [
      (Icons.military_tech_outlined, l10n.level, '${user.level}'),
      (Icons.bolt_outlined, l10n.totalXp, '${user.totalXp}'),
      (
        Icons.local_fire_department_outlined,
        l10n.streak,
        '${user.currentStreak}',
      ),
      (Icons.school_outlined, l10n.wordsLearned, '${user.wordsLearned}'),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: textScale >= 1.6 ? 1.2 : 2.4,
      children: [
        for (final (icon, label, value) in items)
          _StatCard(icon: icon, label: label, value: value),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.tigerOrange, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
                Text(
                  label,
                  maxLines: 2,
                  softWrap: true,
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
