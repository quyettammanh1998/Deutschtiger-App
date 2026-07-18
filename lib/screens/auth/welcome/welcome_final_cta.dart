import 'package:flutter/material.dart';

import 'package:deutschtiger/widgets/common/tiger_logo.dart';
import 'welcome_palette.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Final CTA band — mirrors `welcome-final-cta.tsx`.
class WelcomeFinalCta extends StatelessWidget {
  const WelcomeFinalCta({super.key, required this.onCtaPressed});

  final VoidCallback onCtaPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('premium'),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: WelPalette.cardBorder),
      ),
      child: Column(
        children: [
          const TigerIcon(size: 72),
          const SizedBox(height: 18),
          Text.rich(
            TextSpan(
              children: const [
                TextSpan(text: 'Bắt đầu với\n'),
                TextSpan(text: 'tiếng Đức hôm nay.', style: TextStyle(color: WelPalette.orange500)),
              ],
              style: const TextStyle(
                fontFamily: WelPalette.displayFont,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                height: 1.1,
                color: WelPalette.ink,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Miễn phí trọn đời cho A1–B1. Cài đặt 30 giây, không cần thẻ tín dụng.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.5, height: 1.5, color: WelPalette.inkMuted60),
          ),
          const SizedBox(height: 20),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: WelPalette.ctaGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [BoxShadow(color: Color(0x80F7931E), blurRadius: 18, offset: Offset(0, 8))],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: onCtaPressed,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          'Bắt đầu hành trình',
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(PhosphorIcons.arrowRight, size: 16, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
