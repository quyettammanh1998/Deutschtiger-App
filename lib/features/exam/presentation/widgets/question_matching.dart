// ignore_for_file: prefer_initializing_formals
//
// Matching renderer — 2 cột, user chọn từng item trái rồi gán 1 item phải.
// Lưu answer dạng "left:right,left:right" để provider so sánh với correctMatches.

import 'package:flutter/material.dart';

import '../../../../core/design_tokens.dart';
import '../../../../core/exam_design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/exam_models.dart';
import 'matching_subwidgets.dart';
import 'question_card_frame.dart';

class QuestionMatching extends StatefulWidget {
  const QuestionMatching({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.sectionLabel,
    required this.answer,
    required this.onChange,
    this.showCorrectness = false,
  });

  final ExamQuestion question;
  final int questionNumber;
  final String sectionLabel;
  final String? answer;
  final ValueChanged<String> onChange;
  final bool showCorrectness;

  @override
  State<QuestionMatching> createState() => _QuestionMatchingState();
}

class _QuestionMatchingState extends State<QuestionMatching> {
  int? _selectedLeft;

  Map<int, int> get _pairs {
    final raw = widget.answer;
    if (raw == null || raw.isEmpty) return <int, int>{};
    final result = <int, int>{};
    for (final p in raw.split(',')) {
      if (p.contains(':')) {
        final parts = p.split(':');
        final left = int.tryParse(parts[0]);
        final right = int.tryParse(parts[1]);
        if (left != null && right != null) result[left] = right;
      }
    }
    return result;
  }

  void _setPair(int left, int right) {
    final next = {..._pairs};
    next.removeWhere((k, v) => k == left || v == right);
    next[left] = right;
    widget.onChange(next.entries.map((e) => '${e.key}:${e.value}').join(','));
    setState(() => _selectedLeft = null);
  }

  void _clearPair(int left) {
    final next = {..._pairs}..remove(left);
    widget.onChange(next.entries.map((e) => '${e.key}:${e.value}').join(','));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final leftItems = widget.question.matchLeft ?? const [];
    final rightItems = widget.question.matchRight ?? const [];
    final pairs = _pairs;

    return QuestionCardFrame(
      questionNumber: widget.questionNumber,
      sectionLabel: widget.sectionLabel,
      questionId: widget.question.answerKey,
      prompt: widget.question.prompt,
      topSlot: Column(
        children: [
          for (var i = 0; i < leftItems.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
              child: _MatchingRow(
                index: i,
                leftText: leftItems[i],
                rightItems: rightItems,
                selectedLeft: _selectedLeft,
                currentRightIdx: pairs[i],
                showCorrectness: widget.showCorrectness,
                correctRightIdx: widget.question.correctMatches[i],
                onTapLeft: () => setState(
                  () => _selectedLeft = _selectedLeft == i ? null : i,
                ),
                onTapRight: (rightIdx) {
                  final left = _selectedLeft;
                  if (left != null) _setPair(left, rightIdx);
                },
                onClear: () => _clearPair(i),
              ),
            ),
          if (_selectedLeft != null)
            Padding(
              padding: const EdgeInsets.only(top: DesignTokens.spacingSm),
              child: Text(
                l10n.matchingSelectRight(_selectedLeft! + 1),
                style: const TextStyle(
                  fontSize: 12,
                  color: ExamDesignTokens.examActive,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MatchingRow extends StatelessWidget {
  const _MatchingRow({
    required this.index,
    required this.leftText,
    required this.rightItems,
    required this.selectedLeft,
    required this.currentRightIdx,
    required this.showCorrectness,
    required this.correctRightIdx,
    required this.onTapLeft,
    required this.onTapRight,
    required this.onClear,
  });

  final int index;
  final String leftText;
  final List<String> rightItems;
  final int? selectedLeft;
  final int? currentRightIdx;
  final bool showCorrectness;
  final int? correctRightIdx;
  final VoidCallback onTapLeft;
  final ValueChanged<int> onTapRight;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedLeft == index;
    final isCorrectPair =
        showCorrectness &&
        currentRightIdx != null &&
        currentRightIdx == correctRightIdx;

    return Row(
      children: [
        Expanded(
          child: LeftItemTile(
            index: index,
            text: leftText,
            isSelected: isSelected,
            isCorrectPair: isCorrectPair,
            onTap: onTapLeft,
            onClear: onClear,
          ),
        ),
        const SizedBox(width: DesignTokens.spacingSm),
        ArrowSeparator(isCorrect: isCorrectPair),
        const SizedBox(width: DesignTokens.spacingSm),
        Expanded(
          child:
              currentRightIdx != null &&
                  currentRightIdx! >= 0 &&
                  currentRightIdx! < rightItems.length
              ? PickedRight(
                  text: rightItems[currentRightIdx!],
                  isCorrect: isCorrectPair,
                )
              : RightLetterStrip(
                  rightItems: rightItems,
                  selectedLeft: selectedLeft,
                  onTapRight: onTapRight,
                ),
        ),
      ],
    );
  }
}
