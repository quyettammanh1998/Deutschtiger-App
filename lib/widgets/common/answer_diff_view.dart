import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

/// Word-level diff type — web parity `lib/practice/answer-diff.ts`
/// `DiffSegmentType`.
enum DiffSegmentType { correct, missing, extra }

class DiffSegment {
  const DiffSegment(this.type, this.text);

  final DiffSegmentType type;
  final String text;
}

String _norm(String w) => w.trim().toLowerCase();

/// LCS-based word diff between what the user typed and the correct answer —
/// mirrors web `computeAnswerDiff` (`answer-diff.ts`). `correct` = matched
/// word, `missing` = word the user skipped, `extra` = word the user typed
/// that isn't part of the answer.
List<DiffSegment> computeAnswerDiff(String userAnswer, String correctAnswer) {
  final userWords = userAnswer.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  final correctWords = correctAnswer.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

  if (userWords.isEmpty) {
    return [for (final w in correctWords) DiffSegment(DiffSegmentType.missing, w)];
  }

  final m = userWords.length;
  final n = correctWords.length;
  final dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));
  for (var i = 1; i <= m; i++) {
    for (var j = 1; j <= n; j++) {
      dp[i][j] = _norm(userWords[i - 1]) == _norm(correctWords[j - 1])
          ? dp[i - 1][j - 1] + 1
          : (dp[i - 1][j] > dp[i][j - 1] ? dp[i - 1][j] : dp[i][j - 1]);
    }
  }

  final ops = <DiffSegment>[];
  var i = m;
  var j = n;
  while (i > 0 || j > 0) {
    if (i > 0 && j > 0 && _norm(userWords[i - 1]) == _norm(correctWords[j - 1])) {
      ops.add(DiffSegment(DiffSegmentType.correct, correctWords[j - 1]));
      i--;
      j--;
    } else if (j > 0 && (i == 0 || dp[i][j - 1] >= dp[i - 1][j])) {
      ops.add(DiffSegment(DiffSegmentType.missing, correctWords[j - 1]));
      j--;
    } else {
      ops.add(DiffSegment(DiffSegmentType.extra, userWords[i - 1]));
      i--;
    }
  }
  return ops.reversed.toList(growable: false);
}

/// Renders a [computeAnswerDiff] result as inline colored chips — web parity
/// `answer-diff-display.tsx`: green = correct, amber underline = missing
/// (word to learn), red strikethrough = extra (typo/wrong word). Hoisted to
/// `widgets/common` (P1 gap) so cloze/writing practice views and P9 exam
/// writing share one implementation.
class AnswerDiffView extends StatelessWidget {
  const AnswerDiffView({super.key, required this.userAnswer, required this.correctAnswer});

  final String userAnswer;
  final String correctAnswer;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final segments = computeAnswerDiff(userAnswer, correctAnswer);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final seg in segments) _DiffChip(segment: seg, tokens: tokens),
      ],
    );
  }
}

class _DiffChip extends StatelessWidget {
  const _DiffChip({required this.segment, required this.tokens});

  final DiffSegment segment;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    TextDecoration? decoration;
    switch (segment.type) {
      case DiffSegmentType.correct:
        bg = tokens.success.withValues(alpha: 0.15);
        fg = tokens.success;
      case DiffSegmentType.missing:
        bg = tokens.warning.withValues(alpha: 0.18);
        fg = tokens.warning;
        decoration = TextDecoration.underline;
      case DiffSegmentType.extra:
        bg = tokens.destructive.withValues(alpha: 0.12);
        fg = tokens.destructive;
        decoration = TextDecoration.lineThrough;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(
        segment.text,
        style: TextStyle(color: fg, fontWeight: FontWeight.w600, decoration: decoration),
      ),
    );
  }
}
