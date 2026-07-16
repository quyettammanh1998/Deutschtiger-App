import 'package:flutter/material.dart';

import '../../../../core/icons/app_phosphor_icons.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';
import '../../../../widgets/common/app_card.dart';
import 'de_thi_question_option_row.dart';
import 'de_thi_question_reveal_blocks.dart';

/// Web parity: `de-thi-question-card.tsx` — option rows with
/// selected/correct/wrong states, plus post-submit translate/explanation
/// toggles.
class DeThiQuestionCard extends StatefulWidget {
  const DeThiQuestionCard({
    super.key,
    required this.question,
    required this.selected,
    required this.submitted,
    required this.onSelect,
  });

  final DeThiQuestion question;
  final String? selected;
  final bool submitted;
  final ValueChanged<String> onSelect;

  @override
  State<DeThiQuestionCard> createState() => _DeThiQuestionCardState();
}

class _DeThiQuestionCardState extends State<DeThiQuestionCard> {
  bool _showTranslation = false;
  bool _showExplanation = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final q = widget.question;
    return AppCard.card(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tokens.foreground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${q.no}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: tokens.background,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  q.questionDe,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: tokens.foreground,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final key in q.optionsDe.keys)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: DeThiQuestionOptionRow(
                optionKey: key,
                label: q.optionsDe[key] ?? '',
                selected: widget.selected == key,
                isCorrect: widget.submitted && q.answer == key,
                isWrong:
                    widget.submitted &&
                    widget.selected == key &&
                    q.answer != key,
                dimmed:
                    widget.submitted ||
                    (widget.selected != null && widget.selected != key),
                onTap: widget.submitted ? null : () => widget.onSelect(key),
              ),
            ),
          if (widget.submitted) ...[
            const Divider(height: 20),
            Row(
              children: [
                DeThiToggleLink(
                  icon: AppPhosphorIcons.translate,
                  label: _showTranslation ? 'Ẩn bản dịch' : 'Dịch tiếng Việt',
                  color: const Color(0xFF2563EB),
                  onTap: () =>
                      setState(() => _showTranslation = !_showTranslation),
                ),
                const SizedBox(width: 16),
                DeThiToggleLink(
                  icon: AppPhosphorIcons.lightbulb,
                  label: _showExplanation ? 'Ẩn giải thích' : 'Giải thích',
                  color: const Color(0xFF0284C7),
                  onTap: () =>
                      setState(() => _showExplanation = !_showExplanation),
                ),
              ],
            ),
            if (_showTranslation) ...[
              const SizedBox(height: 8),
              DeThiTranslationBlock(question: q),
            ],
            if (_showExplanation && q.explanationVi.isNotEmpty) ...[
              const SizedBox(height: 8),
              DeThiExplanationBlock(text: q.explanationVi),
            ],
          ],
        ],
      ),
    );
  }
}
