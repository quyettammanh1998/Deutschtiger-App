import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import 'dictation_diff.dart';

/// Colored word-diff result for the full-sentence dictation activity —
/// mirrors web `DiffToken` in `exam-dictation-full-practice.tsx`.
class FullDictationDiffText extends StatelessWidget {
  const FullDictationDiffText({super.key, required this.diff});

  final List<WordDiff> diff;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final spans = <InlineSpan>[];
    for (final d in diff) {
      if (d.correct) {
        spans.add(
          TextSpan(
            text: '${d.expected} ',
            style: TextStyle(
              color: tokens.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      } else {
        if (d.userWord != null && d.userWord!.isNotEmpty) {
          spans.add(
            TextSpan(
              text: '${d.userWord} ',
              style: TextStyle(
                color: tokens.destructive,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          );
        }
        spans.add(
          TextSpan(
            text: '${d.expected} ',
            style: TextStyle(
              color: tokens.destructive,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        );
      }
    }
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 14, color: tokens.foreground),
        children: spans,
      ),
    );
  }
}
