import 'package:flutter/material.dart';

import 'welcome_palette.dart';

/// Small decorative "3D" badge icons for the hero phone mock — vector
/// approximations of `welcome-hero-badges.tsx`'s inline-SVG badges
/// (streak flame / XP medal / level-up / trophy). All decorative.
class WelStreakBadge extends StatelessWidget {
  const WelStreakBadge({super.key, this.size = 32});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.local_fire_department, size: size, color: WelPalette.orange600);
  }
}

class WelXpBadge extends StatelessWidget {
  const WelXpBadge({super.key, this.size = 30});
  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [Color(0xFFFDE68A), WelPalette.amber500]),
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: const Icon(Icons.star, size: 16, color: Colors.white),
      ),
    );
  }
}

class WelLevelUpBadge extends StatelessWidget {
  const WelLevelUpBadge({super.key, this.size = 34});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.arrow_upward_rounded, size: size, color: WelPalette.green600);
  }
}

class WelTrophyBadge extends StatelessWidget {
  const WelTrophyBadge({super.key, this.size = 30});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.emoji_events, size: size, color: WelPalette.amber400);
  }
}

/// A floating proof-point card next to the phone mock, e.g. "27 ngày
/// streak · Trên 92% học viên" — mirrors `.wel-float-badge`.
class WelFloatBadge extends StatelessWidget {
  const WelFloatBadge({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final Widget icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 12, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 18, offset: Offset(0, 8)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 32, height: 32, child: Center(child: icon)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: WelPalette.ink),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: WelPalette.inkMuted55),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
