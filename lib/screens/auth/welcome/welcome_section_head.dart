import 'package:flutter/material.dart';

import 'welcome_palette.dart';

/// Shared "eyebrow + h2 + lede" section head — mirrors `.c-eyebrow`/`.c-h2`/
/// `.c-lede` CSS classes reused across how-it-works/features/testimonials.
class WelcomeSectionHead extends StatelessWidget {
  const WelcomeSectionHead({
    super.key,
    required this.eyebrow,
    required this.title,
    this.titleEmphasis,
    required this.lede,
  });

  final String eyebrow;
  final String title;
  final String? titleEmphasis;
  final String lede;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(color: const Color(0xFFFFF8EF), borderRadius: BorderRadius.circular(999)),
          child: Text(
            eyebrow.toUpperCase(),
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1, color: WelPalette.orange500),
          ),
        ),
        const SizedBox(height: 14),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: title),
              if (titleEmphasis != null) TextSpan(text: titleEmphasis, style: const TextStyle(color: WelPalette.orange500)),
            ],
            style: const TextStyle(
              fontFamily: WelPalette.displayFont,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -0.5,
              color: WelPalette.ink,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          lede,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14.5, height: 1.55, color: WelPalette.inkMuted60),
        ),
      ],
    );
  }
}
