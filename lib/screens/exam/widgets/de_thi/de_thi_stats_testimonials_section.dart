import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../widgets/common/app_card.dart';

/// Web parity: `StatsRow` + `Testimonials` in `de-thi-list-page.tsx` —
/// hardcoded SEO trust-block copy (approved plan exception, not localized).
const List<(String value, String label, Color color)> _stats = [
  ('12.5k', 'Học viên đang học', Color(0xFFDB2777)),
  ('10k+', 'Từ vựng A1–C1', Color(0xFF0284C7)),
  ('149', 'Bài ngữ pháp', Color(0xFF7C3AED)),
  ('AI', 'Chấm Viết & Nói', Color(0xFF059669)),
];

const List<
  (
    String who,
    String initial,
    String sub,
    String level,
    List<Color> gradient,
    String quote,
  )
>
_testimonials = [
  (
    'Như Anh',
    'N',
    'Đại học TU Berlin · Khóa 2024',
    'B1',
    [Color(0xFFFBBF24), Color(0xFFF97316)],
    'Đề thi thử sát thực tế. Mình đậu B1 ngay lần đầu nhờ luyện ở đây — tiết kiệm hẳn ba tháng so với học truyền thống.',
  ),
  (
    'Duyên Vũ',
    'D',
    'Tự học · Hà Nội',
    'A2',
    [Color(0xFFA78BFA), Color(0xFF7C3AED)],
    'Phần game giúp mình nhớ từ nhanh hơn hẳn chép tay. Streak 90 ngày rồi, không bỏ một ngày nào.',
  ),
  (
    'Mạnh Nguyễn',
    'M',
    'Du học sinh Munich',
    'B2',
    [Color(0xFF34D399), Color(0xFF10B981)],
    'Giao diện dễ dùng, vừa học từ vừa luyện nghe trong cùng app. Phần dịch nghĩa bằng tiếng Việt rất chính xác.',
  ),
];

class DeThiStatsTestimonialsSection extends StatelessWidget {
  const DeThiStatsTestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Giới thiệu Deutsch Tiger',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: tokens.foreground,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (final stat in _stats)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: AppCard.small(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        Text(
                          stat.$1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: stat.$3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          stat.$2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.2,
                            color: tokens.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Người Việt học tiếng Đức ở đây',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: tokens.foreground,
          ),
        ),
        const SizedBox(height: 12),
        for (final t in _testimonials)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard.card(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: t.$5),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          t.$2,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.$1,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: tokens.foreground,
                              ),
                            ),
                            Text(
                              t.$3,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: tokens.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: tokens.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          t.$4,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: tokens.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '"${t.$6}"',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: tokens.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
