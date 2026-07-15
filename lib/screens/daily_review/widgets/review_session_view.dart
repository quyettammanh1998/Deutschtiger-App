import 'package:flutter/material.dart';

import '../../../../core/design_tokens.dart';
import '../../../data/flashcard/review_item.dart';
import '../../../l10n/app_localizations.dart';

/// Active review surface — flashcard reveal + 4-button FSRS grading
/// (Again / Hard / Good / Easy). Tracks a single card's reveal state.
/// FSRS tính toàn bộ phía server — widget này chỉ hiển thị + phát ra rating.
class ReviewSessionView extends StatefulWidget {
  const ReviewSessionView({
    super.key,
    required this.position,
    required this.total,
    required this.item,
    required this.onAnswer,
    this.submitting = false,
    this.errorMessage,
  });

  final int position;
  final int total;
  final ReviewItem item;
  final ValueChanged<ReviewRating> onAnswer;
  final bool submitting;
  final String? errorMessage;

  @override
  State<ReviewSessionView> createState() => _ReviewSessionViewState();
}

class _ReviewSessionViewState extends State<ReviewSessionView> {
  bool _revealed = false;

  @override
  void didUpdateWidget(covariant ReviewSessionView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id) {
      _revealed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        backgroundColor: DesignTokens.background,
        title: Text(
          l10n.reviewProgress(widget.position, widget.total),
          style: TextStyle(color: DesignTokens.mutedForeground),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.all(DesignTokens.spacingLg),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LinearProgressIndicator(
                    value: widget.position / widget.total,
                    backgroundColor: DesignTokens.muted,
                    valueColor: const AlwaysStoppedAnimation(
                      DesignTokens.tigerOrange,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.item.displayDe,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_revealed) ...[
                          const SizedBox(height: DesignTokens.spacingLg),
                          Text(
                            widget.item.displayVi,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              color: DesignTokens.mutedForeground,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!_revealed)
                    FilledButton(
                      onPressed: () => setState(() => _revealed = true),
                      style: FilledButton.styleFrom(
                        backgroundColor: DesignTokens.tigerOrange,
                        foregroundColor: DesignTokens.card,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusSm + 4,
                          ),
                        ),
                      ),
                      child: Text(
                        l10n.showMeaning,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.errorMessage != null) ...[
                          Text(
                            l10n.couldNotSaveReview,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: DesignTokens.error),
                          ),
                          const SizedBox(height: DesignTokens.spacingSm),
                        ],
                        FsrsRatingBar(
                          onAnswer: widget.onAnswer,
                          enabled: !widget.submitting,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 4-button FSRS grading bar (Again / Hard / Good / Easy).
class FsrsRatingBar extends StatelessWidget {
  const FsrsRatingBar({super.key, required this.onAnswer, this.enabled = true});
  final ValueChanged<ReviewRating> onAnswer;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final textScale = MediaQuery.textScalerOf(context).scale(1);
        final columns = textScale >= 1.4 ? 2 : 4;
        final buttonWidth =
            (constraints.maxWidth - DesignTokens.spacingSm * (columns - 1)) /
            columns;
        return Wrap(
          spacing: DesignTokens.spacingSm,
          runSpacing: DesignTokens.spacingSm,
          children: [
            _RatingButton(
              width: buttonWidth,
              label: l10n.ratingAgain,
              subtitle: l10n.ratingAgainHint,
              color: DesignTokens.error,
              onTap: enabled ? () => onAnswer(ReviewRating.forgot) : null,
            ),
            _RatingButton(
              width: buttonWidth,
              label: l10n.ratingHard,
              subtitle: l10n.ratingHardHint,
              color: DesignTokens.warning,
              onTap: enabled ? () => onAnswer(ReviewRating.hard) : null,
            ),
            _RatingButton(
              width: buttonWidth,
              label: l10n.ratingGood,
              subtitle: l10n.ratingGoodHint,
              color: DesignTokens.tigerOrange,
              onTap: enabled ? () => onAnswer(ReviewRating.medium) : null,
            ),
            _RatingButton(
              width: buttonWidth,
              label: l10n.ratingEasy,
              subtitle: l10n.ratingEasyHint,
              color: DesignTokens.success,
              onTap: enabled ? () => onAnswer(ReviewRating.easy) : null,
            ),
          ],
        );
      },
    );
  }
}

class _RatingButton extends StatelessWidget {
  const _RatingButton({
    required this.label,
    required this.subtitle,
    required this.width,
    required this.color,
    required this.onTap,
  });
  final String label;
  final String subtitle;
  final double width;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Opacity(
        opacity: onTap == null ? 0.5 : 1,
        child: Material(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm + 4),
          child: InkWell(
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm + 4),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: DesignTokens.spacingSm + 4,
              ),
              child: Column(
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: DesignTokens.mutedForeground,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
