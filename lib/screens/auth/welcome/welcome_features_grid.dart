import 'package:flutter/material.dart';

import 'welcome_palette.dart';
import 'welcome_section_head.dart';

/// "Tính năng" — 9-card grid — mirrors `welcome-features-grid.tsx`.
class WelcomeFeaturesGrid extends StatelessWidget {
  const WelcomeFeaturesGrid({super.key});

  static const _cards = [
    (
      icon: Icons.sports_esports,
      gradient: [Color(0xFFFB923C), Color(0xFFE11D48)],
      stamp: 'Phổ biến',
      title: 'Runner Game',
      desc: 'Chạy, nhảy chướng ngại, trả lời câu hỏi từ vựng. Càng đúng càng nhanh.',
      meta: '6,508 đang chơi',
    ),
    (
      icon: Icons.speed,
      gradient: [Color(0xFF38BDF8), WelPalette.sky600],
      stamp: null,
      title: 'Word Sprint',
      desc: '60 giây, trả lời nhiều nhất có thể. Thử thách tốc độ phản xạ từ vựng.',
      meta: 'BXH tuần · Top 100',
    ),
    (
      icon: Icons.style,
      gradient: [Color(0xFFA78BFA), WelPalette.violet600],
      stamp: null,
      title: 'Flashcards SRS',
      desc: 'Spaced repetition theo SM-2. Hệ thống biết lúc nào bạn sắp quên — nhắc đúng thời điểm.',
      meta: 'Thuật toán SM-2',
    ),
    (
      icon: Icons.menu_book,
      gradient: [Color(0xFF34D399), Color(0xFF059669)],
      stamp: null,
      title: '24 khóa A1–C1',
      desc: 'Có cấu trúc, video bài giảng, bài tập, kiểm tra cuối bài. Mỗi bài 8–12 phút.',
      meta: '149 bài · A1→C1',
    ),
    (
      icon: Icons.school,
      gradient: [Color(0xFFFBBF24), Color(0xFFD97706)],
      stamp: 'Premium',
      title: 'Đề thi mô phỏng',
      desc: 'Goethe, telc, ÖSD — bốn kỹ năng, chấm theo barem chuẩn, có AI feedback.',
      meta: 'A1 · A2 · B1 · B2 · C1',
    ),
    (
      icon: Icons.headphones,
      gradient: [Color(0xFFF472B6), WelPalette.rose600],
      stamp: null,
      title: 'Listening Hub',
      desc: 'Luyện tai với giọng bản xứ — Hochdeutsch, có sub song ngữ. Podcast, phim ngắn.',
      meta: '1,200+ audio',
    ),
    (
      icon: Icons.mic,
      gradient: [Color(0xFF22D3EE), WelPalette.cyan600],
      stamp: 'Mới',
      title: 'Shadowing',
      desc: 'Nghe câu mẫu rồi đọc theo. AI chấm phát âm, đánh dấu chỗ sai theo IPA.',
      meta: 'AI chấm phát âm',
    ),
    (
      icon: Icons.smart_display,
      gradient: [Color(0xFFF87171), WelPalette.red600],
      stamp: null,
      title: 'Video YouTube',
      desc: 'Xem video tiếng Đức kèm sub song ngữ. Click từ là tra nghĩa ngay, lưu vào sổ tay.',
      meta: '500+ video B1–C1',
    ),
    (
      icon: Icons.auto_awesome,
      gradient: [Color(0xFFC084FC), WelPalette.purple600],
      stamp: 'AI',
      title: 'Tiger AI',
      desc: 'Chấm bài Schreiben, giải thích ngữ pháp, luyện hội thoại — như có gia sư bản xứ 24/7.',
      meta: 'Powered by Claude',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('features'),
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 40),
      child: Column(
        children: [
          const WelcomeSectionHead(
            eyebrow: 'Tính năng',
            title: 'Chín công cụ, ',
            titleEmphasis: 'một app.',
            lede: 'Vừa chơi game, vừa xem video YouTube tiếng Đức, vừa luyện nói với tiger AI — tất cả trong một, tiến độ đồng bộ.',
          ),
          const SizedBox(height: 24),
          // 2-per-row without a forced aspect ratio (Grandstander titles +
          // description text grow at high text-scale/German string
          // lengths; a fixed `childAspectRatio` clips them).
          for (var i = 0; i < _cards.length; i += 2)
            Padding(
              padding: EdgeInsets.only(bottom: i + 2 < _cards.length ? 12 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _cardAt(i)),
                  const SizedBox(width: 12),
                  Expanded(child: i + 1 < _cards.length ? _cardAt(i + 1) : const SizedBox.shrink()),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _cardAt(int i) {
    final c = _cards[i];
    return _FeatCard(icon: c.icon, gradient: c.gradient, stamp: c.stamp, title: c.title, desc: c.desc, meta: c.meta);
  }
}

class _FeatCard extends StatelessWidget {
  const _FeatCard({
    required this.icon,
    required this.gradient,
    required this.stamp,
    required this.title,
    required this.desc,
    required this.meta,
  });

  final IconData icon;
  final List<Color> gradient;
  final String? stamp;
  final String title;
  final String desc;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: WelPalette.cardBorder),
      ),
      child: Stack(
        children: [
          if (stamp != null)
            Positioned(
              top: 0,
              right: 0,
              child: Transform.rotate(
                angle: 0.07,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(gradient: LinearGradient(colors: gradient), borderRadius: BorderRadius.circular(999)),
                  child: Text(stamp!, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white)),
                ),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontFamily: WelPalette.displayFont, fontSize: 16, fontWeight: FontWeight.w900, color: WelPalette.ink),
              ),
              const SizedBox(height: 4),
              Text(desc, style: const TextStyle(fontSize: 11.5, height: 1.4, color: WelPalette.inkMuted55)),
              const SizedBox(height: 8),
              Text(meta, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: WelPalette.inkMuted55)),
            ],
          ),
        ],
      ),
    );
  }
}
