import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/view_models/ai/ai_provider.dart';
import 'package:deutschtiger/data/ai/ai_chat_live_models.dart';
import 'package:deutschtiger/widgets/ai/chat_history_sidebar.dart';

/// Tiger AI chat — streams `POST /ai/chat` token-by-token via [AiChatNotifier]
/// (SSE parsed by `lib/services/api/sse_client.dart`). This is the canonical
/// AI chat surface (the former `screens/ai_tutor/` static-data duplicate was
/// removed — see phase-01 plan).
class AIChatPage extends ConsumerStatefulWidget {
  const AIChatPage({super.key});

  @override
  ConsumerState<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends ConsumerState<AIChatPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _showSidebar = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    ref.read(aiChatNotifierProvider.notifier).sendMessage(text);
    _textController.clear();
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _startNewSession() {
    ref.read(aiChatNotifierProvider.notifier).startNewSession();
  }

  void _onSessionSelected(ChatSessionSummary session) {
    ref.read(aiChatNotifierProvider.notifier).resumeSession(session.id);
    setState(() => _showSidebar = false);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiChatNotifierProvider);

    ref.listen(aiChatNotifierProvider.select((s) => s.messages.length), (_, _) {
      Future.delayed(const Duration(milliseconds: 50), _scrollToBottom);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiger AI'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => setState(() => _showSidebar = !_showSidebar),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            onPressed: _startNewSession,
            tooltip: 'New Chat',
          ),
        ],
      ),
      body: Row(
        children: [
          if (_showSidebar)
            SizedBox(
              width: 280,
              child: ChatHistorySidebar(
                onSessionSelected: _onSessionSelected,
                currentSessionId: state.sessionId,
                onClose: () => setState(() => _showSidebar = false),
              ),
            ),
          Expanded(
            child: Column(
              children: [
                const _QuotaBanner(),
                Expanded(
                  child: state.messages.isEmpty
                      ? _EmptyState(onStartChat: _startNewSession)
                      : _MessageList(
                          messages: state.messages,
                          scrollController: _scrollController,
                        ),
                ),
                if (state.banner != AiChatBannerKind.none)
                  _ErrorBanner(
                    kind: state.banner,
                    message: state.bannerMessage ?? '',
                    onRetry: state.banner == AiChatBannerKind.error
                        ? () => ref.read(aiChatNotifierProvider.notifier).retry()
                        : null,
                  ),
                _InputBar(
                  controller: _textController,
                  onSend: _sendMessage,
                  enabled: !state.isSending,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onStartChat;

  const _EmptyState({required this.onStartChat});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          Text(
            'Start a Conversation',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Hỏi bất cứ điều gì về tiếng Đức — Tiger AI trả lời ngay.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  final List<AiChatUiMessage> messages;
  final ScrollController scrollController;

  const _MessageList({required this.messages, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _MessageBubble(message: message, isUser: message.role == 'user');
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final AiChatUiMessage message;
  final bool isUser;

  const _MessageBubble({required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.content.isEmpty && message.isStreaming)
              const _TypingDots()
            else
              Text(
                message.content,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            if (message.isStreaming && message.content.isNotEmpty)
              const Padding(padding: EdgeInsets.only(top: 6), child: _TypingDots(compact: true)),
          ],
        ),
      ),
    );
  }
}

/// Small daily-quota counter from `GET /ai/chat-status` (already fetched by
/// [aiChatStatusProvider]). Hidden for premium users (unlimited) and while
/// the status call is in flight/failed — this is a soft hint, not a gate.
class _QuotaBanner extends ConsumerWidget {
  const _QuotaBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(aiChatStatusProvider);
    final status = statusAsync.valueOrNull;
    if (status == null || status.isPremium || status.dailyLimit <= 0) {
      return const SizedBox.shrink();
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: AppColors.primary.withAlpha(15),
      child: Text(
        'Còn ${status.remaining}/${status.dailyLimit} lượt chat hôm nay',
        style: TextStyle(fontSize: 12, color: AppColors.primary),
      ),
    );
  }
}

/// Error/quota/limit banner above the input bar. Quota and session-limit
/// hits are terminal for the current turn (no retry — the backend already
/// rejected the request before streaming started); a plain error (validation,
/// network, or an in-band SSE error chunk) offers Retry.
class _ErrorBanner extends StatelessWidget {
  final AiChatBannerKind kind;
  final String message;
  final VoidCallback? onRetry;

  const _ErrorBanner({required this.kind, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final color = kind == AiChatBannerKind.error ? Colors.red : Colors.orange;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: color.withAlpha(20),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 18, color: color[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message.isEmpty ? 'Đã xảy ra lỗi. Vui lòng thử lại.' : message,
              style: TextStyle(color: color[900], fontSize: 13),
            ),
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  final bool compact;
  const _TypingDots({this.compact = false});

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final progress = (_controller.value - delay).clamp(0.0, 1.0);
            final size = widget.compact ? 5.0 : 8.0;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.grey[400]!.withAlpha(
                  (255 * (progress < 0.5 ? progress * 2 : 2 - progress * 2)).toInt(),
                ),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool enabled;

  const _InputBar({required this.controller, required this.onSend, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(24)),
              child: TextField(
                controller: controller,
                enabled: enabled,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                maxLines: null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              gradient: enabled ? AppColors.primaryGradient : null,
              color: enabled ? null : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send),
              color: Colors.white,
              onPressed: enabled ? onSend : null,
            ),
          ),
        ],
      ),
    );
  }
}
