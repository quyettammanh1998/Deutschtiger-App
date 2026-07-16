import 'package:flutter/material.dart';

import '../../../data/speech/conversation_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../speaking/widgets/conversation/conversation_message_bubble.dart';

/// Read-only transcript list reused by the history detail page — same
/// bubble styling as the live [ConversationMessageBubble], minus the
/// composer. Web parity: `conversation-transcript.tsx`.
class ConversationTranscriptView extends StatelessWidget {
  const ConversationTranscriptView({super.key, required this.messages});

  final List<DialogMessage> messages;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(AppLocalizations.of(context).conversationTranscriptEmpty),
        ),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < messages.length; i++)
          ConversationMessageBubble(message: messages[i], index: i),
      ],
    );
  }
}
