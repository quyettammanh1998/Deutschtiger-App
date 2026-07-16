import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/sprint/sm2_scheduler.dart';
import '../../../../../features/writing/domain/sprint/sprint_types.dart';

/// Again / Hard / Good / Easy rating buttons with interval labels — web
/// parity `sr-rating-bar.tsx`. Not sticky (the session page already scrolls
/// the whole back-face column; wrapping in `Positioned`/sticky adds
/// complexity without a clear mobile UX win over placing it at the natural
/// bottom of the scroll — deviation from web's CSS-sticky, documented).
class SrRatingBar extends StatelessWidget {
  const SrRatingBar({super.key, required this.mode, required this.onRate, this.disabled = false});

  final SRMode mode;
  final ValueChanged<SRRating> onRate;
  final bool disabled;

  static const _ratings = <(SRRating rating, String label, Color Function(AppTokens) bg, Color Function(AppTokens) fg)>[
    (SRRating.again, 'Again', _redBg, _redFg),
    (SRRating.hard, 'Hard', _yellowBg, _yellowFg),
    (SRRating.good, 'Good', _blueBg, _blueFg),
    (SRRating.easy, 'Easy', _greenBg, _greenFg),
  ];

  static Color _redBg(AppTokens t) => t.destructive.withValues(alpha: 0.12);
  static Color _redFg(AppTokens t) => t.destructive;
  static Color _yellowBg(AppTokens t) => t.warning.withValues(alpha: 0.15);
  static Color _yellowFg(AppTokens t) => t.warning;
  static Color _blueBg(AppTokens t) => t.primary.withValues(alpha: 0.12);
  static Color _blueFg(AppTokens t) => t.primary;
  static Color _greenBg(AppTokens t) => t.success.withValues(alpha: 0.15);
  static Color _greenFg(AppTokens t) => t.success;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      children: [
        for (final r in _ratings) ...[
          Expanded(
            child: Opacity(
              opacity: disabled ? 0.4 : 1,
              child: Material(
                color: r.$3(tokens),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: disabled ? null : () => onRate(r.$1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        Text(r.$2, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: r.$4(tokens))),
                        Text(
                          intervalLabel(r.$1, mode),
                          style: TextStyle(fontSize: 11, color: r.$4(tokens).withValues(alpha: 0.75)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (r != _ratings.last) const SizedBox(width: 6),
        ],
      ],
    );
  }
}
