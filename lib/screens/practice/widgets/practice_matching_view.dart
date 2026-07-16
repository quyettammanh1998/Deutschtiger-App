import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../data/practice/practice_result.dart';
import '../../../data/practice/practice_round_item.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/providers.dart';
import 'practice_progress_header.dart';

const _pairsPerRound = 6;

/// "Nối từ" (`/games/matching`, web `practice-matching-page.tsx` →
/// `PracticeMatching`) — ghép từ tiếng Đức với nghĩa tiếng Việt theo từng
/// vòng 6 cặp (web parity, thay vì 1 vòng phẳng tối đa 8 cặp cũ). Round type
/// = [PracticeRoundItem].
class PracticeMatchingView extends ConsumerStatefulWidget {
  const PracticeMatchingView({super.key, required this.items, required this.onComplete});

  final List<PracticeRoundItem> items;
  final void Function(List<PracticeResultEntry>) onComplete;

  @override
  ConsumerState<PracticeMatchingView> createState() => _PracticeMatchingViewState();
}

class _PracticeMatchingViewState extends ConsumerState<PracticeMatchingView> {
  late final List<List<PracticeRoundItem>> _rounds;
  int _round = 0;
  int _xp = 0;
  late List<PracticeRoundItem> _germanOrder;
  late List<PracticeRoundItem> _vietnameseOrder;
  final Set<String> _matched = {};
  String? _selectedGerman;
  String? _selectedVietnamese;
  bool _shake = false;
  final _results = <PracticeResultEntry>[];

  List<PracticeRoundItem> get _pairs => _rounds[_round];

  @override
  void initState() {
    super.initState();
    _rounds = [
      for (var i = 0; i < widget.items.length; i += _pairsPerRound)
        widget.items.sublist(i, (i + _pairsPerRound).clamp(0, widget.items.length)),
    ];
    _shuffleRound();
  }

  void _shuffleRound() {
    _germanOrder = List<PracticeRoundItem>.from(_pairs)..shuffle();
    _vietnameseOrder = List<PracticeRoundItem>.from(_pairs)..shuffle();
    _matched.clear();
  }

  Future<void> _selectGerman(PracticeRoundItem item) async {
    if (_matched.contains(item.id)) return;
    setState(() => _selectedGerman = item.id);
    await ref.read(audioServiceProvider).play(audioUrl: item.audioUrl, text: item.word);
    _tryMatch();
  }

  void _selectVietnamese(String id) {
    if (_matched.contains(id)) return;
    setState(() => _selectedVietnamese = id);
    _tryMatch();
  }

  void _tryMatch() {
    final de = _selectedGerman;
    final vi = _selectedVietnamese;
    if (de == null || vi == null) return;

    if (de == vi) {
      setState(() {
        _matched.add(de);
        _selectedGerman = null;
        _selectedVietnamese = null;
        _xp += 6;
      });
      if (_matched.length == _pairs.length) {
        _results.addAll(
          _pairs.map((w) => PracticeResultEntry(cardId: w.id, correct: true, correctAnswer: w.translation)),
        );
        _finishRound();
      }
    } else {
      setState(() => _shake = true);
      Future.delayed(const Duration(milliseconds: 350), () {
        if (!mounted) return;
        setState(() {
          _shake = false;
          _selectedGerman = null;
          _selectedVietnamese = null;
        });
      });
    }
  }

  void _finishRound() {
    if (_round < _rounds.length - 1) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() {
          _round++;
          _shuffleRound();
        });
      });
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) widget.onComplete(_results);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;

    if (_pairs.length < 2) {
      return Center(child: Text(l10n.practiceMatchingNeedsMoreWords));
    }

    return Column(
      children: [
        PracticeProgressHeader(
          current: _round + 1,
          total: _rounds.length,
          xp: _xp,
          gradientStart: const Color(0xFFEC4899),
          gradientEnd: const Color(0xFFE11D48),
          extraLabel: '${_matched.length}/${_pairs.length}',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.practiceMatchingColumnDe, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: tokens.mutedForeground)),
              Text(l10n.practiceMatchingColumnVi, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: tokens.mutedForeground)),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      for (final w in _germanOrder)
                        _WordTile(
                          key: Key('practice_matching_de_${w.id}'),
                          text: w.word,
                          isMatched: _matched.contains(w.id),
                          isSelected: _selectedGerman == w.id,
                          shake: _shake && _selectedGerman == w.id,
                          tokens: tokens,
                          onTap: () => _selectGerman(w),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      for (final w in _vietnameseOrder)
                        _WordTile(
                          key: Key('practice_matching_vi_${w.id}'),
                          text: w.translation,
                          isMatched: _matched.contains(w.id),
                          isSelected: _selectedVietnamese == w.id,
                          shake: _shake && _selectedVietnamese == w.id,
                          tokens: tokens,
                          onTap: () => _selectVietnamese(w.id),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _WordTile extends StatelessWidget {
  const _WordTile({
    super.key,
    required this.text,
    required this.isMatched,
    required this.isSelected,
    required this.shake,
    required this.tokens,
    required this.onTap,
  });

  final String text;
  final bool isMatched;
  final bool isSelected;
  final bool shake;
  final AppTokens tokens;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color border = tokens.border;
    Color bg = tokens.card;
    if (isMatched) {
      border = tokens.success;
      bg = tokens.success.withValues(alpha: 0.12);
    } else if (shake) {
      border = tokens.destructive;
      bg = tokens.destructive.withValues(alpha: 0.1);
    } else if (isSelected) {
      border = const Color(0xFFA855F7);
      bg = const Color(0xFFA855F7).withValues(alpha: 0.08);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: isMatched ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: border, width: 2)),
          child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
