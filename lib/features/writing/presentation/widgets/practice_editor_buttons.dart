import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/writing_draft_store.dart';

/// Small solid-fill pill button — web parity the gradient "Khôi phục"/"Thử
/// lại" CTAs inside inline banners (approximated as a flat [tokens.primary]
/// fill; these banners are compact enough that a gradient reads the same).
class GradientMiniButton extends StatelessWidget {
  const GradientMiniButton({super.key, required this.label, required this.onTap, required this.tokens});
  final String label;
  final VoidCallback onTap;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: tokens.primary,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            label,
            style: TextStyle(color: tokens.primaryForeground, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ),
      ),
    );
  }
}

/// Small bordered pill button — web parity "Bỏ"/"Đóng" secondary CTAs.
class OutlineMiniButton extends StatelessWidget {
  const OutlineMiniButton({super.key, required this.label, required this.onTap, required this.tokens});
  final String label;
  final VoidCallback onTap;
  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: tokens.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(color: tokens.mutedForeground, fontWeight: FontWeight.w500, fontSize: 12),
          ),
        ),
      ),
    );
  }
}

/// "Đã lưu nháp" pending-draft banner shown above the textarea, offering to
/// restore or discard — web parity the amber `showRestorePrompt` block.
class RestoreDraftBanner extends StatelessWidget {
  const RestoreDraftBanner({
    super.key,
    required this.draft,
    required this.l10n,
    required this.onRestore,
    required this.onDiscard,
  });

  final WritingDraft draft;
  final AppLocalizations l10n;
  final VoidCallback onRestore;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final time =
        '${draft.savedAt.hour.toString().padLeft(2, '0')}:${draft.savedAt.minute.toString().padLeft(2, '0')}';
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: tokens.warning.withValues(alpha: 0.12),
        border: Border.all(color: tokens.warning.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.writingRestorePromptSaved(time, draft.wordCount),
            style: TextStyle(fontSize: 13, color: tokens.foreground),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              GradientMiniButton(label: l10n.writingRestore, onTap: onRestore, tokens: tokens),
              const SizedBox(width: 8),
              OutlineMiniButton(label: l10n.writingDiscard, onTap: onDiscard, tokens: tokens),
            ],
          ),
        ],
      ),
    );
  }
}

/// Dismissible error banner with an optional retry CTA — shared by the
/// submit-error and grading-error surfaces.
class WritingErrorBanner extends StatelessWidget {
  const WritingErrorBanner({
    super.key,
    required this.message,
    required this.l10n,
    required this.onRetry,
    required this.onDismiss,
    required this.busy,
  });

  final String message;
  final AppLocalizations l10n;
  final VoidCallback onRetry;
  final VoidCallback onDismiss;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.destructive.withValues(alpha: 0.08),
        border: Border.all(color: tokens.destructive.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: TextStyle(color: tokens.destructive, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: [
              GradientMiniButton(
                label: l10n.writingRetry,
                onTap: busy ? () {} : onRetry,
                tokens: tokens.copyWith(primary: tokens.destructive),
              ),
              const SizedBox(width: 8),
              OutlineMiniButton(label: l10n.writingClose, onTap: onDismiss, tokens: tokens),
            ],
          ),
        ],
      ),
    );
  }
}
