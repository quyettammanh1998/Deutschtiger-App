// Nav sheet — web `mobile-nav-sheet.tsx` + `shared/question-nav.tsx`: bottom
// sheet grouped by Teil (ExamSection), 6-col grid, semantic colors (current
// blue / answered blue-50 / review green-red), legend + stats row.
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/exam_models.dart';
import 'exam_player_palette.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

Future<void> showMobileNavSheet(
  BuildContext context, {
  required List<ExamSection> sections,
  required int currentGlobalIndex,
  required Set<String> answeredKeys,
  required ExamMode mode,
  required ValueChanged<int> onNavigate,
  Map<String, bool>? correctByKey,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _MobileNavSheet(
      sections: sections,
      currentGlobalIndex: currentGlobalIndex,
      answeredKeys: answeredKeys,
      mode: mode,
      onNavigate: onNavigate,
      correctByKey: correctByKey,
    ),
  );
}

class _NavItem {
  const _NavItem(this.globalIndex, this.displayNumber, this.answerKey);
  final int globalIndex;
  final int displayNumber;
  final String answerKey;
}

class _MobileNavSheet extends StatelessWidget {
  const _MobileNavSheet({
    required this.sections,
    required this.currentGlobalIndex,
    required this.answeredKeys,
    required this.mode,
    required this.onNavigate,
    this.correctByKey,
  });

  final List<ExamSection> sections;
  final int currentGlobalIndex;
  final Set<String> answeredKeys;
  final ExamMode mode;
  final ValueChanged<int> onNavigate;
  final Map<String, bool>? correctByKey;

  bool get _showStats => mode == ExamMode.practice || mode == ExamMode.review;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;

    var globalIndex = 0;
    var seq = 1;
    final groups = <String, List<_NavItem>>{};
    for (final section in sections) {
      final label = '${section.kind.labelDe} · ${section.kind.labelVi}';
      final items = <_NavItem>[];
      for (final q in section.questions) {
        items.add(_NavItem(globalIndex, seq, q.answerKey));
        globalIndex++;
        seq++;
      }
      groups[label] = items;
    }

    final allItems = groups.values.expand((v) => v).toList();
    final answeredCount = allItems
        .where((i) => answeredKeys.contains(i.answerKey))
        .length;
    final correctCount = _showStats
        ? allItems.where((i) => correctByKey?[i.answerKey] == true).length
        : 0;
    final wrongCount = _showStats
        ? allItems
              .where(
                (i) =>
                    answeredKeys.contains(i.answerKey) &&
                    correctByKey?.containsKey(i.answerKey) == true &&
                    correctByKey![i.answerKey] == false,
              )
              .length
        : 0;
    final unansweredCount = allItems.length - answeredCount;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: tokens.mutedForeground.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  mode == ExamMode.practice
                      ? l10n.examNavSheetPracticeTitle
                      : l10n.examNavSheetTitle,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: tokens.foreground,
                  ),
                ),
                const Spacer(),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    PhosphorIcons.x,
                    size: 18,
                    color: tokens.mutedForeground,
                  ),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_showStats) ...[
                      const SizedBox(height: 4),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        children: [
                          Text(
                            l10n.examNavStatCorrect(correctCount),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: examNavGreen(context),
                            ),
                          ),
                          Text(
                            l10n.examNavStatWrong(wrongCount),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: examNavRed(context),
                            ),
                          ),
                          Text(
                            l10n.examNavStatUnanswered(unansweredCount),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: tokens.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    for (final entry in groups.entries)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: _SectionGroup(
                          label: entry.key,
                          items: entry.value,
                          currentGlobalIndex: currentGlobalIndex,
                          answeredKeys: answeredKeys,
                          showStats: _showStats,
                          correctByKey: correctByKey,
                          onNavigate: (idx) {
                            onNavigate(idx);
                            Navigator.of(context).maybePop();
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionGroup extends StatelessWidget {
  const _SectionGroup({
    required this.label,
    required this.items,
    required this.currentGlobalIndex,
    required this.answeredKeys,
    required this.showStats,
    required this.onNavigate,
    this.correctByKey,
  });

  final String label;
  final List<_NavItem> items;
  final int currentGlobalIndex;
  final Set<String> answeredKeys;
  final bool showStats;
  final Map<String, bool>? correctByKey;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final answered = items
        .where((i) => answeredKeys.contains(i.answerKey))
        .length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  color: tokens.foreground,
                ),
              ),
            ),
            Text(
              '$answered/${items.length}',
              style: TextStyle(fontSize: 10, color: tokens.mutedForeground),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Divider(height: 1, color: tokens.border),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: items.length,
          itemBuilder: (context, i) {
            final item = items[i];
            final isCurrent = item.globalIndex == currentGlobalIndex;
            final isAnswered = answeredKeys.contains(item.answerKey);
            final isCorrect =
                showStats && correctByKey?[item.answerKey] == true;
            final isWrong =
                showStats &&
                isAnswered &&
                correctByKey?.containsKey(item.answerKey) == true &&
                correctByKey![item.answerKey] == false;

            Color bg = tokens.card;
            Color fg = tokens.foreground;
            Color border = tokens.border;
            double borderWidth = 1;

            if (isCurrent) {
              bg = examNavBlue(context);
              fg = Colors.white;
              border = examNavBlue(context);
              borderWidth = 2;
            } else if (isCorrect) {
              border = examNavGreen(context);
              borderWidth = 2;
            } else if (isWrong) {
              border = examNavRed(context);
              borderWidth = 2;
            } else if (!showStats && isAnswered) {
              bg = examNavBlueSoft(context);
              border = examNavBlueBorder(context);
              borderWidth = 2;
            }

            return InkWell(
              onTap: () => onNavigate(item.globalIndex),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  color: bg,
                  border: Border.all(color: border, width: borderWidth),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${item.displayNumber}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
