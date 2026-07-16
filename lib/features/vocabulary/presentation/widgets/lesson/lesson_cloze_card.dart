import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../shared/widgets/speak_button.dart';

/// [VocabCardMode.cloze] renderer — fill the blank in an example sentence.
/// Web parity: `ClozeCard`. Use `key: ValueKey(card.id)` at the call site.
///
/// Renders the blank as an inline [TextField] laid out in a [Wrap] rather
/// than a rich-text inline span, matching the pattern already used by
/// `practice_cloze_view.dart` elsewhere in this app.
class LessonClozeCard extends StatefulWidget {
  const LessonClozeCard({
    super.key,
    required this.prompt,
    required this.target,
    required this.vi,
    required this.audioUrl,
    required this.correct,
    required this.onInputChange,
    required this.onSubmit,
  });

  final String prompt;
  final String target;
  final String vi;
  final String audioUrl;
  final bool? correct;
  final ValueChanged<String> onInputChange;
  final VoidCallback onSubmit;

  @override
  State<LessonClozeCard> createState() => _LessonClozeCardState();
}

class _LessonClozeCardState extends State<LessonClozeCard> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final parts = widget.prompt.split(RegExp('_{2,}|___'));
    final before = parts.isNotEmpty ? parts[0] : '';
    final after = parts.length > 1 ? parts[1] : '';
    final locked = widget.correct != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: tokens.card, borderRadius: BorderRadius.circular(20), border: Border.all(color: tokens.border)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('ĐIỀN TỪ VÀO CHỖ TRỐNG', style: TextStyle(fontSize: 11, letterSpacing: 1, color: tokens.mutedForeground)),
          if (widget.audioUrl.isNotEmpty) SpeakButton(text: widget.target, audioUrl: widget.audioUrl),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (before.isNotEmpty)
                Text(before, style: TextStyle(fontSize: 17, color: tokens.foreground, height: 1.5)),
              SizedBox(
                width: 110,
                child: TextField(
                  enabled: !locked,
                  controller: _controller,
                  onChanged: widget.onInputChange,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFFEA580C), fontWeight: FontWeight.w700),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFEA580C), width: 2)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFEA580C), width: 2)),
                  ),
                ),
              ),
              if (after.isNotEmpty)
                Text(after, style: TextStyle(fontSize: 17, color: tokens.foreground, height: 1.5)),
            ],
          ),
          if (widget.vi.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(widget.vi, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: tokens.mutedForeground)),
          ],
          const SizedBox(height: 12),
          if (widget.correct != null)
            _ResultText(correct: widget.correct!, answer: widget.target)
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

class _ResultText extends StatelessWidget {
  const _ResultText({required this.correct, required this.answer});
  final bool correct;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final color = correct ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: correct ? '✓ Đúng! — Đáp án: ' : '✗ Chưa đúng — Đáp án: ', style: TextStyle(color: color)),
            TextSpan(text: answer, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
