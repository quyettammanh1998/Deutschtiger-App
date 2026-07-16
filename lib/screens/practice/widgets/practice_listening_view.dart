import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/icons/app_phosphor_icons.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/practice/practice_result.dart';
import '../../../data/practice/practice_round_item.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/providers.dart';
import 'practice_progress_header.dart';

const _speeds = [0.75, 1.0, 1.25];

/// "Luyện Flashcards" (`/games/flashcards`, web `practice-listening-page.tsx`
/// → `ListeningPlayer`) — thẻ lật 3D: mặt trước phát âm từ tiếng Đức, mặt sau
/// lộ nghĩa tiếng Việt; người dùng tự đánh giá "Chưa nhớ"/"Đã nhớ" (không có
/// đáp án trắc nghiệm — khớp thiết kế web, khác bản MCQ cũ). Round type =
/// [PracticeRoundItem] (dùng chung với 3 view kia).
class PracticeListeningView extends ConsumerStatefulWidget {
  const PracticeListeningView({super.key, required this.items, required this.onComplete});

  final List<PracticeRoundItem> items;
  final void Function(List<PracticeResultEntry>) onComplete;

  @override
  ConsumerState<PracticeListeningView> createState() => _PracticeListeningViewState();
}

class _PracticeListeningViewState extends ConsumerState<PracticeListeningView>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  int _xp = 0;
  bool _flipped = false;
  double _speed = 1.0;
  final _results = <PracticeResultEntry>[];
  late final AnimationController _flipController;

  PracticeRoundItem get _current => widget.items[_index];

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    WidgetsBinding.instance.addPostFrameCallback((_) => _play());
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  Future<void> _play() async {
    await ref.read(audioServiceProvider).play(audioUrl: _current.audioUrl, text: _current.word);
  }

  void _flip() {
    setState(() => _flipped = !_flipped);
    if (_flipped) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
  }

  void _rate(bool understood) {
    _results.add(
      PracticeResultEntry(
        cardId: _current.id,
        correct: understood,
        userAnswer: understood ? 'understood' : 'misunderstood',
        correctAnswer: _current.translation,
      ),
    );
    if (understood) _xp += 8;
    if (_index < widget.items.length - 1) {
      setState(() {
        _index++;
        _flipped = false;
        _flipController.value = 0;
      });
      _play();
    } else {
      widget.onComplete(_results);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;

    return Column(
      children: [
        PracticeProgressHeader(current: _index + 1, total: widget.items.length, xp: _xp),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final speed in _speeds)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text('${speed}x'),
                    selected: _speed == speed,
                    onSelected: (_) => setState(() => _speed = speed),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: GestureDetector(
              key: const Key('practice_listening_flip'),
              onTap: _flip,
              child: AnimatedBuilder(
                animation: _flipController,
                builder: (context, child) {
                  final angle = _flipController.value * pi;
                  final showBack = angle > pi / 2;
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    child: showBack
                        ? Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(pi),
                            child: _cardBack(tokens, l10n),
                          )
                        : _cardFront(tokens, l10n),
                  );
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: _flipped
              ? Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        key: const Key('practice_listening_no'),
                        onPressed: () => _rate(false),
                        child: Text(l10n.practiceListeningNotYet),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        key: const Key('practice_listening_yes'),
                        onPressed: () => _rate(true),
                        child: Text(l10n.practiceListeningKnown),
                      ),
                    ),
                  ],
                )
              : Text(
                  l10n.practiceListeningPrompt,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: tokens.mutedForeground),
                ),
        ),
      ],
    );
  }

  Widget _cardFront(AppTokens tokens, AppLocalizations l10n) {
    return _card(
      tokens,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _current.word,
            key: const Key('practice_listening_word'),
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          IconButton.filled(
            onPressed: _play,
            icon: Icon(AppPhosphorIcons.speakerHigh, color: tokens.primaryForeground),
            style: IconButton.styleFrom(backgroundColor: tokens.primary),
          ),
          const SizedBox(height: 12),
          Text(l10n.practiceListeningTapToFlip, style: TextStyle(color: tokens.mutedForeground, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _cardBack(AppTokens tokens, AppLocalizations l10n) {
    return _card(
      tokens,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: tokens.warning.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999)),
            child: Text(l10n.practiceListeningMeaningLabel, style: TextStyle(color: tokens.warning, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 10),
          Text(
            _current.translation,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          if (_current.example != null) ...[
            const SizedBox(height: 8),
            Text(_current.example!, textAlign: TextAlign.center, style: TextStyle(color: tokens.mutedForeground)),
          ],
        ],
      ),
    );
  }

  Widget _card(AppTokens tokens, {required Widget child}) {
    return Container(
      width: 280,
      height: 200,
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tokens.border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: child,
    );
  }
}
