import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/practice/practice_result.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/confetti_overlay.dart';
import '../../../widgets/common/app_button.dart';
import '../../../widgets/common/app_card.dart';
import '../../daily_review/widgets/daily_review_round_cards.dart' show DailyReviewXpPill;

/// Màn kết quả sau khi hoàn thành 1 phiên luyện tập — web parity:
/// `practice-page.tsx` results screen ("Hoàn thành!" + accuracy + XP
/// gradient pill + `ConfettiBurst`), thay cho trophy icon tự chế trước đây.
class PracticeResultsView extends StatefulWidget {
  const PracticeResultsView({
    super.key,
    required this.results,
    required this.onRestart,
    required this.onBackToDeck,
    this.backLabel,
  });

  final List<PracticeResultEntry> results;
  final VoidCallback onRestart;
  final VoidCallback onBackToDeck;

  /// Overrides the default "Back to deck" copy for callers that aren't
  /// deck-scoped (e.g. the standalone `/games/*` practice-view routes).
  final String? backLabel;

  @override
  State<PracticeResultsView> createState() => _PracticeResultsViewState();
}

class _PracticeResultsViewState extends State<PracticeResultsView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final correctCount = widget.results.where((r) => r.correct).length;
    final accuracy = widget.results.isEmpty
        ? 0
        : (correctCount / widget.results.length * 100).round();
    // Round-level XP isn't threaded back through `PracticeResultEntry` (each
    // view tracks its own per-item XP counter internally for the in-progress
    // header) — the results screen approximates the web `+N XP` pill with
    // the same `correct * 10` heuristic used by the daily-review round
    // summary, for visual consistency across both flows.
    final xpEarned = correctCount * 10;

    return Stack(
      children: [
        Positioned.fill(child: ConfettiOverlay(controller: _confettiController)),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: AppCard.card(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.practiceResultsTitle,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: tokens.foreground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.results.isNotEmpty) ...[
                    Text(
                      '$accuracy%',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: tokens.primary,
                      ),
                    ),
                    Text(
                      l10n.practiceAccuracySummary(correctCount, widget.results.length),
                      style: TextStyle(color: tokens.mutedForeground),
                    ),
                    if (xpEarned > 0) ...[
                      const SizedBox(height: 12),
                      DailyReviewXpPill(xp: xpEarned),
                    ],
                  ],
                  const SizedBox(height: 24),
                  // Web mobile default is `flex-col` (row only from `sm:` up)
                  // — stack full-width so longer localized labels (German)
                  // never overflow a tight 2-col row.
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          label: l10n.practiceRestart,
                          onPressed: widget.onRestart,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          label: widget.backLabel ?? l10n.practiceBackToDeck,
                          variant: AppButtonVariant.outline,
                          onPressed: widget.onBackToDeck,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
