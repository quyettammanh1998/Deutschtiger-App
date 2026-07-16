import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../l10n/app_localizations.dart';

/// "🎯 Đánh dấu hoàn thành" CTA — web parity: centered gradient pill, states
/// idle / completed / pending.
class WritingCompleteCta extends StatelessWidget {
  const WritingCompleteCta({
    super.key,
    required this.isCompleted,
    required this.isSaving,
    required this.onTap,
  });

  final bool isCompleted;
  final bool isSaving;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = isCompleted
        ? const [Color(0xFF22C55E), Color(0xFF16A34A)]
        : const [Color(0xFF10B981), Color(0xFF059669)];
    final label = isSaving
        ? l10n.writingCompleteSaving
        : isCompleted
            ? l10n.writingCompleteDone
            : l10n.writingCompleteMark;

    return Center(
      child: Opacity(
        opacity: isCompleted && !isSaving ? 0.6 : 1,
        child: InkWell(
          onTap: (isCompleted && !isSaving) || isSaving ? null : onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            decoration: BoxDecoration(gradient: LinearGradient(colors: colors), borderRadius: BorderRadius.circular(999)),
            child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

/// Premium-lock amber card — shown when the topic is behind the free-tier
/// limit or an official-locked premium topic.
class WritingLockCard extends StatelessWidget {
  const WritingLockCard({super.key, required this.isOfficial});

  final bool isOfficial;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.writingLockTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF78350F))),
          const SizedBox(height: 6),
          Text(
            isOfficial ? l10n.writingLockOfficialCopy : l10n.writingLockLegacyCopy,
            style: const TextStyle(fontSize: 12, color: Color(0xFF92400E), height: 1.5),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => context.push('/premium'),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: tokens.primary, width: 4)),
                color: tokens.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock, size: 16, color: tokens.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(l10n.writingUnlockPremiumCta,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.primary)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
