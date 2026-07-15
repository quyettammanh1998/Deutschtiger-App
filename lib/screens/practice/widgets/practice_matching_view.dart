import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/decks/deck_models.dart';
import '../../../data/practice/practice_result.dart';
import '../../../l10n/app_localizations.dart';

/// Chế độ "Nối từ" — ghép từ tiếng Đức với nghĩa tiếng Việt tương ứng.
/// Giới hạn tối đa 8 cặp/vòng (khớp UX web `PracticeMatching`) để lưới vẫn
/// gọn trên màn hình di động; deck lớn hơn sẽ lấy 8 thẻ đầu.
class PracticeMatchingView extends StatefulWidget {
  const PracticeMatchingView({
    super.key,
    required this.words,
    required this.onComplete,
  });

  final List<DeckWord> words;
  final void Function(List<PracticeResultEntry>) onComplete;

  @override
  State<PracticeMatchingView> createState() => _PracticeMatchingViewState();
}

class _PracticeMatchingViewState extends State<PracticeMatchingView> {
  static const _maxPairs = 8;

  late List<DeckWord> _pairs;
  late List<DeckWord> _germanOrder;
  late List<DeckWord> _vietnameseOrder;
  final Set<String> _matched = {};
  String? _selectedGermanId;
  String? _selectedVietnameseId;
  int _attempts = 0;

  @override
  void initState() {
    super.initState();
    _pairs = widget.words.take(_maxPairs).toList();
    _germanOrder = List<DeckWord>.from(_pairs)..shuffle();
    _vietnameseOrder = List<DeckWord>.from(_pairs)..shuffle();
  }

  void _selectGerman(String id) {
    if (_matched.contains(id)) return;
    setState(() {
      _selectedGermanId = id;
      _tryMatch();
    });
  }

  void _selectVietnamese(String id) {
    if (_matched.contains(id)) return;
    setState(() {
      _selectedVietnameseId = id;
      _tryMatch();
    });
  }

  void _tryMatch() {
    final germanId = _selectedGermanId;
    final vietnameseId = _selectedVietnameseId;
    if (germanId == null || vietnameseId == null) return;

    _attempts++;
    final correct = germanId == vietnameseId;
    if (correct) {
      _matched.add(germanId);
      _selectedGermanId = null;
      _selectedVietnameseId = null;
      if (_matched.length == _pairs.length) {
        _finish();
      }
    } else {
      final capturedGerman = germanId;
      final capturedVietnamese = vietnameseId;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() {
          if (_selectedGermanId == capturedGerman) _selectedGermanId = null;
          if (_selectedVietnameseId == capturedVietnamese) _selectedVietnameseId = null;
        });
      });
    }
  }

  void _finish() {
    final results = _pairs
        .map((w) => PracticeResultEntry(cardId: w.id, correct: true, correctAnswer: w.translation))
        .toList();
    widget.onComplete(results);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_pairs.length < 2) {
      return Center(child: Text(l10n.practiceMatchingNeedsMoreWords));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.practiceMatchingProgress(_matched.length, _pairs.length, _attempts),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    children: _germanOrder
                        .map(
                          (w) => _WordTile(
                            key: Key('practice_matching_de_${w.id}'),
                            text: w.word,
                            isMatched: _matched.contains(w.id),
                            isSelected: _selectedGermanId == w.id,
                            onTap: () => _selectGerman(w.id),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ListView(
                    children: _vietnameseOrder
                        .map(
                          (w) => _WordTile(
                            key: Key('practice_matching_vi_${w.id}'),
                            text: w.translation,
                            isMatched: _matched.contains(w.id),
                            isSelected: _selectedVietnameseId == w.id,
                            onTap: () => _selectVietnamese(w.id),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
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
    required this.onTap,
  });

  final String text;
  final bool isMatched;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color border = Colors.grey.shade300;
    Color bg = Colors.white;
    if (isMatched) {
      border = AppColors.success;
      bg = Colors.green.shade50;
    } else if (isSelected) {
      border = AppColors.tigerOrange;
      bg = AppColors.tigerOrange.withValues(alpha: 0.08);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: isMatched ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border, width: 2),
          ),
          child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
