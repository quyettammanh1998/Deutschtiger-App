import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../data/pronunciation/pronunciation_models.dart';
import '../../data/pronunciation/pronunciation_providers.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/minimal_pair_quiz.dart';
import 'widgets/pronunciation_completion_card.dart';
import 'widgets/pronunciation_mode_toggle.dart';
import 'widgets/pronunciation_status_views.dart';
import 'widgets/pronunciation_trainer_header.dart';
import 'widgets/pronunciation_word_drill_card.dart';

const _kSpStGradient = [Color(0xFFF59E0B), Color(0xFFEA580C)];
const _kSpStQuizCount = 10;

class _SpStRound {
  const _SpStRound({
    required this.wordA,
    required this.wordB,
    required this.playedA,
  });
  final SpStItem wordA; // sp word
  final SpStItem wordB; // st word
  final bool playedA;
}

List<_SpStRound> _buildSpStRounds(List<SpStItem> items) {
  final spWords = items.where((it) => it.isSp).toList(growable: false);
  final stWords = items.where((it) => !it.isSp).toList(growable: false);
  if (spWords.isEmpty || stWords.isEmpty) return const [];
  final random = Random();
  return List.generate(_kSpStQuizCount, (i) {
    return _SpStRound(
      wordA: spWords[i % spWords.length],
      wordB: stWords[i % stWords.length],
      playedA: random.nextBool(),
    );
  }, growable: false);
}

/// `sp → /ʃp/` / `st → /ʃt/` initial-cluster trainer — web parity:
/// `sp-st-initial-page.tsx`. Quiz mode contrasts two independent word pools
/// (sp vs st) rather than a per-item `minimal_pair` field.
class SpStTrainerPage extends ConsumerStatefulWidget {
  const SpStTrainerPage({super.key});

  @override
  ConsumerState<SpStTrainerPage> createState() => _SpStTrainerPageState();
}

class _SpStTrainerPageState extends ConsumerState<SpStTrainerPage> {
  bool _drillMode = true;
  int _sessionSeed = 0;
  int _drillIndex = 0;
  bool _drillPlayed = false;
  bool _completed = false;
  int _finalScore = 0;
  int _finalTotal = 0;

  List<_SpStRound>? _rounds;
  int _quizIndex = 0;
  int _quizScore = 0;
  int _quizStreak = 0;

  void _restart() {
    setState(() {
      _completed = false;
      _drillIndex = 0;
      _drillPlayed = false;
      _quizIndex = 0;
      _quizScore = 0;
      _quizStreak = 0;
      _rounds = null;
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
    final itemsAsync = ref.watch(spStItemsProvider(_sessionSeed));

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: itemsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, st) => PronunciationErrorView(
            message: l10n.pronunciationLoadError,
            retryLabel: l10n.pronunciationRetry,
            onRetry: () => ref.invalidate(spStItemsProvider(_sessionSeed)),
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
                    title: l10n.pronunciationSpStTitle,
                    onBack: () => context.go('/pronunciation'),
                  ),
                  const SizedBox(height: 16),
                  PronunciationModeToggle(
                    leftLabel: l10n.pronunciationModePronounce,
                    rightLabel: l10n.pronunciationModeDistinguishSpSt,
                    isLeftSelected: _drillMode,
                    onChanged: (left) => setState(() => _drillMode = left),
                  ),
                  const SizedBox(height: 16),
                  if (items.isEmpty)
                    PronunciationEmptyView(message: l10n.pronunciationNoData)
                  else if (_drillMode)
                    _buildDrill(context, l10n, items)
                  else
                    _buildQuiz(context, l10n, items),
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
    List<SpStItem> items,
  ) {
    final index = _drillIndex.clamp(0, items.length - 1);
    final item = items[index];
    final isLast = index + 1 >= items.length;
    return PronunciationWordDrillCard(
      progressLabel: '${index + 1} / ${items.length}',
      badgeLabel: item.isSp ? '/ʃp/ — shp' : '/ʃt/ — sht',
      badgeColor: item.isSp
          ? const Color(0xFFFEF3C7)
          : const Color(0xFFFFEDD5),
      badgeTextColor: item.isSp
          ? const Color(0xFFB45309)
          : const Color(0xFFC2410C),
      word: item.word,
      ipa: item.ipa,
      meaning: item.viMeaning,
      hintLabel: l10n.pronunciationHintLabel,
      hint: item.viHint,
      gradient: _kSpStGradient,
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

  Widget _buildQuiz(
    BuildContext context,
    AppLocalizations l10n,
    List<SpStItem> items,
  ) {
    final rounds = _rounds ??= _buildSpStRounds(items);
    if (rounds.isEmpty) {
      return PronunciationEmptyView(
        message: l10n.pronunciationQuizInsufficientData,
      );
    }
    final round = rounds[_quizIndex.clamp(0, rounds.length - 1)];
    final isLast = _quizIndex + 1 >= rounds.length;

    return MinimalPairQuizCard(
      key: ValueKey('sp-st-quiz-$_quizIndex-$_sessionSeed'),
      progressLabel: '${_quizIndex + 1} / ${rounds.length}',
      scoreLabel: l10n.pronunciationQuizScore(_quizScore),
      streak: _quizStreak,
      streakLabel: (s) => l10n.pronunciationStreak(s),
      promptLabel: l10n.pronunciationQuizPrompt,
      replayHintLabel: l10n.pronunciationQuizReplayHint,
      optionAText: round.wordA.word,
      optionASubtext: '/ʃp/',
      optionBText: round.wordB.word,
      optionBSubtext: '/ʃt/',
      targetIsA: round.playedA,
      onPlayTarget: () => playPronunciationWord(
        ref,
        round.playedA ? round.wordA.word : round.wordB.word,
      ),
      onAnswer: (choseA) {
        final correct = choseA == round.playedA;
        setState(() {
          if (correct) {
            _quizScore++;
            _quizStreak++;
          } else {
            _quizStreak = 0;
          }
        });
        Future<void>.delayed(const Duration(milliseconds: 200), () {
          if (mounted) playPronunciationWord(ref, round.wordA.word);
        });
        Future<void>.delayed(const Duration(milliseconds: 1200), () {
          if (mounted) playPronunciationWord(ref, round.wordB.word);
        });
      },
      correctFeedbackLabel: l10n.pronunciationQuizCorrect,
      wrongFeedbackLabel: l10n.pronunciationQuizWrong,
      heardLabel: l10n.pronunciationQuizHeardLabel,
      comparingLabel: l10n.pronunciationQuizComparing,
      nextLabel: isLast
          ? l10n.pronunciationQuizSeeResult
          : l10n.pronunciationNextCta,
      onNext: () {
        if (isLast) {
          _finish(_quizScore, rounds.length);
        } else {
          setState(() => _quizIndex++);
        }
      },
      gradient: _kSpStGradient,
    );
  }
}
