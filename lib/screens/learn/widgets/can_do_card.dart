import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/learn/learn_models.dart';
import '../../../l10n/app_localizations.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

const _rungIcons = ['👂', '👁️', '✍️', '🗣️'];

/// Một "việc làm được" — thẻ hiển thị trong capability map, mirror web
/// `can-do-card.tsx`. Bấm "Luyện ngay" mở [CanDoPracticeScreen] cho id này.
class CanDoCard extends StatelessWidget {
  const CanDoCard({super.key, required this.canDo});

  final CanDo canDo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final statusLabel = canDo.spoken
        ? l10n.canDoStatusSpoken
        : switch (canDo.status) {
            'mastered' => l10n.canDoStatusMastered,
            'in_progress' => l10n.canDoStatusInProgress,
            _ => l10n.canDoStatusNew,
          };
    final statusColor = switch (canDo.status) {
      'mastered' => tokens.warning,
      'in_progress' => AppColors.tigerOrange,
      _ => tokens.mutedForeground,
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: tokens.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      canDo.labelVi,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${canDo.labelDe} · ${canDo.cefr}',
                      style: TextStyle(
                        fontSize: 12,
                        color: tokens.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: canDo.members
                .map(
                  (m) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: tokens.muted,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_rungIcons[m.rung.clamp(0, 3)]} ${m.label}',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                )
                .toList(),
          ),
          if (!canDo.isMastered) ...[
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () => context.push(
                '/learn/can-do/${Uri.encodeComponent(canDo.id)}/practice',
              ),
              icon: const Icon(PhosphorIcons.pencilSimple, size: 16),
              label: Text(l10n.canDoPracticeNow),
            ),
          ],
        ],
      ),
    );
  }
}
