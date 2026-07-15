// ignore_for_file: prefer_initializing_formals
//
// Confirm dialogs cho exam player (exit / submit).

import 'package:flutter/material.dart';

import '../../../../core/exam_design_tokens.dart';
import '../../../../l10n/app_localizations.dart';

Future<bool> showExitExamDialog(BuildContext context) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      final l10n = AppLocalizations.of(ctx);
      return AlertDialog(
        title: Text(l10n.exitExamTitle),
        content: Text(l10n.exitExamBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.continueAction),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l10n.exit,
              style: TextStyle(color: ExamDesignTokens.examAnswerWrongColor),
            ),
          ),
        ],
      );
    },
  );
  return res == true;
}

Future<bool> showSubmitExamDialog(BuildContext context, int unanswered) async {
  if (unanswered <= 0) return true;
  final res = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      final l10n = AppLocalizations.of(ctx);
      return AlertDialog(
        title: Text(l10n.submitExamTitle),
        content: Text(l10n.submitExamUnanswered(unanswered)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.reviewAnswers),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.submitExam),
          ),
        ],
      );
    },
  );
  return res == true;
}
