import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../shared/widgets/speak_button.dart';
import '../../vocab_lesson_session_controller.dart';

/// [VocabCardMode.compose] renderer — write a full sentence using the
/// target word, AI-graded. Web parity: `ComposeCard`. Use
/// `key: ValueKey(card.id)` at the call site.
class LessonComposeCard extends StatefulWidget {
  const LessonComposeCard({
    super.key,
    required this.wordDe,
    required this.wordVi,
    required this.referenceDe,
    required this.referenceVi,
    required this.audioUrl,
    required this.correct,
    required this.feedback,
    required this.checking,
    required this.onInputChange,
    required this.onSubmit,
  });

  final String wordDe;
  final String wordVi;
  final String referenceDe;
  final String referenceVi;
  final String audioUrl;
  final bool? correct;
  final GradeFeedback? feedback;
  final bool checking;
  final ValueChanged<String> onInputChange;
  final VoidCallback onSubmit;

  @override
  State<LessonComposeCard> createState() => _LessonComposeCardState();
}

class _LessonComposeCardState extends State<LessonComposeCard> {
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
          Text('VIẾT MỘT CÂU DÙNG TỪ NÀY', style: TextStyle(fontSize: 11, letterSpacing: 1, color: tokens.mutedForeground)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.wordDe, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: tokens.foreground)),
              if (widget.audioUrl.isNotEmpty) SpeakButton(text: widget.wordDe, audioUrl: widget.audioUrl, iconSize: 18),
            ],
          ),
          if (widget.wordVi.isNotEmpty) Text(widget.wordVi, style: TextStyle(fontSize: 13, color: tokens.mutedForeground)),
          const SizedBox(height: 8),
          TextField(
            enabled: !locked,
            controller: _controller,
            onChanged: widget.onInputChange,
            maxLines: 3,
            decoration: InputDecoration(hintText: 'Viết một câu tiếng Đức dùng từ này...', filled: true, fillColor: tokens.background),
          ),
          const SizedBox(height: 10),
          if (widget.checking)
            const Padding(padding: EdgeInsets.all(8), child: Text('AI đang chấm câu…', style: TextStyle(fontSize: 12)))
          else if (widget.correct != null)
            _ComposeResult(correct: widget.correct!, feedback: widget.feedback, referenceDe: widget.referenceDe, referenceVi: widget.referenceVi)
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

class _ComposeResult extends StatelessWidget {
  const _ComposeResult({required this.correct, this.feedback, required this.referenceDe, required this.referenceVi});
  final bool correct;
  final GradeFeedback? feedback;
  final String referenceDe;
  final String referenceVi;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final color = correct ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(correct ? '✓ Câu hợp lý!' : '✗ Câu chưa ổn', style: TextStyle(color: color, fontWeight: FontWeight.w700)),
          if ((feedback?.hint ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('💡 ${feedback!.hint}', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: color)),
          ],
          if ((feedback?.suggestion ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('Gợi ý sửa: ${feedback!.suggestion}', style: TextStyle(fontSize: 12, color: color)),
          ],
          if (referenceDe.isNotEmpty) ...[
            const Divider(height: 18),
            Text('CÂU MẪU', style: TextStyle(fontSize: 10, letterSpacing: 1, color: tokens.mutedForeground)),
            Text(referenceDe, style: TextStyle(fontSize: 13, color: tokens.foreground)),
            if (referenceVi.isNotEmpty) Text(referenceVi, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
          ],
        ],
      ),
    );
  }
}
