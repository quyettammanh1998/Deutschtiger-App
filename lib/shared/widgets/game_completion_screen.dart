import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';
import '../../l10n/app_localizations.dart';
import 'confetti_overlay.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Game / lesson end screen with score, accuracy, and two CTAs.
///
/// Renders a small simulated confetti layer via [ConfettiOverlay] and a
/// result card. No third-party packages required.
class GameCompletionScreen extends StatefulWidget {
  const GameCompletionScreen({
    super.key,
    required this.score,
    required this.total,
    required this.onPlayAgain,
    required this.onGoHome,
    this.title,
    this.subtitle,
    this.accuracyLabel,
  });

  final int score;
  final int total;
  final VoidCallback onPlayAgain;
  final VoidCallback onGoHome;
  final String? title;
  final String? subtitle;
  final String? accuracyLabel;

  @override
  State<GameCompletionScreen> createState() => _GameCompletionScreenState();
}

class _GameCompletionScreenState extends State<GameCompletionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _accuracy {
    if (widget.total <= 0) return 0;
    return (widget.score / widget.total).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final pct = (_accuracy * 100).round();
    return Scaffold(
      backgroundColor: DesignTokens.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: ConfettiOverlay(controller: _controller)),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingLg,
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                    DesignTokens.spacingLg,
                    28,
                    DesignTokens.spacingLg,
                    DesignTokens.spacingLg,
                  ),
                  decoration: BoxDecoration(
                    color: DesignTokens.card,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                    boxShadow: DesignTokens.shadowMd,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        PhosphorIcons.trophy,
                        size: 56,
                        color: DesignTokens.warning,
                      ),
                      const SizedBox(height: DesignTokens.spacingSm + 4),
                      Text(
                        widget.title ?? l10n.completed,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: DesignTokens.spacingSm - 2),
                        Text(
                          widget.subtitle!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: DesignTokens.mutedForeground,
                          ),
                        ),
                      ],
                      const SizedBox(height: DesignTokens.spacingLg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: _StatBlock(
                              label: l10n.score,
                              value: '${widget.score}/${widget.total}',
                            ),
                          ),
                          Expanded(
                            child: _StatBlock(
                              label: widget.accuracyLabel ?? l10n.accuracy,
                              value: '$pct%',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: widget.onPlayAgain,
                          icon: const Icon(PhosphorIcons.arrowCounterClockwise),
                          label: Text(l10n.playAgain),
                          style: FilledButton.styleFrom(
                            backgroundColor: DesignTokens.orange500,
                            foregroundColor: DesignTokens.card,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacingSm + 2),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: widget.onGoHome,
                          icon: const Icon(PhosphorIcons.house),
                          label: Text(l10n.backToHome),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: DesignTokens.orange500,
                            side: const BorderSide(
                              color: DesignTokens.orange500,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: DesignTokens.orange500,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingXs),
        Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: DesignTokens.mutedForeground,
          ),
        ),
      ],
    );
  }
}
