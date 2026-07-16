import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/practice/practice_result.dart';
import '../../../data/practice/practice_round_item.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/providers.dart';
import '../../../widgets/common/answer_diff_view.dart';
import 'practice_progress_header.dart';

/// "Điền từ" (`/games/cloze`, web `practice-cloze-page.tsx` → `PracticeCloze`)
/// — chèn ô trống inline vào câu ví dụ của [PracticeRoundItem], người dùng
/// gõ lại từ tiếng Đức đúng. Round type = [PracticeRoundItem] (nguồn-agnostic:
/// deck word hoặc learning item) nên mission runner (P3) và guided-lesson
/// (P5) tái dùng được trực tiếp. Khi item không có câu ví dụ, hiển thị gợi ý
/// bằng nghĩa tiếng Việt thay vì bỏ item.
///
/// Không port toàn bộ reinforcement state machine của web (nhiều vòng lặp
/// tùy chỉnh) — rút gọn còn 1 vòng "gõ lại cho đúng" sau khi sai (YAGNI),
/// vẫn giữ trải nghiệm cốt lõi: xem diff → thử lại → qua câu tiếp theo.
class PracticeClozeView extends ConsumerStatefulWidget {
  const PracticeClozeView({super.key, required this.items, required this.onComplete});

  final List<PracticeRoundItem> items;
  final void Function(List<PracticeResultEntry>) onComplete;

  @override
  ConsumerState<PracticeClozeView> createState() => _PracticeClozeViewState();
}

class _PracticeClozeViewState extends ConsumerState<PracticeClozeView> {
  int _index = 0;
  bool? _isCorrect;
  bool _reinforcing = false;
  bool _hintShown = false;
  int _xp = 0;
  final _controller = TextEditingController();
  final _results = <PracticeResultEntry>[];

  PracticeRoundItem get _current => widget.items[_index];

  ({String before, String after}) get _segments {
    final example = _current.example?.trim();
    if (example != null && example.isNotEmpty) {
      final pattern = RegExp(RegExp.escape(_current.word), caseSensitive: false);
      final match = pattern.firstMatch(example);
      if (match != null) {
        return (before: example.substring(0, match.start), after: example.substring(match.end));
      }
    }
    return (before: '', after: '');
  }

  bool get _hasSentence => _current.example != null && _current.example!.trim().isNotEmpty;

  Future<void> _play() => ref.read(audioServiceProvider).play(text: _current.word);

  void _submit() {
    if (_isCorrect != null) return;
    final answer = _controller.text.trim();
    final correct = answer.toLowerCase() == _current.word.trim().toLowerCase();

    setState(() => _isCorrect = correct);

    if (correct) {
      setState(() => _xp += _reinforcing ? 5 : 10);
      Future.delayed(const Duration(milliseconds: 700), _advance);
    } else if (!_reinforcing) {
      // First miss: show diff + require one clean retype (simplified reinforce loop).
      setState(() => _reinforcing = true);
    } else {
      // Missed the reinforced retype too — record as not-clean and move on.
      Future.delayed(const Duration(milliseconds: 1200), _advance);
    }
  }

  void _advance() {
    if (!mounted) return;
    _results.add(
      PracticeResultEntry(
        cardId: _current.id,
        correct: _isCorrect ?? false,
        userAnswer: _controller.text.trim(),
        correctAnswer: _current.word,
      ),
    );
    if (_index < widget.items.length - 1) {
      setState(() {
        _index++;
        _isCorrect = null;
        _reinforcing = false;
        _hintShown = false;
        _controller.clear();
      });
    } else {
      widget.onComplete(_results);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final segments = _segments;

    return Column(
      children: [
        PracticeProgressHeader(current: _index + 1, total: widget.items.length, xp: _xp),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (_reinforcing && _isCorrect == false)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AnswerDiffView(userAnswer: _controller.text, correctAnswer: _current.word),
                ),
              _hasSentence
                  ? Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(segments.before, style: Theme.of(context).textTheme.headlineSmall),
                        _blank(tokens),
                        Text(segments.after, style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    )
                  : Column(
                      children: [
                        Text(
                          l10n.practiceClozeHint,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: tokens.mutedForeground),
                        ),
                        const SizedBox(height: 8),
                        Text(_current.translation, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 12),
                        _blank(tokens, width: 160),
                      ],
                    ),
              if (_current.exampleTranslation != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _current.exampleTranslation!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: tokens.mutedForeground, fontStyle: FontStyle.italic),
                  ),
                ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: [
                  _pillButton(
                    tokens,
                    icon: AppPhosphorIcons.speakerHigh,
                    label: l10n.practiceListenPill,
                    color: tokens.primary,
                    onTap: _play,
                  ),
                  if (!_hintShown && _isCorrect == null)
                    _pillButton(
                      tokens,
                      icon: AppPhosphorIcons.lightbulb,
                      label: l10n.practiceHintPill,
                      color: tokens.warning,
                      onTap: () => setState(() => _hintShown = true),
                    ),
                ],
              ),
              if (_hintShown && _isCorrect == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    l10n.practiceHintLetter(_current.word.isNotEmpty ? _current.word[0] : ''),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: tokens.warning, fontWeight: FontWeight.w600),
                  ),
                ),
              const SizedBox(height: 20),
              Center(
                child: FilledButton(
                  onPressed: _isCorrect == true ? null : _submit,
                  child: Text(
                    _isCorrect == false ? l10n.practiceRetryAnswer : l10n.practiceCheckAnswer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _blank(AppTokens tokens, {double width = 120}) {
    final revealColor = _isCorrect == null ? tokens.primary : (_isCorrect! ? tokens.success : tokens.destructive);
    return SizedBox(
      width: width,
      child: TextField(
        key: const Key('practice_cloze_input'),
        controller: _controller,
        enabled: _isCorrect != true,
        textAlign: TextAlign.center,
        autocorrect: false,
        style: TextStyle(color: revealColor, fontWeight: FontWeight.w700, fontSize: 18),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: revealColor, width: 2)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: revealColor, width: 2)),
        ),
        onSubmitted: (_) => _submit(),
      ),
    );
  }

  Widget _pillButton(
    AppTokens tokens, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
