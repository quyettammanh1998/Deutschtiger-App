import 'package:flutter/material.dart';

import '../../../../core/icons/app_phosphor_icons.dart';
import '../../../../core/theme/app_tokens.dart';

/// Web parity: `FaqAccordion` in `de-thi-list-page.tsx` — hardcoded SEO
/// trust-block copy, kept inline (approved plan exception, not localized).
const List<(String, String)> _deThiFaq = [
  (
    'Đề thi tiếng Đức trên Deutsch Tiger có phải đề chính thức không?',
    'Các đề thi là đề THPT Quốc gia và đề tham khảo Goethe/Telc B1. Đáp án tham khảo được ghi chú rõ ràng. Mục tiêu là giúp bạn làm quen với cấu trúc đề và rèn kỹ năng đọc hiểu thực tế.',
  ),
  (
    'Làm đề thi có mất phí không?',
    'Hoàn toàn miễn phí, không cần đăng nhập. Bạn có thể làm bài, chấm điểm tại chỗ và xem giải thích đáp án ngay trên trình duyệt.',
  ),
  (
    'Hệ thống chấm điểm hoạt động thế nào?',
    'Sau khi nộp bài, hệ thống tự động chấm và hiển thị kết quả chi tiết từng câu — câu đúng, câu sai và giải thích tại sao. Phần dịch nghĩa tiếng Việt giúp bạn hiểu rõ ngữ cảnh.',
  ),
  (
    'Có thể luyện thêm các kỹ năng khác ngoài đọc hiểu không?',
    'Có. Deutsch Tiger có đầy đủ 4 kỹ năng: Đọc hiểu (Lesen), Nghe hiểu (Hören), Viết (Schreiben có AI chấm điểm) và Nói (Sprechen có AI chấm phát âm). Đăng ký miễn phí để truy cập.',
  ),
  (
    'Deutsch Tiger phù hợp với ai?',
    'Học sinh THPT học tiếng Đức, người Việt đang luyện thi Goethe/Telc B1–B2, du học sinh cần ôn thi DSH/TestDaF, hoặc bất kỳ ai muốn học tiếng Đức từ A1 với giao diện hỗ trợ tiếng Việt.',
  ),
];

class DeThiFaqSection extends StatefulWidget {
  const DeThiFaqSection({super.key});

  @override
  State<DeThiFaqSection> createState() => _DeThiFaqSectionState();
}

class _DeThiFaqSectionState extends State<DeThiFaqSection> {
  int? _open = 0;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Câu hỏi thường gặp',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: tokens.foreground,
          ),
        ),
        const SizedBox(height: 12),
        DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.card,
            borderRadius: BorderRadius.circular(tokens.radius),
            border: Border.all(color: tokens.border),
          ),
          child: Column(
            children: [
              for (var i = 0; i < _deThiFaq.length; i++)
                _FaqItem(
                  question: _deThiFaq[i].$1,
                  answer: _deThiFaq[i].$2,
                  open: _open == i,
                  showDivider: i > 0,
                  onTap: () => setState(() => _open = _open == i ? null : i),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FaqItem extends StatelessWidget {
  const _FaqItem({
    required this.question,
    required this.answer,
    required this.open,
    required this.showDivider,
    required this.onTap,
  });

  final String question;
  final String answer;
  final bool open;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: showDivider
            ? Border(top: BorderSide(color: tokens.border))
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: tokens.foreground,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      AppPhosphorIcons.caretDown,
                      size: 16,
                      color: tokens.mutedForeground,
                    ),
                  ),
                ],
              ),
              if (open) ...[
                const SizedBox(height: 8),
                Text(
                  answer,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: tokens.mutedForeground,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
