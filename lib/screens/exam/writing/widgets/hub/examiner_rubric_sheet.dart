import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';

/// "📋 Cách chấm" bottom sheet — web parity `ExaminerRubricSheet`. Long-form
/// Vietnamese rubric copy stays inline (approved exception for reference/
/// tip text — see plan §Nguyên tắc chung).
void showExaminerRubricSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _ExaminerRubricSheet(),
  );
}

class _ExaminerRubricSheet extends StatelessWidget {
  const _ExaminerRubricSheet();

  static const _criteria = [
    (
      'Hoàn thành đề (25đ)',
      'Bài viết trả lời đủ các ý yêu cầu trong đề, đúng thể loại (email/bài luận), độ dài phù hợp.',
    ),
    (
      'Ngữ pháp (25đ)',
      'Chia động từ, thì, giới từ, mạo từ, trật tự từ đúng quy tắc tiếng Đức. Ít lỗi lặp lại.',
    ),
    (
      'Từ vựng (25đ)',
      'Dùng từ đa dạng, đúng ngữ cảnh, đúng trình độ B1 trở lên — không lặp từ quá nhiều.',
    ),
    (
      'Liên kết (25đ)',
      'Câu văn mạch lạc, dùng liên từ (deshalb, außerdem, jedoch…) để nối ý, đoạn văn có cấu trúc rõ ràng.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: tokens.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: tokens.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '📋 Cách AI chấm bài viết',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: tokens.foreground),
            ),
            const SizedBox(height: 6),
            Text(
              'Thang điểm 100, chia đều 4 tiêu chí theo khung Goethe/telc. AI chấm dựa trên bản '
              'đề gốc và các ý yêu cầu — điểm chỉ mang tính tham khảo, không thay thế kết quả thi thật.',
              style: TextStyle(fontSize: 13, color: tokens.mutedForeground, height: 1.4),
            ),
            const SizedBox(height: 16),
            for (final c in _criteria)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.$1,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tokens.foreground),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      c.$2,
                      style: TextStyle(fontSize: 12, color: tokens.mutedForeground, height: 1.4),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
