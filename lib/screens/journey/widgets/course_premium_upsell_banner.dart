import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../widgets/common/app_button.dart';

/// Orange-gradient upsell strip shown when the user is beyond the free
/// course/lesson limit — web parity: the "Mở khóa toàn bộ N khoá học" /
/// "N bài học" cards in `course-hub-page.tsx` / `course-detail-page.tsx`.
/// CTA routes to the app's existing `/settings/premium` surface (no SePay,
/// IAP flow owned by MASTER P7 — see plan constraints).
class CoursePremiumUpsellBanner extends StatelessWidget {
  const CoursePremiumUpsellBanner({super.key, required this.title, required this.subtitle, required this.ctaLabel});

  final String title;
  final String subtitle;
  final String ctaLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tokens.primary.withValues(alpha: 0.05),
        border: Border.all(color: tokens.primary.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tokens.foreground),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 36,
            child: AppGradientButton(
              label: ctaLabel,
              onPressed: () => context.push('/settings/premium'),
              height: 36,
            ),
          ),
        ],
      ),
    );
  }
}
