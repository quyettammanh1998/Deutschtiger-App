import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/decks/deck_models.dart';
import '../../../data/practice/practice_result.dart';
import '../../../l10n/app_localizations.dart';
import 'practice_progress_header.dart';

/// Chế độ "Luyện viết" — cho nghĩa tiếng Việt, người dùng gõ lại từ tiếng
/// Đức tương ứng.
class PracticeWritingView extends StatefulWidget {
  const PracticeWritingView({
    super.key,
    required this.words,
    required this.onComplete,
  });

  final List<DeckWord> words;
  final void Function(List<PracticeResultEntry>) onComplete;

  @override
  State<PracticeWritingView> createState() => _PracticeWritingViewState();
}

class _PracticeWritingViewState extends State<PracticeWritingView> {
  int _index = 0;
  bool? _isCorrect;
  final _controller = TextEditingController();
  final _results = <PracticeResultEntry>[];

  DeckWord get _current => widget.words[_index];

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
                _current.translation,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                key: const Key('practice_writing_input'),
                controller: _controller,
                enabled: _isCorrect == null,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: l10n.practiceWritingHint,
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
