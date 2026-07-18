import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Per-Teil metadata — web parity `TEIL_META` in `teil-pick-card.tsx`.
/// Fixed (only 3 Teils exist for Goethe B1 Schreiben); not sourced from the
/// backend.
class TeilMeta {
  const TeilMeta({
    required this.emoji,
    required this.points,
    required this.color,
    required this.tintBg,
  });

  final String emoji;
  final int points;
  final Color color;
  final Color tintBg;

  static const _blue = Color(0xFF2563EB);
  static const _violet = Color(0xFF7C3AED);
  static const _green = Color(0xFF15803D);

  static TeilMeta forTeil(int teil) => switch (teil) {
    2 => const TeilMeta(emoji: '💬', points: 40, color: _violet, tintBg: Color(0xFFF5F3FF)),
    3 => const TeilMeta(emoji: '📋', points: 20, color: _green, tintBg: Color(0xFFF0FDF4)),
    _ => const TeilMeta(emoji: '✉️', points: 40, color: _blue, tintBg: Color(0xFFEFF6FF)),
  };
}

/// One `Teil {n}` row inside the teil-pick page's `card divide-y` list —
/// web parity `components/exam/goethe-b1-writing/teil-pick-card.tsx`.
class TeilPickCard extends StatelessWidget {
  const TeilPickCard({
    super.key,
    required this.teil,
    required this.titleVi,
    required this.subtitle,
    required this.topicCount,
    required this.doneCount,
    required this.onTap,
    this.showTopBorder = false,
  });

  final int teil;
  final String titleVi;
  final String subtitle;
  final int topicCount;
  final int doneCount;
  final VoidCallback onTap;
  final bool showTopBorder;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final meta = TeilMeta.forTeil(teil);
    final pct = topicCount > 0 ? (doneCount / topicCount).clamp(0, 1).toDouble() : 0.0;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: showTopBorder ? Border(top: BorderSide(color: tokens.border)) : null,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: meta.tintBg, borderRadius: BorderRadius.circular(12)),
                child: Text(meta.emoji, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Text(
                          l10n.goetheB1WritingTeilLabel(teil),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: meta.color),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: meta.tintBg,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            l10n.goetheB1WritingPoints(meta.points),
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: meta.color),
                          ),
                        ),
                        Text(
                          titleVi,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: tokens.foreground,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: pct,
                        minHeight: 3,
                        backgroundColor: tokens.border,
                        valueColor: AlwaysStoppedAnimation(meta.color),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$doneCount/$topicCount',
                    style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                  ),
                  const SizedBox(height: 4),
                  Icon(PhosphorIcons.caretRight, size: 16, color: tokens.mutedForeground.withValues(alpha: 0.4)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
