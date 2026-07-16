import 'package:flutter/material.dart';

import 'welcome_palette.dart';

/// Stats row — mirrors `welcome-stats-bar.tsx` (4 cards, 2x2 on mobile).
class WelcomeStatsBar extends StatelessWidget {
  const WelcomeStatsBar({super.key});

  static const _stats = [
    (v: '10k+', label: 'Từ vựng A1–C1', color: WelPalette.cyan600),
    (v: '149', label: 'Bài ngữ pháp', color: WelPalette.violet600),
    (v: '12.5k', label: 'Học viên đang học', color: WelPalette.rose600),
    (v: '86%', label: 'Đạt mục tiêu tuần', color: WelPalette.green500),
  ];

  @override
  Widget build(BuildContext context) {
    // 2x2 grid without a forced aspect ratio — Row/Column pairs size to
    // content so the Grandstander numeral never gets clipped.
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _StatCard(v: _stats[0].v, label: _stats[0].label, color: _stats[0].color)),
              const SizedBox(width: 10),
              Expanded(child: _StatCard(v: _stats[1].v, label: _stats[1].label, color: _stats[1].color)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _StatCard(v: _stats[2].v, label: _stats[2].label, color: _stats[2].color)),
              const SizedBox(width: 10),
              Expanded(child: _StatCard(v: _stats[3].v, label: _stats[3].label, color: _stats[3].color)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.v, required this.label, required this.color});
  final String v;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: WelPalette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            v,
            style: TextStyle(
              fontFamily: WelPalette.displayFont,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: WelPalette.inkMuted55)),
        ],
      ),
    );
  }
}
