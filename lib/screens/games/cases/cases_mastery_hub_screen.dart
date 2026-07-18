import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../widgets/common/game_shell.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Hub cho 4 sub-game "Cases Mastery" — mirrors web
/// `src/pages/game/cases-mastery-hub-page.tsx`. Mỗi thẻ dẫn tới một game
/// live riêng (`/user/cases/{akk-dat,adjektiv,wechselprep,verb-case}`).
class CasesMasteryHubScreen extends StatelessWidget {
  const CasesMasteryHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GameShell(
      title: 'Luyện 4 Cách',
      exitGuard: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.blue.shade900.withValues(alpha: 0.3)
                  : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: isDark ? Colors.blue.shade200 : Colors.blue.shade900,
                    ),
                    children: const [
                      TextSpan(text: 'Hệ thống 4 cách (Fälle) là '),
                      TextSpan(
                        text: 'gốc rễ',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text:
                            ' tiếng Đức. Luyện đến khi phản xạ Akk/Dat/Gen + đuôi '
                            'tính từ + giới từ "luôn 2 mặt" sẽ giúp bạn nói/viết '
                            'đúng và tự tin.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: isDark
                          ? Colors.blue.shade300.withValues(alpha: 0.8)
                          : Colors.blue.shade800.withValues(alpha: 0.8),
                    ),
                    children: const [
                      TextSpan(text: 'Mỗi game là một '),
                      TextSpan(
                        text: 'kho câu lớn',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text:
                            ', cá nhân hoá theo trình độ — mỗi lượt là câu '
                            'mới, ưu tiên chỗ bạn hay sai.',
                      ),
                    ],
                  ),
                ),
              ],
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
                icon: PhosphorIcons.shuffle,
                gradient: const [Color(0xFF3B82F6), Color(0xFF0891B2)],
                tokens: tokens,
                onTap: () => context.push('/games/cases-akk-dat'),
              ),
              _SubDrillCard(
                title: 'Adjektivendungen',
                description: 'Der ___ Mann (groß) → große / großen',
                icon: PhosphorIcons.translate,
                gradient: const [Color(0xFFA855F7), Color(0xFF7C3AED)],
                tokens: tokens,
                onTap: () => context.push('/games/cases-adjektiv'),
              ),
              _SubDrillCard(
                title: 'Wechselpräpositionen',
                description: 'in die Schule (Akk) vs in der Schule (Dat)',
                icon: PhosphorIcons.listBullets,
                gradient: const [Color(0xFFF59E0B), Color(0xFFEA580C)],
                tokens: tokens,
                onTap: () => context.push('/games/cases-wechselprep'),
              ),
              _SubDrillCard(
                title: 'Verb-Case Matching',
                description: 'helfen → Dativ, sehen → Akkusativ',
                icon: PhosphorIcons.bookOpen,
                gradient: const [Color(0xFF10B981), Color(0xFF0D9488)],
                tokens: tokens,
                onTap: () => context.push('/games/cases-verb-case'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubDrillCard extends StatelessWidget {
  const _SubDrillCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.tokens,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final AppTokens tokens;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tokens.border),
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
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: tokens.foreground,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
