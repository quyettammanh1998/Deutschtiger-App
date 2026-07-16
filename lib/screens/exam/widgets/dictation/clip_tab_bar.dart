import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';

/// Horizontal scrollable clip switcher — shared by [FullPracticeView] and
/// [KaraokeView]. Mirrors web `ClipTabBar` / karaoke clip tab row.
class ClipTabBar extends StatelessWidget {
  const ClipTabBar({
    super.key,
    required this.labels,
    required this.activeIndex,
    required this.onSelect,
  });

  final List<String> labels;
  final int activeIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    if (labels.length <= 1) return const SizedBox.shrink();
    final tokens = context.tokens;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.card,
        border: Border(bottom: BorderSide(color: tokens.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            for (var i = 0; i < labels.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: InkWell(
                  onTap: () => onSelect(i),
                  borderRadius: BorderRadius.circular(999),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: i == activeIndex ? tokens.primary : tokens.muted,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      child: Text(
                        labels[i],
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: i == activeIndex
                              ? tokens.primaryForeground
                              : tokens.foreground,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
