import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../shared/widgets/speak_button.dart';
import '../../vocab_lesson_session_controller.dart';

/// [VocabCardMode.writing] renderer — type the DE word from its VN meaning,
/// AI-graded on mismatch. Web parity: `WritingCard`.
///
/// Give this widget `key: ValueKey(card.id)` at the call site so Flutter
/// tears down and recreates its internal [TextEditingController] whenever
/// the underlying card changes (instead of reusing stale text/cursor state).
class LessonWritingCard extends StatefulWidget {
  const LessonWritingCard({
    super.key,
    required this.wordDe,
    required this.wordVi,
    required this.audioUrl,
    required this.correct,
    required this.feedback,
    required this.checking,
    required this.onInputChange,
    required this.onSubmit,
  });

  final String wordDe;
  final String wordVi;
  final String audioUrl;
  final bool? correct;
  final GradeFeedback? feedback;
  final bool checking;
  final ValueChanged<String> onInputChange;
  final VoidCallback onSubmit;

  @override
  State<LessonWritingCard> createState() => _LessonWritingCardState();
}

class _LessonWritingCardState extends State<LessonWritingCard> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final locked = widget.correct != null || widget.checking;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: tokens.card, borderRadius: BorderRadius.circular(20), border: Border.all(color: tokens.border)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.wordVi.isEmpty ? '—' : widget.wordVi, textAlign: TextAlign.center, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: tokens.foreground)),
          if (widget.audioUrl.isNotEmpty) SpeakButton(text: widget.wordDe, audioUrl: widget.audioUrl),
          const SizedBox(height: 8),
          TextField(
            enabled: !locked,
            controller: _controller,
            onChanged: widget.onInputChange,
            textAlign: TextAlign.center,
            decoration: InputDecoration(hintText: 'Gõ từ tiếng Đức...', filled: true, fillColor: tokens.background),
            onSubmitted: (_) => locked ? null : widget.onSubmit(),
          ),
          const SizedBox(height: 10),
          if (widget.checking)
            const Padding(padding: EdgeInsets.all(8), child: Text('AI đang kiểm tra…', style: TextStyle(fontSize: 12)))
          else if (widget.correct != null)
            _ResultBlock(correct: widget.correct!, answer: widget.feedback?.suggestion ?? widget.wordDe, hint: widget.feedback?.hint)
          else
            FilledButton(
              onPressed: widget.onSubmit,
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF97316), minimumSize: const Size.fromHeight(46)),
              child: const Text('Kiểm tra'),
            ),
        ],
      ),
    );
  }
}

class _ResultBlock extends StatelessWidget {
  const _ResultBlock({required this.correct, required this.answer, this.hint});
  final bool correct;
  final String answer;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final color = correct ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: correct ? '✓ Đúng! — Đáp án: ' : '✗ Chưa đúng — Đáp án: ', style: TextStyle(color: color)),
                TextSpan(text: answer, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          if (hint != null && hint!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('💡 $hint', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: color)),
          ],
        ],
      ),
    );
  }
}

/// [VocabCardMode.choice] renderer — DE word shown, pick the correct VN
/// meaning from 4 options. Web parity: `ChoiceCard`.
class LessonChoiceCard extends StatelessWidget {
  const LessonChoiceCard({
    super.key,
    required this.wordDe,
    required this.wordVi,
    required this.audioUrl,
    required this.options,
    required this.result,
    required this.onSelect,
  });

  final String wordDe;
  final String wordVi;
  final String audioUrl;
  final List<String> options;
  final ChoiceOutcome? result;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: tokens.card, borderRadius: BorderRadius.circular(20), border: Border.all(color: tokens.border)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(wordDe, textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: tokens.foreground)),
          if (audioUrl.isNotEmpty) SpeakButton(text: wordDe, audioUrl: audioUrl),
          const SizedBox(height: 6),
          Text('CHỌN NGHĨA ĐÚNG', style: TextStyle(fontSize: 11, letterSpacing: 1, color: tokens.mutedForeground)),
          const SizedBox(height: 10),
          for (final opt in options)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ChoiceOption(
                option: opt,
                isCorrectAnswer: opt == wordVi,
                isSelected: result?.selected == opt,
                revealed: result != null,
                onTap: () => onSelect(opt),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChoiceOption extends StatelessWidget {
  const _ChoiceOption({
    required this.option,
    required this.isCorrectAnswer,
    required this.isSelected,
    required this.revealed,
    required this.onTap,
  });

  final String option;
  final bool isCorrectAnswer;
  final bool isSelected;
  final bool revealed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    Color bg = tokens.background;
    Color border = tokens.border;
    Color fg = tokens.foreground;
    double opacity = 1;
    if (revealed) {
      if (isCorrectAnswer) {
        bg = const Color(0xFF22C55E).withValues(alpha: 0.15);
        border = const Color(0xFF22C55E);
        fg = const Color(0xFF16A34A);
      } else if (isSelected) {
        bg = const Color(0xFFEF4444).withValues(alpha: 0.15);
        border = const Color(0xFFEF4444);
        fg = const Color(0xFFDC2626);
      } else {
        opacity = 0.6;
      }
    }
    return Opacity(
      opacity: opacity,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: revealed ? null : onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: border)),
            child: Text(option, style: TextStyle(color: fg, fontWeight: FontWeight.w500)),
          ),
        ),
      ),
    );
  }
}
