import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Fullscreen typing-practice runner — simplified web parity
/// `TypingPracticeSheet`/`TypingPracticeRunner`.
///
/// DEVIATIONS (documented, named follow-ups, not silent drops):
/// - No group picker step (web: checkbox groups → "Bắt đầu gõ n câu →");
///   this runs straight through every collected sentence in order.
/// - No `sessionStorage`/local-persisted resume across app restarts.
/// - No masked/reveal toggle or word-diff highlighting — plain textfield
///   input, exact-match-after-normalize check with a correct/incorrect
///   banner (case/punctuation-insensitive compare, matching web's core
///   comparison rule even though the surrounding UI is simplified).
class TypingPracticeSheet extends StatefulWidget {
  const TypingPracticeSheet({super.key, required this.sentences});

  final List<String> sentences;

  static Future<void> show(BuildContext context, {required List<String> sentences}) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => TypingPracticeSheet(sentences: sentences), fullscreenDialog: true),
    );
  }

  @override
  State<TypingPracticeSheet> createState() => _TypingPracticeSheetState();
}

class _TypingPracticeSheetState extends State<TypingPracticeSheet> {
  final _controller = TextEditingController();
  int _index = 0;
  int _correct = 0;
  int _wrong = 0;
  bool? _lastCorrect;

  static String _normalize(String s) =>
      s.toLowerCase().replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), '').trim();

  bool get _isDone => _index >= widget.sentences.length;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _check() {
    final expected = widget.sentences[_index];
    final ok = _normalize(_controller.text) == _normalize(expected);
    setState(() {
      _lastCorrect = ok;
      if (ok) {
        _correct++;
      } else {
        _wrong++;
      }
    });
  }

  void _next() {
    setState(() {
      _index++;
      _controller.clear();
      _lastCorrect = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: Text(l10n.writingTypingPracticeTitle),
        leading: IconButton(icon: const Icon(PhosphorIcons.x), onPressed: () => Navigator.of(context).pop()),
      ),
      body: SafeArea(
        child: _isDone ? _buildCompletion(tokens, l10n) : _buildRunner(tokens, l10n),
      ),
    );
  }

  Widget _buildRunner(AppTokens tokens, AppLocalizations l10n) {
    final expected = widget.sentences[_index];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(value: (_index) / widget.sentences.length),
          const SizedBox(height: 8),
          Text(l10n.writingTypingProgress(_index + 1, widget.sentences.length),
              style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: tokens.muted.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(12)),
            child: Text(
              _lastCorrect == null ? '•' * expected.replaceAll(' ', '').length : expected,
              style: TextStyle(fontSize: 15, color: tokens.foreground, fontFamily: _lastCorrect == null ? 'monospace' : null),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            maxLines: 2,
            enabled: _lastCorrect == null,
            decoration: InputDecoration(
              hintText: l10n.writingTypingHint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onSubmitted: (_) => _lastCorrect == null ? _check() : _next(),
          ),
          const SizedBox(height: 12),
          if (_lastCorrect != null)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _lastCorrect! ? const Color(0xFFF0FDF4) : const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _lastCorrect! ? l10n.writingTypingCorrect : l10n.writingTypingIncorrect,
                style: TextStyle(fontSize: 13, color: _lastCorrect! ? const Color(0xFF15803D) : const Color(0xFFB45309)),
              ),
            ),
          const Spacer(),
          Row(
            children: [
              OutlinedButton(onPressed: _next, child: Text(l10n.writingTypingSkip)),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: _lastCorrect == null ? _check : _next,
                  child: Text(_lastCorrect == null ? l10n.writingTypingCheck : l10n.writingTypingNext),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletion(AppTokens tokens, AppLocalizations l10n) {
    final total = widget.sentences.length;
    final pct = total == 0 ? 0 : (_correct / total * 100).round();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(pct >= 90 ? '🎉' : pct >= 70 ? '👏' : pct >= 50 ? '👍' : '💪', style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(l10n.writingTypingDoneCount(total), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: tokens.foreground)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StatTile(label: l10n.writingTypingCorrect, value: '$_correct', color: const Color(0xFF15803D)),
                const SizedBox(width: 10),
                _StatTile(label: l10n.writingTypingIncorrect, value: '$_wrong', color: const Color(0xFFDC2626)),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.writingTypingClose),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: tokens.muted.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 10, color: tokens.mutedForeground)),
        ],
      ),
    );
  }
}
