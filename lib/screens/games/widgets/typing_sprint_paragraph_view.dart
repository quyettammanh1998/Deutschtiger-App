import 'package:flutter/material.dart';

/// Coral palette — approximates web `--ts-*` custom properties scoped to
/// `typing-sprint-page.tsx` (`ts-root` CSS vars). Kept local to the typing
/// sprint widgets rather than added to [AppTokens]/`app_tokens.dart` since
/// it's a one-screen themed surface, not a reusable app-wide token set (web
/// itself scopes it the same way, via a page-local `<style>` block).
class TypingSprintPalette {
  const TypingSprintPalette._();

  static const bg = Color(0xFFEFE8DC);
  static const bgInner = Color(0xFFFBF6F0);
  static const card = Color(0xFFFFFFFF);
  static const chipBg = Color(0xFFF4EDE3);
  static const ink = Color(0xFF1F1914);
  static const inkDim = Color(0xFF857B70);
  static const inkFaint = Color(0xFFBEB2A2);
  static const coral = Color(0xFFE87B4F);
  static const coralDeep = Color(0xFFC4542B);
  static const coralSoft = Color(0xFFFDEEE4);
}

/// Live per-character diff view for the sentence being typed — compares
/// [typed] against [target] character-by-character. Web parity:
/// `ParagraphView`'s char-state coloring (simplified to a single sentence,
/// since the Flutter backend contract serves one sentence at a time via
/// `GET /user/typing/sentences`, not web's full-paragraph stream).
class TypingSprintParagraphView extends StatelessWidget {
  const TypingSprintParagraphView({
    super.key,
    required this.target,
    required this.typed,
  });

  final String target;
  final String typed;

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    for (var i = 0; i < target.length; i++) {
      final targetChar = target[i];
      Color color;
      TextDecoration? decoration;
      if (i < typed.length) {
        final typedChar = typed[i];
        final matches = typedChar.toLowerCase() == targetChar.toLowerCase();
        color = matches ? TypingSprintPalette.coralDeep : Colors.red.shade600;
        decoration = matches ? null : TextDecoration.underline;
      } else if (i == typed.length) {
        color = TypingSprintPalette.ink;
      } else {
        color = TypingSprintPalette.inkFaint;
      }
      spans.add(
        TextSpan(
          text: targetChar,
          style: TextStyle(
            color: color,
            decoration: decoration,
            backgroundColor: i == typed.length
                ? TypingSprintPalette.coralSoft
                : null,
          ),
        ),
      );
    }
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          height: 1.5,
        ),
        children: spans,
      ),
    );
  }
}
