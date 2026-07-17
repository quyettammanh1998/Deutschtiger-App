import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/speech/conversation_display.dart';
import '../../../../data/speech/conversation_session_models.dart';
import '../../../../l10n/app_localizations.dart';

/// Hub hero: gradient card with the "type any topic" search + level picker +
/// daily-limit row + quick-suggest chips. Web parity: the hero block inside
/// `conversation-hub-page.tsx`.
class ConversationHero extends StatelessWidget {
  const ConversationHero({
    super.key,
    required this.controller,
    required this.level,
    required this.onLevelChanged,
    required this.onSubmit,
    required this.quota,
    required this.onUpgrade,
    this.onChanged,
  });

  final TextEditingController controller;
  final String level;
  final ValueChanged<String> onLevelChanged;
  final ValueChanged<String> onSubmit;
  final ValueChanged<String>? onChanged;
  final ConversationDailyQuota? quota;
  final VoidCallback onUpgrade;

  bool get _walled => quota != null && quota!.isWalled;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: tokens.primary.withValues(alpha: 0.25)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            tokens.primary.withValues(alpha: 0.08),
            const Color(0xFFFFF1F2).withValues(alpha: 0.4),
            const Color(0xFFFDF4FF).withValues(alpha: 0.35),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: tokens.card.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(PhosphorIcons.sparkleFill, size: 14, color: tokens.primary),
                const SizedBox(width: 6),
                Text(
                  l10n.conversationHeroBadge,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: tokens.foreground,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.conversationHeroTitle,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: tokens.foreground,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: tokens.card,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(PhosphorIcons.sparkleFill, size: 18, color: tokens.primary.withValues(alpha: 0.7)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          maxLength: 180,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                            hintText: l10n.conversationHeroSearchHint,
                          ),
                          style: TextStyle(fontSize: 15, color: tokens.foreground),
                          onChanged: onChanged,
                          onSubmitted: onSubmit,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: tokens.card,
                  border: Border.all(color: tokens.border),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: level,
                    items: conversationLevels
                        .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) onLevelChanged(v);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: _walled ? const Color(0xFFF59E0B) : tokens.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _walled ? onUpgrade : () => onSubmit(controller.text),
              icon: Icon(_walled ? PhosphorIcons.crownFill : PhosphorIcons.arrowRight),
              label: Text(_walled ? l10n.conversationHeroUpgrade : l10n.conversationHeroCreateNow),
            ),
          ),
          if (quota != null && !quota!.unlimited) ...[
            const SizedBox(height: 10),
            _QuotaRow(quota: quota!, onUpgrade: onUpgrade),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Text(
                l10n.conversationHeroTryNow,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: tokens.mutedForeground,
                ),
              ),
              ...conversationQuickSuggest.map(
                (topic) => ActionChip(
                  label: Text(topic, style: const TextStyle(fontSize: 12)),
                  backgroundColor: tokens.card.withValues(alpha: 0.75),
                  onPressed: _walled ? null : () => onSubmit(topic),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuotaRow extends StatelessWidget {
  const _QuotaRow({required this.quota, required this.onUpgrade});

  final ConversationDailyQuota quota;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    if (quota.isWalled) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          // Amber quota-limit banner: light amber in light mode, translucent
          // amber on dark so it stays on-theme.
          color: isDark
              ? const Color(0x33F59E0B)
              : const Color(0xFFFEF3C7).withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(PhosphorIcons.crownFill,
                size: 16,
                color: isDark
                    ? const Color(0xFFFCD34D)
                    : const Color(0xFFD97706)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.conversationQuotaWalled(quota.maxSessions),
                style: const TextStyle(fontSize: 12, color: Color(0xFF92400E), fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(onPressed: onUpgrade, child: Text(l10n.conversationHeroUpgrade)),
          ],
        ),
      );
    }
    final remaining = quota.maxSessions - quota.sessionsUsed;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.conversationQuotaFreeRemaining(remaining, quota.maxSessions),
          style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
        ),
        TextButton.icon(
          onPressed: onUpgrade,
          icon: const Icon(PhosphorIcons.crownFill, size: 12),
          label: Text(l10n.conversationQuotaUnlimited, style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}
