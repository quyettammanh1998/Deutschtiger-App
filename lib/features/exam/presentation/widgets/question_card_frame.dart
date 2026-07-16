// ignore_for_file: prefer_initializing_formals
//
// Khung chung cho mọi question renderer: badge số câu + prompt text.
//
// Web parity (mobile player rebuild wave B): khi word-lookup bật, prompt
// hiển thị qua `TappableSentence` (tap 1 từ → mở `WordLookupSheet`, dùng
// chung 2 widget đã có ở `lib/shared/widgets/`). Highlight là toggle theo từ
// (đơn giản hoá so với CSS Custom Highlight API của web — xem
// `reader_prefs.dart`), áp dụng bằng background màu trên từng token.
// Interface công khai (constructor params) KHÔNG đổi — cần optional
// [questionId] để khoá state highlight/lookup theo câu; renderer con không
// cần sửa nếu không truyền, chỉ mất tap-lookup/highlight cho câu đó.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_tokens.dart';
import '../../../../core/exam_design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/tappable_sentence.dart';
import '../../../../shared/widgets/word_lookup_sheet.dart';
import 'mobile_player/exam_player_palette.dart';
import 'mobile_player/reader_prefs.dart';

class QuestionCardFrame extends ConsumerWidget {
  const QuestionCardFrame({
    super.key,
    required this.questionNumber,
    required this.sectionLabel,
    required this.prompt,
    this.topSlot,
    this.questionId,
  });

  final int questionNumber;
  final String sectionLabel;
  final String prompt;
  final Widget? topSlot;

  /// Khoá tra cứu highlight theo câu — dùng [ExamQuestion.answerKey] nếu có.
  /// Null → vẫn hiển thị tappable/highlight nhưng dùng chung 1 khoá rỗng
  /// (chấp nhận được vì mỗi `QuestionCardFrame` chỉ render 1 câu tại 1 thời
  /// điểm trên màn).
  final String? questionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final wordLookupEnabled = ref.watch(wordLookupEnabledProvider);
    final highlight = ref.watch(highlightControllerProvider);
    final key = questionId ?? '';
    final promptStyle = const TextStyle(
      fontSize: 15,
      height: 1.55,
      color: ExamDesignTokens.examTextPrimary,
      fontWeight: FontWeight.w400,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ExamDesignTokens.examCardPadding),
      decoration: BoxDecoration(
        color: ExamDesignTokens.examPaperColor,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: ExamDesignTokens.examBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: DesignTokens.spacingSm,
            runSpacing: DesignTokens.spacingXs,
            children: [
              _Badge(
                label: l10n.examQuestionNumber(questionNumber),
                color: ExamDesignTokens.examActive,
              ),
              _Badge(
                label: sectionLabel,
                color: ExamDesignTokens.examActiveStrong,
                soft: true,
              ),
            ],
          ),
          if (topSlot != null) ...[
            const SizedBox(height: DesignTokens.spacingMd),
            topSlot!,
          ],
          const SizedBox(height: DesignTokens.spacingMd),
          if (highlight.enabled)
            _HighlightableText(
              text: prompt,
              style: promptStyle,
              highlighted: highlight.marks[key] ?? const {},
              highlightColor:
                  examHighlightColors[highlight.activeColorIndex %
                      examHighlightColors.length],
              onWordTap: (word) => ref
                  .read(highlightControllerProvider.notifier)
                  .toggleWord(key, word),
            )
          else if (wordLookupEnabled)
            TappableSentence(
              text: prompt,
              style: promptStyle,
              onWordTap: (word) => showWordLookupSheet(context, word: word),
            )
          else
            SelectableText(prompt, style: promptStyle),
        ],
      ),
    );
  }
}

/// Word-level highlight painter (tap-to-mark), dùng khi highlight mode bật.
/// Đơn giản hoá so với web (range/CSS Custom Highlight API) — ghi chú
/// deviation trong report.
class _HighlightableText extends StatelessWidget {
  const _HighlightableText({
    required this.text,
    required this.style,
    required this.highlighted,
    required this.highlightColor,
    required this.onWordTap,
  });

  final String text;
  final TextStyle style;
  final Set<String> highlighted;
  final Color highlightColor;
  final ValueChanged<String> onWordTap;

  static final _tokenRegex = RegExp(r'\S+');
  static final _stripRegex = RegExp(
    r'^[^\p{L}\p{N}]+|[^\p{L}\p{N}]+$',
    unicode: true,
  );

  @override
  Widget build(BuildContext context) {
    final matches = _tokenRegex.allMatches(text).toList();
    final spans = <InlineSpan>[];
    var cursor = 0;
    for (final m in matches) {
      if (m.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, m.start)));
      }
      final raw = m.group(0)!;
      final clean = raw.replaceAll(_stripRegex, '');
      final isMarked =
          clean.isNotEmpty && highlighted.contains(clean.toLowerCase());
      spans.add(
        TextSpan(
          text: raw,
          style: isMarked
              ? style.copyWith(backgroundColor: highlightColor)
              : style,
          recognizer: clean.isEmpty
              ? null
              : (TapGestureRecognizer()..onTap = () => onWordTap(clean)),
        ),
      );
      cursor = m.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }
    return SelectableText.rich(TextSpan(style: style, children: spans));
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color, this.soft = false});

  final String label;
  final Color color;
  final bool soft;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingSm,
        vertical: DesignTokens.spacingXs / 2,
      ),
      decoration: BoxDecoration(
        color: soft ? color.withValues(alpha: 0.08) : color,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm / 2),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: soft ? color : Colors.white,
        ),
      ),
    );
  }
}
