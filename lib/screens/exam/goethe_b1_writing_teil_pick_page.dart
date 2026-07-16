import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../features/writing/data/goethe_b1_writing_repository.dart';
import '../../features/writing/domain/goethe_b1_writing_manifest.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common/app_card.dart';
import 'widgets/writing_teil_pick/teil_pick_card.dart';
import 'widgets/writing_teil_pick/teil_pick_hero.dart';

/// Goethe B1 writing Teil picker — web parity
/// `goethe-b1-writing-teil-pick-page.tsx` (`/exams/goethe-b1/writing`):
/// orange/amber hero + badge pills + stat mini-cards, then a `card
/// divide-y` of 3 [TeilPickCard]s with per-Teil progress bars. Data:
/// `GET /goethe-b1-writing/manifest` (public) for titles/topic counts,
/// `GET /user/goethe-b1-writing-results` (auth) for the done count.
class GoetheB1WritingTeilPickPage extends ConsumerWidget {
  const GoetheB1WritingTeilPickPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final manifestAsync = ref.watch(goetheB1WritingManifestProvider);
    final resultsAsync = ref.watch(goetheB1WritingAllResultsProvider);
    final isLoading = manifestAsync.isLoading;
    final totalTopics = manifestAsync.valueOrNull?.totalTopics ?? 0;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.goetheB1WritingEyebrow,
                            style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: tokens.foreground,
                              ),
                              children: [
                                TextSpan(text: l10n.goetheB1WritingHeadingPrefix),
                                TextSpan(
                                  text: l10n.goetheB1WritingHeadingSchreiben,
                                  style: const TextStyle(color: Color(0xFFF97316)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TeilPickHero(totalTopics: totalTopics, isLoading: isLoading),
              const SizedBox(height: 10),
              Wrap(
                spacing: 16,
                runSpacing: 4,
                children: [
                  InkWell(
                    onTap: () => context.push('/luyen-viet'),
                    child: Text(
                      l10n.goetheB1WritingAllExamsLink,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tokens.primary),
                    ),
                  ),
                  InkWell(
                    onTap: () => context.push('/luyen-viet?tab=my'),
                    child: Text(
                      l10n.goetheB1WritingMyEssaysLink,
                      style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _TeilList(
                isLoading: isLoading,
                teils: manifestAsync.valueOrNull?.teils ?? const [],
                results: resultsAsync.valueOrNull ?? const [],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeilList extends StatelessWidget {
  const _TeilList({required this.isLoading, required this.teils, required this.results});

  final bool isLoading;
  final List<GoetheB1WritingManifestTeil> teils;
  final List<GoetheB1WritingResult> results;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (isLoading) {
      return AppCard.card(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            for (var i = 0; i < 3; i++) const _SkeletonRow(showTopBorder: false),
          ],
        ),
      );
    }
    return AppCard.card(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < teils.length; i++)
            TeilPickCard(
              teil: teils[i].teil,
              titleVi: teils[i].titleVi,
              subtitle: _subtitleFor(l10n, teils[i].teil),
              topicCount: teils[i].topicCount,
              doneCount: results.where((r) => r.teil == teils[i].teil).length,
              onTap: () => context.push('/exam/goethe-b1/writing/${teils[i].teil}'),
              showTopBorder: i > 0,
            ),
        ],
      ),
    );
  }

  String _subtitleFor(AppLocalizations l10n, int teil) => switch (teil) {
    2 => l10n.goetheB1WritingTeil2Subtitle,
    3 => l10n.goetheB1WritingTeil3Subtitle,
    _ => l10n.goetheB1WritingTeil1Subtitle,
  };
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow({required this.showTopBorder});
  final bool showTopBorder;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: showTopBorder ? Border(top: BorderSide(color: tokens.border)) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: tokens.muted, borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, width: 140, color: tokens.muted),
                  const SizedBox(height: 8),
                  Container(height: 10, width: 90, color: tokens.muted),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
