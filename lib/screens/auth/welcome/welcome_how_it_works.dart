import 'package:flutter/material.dart';

import 'welcome_palette.dart';
import 'welcome_section_head.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// "Cách học" — 3-step showcase — mirrors `welcome-how-it-works.tsx`.
/// Mobile: stacked (web's alternating left/right reverse rows collapse to a
/// single column on narrow viewports already, so this matches web mobile).
class WelcomeHowItWorks extends StatelessWidget {
  const WelcomeHowItWorks({super.key});

  static const _steps = [
    (
      step: 1,
      tag: 'BẮT ĐẦU · A1',
      title: '10,000+ từ vựng, lặp đúng lúc bạn sắp quên.',
      desc:
          'Spaced repetition theo nguyên lý SM-2. App biết bạn ở đâu, gợi lại đúng thời điểm — không lặp quá nhiều, không bỏ sót.',
      bullets: [
        'Cards có ví dụ, ảnh minh hoạ, IPA',
        'Phát âm bản xứ — Hochdeutsch',
        'Tự lưu sổ tay riêng',
      ],
      zone: [Color(0xFFDBEAFE), Color(0xFFE0F2FE)],
    ),
    (
      step: 2,
      tag: "LUYỆN · 5'/NGÀY",
      title: 'Chơi để học. Không cảm thấy đang học.',
      desc:
          'Sáu mini-game thay đổi mỗi ngày. Streak giữ động lực, leaderboard so kè với bạn người Việt khác.',
      bullets: [
        'Chỉ 5 phút/ngày, có cả lúc đợi xe',
        'Streak + huy hiệu — nghiện học như nghiện game',
        'Thách đấu bạn bè · BXH tuần',
      ],
      zone: [Color(0xFFFEF3C7), Color(0xFFFFEDD5)],
    ),
    (
      step: 3,
      tag: 'ĐỖ · A2 → C1',
      title: 'Đề thi mô phỏng sát thực tế, chấm theo barem chuẩn.',
      desc:
          'Goethe A1–B2, telc B1–C1, ÖSD A2–C1. Bốn kỹ năng — biết yếu chỗ nào để luyện thêm.',
      bullets: [
        'Đề bám sát đề thật, ra liên tục hàng tháng',
        'Schreiben + Sprechen có AI feedback',
        'Phân tích yếu/mạnh theo skill',
      ],
      zone: [Color(0xFFFFE4E6), Color(0xFFFCE7F3)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('cach-hoc'),
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 40),
      child: Column(
        children: [
          const WelcomeSectionHead(
            eyebrow: 'Cách học',
            title: 'Ba bước — từ A1 đến ',
            titleEmphasis: 'giấy mời nhập học.',
            lede:
                'Đặt mục tiêu → học mỗi ngày 5 phút → kiểm tra trước khi thi thật. Hệ thống lo phần còn lại.',
          ),
          const SizedBox(height: 32),
          for (final s in _steps) ...[
            _ShowcaseRow(
              step: s.step,
              tag: s.tag,
              title: s.title,
              desc: s.desc,
              bullets: s.bullets,
              zone: s.zone,
            ),
            const SizedBox(height: 28),
          ],
        ],
      ),
    );
  }
}

/// Small illustration card mirroring `VocabIllu`/`GameIllu`/`ExamIllu` —
/// simplified single-state preview per step (web illustrations are static
/// mock screenshots, not interactive; kept minimal here by design).
class _MiniIllustration extends StatelessWidget {
  const _MiniIllustration({required this.step});
  final int step;

  @override
  Widget build(BuildContext context) {
    final (title, subtitle) = switch (step) {
      1 => ('Beruf', 'nghề nghiệp, công việc'),
      2 => ('die Schule ✓', 'Streak 27 · Điểm 2,450'),
      _ => ('Goethe B1 · ĐỖ', 'Tổng: 76.3/100'),
    };
    // Decorative "screenshot" content, like web's static `.illu-card` mock —
    // pinned to the system default text scale so it never outgrows the
    // fixed 5:4 illustration frame (mirrors a real screenshot not
    // reflowing with OS font-size settings).
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: Container(
        width: 190,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2E000000),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: WelPalette.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: WelPalette.inkMuted55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShowcaseRow extends StatelessWidget {
  const _ShowcaseRow({
    required this.step,
    required this.tag,
    required this.title,
    required this.desc,
    required this.bullets,
    required this.zone,
  });

  final int step;
  final String tag;
  final String title;
  final String desc;
  final List<String> bullets;
  final List<Color> zone;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
          decoration: BoxDecoration(
            color: const Color(0x1AF97316),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 11,
                backgroundColor: WelPalette.orange500,
                child: Text(
                  '$step',
                  style: const TextStyle(fontSize: 11, color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  tag,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: WelPalette.orange500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          style: const TextStyle(
            fontFamily: WelPalette.displayFont,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            height: 1.1,
            color: WelPalette.ink,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          desc,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: WelPalette.inkMuted60,
          ),
        ),
        const SizedBox(height: 14),
        for (final b in bullets)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Color(0xFFDCFCE7),
                    child: Icon(
                      PhosphorIcons.check,
                      size: 12,
                      color: WelPalette.green700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    b,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: WelPalette.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 5 / 4,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: zone,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(child: _MiniIllustration(step: step)),
          ),
        ),
      ],
    );
  }
}
