import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/pronunciation/pronunciation_models.dart';
import '../../data/pronunciation/pronunciation_providers.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/pronunciation_completion_card.dart';
import 'widgets/pronunciation_mode_toggle.dart';
import 'widgets/pronunciation_status_views.dart';
import 'widgets/pronunciation_trainer_header.dart';
import 'widgets/pronunciation_word_drill_card.dart';

const _kRSoundGradient = [Color(0xFF10B981), Color(0xFF0D9488)];

const _kPositionColors = <RPosition, Color>{
  RPosition.initial: Color(0xFFD1FAE5),
  RPosition.afterVowel: Color(0xFFDBEAFE),
  RPosition.consonantCluster: Color(0xFFEDE9FE),
  RPosition.vocalic: Color(0xFFFEF3C7),
};

const _kPositionTextColors = <RPosition, Color>{
  RPosition.initial: Color(0xFF047857),
  RPosition.afterVowel: Color(0xFF1D4ED8),
  RPosition.consonantCluster: Color(0xFF6D28D9),
  RPosition.vocalic: Color(0xFFB45309),
};

String _positionLabel(AppLocalizations l10n, RPosition position) =>
    switch (position) {
      RPosition.initial => l10n.pronunciationRPositionInitial,
      RPosition.afterVowel => l10n.pronunciationRPositionAfterVowel,
      RPosition.consonantCluster => l10n.pronunciationRPositionCluster,
      RPosition.vocalic => l10n.pronunciationRPositionVocalic,
    };

/// German R-sound trainer — web parity: `r-sound-page.tsx`. Second tab is a
/// 4-position **overview** (not a minimal-pair quiz), grouping the word pool
/// by `RPosition` — matches web's `PositionOverview`.
class RSoundTrainerPage extends ConsumerStatefulWidget {
  const RSoundTrainerPage({super.key});

  @override
  ConsumerState<RSoundTrainerPage> createState() => _RSoundTrainerPageState();
}

class _RSoundTrainerPageState extends ConsumerState<RSoundTrainerPage> {
  bool _drillMode = true;
  int _sessionSeed = 0;
  int _drillIndex = 0;
  bool _drillPlayed = false;
  bool _completed = false;
  int _finalScore = 0;
  int _finalTotal = 0;

  void _restart() {
    setState(() {
      _completed = false;
      _drillIndex = 0;
      _drillPlayed = false;
      _sessionSeed++;
    });
  }

  void _finish(int score, int total) {
    setState(() {
      _completed = true;
      _finalScore = score;
      _finalTotal = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final itemsAsync = ref.watch(rSoundItemsProvider(_sessionSeed));

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: itemsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, st) => PronunciationErrorView(
            message: l10n.pronunciationLoadError,
            retryLabel: l10n.pronunciationRetry,
            onRetry: () => ref.invalidate(rSoundItemsProvider(_sessionSeed)),
          ),
          data: (items) {
            if (_completed) {
              return PronunciationCompletionCard(
                titleLabel: l10n.pronunciationCompletedTitle,
                score: _finalScore,
                total: _finalTotal,
                scoreLabel: (s, t) => l10n.pronunciationScoreCorrect(s, t),
                retryLabel: l10n.pronunciationRetryCta,
                onRetry: _restart,
                secondaryLabel: l10n.pronunciationBackCta,
                onSecondary: () => context.go('/pronunciation'),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PronunciationTrainerHeader(
                    title: l10n.pronunciationRSoundTitle,
                    onBack: () => context.go('/pronunciation'),
                  ),
                  const SizedBox(height: 16),
                  PronunciationModeToggle(
                    leftLabel: l10n.pronunciationModePronounce,
                    rightLabel: l10n.pronunciationModeCategorize,
                    isLeftSelected: _drillMode,
                    onChanged: (left) => setState(() => _drillMode = left),
                  ),
                  const SizedBox(height: 16),
                  if (items.isEmpty)
                    PronunciationEmptyView(message: l10n.pronunciationNoData)
                  else if (_drillMode)
                    _buildDrill(context, l10n, items)
                  else
                    _PositionOverview(items: items, l10n: l10n),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDrill(
    BuildContext context,
    AppLocalizations l10n,
    List<RSoundItem> items,
  ) {
    final index = _drillIndex.clamp(0, items.length - 1);
    final item = items[index];
    final isLast = index + 1 >= items.length;
    return PronunciationWordDrillCard(
      progressLabel: '${index + 1} / ${items.length}',
      badgeLabel: _positionLabel(l10n, item.position),
      badgeColor: _kPositionColors[item.position]!,
      badgeTextColor: _kPositionTextColors[item.position]!,
      word: item.word,
      ipa: item.ipa,
      meaning: item.viMeaning,
      hintLabel: l10n.pronunciationHintLabel,
      hint: item.viHint,
      gradient: _kRSoundGradient,
      playLabel: l10n.pronunciationPlayCta,
      played: _drillPlayed,
      onPlayed: () => setState(() => _drillPlayed = true),
      nextLabel: isLast
          ? l10n.pronunciationDoneCta
          : l10n.pronunciationNextCta,
      onNext: () {
        if (isLast) {
          _finish(items.length, items.length);
        } else {
          setState(() {
            _drillIndex++;
            _drillPlayed = false;
          });
        }
      },
    );
  }
}

class _PositionOverview extends StatelessWidget {
  const _PositionOverview({required this.items, required this.l10n});

  final List<RSoundItem> items;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final groups = <RPosition, List<RSoundItem>>{
      for (final position in RPosition.values) position: [],
    };
    for (final item in items) {
      groups[item.position]!.add(item);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            l10n.pronunciationROverviewInfo,
            style: const TextStyle(
              color: Color(0xFF1E3A8A),
              fontSize: 13.5,
              height: 1.5,
            ),
          ),
        ),
        for (final entry in groups.entries) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: tokens.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: tokens.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _kPositionColors[entry.key],
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _positionLabel(l10n, entry.key),
                    style: TextStyle(
                      color: _kPositionTextColors[entry.key],
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final word in entry.value)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: tokens.muted.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: tokens.border),
                        ),
                        child: Column(
                          children: [
                            Text(
                              word.word,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: tokens.foreground,
                              ),
                            ),
                            Text(
                              '[${word.ipa}]',
                              style: TextStyle(
                                fontSize: 10,
                                color: tokens.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
