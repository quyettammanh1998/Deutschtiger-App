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
import 'widgets/pronunciation_status_views.dart';
import 'widgets/pronunciation_trainer_header.dart';

const _kMinimalPairsGradient = [Color(0xFFF97316), Color(0xFFEA580C)];
const _kRoundsPerSession = 10;

enum _Screen { picker, drill, summary }

/// Minimal-pairs listening trainer — web parity: `minimal-pairs-page.tsx`.
/// No game wall on this page (unlike the four accent trainers). Picker →
/// drill → summary, all TTS-only (word_a/word_b, optionally a recorded
/// `audio_url` played through the shared [playPronunciationAudio] helper).
class MinimalPairsPage extends ConsumerStatefulWidget {
  const MinimalPairsPage({super.key});

  @override
  ConsumerState<MinimalPairsPage> createState() => _MinimalPairsPageState();
}

class _MinimalPairsPageState extends ConsumerState<MinimalPairsPage> {
  _Screen _screen = _Screen.picker;
  MinimalPairContrast? _contrast;
  List<MinimalPair> _pairs = const [];
  final Set<int> _usedIndices = {};
  MinimalPair? _currentPair;
  bool _targetA = true;
  int _correct = 0;
  int _total = 0;
  int _roundsLeft = _kRoundsPerSession;
  bool _loadingDrill = false;

  Future<void> _startDrill(MinimalPairContrast contrast) async {
    setState(() => _loadingDrill = true);
    try {
      final pairs = await ref.read(minimalPairsProvider(contrast.contrastKey).future);
      if (!mounted || pairs.isEmpty) return;
      final random = Random();
      final index = random.nextInt(pairs.length);
      setState(() {
        _contrast = contrast;
        _pairs = pairs;
        _usedIndices
          ..clear()
          ..add(index);
        _currentPair = pairs[index];
        _targetA = random.nextBool();
        _correct = 0;
        _total = 0;
        _roundsLeft = _kRoundsPerSession;
        _screen = _Screen.drill;
      });
    } finally {
      if (mounted) setState(() => _loadingDrill = false);
    }
  }

  void _handleAnswer(bool choseA) {
    final correct = choseA == _targetA;
    setState(() {
      if (correct) _correct++;
      _total++;
    });
  }

  void _handleNext() {
    final random = Random();
    final pool = _pairs
        .asMap()
        .entries
        .where((e) => !_usedIndices.contains(e.key))
        .toList();
    final source = pool.isNotEmpty
        ? pool
        : _pairs.asMap().entries.toList();
    final picked = source[random.nextInt(source.length)];
    if (_usedIndices.length >= (_pairs.length / 2).ceil()) {
      _usedIndices.clear();
    }
    _usedIndices.add(picked.key);
    setState(() {
      _currentPair = picked.value;
      _targetA = random.nextBool();
      _roundsLeft -= 1;
    });
  }

  void _handleEnd() => setState(() => _screen = _Screen.summary);

  void _handleRetry() {
    final contrast = _contrast;
    if (contrast != null) _startDrill(contrast);
  }

