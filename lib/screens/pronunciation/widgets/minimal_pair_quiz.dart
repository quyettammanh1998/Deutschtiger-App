import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../view_models/providers.dart' show audioServiceProvider;
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Generic two-choice "listen and pick which word played" quiz card — web
/// parity: `src/components/pronunciation/minimal-pair-quiz.tsx`
/// (`MinimalPairQuiz`/`DrillRound` family). Shared by the umlaute/ich-ach/
/// sp-st trainers' "Phân biệt" mode AND the standalone minimal-pairs page,
/// so the play/answer/feedback/next interaction is implemented once.
///
/// Fully presentational + owns only its own playback state; round
/// progression (which pair, which option is the target, score/streak) is
/// held by the caller and passed in per-round via [key] to reset internal
/// state on advance.
class MinimalPairQuizCard extends ConsumerStatefulWidget {
  const MinimalPairQuizCard({
    super.key,
    required this.progressLabel,
    required this.scoreLabel,
    required this.streak,
    required this.streakLabel,
    required this.promptLabel,
    required this.replayHintLabel,
    required this.optionAText,
    required this.optionASubtext,
    required this.optionBText,
    required this.optionBSubtext,
    required this.targetIsA,
    required this.onPlayTarget,
    required this.onAnswer,
    required this.correctFeedbackLabel,
    required this.wrongFeedbackLabel,
    required this.heardLabel,
    required this.comparingLabel,
    required this.nextLabel,
    required this.onNext,
    required this.gradient,
    this.optionBEnabled = true,
  });

  final String progressLabel;
  final String scoreLabel;
  final int streak;
  final String Function(int streak) streakLabel;
  final String promptLabel;
  final String replayHintLabel;

  final String optionAText;
  final String? optionASubtext;
  final String optionBText;
  final String? optionBSubtext;

  /// Whether the word actually played this round was option A.
  final bool targetIsA;

  /// Plays (or replays) the target word's audio via TTS.
  final Future<void> Function() onPlayTarget;

  /// `true` when the user chose option A.
  final ValueChanged<bool> onAnswer;

  final String correctFeedbackLabel;
  final String wrongFeedbackLabel;
  final String heardLabel;
  final String comparingLabel;

  final String nextLabel;
  final VoidCallback onNext;

  final List<Color> gradient;

  /// Option B is disabled when the trainer has no minimal-pair counterpart
  /// for the current item (matches web's `disabled={!minimal_pair.trim()}`).
  final bool optionBEnabled;

  @override
  ConsumerState<MinimalPairQuizCard> createState() =>
      _MinimalPairQuizCardState();
}

class _MinimalPairQuizCardState extends ConsumerState<MinimalPairQuizCard> {
  bool? _chosenA;
  bool _playing = false;

  bool get _answered => _chosenA != null;
  bool get _correct => _answered && _chosenA == widget.targetIsA;

  Future<void> _play() async {
    if (_playing) return;
    setState(() => _playing = true);
    try {
      await widget.onPlayTarget();
    } finally {
      if (mounted) setState(() => _playing = false);
    }
  }

  void _choose(bool choseA) {
    if (_answered) return;
    setState(() => _chosenA = choseA);
    widget.onAnswer(choseA);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.progressLabel,
              style: TextStyle(color: tokens.mutedForeground, fontSize: 14),
            ),
            if (widget.streak >= 3)
              Text(
                widget.streakLabel(widget.streak),
                style: const TextStyle(
                  color: Color(0xFFF59E0B),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            Text(
              widget.scoreLabel,
              style: TextStyle(color: tokens.mutedForeground, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: tokens.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tokens.border),
          ),
          child: Column(
            children: [
              Text(
                widget.promptLabel,
                style: TextStyle(color: tokens.mutedForeground, fontSize: 14),
              ),
              const SizedBox(height: 16),
              InkWell(
                customBorder: const CircleBorder(),
                onTap: _play,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: widget.gradient),
                  ),
                  child: Center(
                    child: _playing
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            PhosphorIcons.play,
                            color: Colors.white,
                            size: 28,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.replayHintLabel,
                style: TextStyle(color: tokens.mutedForeground, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _OptionButton(
                text: widget.optionAText,
                subtext: widget.optionASubtext,
                answered: _answered,
                isTarget: widget.targetIsA,
                isChosen: _chosenA == true,
                enabled: !_answered,
                onTap: () => _choose(true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OptionButton(
                text: widget.optionBText,
                subtext: widget.optionBSubtext,
                answered: _answered,
                isTarget: !widget.targetIsA,
                isChosen: _chosenA == false,
                enabled: !_answered && widget.optionBEnabled,
                onTap: () => _choose(false),
              ),
            ),
          ],
        ),
        if (_answered) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: _correct
                  ? const Color(0xFFECFDF5)
                  : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _correct
                      ? widget.correctFeedbackLabel
                      : widget.wrongFeedbackLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: _correct
                        ? const Color(0xFF15803D)
                        : const Color(0xFFB91C1C),
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${widget.heardLabel} ${widget.targetIsA ? widget.optionAText : widget.optionBText}',
                  style: TextStyle(
                    color: _correct
                        ? const Color(0xFF15803D)
                        : const Color(0xFFB91C1C),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.comparingLabel,
                  style: TextStyle(
                    color: (_correct
                            ? const Color(0xFF15803D)
                            : const Color(0xFFB91C1C))
                        .withValues(alpha: 0.75),
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: widget.gradient),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: widget.onNext,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    widget.nextLabel,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.text,
    required this.subtext,
    required this.answered,
    required this.isTarget,
    required this.isChosen,
    required this.enabled,
    required this.onTap,
  });

  final String text;
  final String? subtext;
  final bool answered;
  final bool isTarget;
  final bool isChosen;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    Color bg = tokens.card;
    Color fg = tokens.foreground;
    if (answered) {
      if (isTarget) {
        bg = const Color(0xFFDCFCE7);
        fg = const Color(0xFF166534);
      } else if (isChosen) {
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFF991B1B);
      } else {
        bg = tokens.card.withValues(alpha: 0.5);
        fg = tokens.mutedForeground;
      }
    }
    return Opacity(
      opacity: enabled || answered ? 1 : 0.4,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: enabled ? onTap : null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: tokens.border),
            ),
            child: Column(
              children: [
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
                if (answered && subtext != null && subtext!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtext!,
                    style: TextStyle(
                      fontSize: 11,
                      color: tokens.mutedForeground,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Convenience: plays [text] via the app's shared TTS pipeline (no
/// recorded-audio fallback needed for the four trainers — they never have
/// an `audio_url`).
Future<void> playPronunciationWord(WidgetRef ref, String text) {
  return ref.read(audioServiceProvider).play(text: text);
}

/// Convenience: plays either a recorded [audioUrl] or falls back to TTS for
/// [text] — used by the minimal-pairs page where pairs may carry a real
/// recorded `audio_url`.
Future<void> playPronunciationAudio(
  WidgetRef ref,
  String text,
  String? audioUrl,
) {
  return ref.read(audioServiceProvider).play(text: text, audioUrl: audioUrl);
}
