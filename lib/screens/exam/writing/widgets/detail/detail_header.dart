import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/goethe_b1_writing_topic.dart';
import '../../../../../l10n/app_localizations.dart';

/// Reader header — web parity `detail-header.tsx`: back + title/titleVi +
/// font-scale control, difficulty/frequency/HOT badges, meta row.
///
/// DEVIATION: the full sequential-playlist "Phát toàn bộ (N)" autoplay
/// transport (prev/pause/next/counter, sub-sentence karaoke highlight) is
/// simplified to a single "Phát toàn bộ" pill that plays each collected
/// sentence back-to-back via [WritingAudioPlayButton]'s shared exclusive
/// player, opening every section first — no scroll-follow/highlight, no
/// fixed top-right transport bar while playing. Documented deviation (see
/// phase report); acceptable given effort budget, not a data gap.
class WritingDetailHeader extends StatelessWidget {
  const WritingDetailHeader({
    super.key,
    required this.topic,
    required this.fontScale,
    required this.onFontScaleChange,
    required this.onPlayAll,
    required this.canPlayAll,
  });

  final GoetheB1WritingTopic topic;
  final double fontScale;
  final ValueChanged<double> onFontScaleChange;
  final VoidCallback onPlayAll;
  final bool canPlayAll;

  static const _difficultyColors = {
    'easy': Color(0xFF16A34A),
    'medium': Color(0xFFB45309),
    'hard': Color(0xFFDC2626),
  };

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final isHot = topic.frequencyStars >= 5;
    final diffColor = _difficultyColors[topic.difficulty];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(topic.titleDe,
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: tokens.foreground)),
                    if (topic.titleVi.isNotEmpty)
                      Text(topic.titleVi,
                          style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: tokens.mutedForeground)),
                  ],
                ),
              ),
            ),
            _FontScaleControl(scale: fontScale, onChange: onFontScaleChange),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            if (topic.textType != null)
              _Pill(topic.textType!, const Color(0xFFFFFBEB), const Color(0xFFB45309)),
            if (diffColor != null)
              _Pill(_difficultyLabel(l10n, topic.difficulty!), diffColor.withValues(alpha: 0.12), diffColor),
            if (topic.frequencyStars > 0)
              Text('★' * topic.frequencyStars.clamp(0, 5) + '☆' * (5 - topic.frequencyStars.clamp(0, 5)),
                  style: const TextStyle(fontSize: 12, color: Color(0xFFF59E0B))),
            if (isHot) _Pill(l10n.writingHotBadge, const Color(0xFFFFF7ED), const Color(0xFFEA580C)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  if (topic.taskWordCount != null)
                    _MetaText('📏 ~${topic.taskWordCount!.target} ${l10n.writingWordsUnit}'),
                  if (topic.examDates.isNotEmpty)
                    _MetaText(l10n.writingExamTimesCount(topic.examDates.length)),
                  if (topic.durationMin != null)
                    _MetaText('⏱ ${topic.durationMin} ${l10n.writingMinutesUnit}'),
                ],
              ),
            ),
            if (canPlayAll)
              InkWell(
                onTap: onPlayAll,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFF97316), Color(0xFFEA580C)]),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.play_arrow, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(l10n.writingPlayAll,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  String _difficultyLabel(AppLocalizations l10n, String value) => switch (value) {
        'easy' => l10n.writingDifficultyEasy,
        'hard' => l10n.writingDifficultyHard,
        _ => l10n.writingDifficultyMedium,
      };
}

class _MetaText extends StatelessWidget {
  const _MetaText(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Text(text, style: TextStyle(fontSize: 11, color: tokens.mutedForeground));
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.label, this.bg, this.fg);
  final String label;
  final Color bg;
  final Color fg;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
        child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: fg)),
      );
}

/// A-/A+ font scale pill — web parity `font-size-control.tsx`. Range
/// 0.85-1.6 step 0.1.
class _FontScaleControl extends StatelessWidget {
  const _FontScaleControl({required this.scale, required this.onChange});
  final double scale;
  final ValueChanged<double> onChange;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: tokens.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Text('A−', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            onPressed: scale <= 0.85 ? null : () => onChange((scale - 0.1).clamp(0.85, 1.6)),
          ),
          Text('${(scale * 100).round()}%',
              style: TextStyle(fontSize: 10, color: tokens.mutedForeground)),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Text('A+', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            onPressed: scale >= 1.6 ? null : () => onChange((scale + 0.1).clamp(0.85, 1.6)),
          ),
        ],
      ),
    );
  }
}
