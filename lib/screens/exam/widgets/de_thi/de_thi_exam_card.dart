import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/exam/exam_ecosystem_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/common/app_card.dart';

/// Web parity: `ExamCards` in `de-thi-list-page.tsx` — level pill (primary),
/// year pill (amber outline), title, skill line, amber disclaimer, CTA.
class DeThiExamCard extends StatelessWidget {
  const DeThiExamCard({super.key, required this.entry});

  final DeThiRegistryEntry entry;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final amber = const Color(0xFFF59F0A);
    return AppCard.interactive(
      onTap: () => context.push('/de-thi/${entry.code}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Pill(
                label: entry.level,
                background: tokens.primary,
                foreground: tokens.primaryForeground,
              ),
              if (entry.year != null) ...[
                const SizedBox(width: 8),
                _Pill(
                  label: '${entry.year}',
                  background: amber.withValues(alpha: 0.12),
                  foreground: amber,
                  border: amber.withValues(alpha: 0.5),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            entry.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: tokens.foreground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            entry.skill,
            style: TextStyle(fontSize: 14, color: tokens.mutedForeground),
          ),
          if (entry.disclaimer != null) ...[
            const SizedBox(height: 4),
            Text(
              entry.disclaimer!,
              style: TextStyle(fontSize: 12, color: amber),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            l10n.deThiStartCta,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: tokens.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.background,
    required this.foreground,
    this.border,
  });

  final String label;
  final Color background;
  final Color foreground;
  final Color? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: border != null ? Border.all(color: border!) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
    );
  }
}
