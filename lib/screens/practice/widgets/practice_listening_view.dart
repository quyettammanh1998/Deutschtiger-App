import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/decks/deck_models.dart';
import '../../../data/practice/practice_result.dart';
import '../../../l10n/app_localizations.dart';
import '../../../view_models/providers.dart';
import 'practice_progress_header.dart';

/// Chế độ "Luyện nghe" — phát âm từ tiếng Đức (server TTS cache → on-device
/// TTS qua [AudioService]), người dùng chọn nghĩa tiếng Việt đúng trong 4
/// lựa chọn.
class PracticeListeningView extends ConsumerStatefulWidget {
  const PracticeListeningView({
    super.key,
    required this.words,
    required this.onComplete,
  });

  final List<DeckWord> words;
  final void Function(List<PracticeResultEntry>) onComplete;

  @override
  ConsumerState<PracticeListeningView> createState() => _PracticeListeningViewState();
}

class _PracticeListeningViewState extends ConsumerState<PracticeListeningView> {
  final _random = Random();
  int _index = 0;
  String? _selected;
  late List<String> _options;
  final _results = <PracticeResultEntry>[];

  DeckWord get _current => widget.words[_index];

  @override
  void initState() {
    super.initState();
    _options = _buildOptions();
  }

  List<String> _buildOptions() {
    final correct = _current.translation;
    final others = widget.words
        .where((w) => w.translation != correct)
        .map((w) => w.translation)
        .toSet()
        .toList()
      ..shuffle(_random);
    final options = <String>{correct, ...others.take(3)}.toList()..shuffle(_random);
    return options;
  }

  Future<void> _play() async {
    await ref.read(audioServiceProvider).play(text: _current.word);
  }

  void _select(String option) {
    if (_selected != null) return;
    final correct = option == _current.translation;

    setState(() {
      _selected = option;
      _results.add(
        PracticeResultEntry(
          cardId: _current.id,
          correct: correct,
          userAnswer: option,
          correctAnswer: _current.translation,
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      if (_index < widget.words.length - 1) {
        setState(() {
          _index++;
          _selected = null;
          _options = _buildOptions();
        });
      } else {
        widget.onComplete(_results);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        PracticeProgressHeader(
          current: _index + 1,
          total: widget.words.length,
          correct: _results.where((r) => r.correct).length,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                l10n.practiceListeningPrompt,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.mutedForeground),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  key: const Key('practice_listening_play'),
                  onTap: _play,
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple.withValues(alpha: 0.1),
                      border: Border.all(color: Colors.purple, width: 3),
                    ),
                    child: const Icon(Icons.volume_up, size: 40, color: Colors.purple),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              for (final option in _options)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _OptionTile(
                    label: option,
                    isSelected: _selected == option,
                    isCorrectOption: option == _current.translation,
                    revealed: _selected != null,
                    onTap: () => _select(option),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.isSelected,
    required this.isCorrectOption,
    required this.revealed,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isCorrectOption;
  final bool revealed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color border = Colors.grey.shade300;
    Color bg = Colors.white;
    if (revealed && isCorrectOption) {
      border = AppColors.success;
      bg = Colors.green.shade50;
    } else if (revealed && isSelected) {
      border = AppColors.error;
      bg = Colors.red.shade50;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border, width: 2),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
