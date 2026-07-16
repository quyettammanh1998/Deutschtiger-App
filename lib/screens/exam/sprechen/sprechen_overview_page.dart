import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/speech/sprechen_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/speech/sprechen_provider.dart';
import '../../../widgets/common/app_card.dart';

/// Web parity: `sprechen-overview-page.tsx` (TELC) — same structure as the
/// Goethe overview with TELC's Teil labels/points, see scout §B.9.
class SprechenOverviewPage extends ConsumerWidget {
  const SprechenOverviewPage({super.key});

  static const _teile = [
    _TeilMeta(
      segment: SprechenTeil.telcTeil1,
      title: 'Teil 1 — Kennenlernen',
      subtitle: 'Kennenlernen',
      points: 15,
      emoji: '👋',
      color: Color(0xFF0284C7),
    ),
    _TeilMeta(
      segment: SprechenTeil.telcTeil2,
      title: 'Teil 2 — Vortrag',
      subtitle: 'Vortrag',
      points: 30,
      emoji: '🎤',
      color: Color(0xFFE11D48),
    ),
    _TeilMeta(
      segment: SprechenTeil.telcTeil3,
      title: 'Teil 3 — Gemeinsam planen',
      subtitle: 'Gemeinsam planen',
      points: 30,
      emoji: '🤝',
      color: Color(0xFFD97706),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.sprechenOverviewTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.sprechenOverviewSubtitle('telc B1'),
              style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
            ),
            const SizedBox(height: 12),
            AppCard.card(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (var i = 0; i < _teile.length; i++) ...[
                    _TeilRow(
                      meta: _teile[i],
                      onTap: () => context.push(
                        '/exams/telc/b1/noi/${_teile[i].segment}',
                      ),
                    ),
                    if (i != _teile.length - 1)
                      Divider(height: 1, color: tokens.border),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppCard.small(
              child: Text(
                l10n.sprechenOverviewTelcInfo,
                style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeilMeta {
  const _TeilMeta({
    required this.segment,
    required this.title,
    required this.subtitle,
    required this.points,
    required this.emoji,
    required this.color,
  });
  final String segment;
  final String title;
  final String subtitle;
  final int points;
  final Color color;
  final String emoji;
}

class _TeilRow extends ConsumerWidget {
  const _TeilRow({required this.meta, required this.onTap});
  final _TeilMeta meta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final topicsAsync = ref.watch(sprechenTopicsProvider(meta.segment));
    final total = topicsAsync.valueOrNull?.length ?? 0;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: meta.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(meta.emoji, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          meta.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: meta.color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: tokens.muted,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${meta.points} Punkte',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    meta.subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: tokens.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context).sprechenTopicCount(total),
                    style: TextStyle(
                      fontSize: 10,
                      color: tokens.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            Icon(AppPhosphorIcons.caretRight, size: 18, color: tokens.mutedForeground),
          ],
        ),
      ),
    );
  }
}
