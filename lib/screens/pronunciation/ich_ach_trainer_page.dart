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
import 'widgets/pronunciation_quiz_rounds.dart';
import 'widgets/pronunciation_status_views.dart';
import 'widgets/pronunciation_trainer_header.dart';
import 'widgets/pronunciation_word_drill_card.dart';

const _kIchAchGradient = [Color(0xFF3B82F6), Color(0xFF0891B2)];

/// Ich-laut `[ç]` / Ach-laut `[x]` trainer — web parity:
/// `ich-ach-laut-page.tsx`. Same drill + quiz shape as the umlaute trainer,
/// with a per-sound badge and a "So sánh: `minimal_pair`" line on the drill
/// card.
class IchAchTrainerPage extends ConsumerStatefulWidget {
  const IchAchTrainerPage({super.key});

  @override
  ConsumerState<IchAchTrainerPage> createState() => _IchAchTrainerPageState();
}

class _IchAchTrainerPageState extends ConsumerState<IchAchTrainerPage> {
  bool _drillMode = true;
  int _sessionSeed = 0;
  int _drillIndex = 0;
  bool _drillPlayed = false;
  bool _completed = false;
  int _finalScore = 0;
  int _finalTotal = 0;

  List<TtsQuizRound<IchAchItem>>? _rounds;
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
    final itemsAsync = ref.watch(ichAchItemsProvider(_sessionSeed));

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: itemsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, st) => PronunciationErrorView(
            message: l10n.pronunciationLoadError,
            retryLabel: l10n.pronunciationRetry,
            onRetry: () => ref.invalidate(ichAchItemsProvider(_sessionSeed)),
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
                    title: l10n.pronunciationIchAchTitle,
                    onBack: () => context.go('/pronunciation'),
                  ),
                  const SizedBox(height: 16),
                  PronunciationModeToggle(
                    leftLabel: l10n.pronunciationModePronounce,
                    rightLabel: l10n.pronunciationModeDistinguish,
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
    List<IchAchItem> items,
  ) {
    final index = _drillIndex.clamp(0, items.length - 1);
    final item = items[index];
    final isLast = index + 1 >= items.length;
    final isIch = item.isIchLaut;
    return PronunciationWordDrillCard(
      progressLabel: '${index + 1} / ${items.length}',
      badgeLabel: isIch
          ? l10n.pronunciationIchLautBadge
          : l10n.pronunciationAchLautBadge,
      badgeColor: isIch
          ? const Color(0xFFDBEAFE)
          : const Color(0xFFFEF3C7),
      badgeTextColor: isIch
          ? const Color(0xFF1D4ED8)
          : const Color(0xFFB45309),
      word: item.word,
      ipa: item.ipa,
      meaning: item.viMeaning,
      compareLabel: item.minimalPair.trim().isEmpty
          ? null
          : '${l10n.pronunciationCompareLabel} ${item.minimalPair}',
      hintLabel: l10n.pronunciationHintLabel,
      hint: item.viHint,
      gradient: _kIchAchGradient,
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
    List<IchAchItem> items,
  ) {
    final rounds = _rounds ??= buildTtsQuizRounds<IchAchItem>(
      items,
      minimalPairOf: (it) => it.minimalPair,
    );
    if (rounds.isEmpty) {
      return PronunciationEmptyView(
        message: l10n.pronunciationQuizInsufficientData,
      );
    }
    final round = rounds[_quizIndex.clamp(0, rounds.length - 1)];
    final isLast = _quizIndex + 1 >= rounds.length;

    return MinimalPairQuizCard(
      key: ValueKey('ich-ach-quiz-$_quizIndex-$_sessionSeed'),
      progressLabel: '${_quizIndex + 1} / ${rounds.length}',
      scoreLabel: l10n.pronunciationQuizScore(_quizScore),
      streak: _quizStreak,
      streakLabel: (s) => l10n.pronunciationStreak(s),
      promptLabel: l10n.pronunciationQuizPrompt,
      replayHintLabel: l10n.pronunciationQuizReplayHint,
      optionAText: round.item.word,
      optionASubtext: '[${round.item.ipa}]',
      optionBText: round.item.minimalPair.isEmpty
          ? '—'
          : round.item.minimalPair,
      optionBSubtext: null,
      optionBEnabled: round.item.minimalPair.trim().isNotEmpty,
      targetIsA: round.playedTarget,
      onPlayTarget: () => playPronunciationWord(
        ref,
        round.playedTarget ? round.item.word : round.item.minimalPair,
      ),
      onAnswer: (choseA) {
        final correct = choseA == round.playedTarget;
        setState(() {
          if (correct) {
            _quizScore++;
            _quizStreak++;
          } else {
            _quizStreak = 0;
          }
        });
        Future<void>.delayed(const Duration(milliseconds: 200), () {
          if (mounted) playPronunciationWord(ref, round.item.word);
        });
        if (round.item.minimalPair.trim().isNotEmpty) {
          Future<void>.delayed(const Duration(milliseconds: 1200), () {
            if (mounted) playPronunciationWord(ref, round.item.minimalPair);
          });
        }
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
      gradient: _kIchAchGradient,
    );
  }
}
