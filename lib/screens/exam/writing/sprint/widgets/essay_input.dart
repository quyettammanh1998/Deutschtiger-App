import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../l10n/app_localizations.dart';

/// Essay textarea with debounced autosave, word count + min/max indicator
/// (50–120 words per Teil) — web parity `essay-input.tsx`.
class EssayInput extends StatefulWidget {
  const EssayInput({
    super.key,
    required this.teil,
    required this.taskDe,
    this.initialValue = '',
    required this.onSave,
    required this.onSubmit,
    this.disabled = false,
  });

  final int teil;
  final String taskDe;
  final String initialValue;
  final ValueChanged<String> onSave;
  final ValueChanged<String> onSubmit;
  final bool disabled;

  @override
  State<EssayInput> createState() => _EssayInputState();
}

class _EssayInputState extends State<EssayInput> {
  static const _min = 50;
  static const _max = 120;

  late final TextEditingController _controller = TextEditingController(text: widget.initialValue);
  Timer? _saveTimer;
  int _words = 0;

  @override
  void initState() {
    super.initState();
    _words = _countWords(widget.initialValue);
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  int _countWords(String text) => text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;

  void _onChanged() {
    setState(() => _words = _countWords(_controller.text));
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 800), () => widget.onSave(_controller.text));
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final canSubmit = _words >= _min && !widget.disabled;
    final wordColor = _words < _min
        ? tokens.destructive
        : (_words > _max ? tokens.warning : tokens.success);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: tokens.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: tokens.border)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.writingSprintTaskLabel(widget.teil), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tokens.mutedForeground)),
              const SizedBox(height: 4),
              Text(widget.taskDe, style: TextStyle(fontSize: 13, height: 1.4, color: tokens.foreground)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _controller,
          enabled: !widget.disabled,
          maxLines: 10,
          style: TextStyle(fontSize: 13, color: tokens.foreground),
          decoration: InputDecoration(
            hintText: l10n.writingSprintEssayHint,
            filled: true,
            fillColor: tokens.card,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: tokens.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: tokens.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: tokens.primary, width: 2)),
          ),
        ),
        const SizedBox(height: 6),
        Text(l10n.writingSprintWordCount(_words, _min, _max), style: TextStyle(fontSize: 12, color: wordColor)),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canSubmit ? () => widget.onSubmit(_controller.text) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: tokens.primary,
              foregroundColor: tokens.primaryForeground,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(widget.disabled ? l10n.writingSprintGrading : l10n.writingSprintSubmitButton(_words)),
          ),
        ),
        if (_words < _min)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Center(
              child: Text(
                l10n.writingSprintWordsNeeded(_min - _words),
                style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
              ),
            ),
          ),
      ],
    );
  }
}
