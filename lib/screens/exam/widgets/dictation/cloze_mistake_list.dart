import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';

/// "Từ cần ôn lại" mistake recap shown on the cloze [DictationEndScreen].
class ClozeMistakeList extends StatelessWidget {
  const ClozeMistakeList({super.key, required this.words});

  final List<String> words;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.muted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Từ cần ôn lại',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: tokens.mutedForeground,
              ),
            ),
            for (final word in words)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(word, style: TextStyle(color: tokens.foreground)),
              ),
          ],
        ),
      ),
    );
  }
}