  void _handleChangePair() {
    setState(() {
      _screen = _Screen.picker;
      _contrast = null;
      _currentPair = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final contrastsAsync = ref.watch(minimalPairContrastsProvider);

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: contrastsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, st) => PronunciationErrorView(
            message: l10n.pronunciationLoadError,
            retryLabel: l10n.pronunciationRetry,
            onRetry: () => ref.invalidate(minimalPairContrastsProvider),
          ),
          data: (contrasts) {
            if (_screen == _Screen.summary && _contrast != null) {
              return PronunciationCompletionCard(
                titleLabel: l10n.pronunciationMinimalPairsResultTitle,
                score: _correct,
                total: _total,
                scoreLabel: (s, t) =>
                    l10n.pronunciationMinimalPairsScoreLabel(s, t),
                retryLabel: l10n.pronunciationRetryCta,
                onRetry: _handleRetry,
                secondaryLabel: l10n.pronunciationChangePairCta,
                onSecondary: _handleChangePair,
                lowScoreHint: l10n.pronunciationMinimalPairsLowScoreHint,
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PronunciationTrainerHeader(
                    title: l10n.pronunciationMinimalPairsTitle,
                    subtitle: _screen == _Screen.drill
                        ? _contrast?.focusLabel
                        : null,
                    onBack: _screen == _Screen.drill
                        ? _handleChangePair
                        : () => context.go('/pronunciation'),
                    trailing: _screen == _Screen.drill
                        ? TextButton(
                            onPressed: _handleEnd,
                            child: Text(l10n.pronunciationEndCta),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  if (_screen == _Screen.picker)
                    _buildPicker(l10n, contrasts)
                  else if (_screen == _Screen.drill && _currentPair != null)
                    _buildDrill(l10n),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPicker(
    AppLocalizations l10n,
    List<MinimalPairContrast> contrasts,
  ) {
    if (contrasts.isEmpty) {
      return PronunciationEmptyView(
        message: l10n.pronunciationMinimalPairsEmpty,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.pronunciationMinimalPairsPickerHint,
          style: TextStyle(color: context.tokens.mutedForeground),
        ),
        const SizedBox(height: 12),
        for (final contrast in contrasts) ...[
          _ContrastCard(
            contrast: contrast,
            loading: _loadingDrill,
            pairsLabel: l10n.pronunciationMinimalPairsCount(
              contrast.pairCount,
            ),
            onTap: _loadingDrill ? null : () => _startDrill(contrast),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildDrill(AppLocalizations l10n) {
    final pair = _currentPair!;
    final isLast = _roundsLeft <= 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${l10n.pronunciationMinimalPairsPracticing} ${pair.focusLabelVi}',
            style: const TextStyle(color: Color(0xFF1E3A8A), fontSize: 13.5),
          ),
        ),
        const SizedBox(height: 12),
        MinimalPairQuizCard(
          key: ValueKey('${pair.id}-$_total'),
          progressLabel:
              '${_kRoundsPerSession - _roundsLeft + 1} / $_kRoundsPerSession',
          scoreLabel: l10n.pronunciationMinimalPairsCorrectOf(
            _correct,
            _total,
          ),
          streak: 0,
          streakLabel: (s) => '',
          promptLabel: l10n.pronunciationMinimalPairsPrompt,
          replayHintLabel: l10n.pronunciationQuizReplayHint,
          optionAText: pair.wordADe,
          optionASubtext: pair.wordAIpa == null ? null : '[${pair.wordAIpa}]',
          optionBText: pair.wordBDe,
          optionBSubtext: pair.wordBIpa == null ? null : '[${pair.wordBIpa}]',
          targetIsA: _targetA,
          onPlayTarget: () => playPronunciationAudio(
            ref,
            _targetA ? pair.wordADe : pair.wordBDe,
            _targetA ? pair.wordAAudioUrl : pair.wordBAudioUrl,
          ),
          onAnswer: (choseA) {
            _handleAnswer(choseA);
            playPronunciationAudio(ref, pair.wordADe, pair.wordAAudioUrl);
            Future<void>.delayed(const Duration(milliseconds: 400), () {
              if (mounted) {
                playPronunciationAudio(ref, pair.wordBDe, pair.wordBAudioUrl);
              }
            });
          },
          correctFeedbackLabel: l10n.pronunciationMinimalPairsCorrectLabel,
          wrongFeedbackLabel: l10n.pronunciationMinimalPairsWrongLabel(
            _targetA ? pair.wordADe : pair.wordBDe,
          ),
          heardLabel: l10n.pronunciationQuizHeardLabel,
          comparingLabel: '',
          nextLabel: isLast
              ? l10n.pronunciationQuizSeeResult
              : l10n.pronunciationNextCta,
          onNext: isLast ? _handleEnd : _handleNext,
          gradient: _kMinimalPairsGradient,
        ),
      ],
    );
  }
}

class _ContrastCard extends StatelessWidget {
  const _ContrastCard({
    required this.contrast,
    required this.loading,
    required this.pairsLabel,
    required this.onTap,
  });

  final MinimalPairContrast contrast;
  final bool loading;
  final String pairsLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Material(
      color: tokens.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tokens.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contrast.focusLabel,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: tokens.foreground,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                contrast.focusLabelVi,
                style: TextStyle(color: tokens.mutedForeground),
              ),
              const SizedBox(height: 6),
              Text(
                pairsLabel,
                style: const TextStyle(
                  color: Color(0xFFEA580C),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
