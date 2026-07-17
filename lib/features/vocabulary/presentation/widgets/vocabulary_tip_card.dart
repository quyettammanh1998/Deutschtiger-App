import 'dart:math';

import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// "💡 Mẹo học tập" card — simplified web parity of `LearningTipCard`: the
/// web version reads a rotating tip from a dedicated tips backend/query
/// (`useRandomTip`, `TIP_TOPIC_LABELS`) that has no Flutter data layer yet;
/// wiring a new tips API is out of this pass's scope (no new backend
/// contract). This ports the AMBER card chrome + "tiếp" rotation UX with a
/// small static VN tip set instead — matches the plan's exception for
/// short hardcoded VN copy.
class VocabularyTipCard extends StatefulWidget {
  const VocabularyTipCard({super.key});

  @override
  State<VocabularyTipCard> createState() => _VocabularyTipCardState();
}

const _kTips = [
  'Danh từ tiếng Đức luôn viết hoa chữ cái đầu, kể cả giữa câu.',
  'Học từ theo cụm (der/die/das + danh từ) thay vì học từ đơn lẻ để nhớ giống từ tốt hơn.',
  'Ôn lại từ đã học trong vòng 24 giờ đầu giúp tăng tỉ lệ ghi nhớ dài hạn rõ rệt.',
  'Đặt câu ví dụ với từ mới ngay khi học — trí nhớ ngữ cảnh bền hơn học từ đơn lẻ.',
  'Nghe lại phát âm nhiều lần trước khi tự đọc to — tai quen trước, miệng theo sau.',
];

class _VocabularyTipCardState extends State<VocabularyTipCard> {
  late int _index = Random().nextInt(_kTips.length);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Light: warm cream chrome + deep amber ink (web parity).
    // Dark: translucent amber tint + light amber ink for readable contrast.
    final backgroundColor = isDark ? const Color(0x33F59E0B) : const Color(0xFFFFFBEB);
    final amberInk = isDark ? const Color(0xFFFCD34D) : const Color(0xFF92400E);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _kTips[_index],
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF92400E)),
            ),
          ),
          InkWell(
            onTap: () => setState(() => _index = (_index + 1) % _kTips.length),
            borderRadius: BorderRadius.circular(999),
            child: const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(Icons.refresh, size: 16, color: Color(0xFF92400E)),
            ),
          ),
        ],
      ),
    );
  }
}
