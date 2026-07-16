import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Orange/amber gradient hero section — web parity
/// `goethe-b1-writing-teil-pick-page.tsx`: 3 pill badges, pitch heading,
/// description paragraph, 3 stacked stat mini-cards (mobile = 1 column).
class TeilPickHero extends StatelessWidget {
  const TeilPickHero({super.key, required this.totalTopics, required this.isLoading});

  final int totalTopics;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    const orange = Color(0xFFF97316);
    const amber = Color(0xFFFBBF24);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: orange.withValues(alpha: 0.3)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [orange.withValues(alpha: 0.08), tokens.background, amber.withValues(alpha: 0.08)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Badge(label: l10n.goetheB1WritingBadgeReal, bg: orange.withValues(alpha: 0.14), fg: orange),
              _Badge(
                label: l10n.goetheB1WritingBadgeYears,
                bg: tokens.success.withValues(alpha: 0.14),
                fg: tokens.success,
              ),
              _Badge(
                label: l10n.goetheB1WritingBadgeQuality,
                bg: tokens.primary.withValues(alpha: 0.14),
                fg: tokens.primary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.goetheB1WritingHeroPitch,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: tokens.foreground),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.goetheB1WritingHeroDesc,
            style: TextStyle(fontSize: 13, height: 1.5, color: tokens.mutedForeground),
          ),
          const SizedBox(height: 14),
          _StatCard(
            label: l10n.goetheB1WritingStatSourceLabel,
            value: l10n.goetheB1WritingStatSourceValue,
          ),
          const SizedBox(height: 8),
          _StatCard(
            label: l10n.goetheB1WritingStatTopicsLabel,
            value: isLoading
                ? l10n.goetheB1WritingLoadingTopics
                : l10n.goetheB1WritingStatTopicsValue(totalTopics),
          ),
          const SizedBox(height: 8),
          _StatCard(
            label: l10n.goetheB1WritingStatValueLabel,
            value: l10n.goetheB1WritingStatValueValue,
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.bg, required this.fg});
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.4, color: fg),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: tokens.card.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.card.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: tokens.mutedForeground),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: tokens.foreground),
          ),
        ],
      ),
    );
  }
}
