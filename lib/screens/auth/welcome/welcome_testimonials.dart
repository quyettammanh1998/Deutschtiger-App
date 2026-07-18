import 'package:flutter/material.dart';

import 'welcome_palette.dart';
import 'welcome_section_head.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// "Học viên" testimonials — mirrors `welcome-testimonials.tsx`.
class WelcomeTestimonials extends StatelessWidget {
  const WelcomeTestimonials({super.key});

  static const _items = [
    (
      who: 'Như Anh',
      initial: 'N',
      avatarColors: [Color(0xFFFBBF24), WelPalette.orange500],
      sub: 'Đại học TU Berlin · Khóa 2024',
      quote: 'Đề thi thử sát thực tế. Mình đậu B1 ngay lần đầu nhờ luyện ở đây — tiết kiệm hẳn ba tháng so với học truyền thống.',
      level: 'B1',
      levelColor: WelPalette.orange700,
      levelBg: Color(0xFFFFEDD5),
    ),
    (
      who: 'Duyên Vũ',
      initial: 'D',
      avatarColors: [Color(0xFFA78BFA), WelPalette.violet600],
      sub: 'Tự học · Hà Nội',
      quote: 'Phần game giúp mình nhớ từ nhanh hơn hẳn chép tay. Streak 90 ngày rồi, không bỏ một ngày nào.',
      level: 'A2',
      levelColor: Color(0xFF1D4ED8),
      levelBg: Color(0xFFDBEAFE),
    ),
    (
      who: 'Mạnh Nguyễn',
      initial: 'M',
      avatarColors: [Color(0xFF34D399), Color(0xFF10B981)],
      sub: 'Du học sinh Munich',
      quote: 'Giao diện dễ dùng, vừa học từ vừa luyện nghe trong cùng app. Phần dịch nghĩa bằng tiếng Việt rất chính xác.',
      level: 'B2',
      levelColor: WelPalette.orange700,
      levelBg: Color(0xFFFED7AA),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('hoc-vien'),
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 40),
      child: Column(
        children: [
          const WelcomeSectionHead(
            eyebrow: 'Học viên',
            title: 'Người Việt học tiếng Đức ở đây.',
            lede: 'Mỗi ngày 1,000+ bạn đang luyện. Đây là một vài chia sẻ.',
          ),
          const SizedBox(height: 24),
          for (final t in _items) ...[
            _TestimonialCard(
              who: t.who,
              initial: t.initial,
              avatarColors: t.avatarColors,
              sub: t.sub,
              quote: t.quote,
              level: t.level,
              levelColor: t.levelColor,
              levelBg: t.levelBg,
            ),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  const _TestimonialCard({
    required this.who,
    required this.initial,
    required this.avatarColors,
    required this.sub,
    required this.quote,
    required this.level,
    required this.levelColor,
    required this.levelBg,
  });

  final String who;
  final String initial;
  final List<Color> avatarColors;
  final String sub;
  final String quote;
  final String level;
  final Color levelColor;
  final Color levelBg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WelPalette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: avatarColors.last,
                child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            who,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: WelPalette.ink),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const CircleAvatar(radius: 7, backgroundColor: WelPalette.orange500, child: Icon(PhosphorIcons.check, size: 9, color: Colors.white)),
                      ],
                    ),
                    Text(sub, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12, color: WelPalette.inkMuted55)),
                  ],
                ),
              ),
              const Text('★★★★★', style: TextStyle(fontSize: 11, color: WelPalette.amber400)),
            ],
          ),
          const SizedBox(height: 12),
          Text('„$quote"', style: const TextStyle(fontSize: 13.5, height: 1.5, color: WelPalette.ink)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(color: levelBg, borderRadius: BorderRadius.circular(999)),
                child: Text('Level $level', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: levelColor)),
              ),
              const Text('3 tuần trước', style: TextStyle(fontSize: 12, color: WelPalette.inkMuted55)),
            ],
          ),
        ],
      ),
    );
  }
}
