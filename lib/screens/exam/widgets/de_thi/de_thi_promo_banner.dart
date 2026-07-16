import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../widgets/common/tiger_logo.dart';

/// Web parity: `MobilePromoBanner` in `de-thi-list-page.tsx` — orange-50
/// card promoting the full app (flashcard/speaking/writing/exam).
class DeThiPromoBanner extends StatelessWidget {
  const DeThiPromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final orange50 = const Color(0xFFFFF7ED);
    final orange200 = const Color(0xFFFED7AA);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => launchUrl(
        Uri.parse('https://deutschtiger.com'),
        mode: LaunchMode.externalApplication,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? tokens.primary.withValues(alpha: 0.08) : orange50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? tokens.primary.withValues(alpha: 0.3) : orange200,
          ),
        ),
        child: Row(
          children: [
            const TigerLogo(width: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Học tiếng Đức toàn diện hơn',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: tokens.foreground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Flashcard · Luyện nói AI · Đề thi B1/B2',
                    style: TextStyle(
                      fontSize: 12,
                      color: tokens.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Thử ngay →',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: tokens.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
