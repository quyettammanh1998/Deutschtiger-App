import 'package:flutter/material.dart';

import '../../../core/design_tokens.dart';
import '../../../data/news/news_models.dart';

/// Quiz trắc nghiệm cuối bài — chấm cục bộ (backend không có endpoint chấm
/// riêng cho news quiz, giống `exam/dictation` grading pattern). Đạt ≥60% gọi
/// [onPass] với điểm % để caller ghi `POST /user/news-progress`.
class NewsQuizCard extends StatefulWidget {
  const NewsQuizCard({super.key, required this.quiz, required this.onPass});

  final List<NewsQuiz> quiz;
  final ValueChanged<int> onPass;

  @override
  State<NewsQuizCard> createState() => _NewsQuizCardState();
}

class _NewsQuizCardState extends State<NewsQuizCard> {
  final Map<int, int> _selected = {};
  bool _submitted = false;
  bool _passReported = false;

  int get _correctCount {
    var count = 0;
    for (var i = 0; i < widget.quiz.length; i++) {
      if (_selected[i] == widget.quiz[i].correct) count++;
    }
    return count;
  }

  int get _scorePct =>
      widget.quiz.isEmpty ? 0 : (_correctCount * 100 / widget.quiz.length).round();

  void _submit() {
    setState(() => _submitted = true);
    if (_scorePct >= 60 && !_passReported) {
      _passReported = true;
      widget.onPass(_scorePct);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allAnswered = _selected.length == widget.quiz.length;
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: DesignTokens.card,
        borderRadius: BorderRadius.circular(DesignTokens.radius),
        border: Border.all(color: DesignTokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Câu hỏi kiểm tra',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          for (var i = 0; i < widget.quiz.length; i++)
            _QuizQuestion(
              index: i,
              quiz: widget.quiz[i],
              selected: _selected[i],
              revealed: _submitted,
              onSelect: _submitted
                  ? null
                  : (option) => setState(() => _selected[i] = option),
            ),
          const SizedBox(height: DesignTokens.spacingSm),
          if (!_submitted)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: allAnswered ? _submit : null,
                style: FilledButton.styleFrom(
                  backgroundColor: DesignTokens.tigerOrange,
                ),
                child: const Text('Nộp bài'),
              ),
            )
          else
            Text(
              'Kết quả: $_correctCount/${widget.quiz.length} câu đúng '
              '($_scorePct%)${_scorePct >= 60 ? ' — Đã lưu tiến độ ✅' : ''}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: _scorePct >= 60
                    ? const Color(0xFF059669)
                    : DesignTokens.mutedForeground,
              ),
            ),
        ],
      ),
    );
  }
}

class _QuizQuestion extends StatelessWidget {
  const _QuizQuestion({
    required this.index,
    required this.quiz,
    required this.selected,
    required this.revealed,
    required this.onSelect,
  });

  final int index;
  final NewsQuiz quiz;
  final int? selected;
  final bool revealed;
  final ValueChanged<int>? onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}. ${quiz.question}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          for (var i = 0; i < quiz.options.length; i++)
            _OptionTile(
              label: quiz.options[i],
              isSelected: selected == i,
              isCorrect: i == quiz.correct,
              revealed: revealed,
              onTap: onSelect == null ? null : () => onSelect!(i),
            ),
          if (revealed && quiz.explanationVi.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                quiz.explanationVi,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  color: DesignTokens.mutedForeground,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.isSelected,
    required this.isCorrect,
    required this.revealed,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isCorrect;
  final bool revealed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color? background;
    Color borderColor = DesignTokens.border;
    if (revealed) {
      if (isCorrect) {
        background = const Color(0xFFD1FAE5);
        borderColor = const Color(0xFF059669);
      } else if (isSelected) {
        background = const Color(0xFFFEE2E2);
        borderColor = const Color(0xFFDC2626);
      }
    } else if (isSelected) {
      background = DesignTokens.tigerOrange.withValues(alpha: 0.12);
      borderColor = DesignTokens.tigerOrange;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            border: Border.all(color: borderColor),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
