import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';

/// Generic pill tab switcher — active = solid primary bg + white text,
/// inactive = card bg. Mirrors web's `bg-primary text-white shadow-sm` vs
/// `card-interactive bg-card/80` tab styling (schedule tabs, status tabs).
class SchedulePillTabs<T> extends StatelessWidget {
  const SchedulePillTabs({
    super.key,
    required this.tabs,
    required this.value,
    required this.onChanged,
  });

  final List<SchedulePillTab<T>> tabs;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tab in tabs)
          InkWell(
            onTap: () => onChanged(tab.value),
            borderRadius: BorderRadius.circular(tokens.radius),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: tab.value == value ? tokens.primary : tokens.card,
                borderRadius: BorderRadius.circular(tokens.radius),
                border: tab.value == value
                    ? null
                    : Border.all(color: tokens.border),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Text(
                  tab.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: tab.value == value
                        ? tokens.primaryForeground
                        : tokens.foreground,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class SchedulePillTab<T> {
  const SchedulePillTab({required this.value, required this.label});
  final T value;
  final String label;
}
