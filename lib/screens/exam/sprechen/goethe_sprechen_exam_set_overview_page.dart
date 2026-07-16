import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/speech/sprechen_session_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/speech/sprechen_session_provider.dart';
import '../../../widgets/common/app_card.dart';

/// Web parity: `goethe-sprechen-exam-set-overview-page.tsx` — 3 Teil
/// buttons for an exam-set that bundles Sprechen with other skills, see
/// scout §B.6. Non-B1 providers show a beta banner on web; this build
/// keeps the same 3-row layout for every level since the beta gate is a
/// content/copy concern, not a structural one.
class GoetheSprechenExamSetOverviewPage extends ConsumerWidget {
  const GoetheSprechenExamSetOverviewPage({
    super.key,
    required this.providerLevel,
    required this.slug,
    required this.examTitle,
  });

  final String providerLevel;
  final String slug;
  final String examTitle;

  static const _teile = [
    ('goethe-teil1', '🤝', 'TEIL 1', 'Gemeinsam Planen'),
    ('goethe-teil2', '🎤', 'TEIL 2', 'Präsentation'),
    ('goethe-teil3', '💬', 'TEIL 3', 'Diskussion'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final resultsAsync = ref.watch(sprechenResultsProvider);
    final results = resultsAsync.valueOrNull ?? const <SprechenResult>[];

    return Scaffold(
      appBar: AppBar(title: Text(examTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            AppLocalizations.of(context).sprechenTeilSetOverviewSubtitle,
            style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
          ),
          const SizedBox(height: 12),
          for (final (segment, emoji, label, title) in _teile)
            _TeilButton(
              emoji: emoji,
              label: label,
              title: title,
              best: results
                  .where((r) => r.teil == segment)
                  .fold<num>(0, (max, r) => r.score > max ? r.score : max),
              onTap: () => context.push(
                '/exams/$providerLevel/$slug/sprechen/$segment',
              ),
            ),
        ],
      ),
    );
  }
}

class _TeilButton extends StatelessWidget {
  const _TeilButton({
    required this.emoji,
    required this.label,
    required this.title,
    required this.best,
    required this.onTap,
  });
  final String emoji;
  final String label;
  final String title;
  final num best;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppCard.small(
      margin: const EdgeInsets.only(bottom: 10),
      onTap: onTap,
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: tokens.mutedForeground,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (best >= 20)
                      Text(
                        AppLocalizations.of(context).sprechenTeilCompletedBadge,
                        style: TextStyle(fontSize: 10, color: tokens.success),
                      )
                    else if (best > 0)
                      Text(
                        'Best $best/25',
                        style: TextStyle(
                          fontSize: 10,
                          color: tokens.mutedForeground,
                        ),
                      ),
                  ],
                ),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Icon(AppPhosphorIcons.caretRight, size: 16, color: tokens.mutedForeground),
        ],
      ),
    );
  }
}
