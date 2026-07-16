import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/widgets/common/tiger_logo.dart';
import 'welcome_palette.dart';

/// Footer — mirrors `welcome-footer.tsx` brand/tagline/credit block.
/// The web footer also ships a large SEO link cloud (25 marketing-only
/// landing pages) and nav columns pointing at web-only routes (help,
/// mailto, community pages outside this phase's ownership) — dropped here
/// since they have no Flutter destination; only the legal links that exist
/// as real app routes are kept.
class WelcomeFooter extends StatelessWidget {
  const WelcomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: WelPalette.cardBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const TigerIcon(size: 28),
              const SizedBox(width: 8),
              Text.rich(
                TextSpan(
                  text: 'Deutsch',
                  style: const TextStyle(fontFamily: WelPalette.brandFont, fontSize: 17, color: WelPalette.ink),
                  children: const [TextSpan(text: 'Tiger', style: TextStyle(color: WelPalette.orange500))],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Học tiếng Đức như chơi game. Cho người Việt, từ A1 đến C2.',
            style: TextStyle(fontSize: 13, height: 1.5, color: WelPalette.inkMuted55),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            children: [
              TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 36)),
                onPressed: () => context.push('/terms-of-service'),
                child: const Text('Điều khoản', style: TextStyle(fontSize: 13, color: WelPalette.inkMuted55)),
              ),
              TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 36)),
                onPressed: () => context.push('/privacy-policy'),
                child: const Text('Bảo mật', style: TextStyle(fontSize: 13, color: WelPalette.inkMuted55)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: WelPalette.cardBorder, height: 1),
          const SizedBox(height: 16),
          const Text('© 2026 Deutsch Tiger · deutschtiger.com', style: TextStyle(fontSize: 12, color: WelPalette.inkMuted55)),
          const SizedBox(height: 8),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('Made in Vietnam · ', style: TextStyle(fontSize: 12, color: WelPalette.inkMuted55)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: WelPalette.cardBorder),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircleAvatar(radius: 8, backgroundColor: WelPalette.orange500, child: Text('V', style: TextStyle(fontSize: 9, color: Colors.white))),
                      SizedBox(width: 5),
                      Text('Vũ Quang Cường', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: WelPalette.ink)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
