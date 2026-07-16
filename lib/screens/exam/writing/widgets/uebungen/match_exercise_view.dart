import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/writing_topic/uebungen_exercise.dart';
import 'exercise_result_banner.dart';

/// Tap-to-pair matching exercise — web parity `MatchExercise`. Mobile:
/// stacked columns (phrase list / function list), tap one from each to pair.
class MatchExerciseView extends StatefulWidget {
  const MatchExerciseView({super.key, required this.exercise});

  final MatchExercise exercise;

  @override
  State<MatchExerciseView> createState() => _MatchExerciseViewState();
}

class _MatchExerciseViewState extends State<MatchExerciseView> {
  final Map<String, int> _matched = {};
  String? _selectedPairId;
  String? _wrongFlashId;

  void _selectPhrase(String id) => setState(() => _selectedPairId = id);

  void _selectFunction(int index) {
    if (_selectedPairId == null) return;
    final pair = widget.exercise.pairs.firstWhere((p) => p.id == _selectedPairId);
    if (pair.correctFunctionIndex == index) {
      setState(() {
        _matched[pair.id] = index;
        _selectedPairId = null;
      });
    } else {
      setState(() => _wrongFlashId = pair.id);
      Future.delayed(const Duration(milliseconds: 550), () {
        if (!mounted) return;
        setState(() {
          _wrongFlashId = null;
          _selectedPairId = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final unmatched = widget.exercise.pairs.where((p) => !_matched.containsKey(p.id)).toList();
    final allMatched = _matched.length == widget.exercise.pairs.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cột A — Cụm từ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: tokens.mutedForeground)),
        for (final p in unmatched)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _MatchButton(
              label: p.phrase,
              selected: _selectedPairId == p.id,
              wrong: _wrongFlashId == p.id,
              onTap: () => _selectPhrase(p.id),
            ),
          ),
        const SizedBox(height: 8),
        Text('Cột B — Chức năng', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: tokens.mutedForeground)),
        for (var i = 0; i < widget.exercise.functions.length; i++)
          if (!_matched.values.contains(i))
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _MatchButton(label: widget.exercise.functions[i], onTap: () => _selectFunction(i)),
            ),
        if (_matched.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: tokens.muted.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final entry in _matched.entries)
                  Text(
                    '${widget.exercise.pairs.firstWhere((p) => p.id == entry.key).phrase} → ${widget.exercise.functions[entry.value]}',
                    style: TextStyle(fontSize: 11, color: tokens.foreground),
                  ),
              ],
            ),
          ),
        ],
        if (allMatched)
          ExerciseResultBanner(
            correct: widget.exercise.pairs.length,
            total: widget.exercise.pairs.length,
            onRetry: () => setState(_matched.clear),
          ),
      ],
    );
  }
}

class _MatchButton extends StatelessWidget {
  const _MatchButton({required this.label, required this.onTap, this.selected = false, this.wrong = false});
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final bool wrong;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: wrong ? const Color(0xFFFEE2E2) : selected ? const Color(0xFFFFEDD5) : tokens.card,
          border: Border.all(color: wrong ? const Color(0xFFEF4444) : selected ? const Color(0xFFF97316) : tokens.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label, style: TextStyle(fontSize: 13, color: tokens.foreground)),
      ),
    );
  }
}
