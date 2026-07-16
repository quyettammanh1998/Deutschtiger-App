import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../data/speech/conversation_models.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../view_models/providers.dart' show audioServiceProvider;

/// One chat bubble — user (orange, right) or AI (muted card, left) — with a
/// TTS "Nghe" button. Web parity: message rows inside `dialog-runner.tsx` /
/// `conversation-transcript.tsx`.
///
/// Per-turn correctness feedback badges ("x/5 · phản hồi") and the examiner
/// popup depend on `/ai/sprechen-feedback`, which is outside this phase's
/// documented Live/Review contract (MASTER P8) — omitted here rather than
/// faked.
class ConversationMessageBubble extends ConsumerWidget {
  const ConversationMessageBubble({super.key, required this.message, required this.index});

  final DialogMessage message;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final l10n = AppLocalizations.of(context);
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        key: ValueKey('conversation-message-$index'),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: isUser
                    ? LinearGradient(colors: [tokens.primary, tokens.primary.withValues(alpha: 0.85)])
                    : null,
                color: isUser ? null : tokens.card,
                border: isUser ? null : Border.all(color: tokens.border),
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
                  fontSize: 14,
                  height: 1.4,
                  color: isUser ? Colors.white : tokens.foreground,
                ),
              ),
            ),
            const SizedBox(height: 2),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              icon: Icon(PhosphorIcons.speakerHigh, size: 15, color: tokens.mutedForeground),
              tooltip: l10n.conversationListen,
              onPressed: () => ref.read(audioServiceProvider).play(text: message.text),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bouncing-dots "AI typing" placeholder shown while [ConversationDialog
/// Controller.sending] is true.
class ConversationTypingBubble extends StatelessWidget {
  const ConversationTypingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: tokens.card,
          border: Border.all(color: tokens.border),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: SizedBox(
          width: 32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (_) => CircleAvatar(radius: 3, backgroundColor: tokens.mutedForeground),
            ),
          ),
        ),
      ),
    );
  }
}
