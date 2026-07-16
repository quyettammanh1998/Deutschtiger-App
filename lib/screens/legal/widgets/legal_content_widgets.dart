import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_tokens.dart';

/// One numbered section — `<h2>` + body. Mirrors web `<section>` block
/// (`h2.text-xl.font-bold` + `space-y-8` gap handled by [LegalScaffold]).
class LegalSection extends StatelessWidget {
  const LegalSection({super.key, required this.heading, required this.body});

  final String heading;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: tokens.foreground,
          ),
        ),
        const SizedBox(height: 12),
        body,
      ],
    );
  }
}

/// Plain paragraph — `leading-relaxed`.
class LegalParagraph extends StatelessWidget {
  const LegalParagraph(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        height: 1.6,
        color: context.tokens.mutedForeground,
      ),
    );
  }
}

/// Paragraph with an inline `mailto:`/`https:` link segment styled
/// `text-orange-600` — mirrors web `<a>` inside prose paragraphs.
class LegalLinkParagraph extends StatelessWidget {
  const LegalLinkParagraph({
    super.key,
    required this.before,
    required this.linkText,
    required this.linkUrl,
    this.after = '',
  });

  final String before;
  final String linkText;
  final String linkUrl;
  final String after;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final bodyStyle = TextStyle(
      fontSize: 14,
      height: 1.6,
      color: tokens.mutedForeground,
    );
    return Text.rich(
      TextSpan(
        style: bodyStyle,
        children: [
          TextSpan(text: before),
          TextSpan(
            text: linkText,
            style: TextStyle(color: tokens.primary),
            recognizer: TapGestureRecognizer()
              ..onTap = () =>
                  launchUrl(Uri.parse(linkUrl), mode: LaunchMode.externalApplication),
          ),
          if (after.isNotEmpty) TextSpan(text: after),
        ],
      ),
    );
  }
}

/// Bulleted list — `list-disc pl-5 space-y-2`. Each item may bold a leading
/// label (`**Label:** rest`) to mirror web's `<strong>` lead-ins.
class LegalBulletList extends StatelessWidget {
  const LegalBulletList(this.items, {super.key});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7, right: 10),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: tokens.mutedForeground,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(child: _bulletText(item, tokens)),
              ],
            ),
          ),
      ],
    );
  }

  /// Splits a leading `**bold:**` prefix (if any) from the rest of the item.
  Widget _bulletText(String item, AppTokens tokens) {
    final match = RegExp(r'^\*\*(.+?)\*\*(.*)$').firstMatch(item);
    final bodyStyle = TextStyle(
      fontSize: 14,
      height: 1.6,
      color: tokens.mutedForeground,
    );
    if (match == null) return Text(item, style: bodyStyle);
    return Text.rich(
      TextSpan(
        style: bodyStyle,
        children: [
          TextSpan(
            text: match.group(1),
            style: TextStyle(fontWeight: FontWeight.w700, color: tokens.foreground),
          ),
          TextSpan(text: match.group(2)),
        ],
      ),
    );
  }
}
