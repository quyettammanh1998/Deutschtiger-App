import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/decks/deck_models.dart';
import '../../../data/practice/practice_result.dart';
import '../../../l10n/app_localizations.dart';
import 'practice_progress_header.dart';

/// Chế độ "Điền từ" — chèn ô trống vào câu ví dụ của thẻ, người dùng gõ lại
/// từ tiếng Đức đúng. Khi thẻ không có câu ví dụ, hiển thị gợi ý bằng nghĩa
/// tiếng Việt thay vì bỏ thẻ (mọi thẻ trong deck đều luyện được).
class PracticeClozeView extends StatefulWidget {
  const PracticeClozeView({
    super.key,
    required this.words,
    required this.onComplete,
  });

  final List<DeckWord> words;
  final void Function(List<PracticeResultEntry>) onComplete;

  @override
  State<PracticeClozeView> createState() => _PracticeClozeViewState();
}

class _PracticeClozeViewState extends State<PracticeClozeView> {
  int _index = 0;
  bool? _isCorrect;
  final _controller = TextEditingController();
  final _results = <PracticeResultEntry>[];

  DeckWord get _current => widget.words[_index];

  String _promptFor(DeckWord word) {
    final example = word.example?.trim();
    if (example != null && example.isNotEmpty) {
      final pattern = RegExp(RegExp.escape(word.word), caseSensitive: false);
      if (pattern.hasMatch(example)) {
        return example.replaceFirst(pattern, '_____');
      }
    }
    return '_____ (${word.translation})';
  }

  void _submit() {
    if (_isCorrect != null) return;
    final answer = _controller.text.trim().toLowerCase();
    final expected = _current.word.trim().toLowerCase();
    final correct = answer.isNotEmpty && answer == expected;

    setState(() {
      _isCorrect = correct;
      _results.add(
        PracticeResultEntry(
          cardId: _current.id,
          correct: correct,
          userAnswer: _controller.text.trim(),
          correctAnswer: _current.word,
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      if (_index < widget.words.length - 1) {
        setState(() {
          _index++;
          _isCorrect = null;
          _controller.clear();
        });
      } else {
        widget.onComplete(_results);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        PracticeProgressHeader(
          current: _index + 1,
          total: widget.words.length,
          correct: _results.where((r) => r.correct).length,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                _promptFor(_current),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              TextField(
                key: const Key('practice_cloze_input'),
                controller: _controller,
                enabled: _isCorrect == null,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: l10n.practiceClozeHint,
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: _isCorrect == null
                      ? Colors.white
                      : (_isCorrect! ? Colors.green.shade50 : Colors.red.shade50),
                ),
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16),
              if (_isCorrect != null)
                Text(
                  _isCorrect!
                      ? l10n.practiceFeedbackCorrect
                      : l10n.practiceFeedbackWrong(_current.word),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isCorrect! ? AppColors.success : AppColors.error,
                  ),
                )
              else
                FilledButton(
                  onPressed: _submit,
                  child: Text(l10n.practiceCheckAnswer),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
