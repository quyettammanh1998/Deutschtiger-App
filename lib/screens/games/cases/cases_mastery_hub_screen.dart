import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

/// Hub cho 4 sub-game "Cases Mastery" — mirrors web
/// `src/pages/game/cases-mastery-hub-page.tsx`. Mỗi thẻ dẫn tới một game
/// live riêng (`/user/cases/{akk-dat,adjektiv,wechselprep,verb-case}`).
class CasesMasteryHubScreen extends StatelessWidget {
  const CasesMasteryHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Luyện 4 Cách'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Hệ thống 4 cách (Fälle) là gốc rễ tiếng Đức. Mỗi game là '
                'một kho câu lớn, cá nhân hoá theo trình độ — mỗi lượt là '
                'câu mới, ưu tiên chỗ bạn hay sai.',
                style: TextStyle(fontSize: 13, color: AppColors.foreground),
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.95,
              children: [
                _SubDrillCard(
                  title: 'Akkusativ vs Dativ',
                  description: 'Chọn đúng der/den/dem trong câu',
                  icon: Icons.shuffle,
                  color: Colors.blue,
                  onTap: () => context.push('/games/cases/akk-dat'),
                ),
                _SubDrillCard(
                  title: 'Adjektivendungen',
                  description: 'große / großen — đuôi tính từ',
                  icon: Icons.translate,
                  color: Colors.purple,
                  onTap: () => context.push('/games/cases/adjektiv'),
                ),
                _SubDrillCard(
                  title: 'Wechselpräpositionen',
                  description: 'in die Schule (Akk) vs in der Schule (Dat)',
                  icon: Icons.list_alt,
                  color: Colors.amber.shade700,
                  onTap: () => context.push('/games/cases/wechselprep'),
                ),
                _SubDrillCard(
                  title: 'Verb-Case Matching',
                  description: 'helfen → Dativ, sehen → Akkusativ',
                  icon: Icons.menu_book,
                  color: Colors.teal,
                  onTap: () => context.push('/games/cases/verb-case'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SubDrillCard extends StatelessWidget {
  const _SubDrillCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.mutedForeground,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
