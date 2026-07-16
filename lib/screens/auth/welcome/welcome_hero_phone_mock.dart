import 'package:flutter/material.dart';

import 'welcome_hero_badges.dart';
import 'welcome_palette.dart';

/// CSS-drawn phone mock with 4 floating proof badges — mirrors
/// `welcome-hero-phone-mock.tsx` + the `.wel-float-badge` positions in
/// `welcome-hero-section.tsx`. Simplified single "app home" screen state
/// (web cycles through phone-mock tabs; not needed for a static hero).
class WelcomeHeroPhoneMock extends StatelessWidget {
  const WelcomeHeroPhoneMock({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 460,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Center(child: _PhoneFrame()),
          const Positioned(
            top: 16,
            left: 0,
            child: WelFloatBadge(
              icon: WelStreakBadge(),
              title: '27 ngày streak',
              subtitle: 'Trên 92% học viên',
            ),
          ),
          const Positioned(
            top: 4,
            right: 0,
            child: WelFloatBadge(
              icon: WelXpBadge(),
              title: '+5 XP',
              subtitle: '„der Schmetterling"',
            ),
          ),
          const Positioned(
            bottom: 70,
            left: 0,
            child: WelFloatBadge(
              icon: WelLevelUpBadge(),
              title: 'Lên cấp B1',
              subtitle: 'Mở 6 khóa mới',
            ),
          ),
          const Positioned(
            bottom: 24,
            right: 0,
            child: WelFloatBadge(
              icon: WelTrophyBadge(),
              title: 'Goethe B1 · Đỗ',
              subtitle: 'Lần đầu thi',
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Decorative "app screenshot" mock, like web's static `.c-phone` CSS
    // mockup — pinned to the system default text scale so it never
    // outgrows the fixed 220x440 frame regardless of OS font-size.
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: Container(
        width: 220,
        height: 440,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(38),
          boxShadow: const [
            BoxShadow(
              color: Color(0x52000000),
              blurRadius: 60,
              offset: Offset(0, 36),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Container(
            color: WelPalette.bgBottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 14, 16, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '9:41',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: WelPalette.ink,
                        ),
                      ),
                      Icon(
                        Icons.signal_cellular_alt,
                        size: 12,
                        color: WelPalette.ink,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Xin chào 👋',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: WelPalette.ink,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _MiniStatCard(),
                        const SizedBox(height: 10),
                        Expanded(child: _MiniVocabCard()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: WelPalette.ctaGradient,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'Streak 27 ngày',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 6),
          Icon(Icons.local_fire_department, size: 16, color: Colors.white),
        ],
      ),
    );
  }
}

class _MiniVocabCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: WelPalette.cardBorder),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'der Schmetterling',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: WelPalette.ink,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'con bướm',
            style: TextStyle(fontSize: 12, color: WelPalette.inkMuted55),
          ),
        ],
      ),
    );
  }
}
