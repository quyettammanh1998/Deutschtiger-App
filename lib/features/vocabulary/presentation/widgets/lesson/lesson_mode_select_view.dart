import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../widgets/common/app_card.dart';
import '../../../data/vocab_lesson_utils.dart';

const _modeOrder = [
  VocabLessonMode.quick,
  VocabLessonMode.standard,
  VocabLessonMode.intensive,
];

/// Per-tier accent — web parity `MODE_ACCENT` in `vocabulary-lesson-page.tsx`.
const Map<VocabLessonMode, Color> _accentColors = {
  VocabLessonMode.quick: Color(0xFFF59E0B), // amber-500
  VocabLessonMode.standard: Color(0xFFF97316), // orange-500
  VocabLessonMode.intensive: Color(0xFFF43F5E), // rose-500
};

const Map<VocabLessonMode, IconData> _modeIcons = {
  VocabLessonMode.quick: Icons.bolt_rounded,
  VocabLessonMode.standard: Icons.menu_book_rounded,
  VocabLessonMode.intensive: Icons.emoji_events_rounded,
};

/// Phase "select-mode" full-screen body — 3 tier cards (Nhanh/Đầy đủ/Chuyên
/// sâu) + a short "Phiên học gồm" info panel. Web parity: mode-select
/// section of `vocabulary-lesson-page.tsx`.
class LessonModeSelectView extends StatelessWidget {
  const LessonModeSelectView({
    super.key,
    required this.collectionName,
    required this.onSelect,
    this.lastUsed,
  });

  final String collectionName;
  final ValueChanged<VocabLessonMode> onSelect;
  final VocabLessonMode? lastUsed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Học theo lộ trình',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: tokens.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            collectionName.isEmpty ? 'Bắt đầu học' : collectionName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: tokens.foreground,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Chọn nhịp học phù hợp, hệ thống sẽ tự trộn thẻ mới và thẻ cần ôn.',
            style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
          ),
          const SizedBox(height: 20),
          for (final mode in _modeOrder)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ModeCard(
                mode: mode,
                selected: mode == lastUsed,
                onTap: () => onSelect(mode),
              ),
            ),
          AppCard.small(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phiên học gồm',
                  style: TextStyle(fontWeight: FontWeight.w700, color: tokens.foreground),
                ),
                const SizedBox(height: 10),
                _InfoLine(color: const Color(0xFFF97316), text: 'Thẻ mới theo chủ đề hiện tại'),
                _InfoLine(color: const Color(0xFF3B82F6), text: 'Thẻ cần ôn theo lịch SRS'),
                _InfoLine(color: const Color(0xFF10B981), text: 'Lưu tiến độ để học tiếp'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.color, required this.text});
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 13, color: context.tokens.mutedForeground)),
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.mode, required this.selected, required this.onTap});
  final VocabLessonMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final cfg = vocabLessonModeConfig[mode]!;
    final accent = _accentColors[mode]!;
    return Material(
      color: selected ? accent.withValues(alpha: 0.08) : tokens.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: selected ? accent.withValues(alpha: 0.5) : tokens.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_modeIcons[mode], color: accent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          cfg.label,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: tokens.foreground),
                        ),
                        _Chip(text: cfg.time, tokens: tokens),
                        if (selected) _Chip(text: 'Lần trước', tokens: tokens, tinted: accent),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(cfg.desc, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                    const SizedBox(height: 2),
                    Text(
                      cfg.skills,
                      style: TextStyle(fontSize: 11, color: tokens.mutedForeground.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: tokens.mutedForeground.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text, required this.tokens, this.tinted});
  final String text;
  final AppTokens tokens;
  final Color? tinted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: tinted?.withValues(alpha: 0.12) ?? tokens.muted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: tinted ?? tokens.mutedForeground,
        ),
      ),
    );
  }
}
