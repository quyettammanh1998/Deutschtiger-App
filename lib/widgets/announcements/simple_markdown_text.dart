import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Minimal, safe markdown renderer for announcement content — Flutter
/// `Text.rich` never interprets its input as HTML, so this only needs to
/// cover the subset web's `renderSimpleMarkdown` supports and is already
/// XSS-safe by construction (no `dangerouslySetInnerHTML` equivalent).
/// Supports: `**bold**`, `*italic*`, `[text](url)` (http/https/mailto
/// only), newlines. Web parity: `announcement-banner.tsx`
/// `renderSimpleMarkdown` — heading (`#`) and `{color:x}` spans are
/// intentionally not ported (announcement content in practice is a short
/// plain-text blurb; full parity would need a real markdown package).
class SimpleMarkdownText extends StatelessWidget {
  const SimpleMarkdownText(this.text, {super.key, required this.style});

  final String text;
  final TextStyle style;

  static final _tokenPattern = RegExp(
    r'\*\*(.+?)\*\*|\*(.+?)\*|\[([^\]]+)\]\(([^)]+)\)',
  );

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    var cursor = 0;
    for (final match in _tokenPattern.allMatches(text)) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, match.start)));
      }
      if (match.group(1) != null) {
        spans.add(TextSpan(
          text: match.group(1),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ));
      } else if (match.group(2) != null) {
        spans.add(TextSpan(
          text: match.group(2),
          style: const TextStyle(fontStyle: FontStyle.italic),
        ));
      } else if (match.group(3) != null) {
        final label = match.group(3)!;
        final url = match.group(4) ?? '';
        final safe = RegExp(r'^https?://', caseSensitive: false).hasMatch(url) ||
            url.startsWith('mailto:');
        spans.add(
          TextSpan(
            text: label,
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w600,
              color: style.color,
            ),
            recognizer: safe
                ? (TapGestureRecognizer()
                    ..onTap = () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication))
                : null,
          ),
        );
      }
      cursor = match.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }
    return Text.rich(TextSpan(style: style, children: spans));
  }
}
