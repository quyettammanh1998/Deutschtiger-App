import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../widgets/common/app_card.dart';
import '../../../../widgets/common/tiger_logo.dart';

/// Web parity: `FounderQuote` + orange→amber CTA card + `PageFooter` in
/// `de-thi-list-page.tsx` — hardcoded SEO trust-block copy (approved plan
/// exception, not localized).
class DeThiFounderCtaFooter extends StatelessWidget {
  const DeThiFounderCtaFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        AppCard.card(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const TigerIcon(size: 48),
              const SizedBox(height: 12),
              Text(
                '"Mình bắt đầu học tiếng Đức từ năm 2023 và gặp khó khăn với các '
                'app hiện có — không app nào hỗ trợ tiếng Việt tốt, có đề thi '
                'thật và có game học từ vựng. Đó là lý do mình tạo ra Deutsch '
                'Tiger."',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                  color: tokens.mutedForeground,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Quang Cường',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: tokens.foreground,
                ),
              ),
              Text(
                'Founder, Deutsch Tiger',
                style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(tokens.radius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      tokens.primary.withValues(alpha: 0.1),
                      const Color(0xFFF59F0A).withValues(alpha: 0.1),
                    ]
                  : const [Color(0xFFFFF7ED), Color(0xFFFFFBEB)],
            ),
          ),
          child: Column(
            children: [
              Text(
                'Học tiếng Đức toàn diện hơn — miễn phí',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: tokens.foreground,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Flashcard · Luyện nói AI · Đề thi B1/B2 · Không cần thẻ tín dụng',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: tokens.mutedForeground),
              ),
              const SizedBox(height: 16),
              InkWell(
                borderRadius: BorderRadius.circular(tokens.radius),
                onTap: () => launchUrl(
                  Uri.parse('https://deutschtiger.com'),
                  mode: LaunchMode.externalApplication,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(tokens.radius),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFF97316),
                        const Color(0xFFEA580C),
                      ],
                    ),
                  ),
                  child: const Text(
                    'Vào học ngay →',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: tokens.border)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 32),
            child: Text(
              '© 2026 Deutsch Tiger · Miễn phí, không cần đăng nhập',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: tokens.mutedForeground.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
