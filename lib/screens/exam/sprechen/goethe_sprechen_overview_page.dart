import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/speech/sprechen_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/speech/sprechen_provider.dart';
import '../../../widgets/common/app_card.dart';

/// Web parity: `goethe-sprechen-overview-page.tsx` — 3-row Teil list
/// (Gemeinsam Planen / Präsentation + Q&A / Diskussion), see scout §B.1.
class GoetheSprechenOverviewPage extends ConsumerWidget {
  const GoetheSprechenOverviewPage({super.key, required this.level});

  final String level;

  static const _teile = [
    _TeilMeta(
      segment: SprechenTeil.goetheTeil1,
      title: 'Teil 1 — Gemeinsam Planen',
      subtitle: 'Gemeinsam Planen',
      points: 25,
      emoji: '🤝',
      color: Color(0xFFD97706),
    ),
    _TeilMeta(
      segment: SprechenTeil.goetheTeil2,
      title: 'Teil 2 — Präsentation',
      subtitle: 'Präsentation + Q&A',
      points: 25,
      emoji: '🎤',
      color: Color(0xFFE11D48),
    ),
    _TeilMeta(
      segment: SprechenTeil.goetheTeil3,
      title: 'Teil 3 — Diskussion',
      subtitle: 'Diskussion',
      points: 25,
      emoji: '💬',
      color: Color(0xFF2563EB),
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
              l10n.sprechenOverviewSubtitle('Goethe $level'),
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
                        '/exams/goethe/$level/sprechen/${_teile[i].segment}',
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
                l10n.sprechenOverviewGoetheInfo,
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
  final String emoji;
  final Color color;
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
