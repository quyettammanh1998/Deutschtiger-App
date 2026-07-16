import 'package:flutter/material.dart';

import '../../../../core/icons/app_phosphor_icons.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Badge shown on community topics that carry a recalled real-exam date —
/// i.e. the contributor sat the actual exam and wrote down what they
/// remember, as opposed to an AI-generated practice topic.
///
/// Web parity: `src/components/community/real-exam-badge.tsx`. `examDate`
/// presence is the sole signal (renders nothing otherwise).
class RealExamBadge extends StatelessWidget {
  const RealExamBadge({
    super.key,
    required this.examDate,
    this.examLocation,
    this.compact = true,
  });

  final String? examDate;
  final String? examLocation;

  /// `true` = icon + "Đề thật" only (browse cards). `false` = also shows
  /// date/location (detail header) — web `variant="full"`.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final date = examDate;
    if (date == null || date.isEmpty) return const SizedBox.shrink();

    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final bg = tokens.success.withValues(alpha: 0.15);
    final fg = tokens.success;

    final suffix = !compact
        ? ' • $date${examLocation != null && examLocation!.isNotEmpty ? ' • $examLocation' : ''}'
        : '';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppPhosphorIcons.sealCheck, size: 11, color: fg),
            const SizedBox(width: 4),
            Text(
              '${l10n.communityRealExamBadge}$suffix',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
