import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// "💡 Gợi ý" panel — amber block toggled by the composer's bulb button. Web
/// parity: the suggestion-chips block in `dialog-runner.tsx`.
///
/// Live chip content comes from `/ai/sprechen-suggestions`, which is outside
/// this phase's documented contract (MASTER P8) — this renders the shell
/// (open/close, pending-state copy) without fabricating suggestion text.
class ConversationSuggestionsPanel extends StatelessWidget {
  const ConversationSuggestionsPanel({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(PhosphorIcons.lightbulbFilamentFill, size: 16, color: Color(0xFFD97706)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.conversationSuggestionsTitle,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF92400E)),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                icon: const Icon(PhosphorIcons.x, size: 14, color: Color(0xFF92400E)),
                onPressed: onClose,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.conversationSuggestionsPending,
            style: TextStyle(fontSize: 12, color: tokens.mutedForeground),
          ),
        ],
      ),
    );
  }
}
