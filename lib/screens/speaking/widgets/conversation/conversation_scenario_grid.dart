import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/speech/conversation_display.dart';
import '../../../../data/speech/conversation_models.dart';
import '../../../../l10n/app_localizations.dart';
import 'scenario_card.dart';

/// Results grid (2 columns, web parity `grid-cols-2`) + empty states: "create
/// custom topic" CTA when the query has ≥3 chars, otherwise "no matches".
class ConversationScenarioGrid extends StatelessWidget {
  const ConversationScenarioGrid({
    super.key,
    required this.scenarios,
    required this.onTap,
    required this.canCreateCustom,
    required this.customQuery,
    required this.onCreateCustom,
  });

  final List<ScenarioMeta> scenarios;
  final void Function(ScenarioMeta) onTap;
  final bool canCreateCustom;
  final String customQuery;
  final VoidCallback onCreateCustom;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (scenarios.isNotEmpty) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.82,
        ),
        itemCount: scenarios.length,
        itemBuilder: (context, i) {
          final s = scenarios[i];
          final display = getScenarioDisplay(s.id);
          return ConversationScenarioCard(
            titleDe: s.titleDe,
            titleVi: s.titleVi,
            level: s.level,
            gradientFrom: display.gradientFrom,
            gradientTo: display.gradientTo,
            icon: display.icon,
            onTap: () => onTap(s),
          );
        },
      );
    }

    final tokens = context.tokens;
    if (canCreateCustom) {
      return InkWell(
        onTap: onCreateCustom,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            border: Border.all(color: tokens.primary, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(16),
            color: tokens.secondary.withValues(alpha: 0.4),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFBBF24), Color(0xFFF97316)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(PhosphorIcons.sparkleFill, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.conversationCreateCustomTitle(customQuery.trim()),
                      style: TextStyle(fontWeight: FontWeight.w800, color: tokens.foreground),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.conversationCreateCustomHint,
                      style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                    ),
                  ],
                ),
              ),
              Icon(PhosphorIcons.arrowRight, color: tokens.primary),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(PhosphorIcons.magnifyingGlass, size: 32, color: tokens.mutedForeground),
          const SizedBox(height: 8),
          Text(l10n.conversationEmptyNoResults, style: TextStyle(fontWeight: FontWeight.w700, color: tokens.foreground)),
          const SizedBox(height: 4),
          Text(l10n.conversationEmptyNoResultsHint, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
        ],
      ),
    );
  }
}
