import 'package:flutter/material.dart';

import '../../../../view_models/speech/conversation_dialog_controller.dart';
import 'conversation_composer.dart';
import 'conversation_message_bubble.dart';
import 'conversation_suggestions_panel.dart';

/// Chat body: scrollable message list (+ typing indicator) and the composer
/// footer. Web parity: `dialog-runner.tsx`'s message list + input area.
class ConversationDialogBody extends StatefulWidget {
  const ConversationDialogBody({
    super.key,
    required this.state,
    required this.onSend,
  });

  final ConversationDialogState state;
  final ValueChanged<String> onSend;

  @override
  State<ConversationDialogBody> createState() => _ConversationDialogBodyState();
}

class _ConversationDialogBodyState extends State<ConversationDialogBody> {
  final _scrollController = ScrollController();
  bool _suggestionsOpen = false;

  @override
  void didUpdateWidget(covariant ConversationDialogBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.messages.length != oldWidget.state.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scrollController.hasClients) return;
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return Column(
      children: [
        Expanded(
          child: state.initializing
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  itemCount: state.messages.length + (state.sending ? 1 : 0),
                  itemBuilder: (context, i) {
                    if (i >= state.messages.length) {
                      return const ConversationTypingBubble();
                    }
                    return ConversationMessageBubble(message: state.messages[i], index: i);
                  },
                ),
        ),
        if (_suggestionsOpen)
          ConversationSuggestionsPanel(onClose: () => setState(() => _suggestionsOpen = false)),
        ConversationComposer(
          onSend: widget.onSend,
          sending: state.sending,
          suggestionsOpen: _suggestionsOpen,
          onToggleSuggestions: () => setState(() => _suggestionsOpen = !_suggestionsOpen),
        ),
      ],
    );
  }
}
