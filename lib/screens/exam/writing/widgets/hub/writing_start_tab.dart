import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_tokens.dart';
import '../../../../../features/writing/domain/writing_offering.dart';
import '../../../../../l10n/app_localizations.dart';

/// "Bắt đầu" tab — web parity `WritingStartTab`: tự-nhập card, Sprint card
/// (inert — W4 not built, matches W1/W2's cross-link precedent), provider ×
/// level grid.
class WritingStartTab extends StatelessWidget {
  const WritingStartTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.writingHubStartIntro,
          style: TextStyle(fontSize: 13, color: tokens.mutedForeground),
        ),
        const SizedBox(height: 16),
        _StartRow(
          emoji: '✍️',
          title: l10n.writingHubCustomTitle,
          subtitle: l10n.writingHubCustomSubtitle,
          onTap: () => context.push('/luyen-viet/tu-nhap'),
        ),
        const SizedBox(height: 12),
        _StartRow(
          emoji: '⚡',
          title: l10n.writingHubSprintTitle,
          subtitle: l10n.writingHubSprintSubtitle,
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.writingSprintComingSoon)),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.1,
          children: [
            for (final o in kWritingCatalog)
              _OfferingCard(
                offering: o,
                onTap: () => context.push(
                  o.providerLevel == 'goethe-b1'
                      ? '/exam/goethe-b1/writing'
                      : '/exam/${o.providerLevel}/writing',
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _StartRow extends StatelessWidget {
  const _StartRow({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tokens.border),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tokens.foreground),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfferingCard extends StatelessWidget {
  const _OfferingCard({required this.offering, required this.onTap});

  final WritingOffering offering;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: tokens.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tokens.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              offering.label,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tokens.foreground),
            ),
            const SizedBox(height: 2),
            Text('Schreiben', style: TextStyle(fontSize: 11, color: tokens.mutedForeground)),
          ],
        ),
      ),
    );
  }
}
