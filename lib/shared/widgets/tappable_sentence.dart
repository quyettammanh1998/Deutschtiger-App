import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Renders a sentence as a flat list of tappable word tokens.
///
/// Punctuation is grouped with the word that directly precedes it so the
/// visual layout matches the original sentence. Tapping a word fires
/// [onWordTap] with the cleaned token (punctuation stripped).
class TappableSentence extends StatefulWidget {
  const TappableSentence({
    super.key,
    required this.text,
    required this.onWordTap,
    this.style,
    this.highlightedWord,
  });

  final String text;
  final ValueChanged<String> onWordTap;
  final TextStyle? style;
  final String? highlightedWord;

  @override
  State<TappableSentence> createState() => _TappableSentenceState();
}

class _TappableSentenceState extends State<TappableSentence> {
  final List<TapGestureRecognizer> _recognizers = <TapGestureRecognizer>[];

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    super.dispose();
  }

  static final RegExp _tokenRegex = RegExp(r'\S+');

  String _cleanToken(String token) {
    return token.replaceAll(
      RegExp(r'^[^\p{L}\p{N}]+|[^\p{L}\p{N}]+$', unicode: true),
      '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle =
        widget.style ??
        DesignTokens.bodyLarge.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        );
    final matches = _tokenRegex.allMatches(widget.text).toList();
    // Dispose old recognizers before rebuilding.
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();

    final spans = <TextSpan>[];
    int cursor = 0;
    for (final m in matches) {
      if (m.start > cursor) {
        spans.add(TextSpan(text: widget.text.substring(cursor, m.start)));
      }
      final raw = m.group(0)!;
      final clean = _cleanToken(raw);
      final isHighlighted =
          widget.highlightedWord != null &&
          clean.toLowerCase() == widget.highlightedWord!.toLowerCase();
      final recognizer = TapGestureRecognizer()
        ..onTap = clean.isEmpty ? null : () => widget.onWordTap(clean);
      _recognizers.add(recognizer);
      spans.add(
        TextSpan(
          text: raw,
          style: baseStyle.copyWith(
            color: isHighlighted
                ? Theme.of(context).colorScheme.primary
                : baseStyle.color,
            fontWeight: isHighlighted ? FontWeight.w700 : baseStyle.fontWeight,
            decoration: TextDecoration.underline,
            decorationColor: isHighlighted
                ? Theme.of(context).colorScheme.primary
                : null,
          ),
          recognizer: recognizer,
        ),
      );
      cursor = m.end;
    }
    if (cursor < widget.text.length) {
      spans.add(TextSpan(text: widget.text.substring(cursor)));
    }

    return RichText(
      text: TextSpan(style: baseStyle, children: spans),
    );
  }
}
