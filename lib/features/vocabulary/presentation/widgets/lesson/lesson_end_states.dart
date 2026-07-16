import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tokens.dart';

/// Full-screen centered message + emoji + 1-2 CTAs — shared shape for the
/// lesson's `loading`/`empty`/`done`/`error` phases. Web parity: the
/// centered-column branches in `vocabulary-lesson-page.tsx`.
class LessonMessageView extends StatelessWidget {
  const LessonMessageView({
    super.key,
    required this.emoji,
    required this.title,
    this.subtitle,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.tertiaryLabel,
    this.onTertiary,
  });

  final String emoji;
  final String title;
  final String? subtitle;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final String? tertiaryLabel;
  final VoidCallback? onTertiary;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: tokens.foreground),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: tokens.mutedForeground)),
            ],
            const SizedBox(height: 20),
            if (secondaryLabel != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
              ),
            if (primaryLabel != null)
              FilledButton(
                onPressed: onPrimary,
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF97316)),
                child: Text(primaryLabel!),
              ),
            if (tertiaryLabel != null)
              TextButton(
                onPressed: onTertiary,
                child: Text(tertiaryLabel!, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
              ),
          ],
        ),
      ),
    );
  }
}
