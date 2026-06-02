import 'package:flutter/material.dart';

import '../../../../core/identity/app_user.dart';
import '../../../../core/theme/app_colors.dart';

/// Header hồ sơ: avatar, tên hiển thị, CEFR level + huy hiệu Premium.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final hasAvatar = user.avatarUrl != null && user.avatarUrl!.isNotEmpty;
    final name = user.displayName.isEmpty ? 'Học viên' : user.displayName;

    return Column(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: AppColors.orange100,
          backgroundImage: hasAvatar ? NetworkImage(user.avatarUrl!) : null,
          child: hasAvatar
              ? null
              : Text(
                  name.characters.first.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.tigerOrange,
                  ),
                ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.foreground,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          alignment: WrapAlignment.center,
          children: [
            if (user.cefrLevel != null && user.cefrLevel!.isNotEmpty)
              _Badge(
                label: user.cefrLevel!.toUpperCase(),
                color: AppColors.accent,
                textColor: AppColors.foreground,
              ),
            if (user.isPremium)
              const _Badge(
                label: '★ Premium',
                color: AppColors.tigerOrange,
                textColor: Colors.white,
              ),
          ],
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
