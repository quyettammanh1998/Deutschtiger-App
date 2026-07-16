import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/common/answer_diff_view.dart';
import '../../../../widgets/common/app_card.dart';
import '../../domain/schreiben_grading_result.dart';
import 'practice_editor_buttons.dart';

/// "Viết lại sau góp ý" (rewrite-from-feedback) block — web parity the
/// bottom half of `practice-editor-card.tsx`. Web renders the before/after
/// comparison as two side-by-side text panels; this mobile build instead
/// reuses the shared [AnswerDiffView] word-diff primitive (P4/P1) — inline
/// green/amber/red chips read better on a narrow phone width than two
/// stacked full-text panels, and the plan explicitly requires reusing the
/// diff-view primitive rather than hand-rolling a new comparison widget.
class PracticeRewriteSection extends StatelessWidget {
  const PracticeRewriteSection({
    super.key,
    required this.gradingResult,
    required this.userText,
    required this.rewriteText,
    required this.rewriteSourceText,
    required this.rewriteError,
    required this.isRewriting,
    required this.onRewrite,
    required this.onUseRewrite,
    required this.onDismissRewriteError,
  });

  final SchreibenGradingResult gradingResult;
  final String userText;
  final String rewriteText;
  final String rewriteSourceText;
  final String? rewriteError;
  final bool isRewriting;
  final VoidCallback onRewrite;
  final VoidCallback onUseRewrite;
  final VoidCallback onDismissRewriteError;

  bool get _hasRewrite => rewriteText.trim().isNotEmpty;
  bool get _canRewrite => userText.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);

    return AppCard.card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.writingRewriteTitle,
                      style: TextStyle(fontWeight: FontWeight.w600, color: tokens.foreground),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.writingRewriteDesc,
                      style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              GradientMiniButton(
                label: isRewriting
                    ? l10n.writingCreatingRewrite
                    : _hasRewrite
                    ? l10n.writingRecreateRewrite
                    : l10n.writingCreateRewrite,
                onTap: (_canRewrite && !isRewriting) ? onRewrite : () {},
                tokens: (_canRewrite && !isRewriting) ? tokens : tokens.copyWith(primary: tokens.muted),
              ),
            ],
          ),
          if (rewriteError != null) ...[
            const SizedBox(height: 12),
            _RewriteErrorBanner(message: rewriteError!, l10n: l10n, onDismiss: onDismissRewriteError),
          ],
          if (_hasRewrite) ...[
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${l10n.writingBeforeFix} → ${l10n.writingAfterFix}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: tokens.mutedForeground,
                ),
              ),
            ),
            const SizedBox(height: 8),
            AnswerDiffView(
              userAnswer: rewriteSourceText.isNotEmpty ? rewriteSourceText : userText,
              correctAnswer: rewriteText,
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: GradientMiniButton(label: l10n.writingUseRewrite, onTap: onUseRewrite, tokens: tokens),
            ),
          ],
        ],
      ),
    );
  }
}

class _RewriteErrorBanner extends StatelessWidget {
  const _RewriteErrorBanner({required this.message, required this.l10n, required this.onDismiss});
  final String message;
  final AppLocalizations l10n;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: tokens.destructive.withValues(alpha: 0.08),
        border: Border.all(color: tokens.destructive.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: TextStyle(color: tokens.destructive, fontSize: 13)),
          const SizedBox(height: 6),
          OutlineMiniButton(label: l10n.writingClose, onTap: onDismiss, tokens: tokens),
        ],
      ),
    );
  }
}
