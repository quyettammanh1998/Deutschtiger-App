import 'package:flutter/material.dart';

import 'package:deutschtiger/widgets/common/tiger_logo.dart';
import 'welcome_palette.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Sticky nav header — mirrors `welcome-nav-header.tsx`: tiger icon +
/// wordmark, streak pill, "Bắt đầu" CTA. Nav link pills (Cách học/Tính
/// năng/Học viên) are web anchor-scroll only, dropped here since the mobile
/// port scrolls the whole page linearly (no in-page section jump needed).
class WelcomeNavHeader extends StatelessWidget {
  const WelcomeNavHeader({super.key, required this.onCtaPressed});

  final VoidCallback onCtaPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xB2FFF7EC), // rgba(255,247,236,0.7)
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              const TigerIcon(size: 32),
              const SizedBox(width: 8),
              // Wordmark sizes to its content (web never truncates it). A
              // `Flexible` here would split free space with the `Spacer` and
              // clip "Tiger" on narrow phones, so keep it intrinsic-width.
              const Text.rich(
                TextSpan(
                  text: 'Deutsch',
                  style: TextStyle(
                    fontFamily: WelPalette.brandFont,
                    fontSize: 18,
                    color: WelPalette.ink,
                  ),
                  children: [
                    TextSpan(
                      text: 'Tiger',
                      style: TextStyle(color: WelPalette.orange500),
                    ),
                  ],
                ),
                maxLines: 1,
              ),
              const Spacer(),
              // Streak chip is hidden below 720px on web (`.wel-nav-streak`
              // `@media max-width: 720px { display: none }`) — the mobile
              // port is always below that breakpoint, so it's dropped here.
              _CtaButton(onPressed: onCtaPressed),
            ],
          ),
        ),
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: WelPalette.ctaGradient,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x8CF7931E),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onPressed,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(14, 9, 8, 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bắt đầu',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                SizedBox(width: 6),
                CircleAvatar(
                  radius: 11,
                  backgroundColor: Color(0x38FFFFFF),
                  child: Icon(PhosphorIcons.arrowRight, size: 12, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
