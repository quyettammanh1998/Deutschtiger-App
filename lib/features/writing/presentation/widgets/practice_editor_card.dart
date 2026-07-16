import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/common/app_card.dart';
import '../../../../widgets/common/umlaut_input_bar.dart';
import '../../data/writing_draft_store.dart';
import '../../domain/schreiben_grading_result.dart';
import 'grading_result_card.dart';
import 'practice_editor_actions.dart';
import 'practice_editor_buttons.dart';
import 'practice_rewrite_section.dart';

/// The writing editor + submit/grade/rewrite flow — web parity
/// `components/exam/goethe-b1-writing/practice/practice-editor-card.tsx`.
/// Pure presentation: every button forwards to a caller-supplied callback,
/// all async/error/loading state is owned by `WritingPracticePanel`. Split
/// across `practice_editor_buttons.dart` (mini buttons/banners) and
/// `practice_editor_actions.dart` (submit/submitted/grading-error rows) to
/// stay under the 200-LOC-per-file guideline.
class PracticeEditorCard extends StatefulWidget {
  const PracticeEditorCard({
    super.key,
    required this.userText,
    required this.isSubmitted,
    required this.isSubmitting,
    required this.isGrading,
    required this.gradingResult,
    required this.gradingError,
    required this.isAiUnavailable,
    required this.retryCooldown,
    required this.rewriteText,
    required this.rewriteSourceText,
    required this.rewriteError,
    required this.isRewriting,
    required this.submitError,
    required this.draft,
    required this.showRestorePrompt,
    required this.onTextChange,
    required this.onSubmit,
    required this.onEdit,
    required this.onGrade,
    required this.onRewrite,
    required this.onUseRewrite,
    required this.onRestoreDraft,
    required this.onDiscardDraft,
    required this.onDismissError,
    required this.onDismissRewriteError,
    this.saveSlot,
  });

  final String userText;
  final bool isSubmitted;
  final bool isSubmitting;
  final bool isGrading;
  final SchreibenGradingResult? gradingResult;
  final String? gradingError;
  final bool isAiUnavailable;
  final int retryCooldown;
  final String rewriteText;
  final String rewriteSourceText;
  final String? rewriteError;
  final bool isRewriting;
  final String? submitError;
  final WritingDraft? draft;
  final bool showRestorePrompt;
  final ValueChanged<String> onTextChange;
  final VoidCallback onSubmit;
  final VoidCallback onEdit;
  final VoidCallback onGrade;
  final VoidCallback onRewrite;
  final VoidCallback onUseRewrite;
  final VoidCallback onRestoreDraft;
  final VoidCallback onDiscardDraft;
  final VoidCallback onDismissError;
  final VoidCallback onDismissRewriteError;

  /// Rendered next to "Sửa với AI" once a submission exists (P9 W2+ wires
  /// the actual save-to-deck action; W1 leaves this a plain optional slot).
  final Widget? saveSlot;

  @override
  State<PracticeEditorCard> createState() => _PracticeEditorCardState();
}

class _PracticeEditorCardState extends State<PracticeEditorCard> {
  late final TextEditingController _controller = TextEditingController(text: widget.userText);
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() => _focused = _focusNode.hasFocus));
  }

  @override
  void didUpdateWidget(covariant PracticeEditorCard old) {
    super.didUpdateWidget(old);
    // Parent-driven text changes (draft restore, rewrite applied) that don't
    // originate from this controller's own onChanged must be reflected here.
    if (widget.userText != _controller.text && widget.userText != old.userText) {
      _controller.value = TextEditingValue(
        text: widget.userText,
        selection: TextSelection.collapsed(offset: widget.userText.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  int get _wordCount => widget.userText.trim().isEmpty
      ? 0
      : widget.userText.trim().split(RegExp(r'\s+')).length;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final wordCount = _wordCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard.card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.writingYourEssay,
                      style: TextStyle(fontWeight: FontWeight.w600, color: tokens.foreground),
                    ),
                  ),
                  if (!widget.isSubmitted && widget.draft != null && !widget.showRestorePrompt)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        l10n.writingDraftSaved,
                        style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                      ),
                    ),
                  if (widget.isSubmitted) _SubmittedBadge(l10n: l10n),
                  Text(
                    l10n.writingWordCount(wordCount),
                    style: TextStyle(
                      fontSize: 12,
                      color: wordCount < 50
                          ? tokens.mutedForeground
                          : wordCount > 200
                          ? tokens.warning
                          : tokens.success,
                    ),
                  ),
                ],
              ),
              if (widget.showRestorePrompt && widget.draft != null && !widget.isSubmitted)
                RestoreDraftBanner(
                  draft: widget.draft!,
                  l10n: l10n,
                  onRestore: widget.onRestoreDraft,
                  onDiscard: widget.onDiscardDraft,
                ),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: !widget.isSubmitted,
                maxLines: 12,
                minLines: 10,
                onChanged: widget.onTextChange,
                decoration: InputDecoration(
                  hintText: widget.isSubmitted ? '' : l10n.writingEditorPlaceholder,
                  filled: true,
                  fillColor: tokens.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: tokens.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: tokens.primary, width: 2),
                  ),
                ),
              ),
              if (!widget.isSubmitted)
                UmlautInputBar(
                  visible: _focused,
                  onInsert: (char) {
                    UmlautInputBar.insertAtCursor(_controller, char);
                    widget.onTextChange(_controller.text);
                  },
                ),
              const SizedBox(height: 12),
              if (!widget.isSubmitted)
                PracticeSubmitActionRow(wordCount: wordCount, l10n: l10n, widget: widget),
              if (widget.submitError != null)
                WritingErrorBanner(
                  message: widget.submitError!,
                  l10n: l10n,
                  onRetry: widget.isSubmitted ? widget.onGrade : widget.onSubmit,
                  onDismiss: widget.onDismissError,
                  busy: widget.isSubmitting || widget.isGrading,
                ),
              if (widget.isSubmitted) PracticeSubmittedActionRow(l10n: l10n, widget: widget),
            ],
          ),
        ),
        if (widget.gradingError != null) ...[
          const SizedBox(height: 12),
          GradingErrorCard(widget: widget, l10n: l10n),
        ],
        if (widget.gradingResult != null) ...[
          const SizedBox(height: 12),
          if (!widget.isSubmitted)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l10n.writingFeedbackUpdateHint,
                style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
              ),
            ),
          GradingResultCard(result: widget.gradingResult!),
          const SizedBox(height: 12),
          PracticeRewriteSection(
            gradingResult: widget.gradingResult!,
            userText: widget.userText,
            rewriteText: widget.rewriteText,
            rewriteSourceText: widget.rewriteSourceText,
            rewriteError: widget.rewriteError,
            isRewriting: widget.isRewriting,
            onRewrite: widget.onRewrite,
            onUseRewrite: widget.onUseRewrite,
            onDismissRewriteError: widget.onDismissRewriteError,
          ),
        ],
      ],
    );
  }
}

class _SubmittedBadge extends StatelessWidget {
  const _SubmittedBadge({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: tokens.success.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        l10n.writingSubmittedBadge,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tokens.success),
      ),
    );
  }
}
