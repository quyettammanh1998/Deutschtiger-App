import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';

/// Shared building blocks for the community exam detail content sections —
/// bordered card with an emoji heading, plus small de/vi text helpers.
/// Split out from `community_exam_detail_sections.dart` to keep each file
/// under the 200-LOC convention.
class CommunityDetailSection extends StatelessWidget {
  const CommunityDetailSection({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: tokens.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: tokens.foreground,
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class CommunityDeViText extends StatelessWidget {
  const CommunityDeViText({super.key, this.de, this.vi});

  final String? de;
  final String? vi;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (de != null)
          Text(de!, style: TextStyle(fontSize: 13, color: tokens.foreground)),
        if (vi != null && vi!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              vi!,
              style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
            ),
          ),
      ],
    );
  }
}

class CommunityBulletDeVi extends StatelessWidget {
  const CommunityBulletDeVi({super.key, this.de, this.vi, this.sep = ''});

  final String? de;
  final String? vi;
  final String sep;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 13, color: tokens.foreground),
          children: [
            TextSpan(text: '• ${de ?? ''} '),
            if (vi != null && vi!.isNotEmpty)
              TextSpan(
                text: sep.isEmpty ? '($vi)' : '$sep $vi',
                style: TextStyle(color: tokens.mutedForeground, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}

class CommunityMutedText extends StatelessWidget {
  const CommunityMutedText(
    this.text, {
    super.key,
    this.bold = false,
    this.muted = true,
  });

  final String text;
  final bool bold;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Text(
      text,
      style: TextStyle(
        fontSize: muted ? 12 : 13,
        fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
        color: muted ? tokens.mutedForeground : tokens.foreground,
      ),
    );
  }
}
