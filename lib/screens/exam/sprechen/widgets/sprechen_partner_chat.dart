import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/speech/sprechen_chat_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/speak_button.dart';

/// Web parity: `sprechen-partner-chat.tsx` — Tiger (AI examiner/partner)
/// chat transcript. User bubbles right-aligned primary fill with a
/// feedback-score pill; assistant bubbles left-aligned muted fill with a
/// mini avatar + speaker button; pending turn renders bouncing dots.
class SprechenPartnerChat extends StatelessWidget {
  const SprechenPartnerChat({
    super.key,
    required this.messages,
    required this.partnerLabel,
    this.partnerSubtitle,
  });

  final List<SprechenChatMessage> messages;
  final String partnerLabel;

  /// Defaults to [AppLocalizations.sprechenPartnerSubtitleDefault] when null.
  final String? partnerSubtitle;

  Color _feedbackColor(AppTokens tokens, int score) {
    if (score >= 4) return tokens.success;
    if (score >= 3) return tokens.warning;
    return tokens.destructive;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: tokens.border),
        borderRadius: BorderRadius.circular(16),
        color: tokens.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: tokens.primary.withValues(alpha: 0.1),
                  child: Text('🐯', style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        partnerLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        partnerSubtitle ??
                            AppLocalizations.of(
                              context,
                            ).sprechenPartnerSubtitleDefault,
                        style: TextStyle(
                          fontSize: 10,
                          color: tokens.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: tokens.border),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final message in messages) ...[
                  _ChatBubble(message: message, feedbackColor: _feedbackColor),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message, required this.feedbackColor});
  final SprechenChatMessage message;
  final Color Function(AppTokens, int) feedbackColor;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isUser = message.role == SprechenChatRole.user;

    if (message.pending) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: tokens.muted,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const SizedBox(
            width: 24,
            height: 8,
            child: Center(
              child: Text('...', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      );
    }

    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.82,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isUser ? tokens.primary : tokens.muted,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isUser ? 16 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 16),
        ),
      ),
      child: Text(
        message.text,
        style: TextStyle(
          color: isUser ? tokens.primaryForeground : tokens.foreground,
          fontSize: 13,
        ),
      ),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                bubble,
                const SizedBox(width: 4),
                SpeakButton(text: message.text, iconSize: 16),
              ],
            )
          else
            bubble,
          if (isUser && message.feedbackScore != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: feedbackColor(
                    tokens,
                    message.feedbackScore!,
                  ).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  AppLocalizations.of(
                    context,
                  ).sprechenFeedbackScoreLabel(message.feedbackScore!),
                  style: TextStyle(
                    fontSize: 10,
                    color: feedbackColor(tokens, message.feedbackScore!),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
