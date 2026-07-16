import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/speech/conversation_models.dart';
import '../../../../l10n/app_localizations.dart';

/// "Tình huống" collapsible header — scenario context_de/context_vi + the
/// learner's role. Web parity: `scenario-context-collapsible.tsx`.
class ConversationContextCollapsible extends StatelessWidget {
  const ConversationContextCollapsible({
    super.key,
    required this.scenario,
    required this.open,
    required this.onToggle,
  });

  final Scenario scenario;
  final bool open;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: tokens.border))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.conversationContextLabel, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.mutedForeground)),
                  Icon(open ? PhosphorIcons.caretUp : PhosphorIcons.caretDown, size: 14, color: tokens.mutedForeground),
                ],
              ),
            ),
          ),
          if (open)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(scenario.contextDe, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tokens.mutedForeground)),
                  const SizedBox(height: 4),
                  Text(scenario.contextVi, style: TextStyle(fontSize: 12, color: tokens.mutedForeground)),
                  const SizedBox(height: 6),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
                      children: [
                        TextSpan(text: '${l10n.conversationYourRoleLabel} ', style: const TextStyle(fontWeight: FontWeight.w600)),
                        TextSpan(text: scenario.userRole),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
