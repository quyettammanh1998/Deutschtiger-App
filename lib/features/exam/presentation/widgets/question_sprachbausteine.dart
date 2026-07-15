// ignore_for_file: prefer_initializing_formals
//
// Sprachbausteine renderer — mỗi gap hiển thị dropdown picker chọn 1 option
// trong pool. Đáp án lưu dạng "optIdx,optIdx,..." (0-based option index theo
// `exam-scoring.ts:17`).

import 'package:flutter/material.dart';

import '../../../../core/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/exam_models.dart';
import 'question_card_frame.dart';
import 'sprachbausteine_subwidgets.dart';

class QuestionSprachbausteine extends StatelessWidget {
  const QuestionSprachbausteine({
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

  List<int?> get _selectedIdxs {
    if (answer == null || answer!.isEmpty) {
      return List.filled(question.gapPositions.length, null);
    }
    final parts = answer!.split(',');
    return [
      for (var i = 0; i < question.gapPositions.length; i++)
        i < parts.length ? int.tryParse(parts[i]) : null,
    ];
  }

  void _setIdx(int gapIdx, int optionIdx) {
    final list = [..._selectedIdxs];
    while (list.length <= gapIdx) {
      list.add(null);
    }
    list[gapIdx] = optionIdx;
    onChange(list.map((e) => e?.toString() ?? '').join(','));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedIdxs = _selectedIdxs;
    return QuestionCardFrame(
      questionNumber: questionNumber,
      sectionLabel: sectionLabel,
      prompt: question.prompt,
      topSlot: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var g = 0; g < question.gapPositions.length; g++)
            Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
              child: SprachbausteineGapPicker(
                gapLabel: l10n.examGapNumber(g + 1),
                options: question.options,
                selectedIdx: g < selectedIdxs.length ? selectedIdxs[g] : null,
                correctIdx: question.gapPositions[g],
                showCorrectness: showCorrectness,
                onPick: (idx) => _setIdx(g, idx),
              ),
            ),
        ],
      ),
    );
  }
}
