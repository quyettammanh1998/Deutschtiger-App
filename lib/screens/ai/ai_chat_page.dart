import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/ai/ai_provider.dart';
import 'package:deutschtiger/data/ai/ai_chat_live_models.dart';
import 'package:deutschtiger/widgets/ai/chat_history_sidebar.dart';
import 'package:deutschtiger/widgets/common/tiger_logo.dart';

/// Tiger AI chat — streams `POST /ai/chat` token-by-token via [AiChatNotifier]
/// (SSE parsed by `lib/services/api/sse_client.dart`). This is the canonical
/// AI chat surface (the former `screens/ai_tutor/` static-data duplicate was
/// removed — see phase-01 plan).
///
/// Visual language mirrors the web mobile chat surface
/// (`src/components/ai/ai-chat-panel.tsx`): card header with a top accent
/// line, tiger avatar bubbles, rounded "tail" message bubbles, and a
/// composer with a circular gradient send button.
class AIChatPage extends ConsumerStatefulWidget {
  const AIChatPage({super.key});

  @override
  ConsumerState<AIChatPage> createState() => _AIChatPageState();
}

/// Static suggestion chips shown above the composer on a fresh chat —
/// mirrors web's `SUGGESTION_CHIPS` in `ai-chat-panel.tsx`.
const _suggestionChips = <(String label, String prompt)>[
  ('📖 Giải thích ngữ pháp', 'Giải thích ngữ pháp Akkusativ và Dativ cho mình nhé'),
  ('📝 Học từ vựng A1', 'Cho mình 10 từ vựng A1 quan trọng nhất về chủ đề gia đình'),
  ('🎮 Gợi ý luyện tập', 'Mình nên luyện tập gì hôm nay để cải thiện tiếng Đức?'),
  ('📚 Mẹo thi Goethe', 'Cho mình tips để thi đậu Goethe A2'),
];

/// Mirrors web's `WELCOME_MESSAGE` — rendered locally (not part of
/// [AiChatState.messages]) so the transcript stays exactly what the backend
/// persisted.
const _welcomeMessage =
    'Xin chào! 🐯 Mình là Deutschtiger AI — trợ lý học tiếng Đức của bạn.\n\n'
    'Bạn có thể hỏi mình về:\n'
    '- 📖 Ngữ pháp tiếng Đức\n'
    '- 📝 Từ vựng và cách dùng\n'
    '- 🗣️ Phát âm và hội thoại\n'
    '- 📚 Mẹo thi Goethe/Telc\n\n'
    'Hãy hỏi mình bất cứ điều gì nhé!';

class _AIChatPageState extends ConsumerState<AIChatPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  bool _showSidebar = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
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

  void _applyChip(String prompt) {
    _textController.text = prompt;
    _textController.selection = TextSelection.collapsed(offset: prompt.length);
    _focusNode.requestFocus();
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _ChatHeader(
              onToggleHistory: () => setState(() => _showSidebar = !_showSidebar),
              onNewSession: _startNewSession,
            ),
            Expanded(
              child: Row(
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
                          child: _MessageList(
                            messages: state.messages,
                            scrollController: _scrollController,
                            onChipTap: _applyChip,
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
                          focusNode: _focusNode,
                          onSend: _sendMessage,
                          onStop: () => ref.read(aiChatNotifierProvider.notifier).cancelStreaming(),
                          isSending: state.isSending,
                        ),
                      ],
                    ),
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

/// Header card: top accent gradient line, tiger avatar, title + status dot,
/// history and new-chat actions. Mirrors the `<div className="... border-b
/// ... shadow-sm">` header in `ai-chat-panel.tsx`.
class _ChatHeader extends ConsumerWidget {
  final VoidCallback onToggleHistory;
  final VoidCallback onNewSession;

  const _ChatHeader({required this.onToggleHistory, required this.onNewSession});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(aiChatStatusProvider);
    final status = statusAsync.valueOrNull;
    final remainingText = (status != null && !status.isPremium && status.dailyLimit > 0)
        ? '${status.remaining}/${status.dailyLimit} lượt còn lại'
        : null;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: const Border(bottom: BorderSide(color: AppColors.border)),
        boxShadow: AppColors.shadowSm,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Accent line — gradient from-primary via-rose-500 to-primary/30.
          Positioned(
            top: -12,
            left: -16,
            right: -8,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.orange500, AppColors.rose600, AppColors.orange500.withValues(alpha: 0.3)],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.orange500.withValues(alpha: 0.15),
                      AppColors.rose600.withValues(alpha: 0.10),
                    ],
                  ),
                ),
                alignment: Alignment.center,
                child: const TigerIcon(size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Deutschtiger AI',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.foreground),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            remainingText ?? 'Trợ lý học tiếng Đức',
                            style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _HeaderIconButton(icon: Icons.history, label: 'Lịch sử', onTap: onToggleHistory),
              _HeaderIconButton(icon: Icons.edit_note_outlined, label: 'Chat mới', onTap: onNewSession),
            ],
          ),
        ],
      ),
    );
  }
}

/// Compact icon+label header action button — matches web's `w-11` icon
/// buttons with a 9px label beneath the icon.
class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HeaderIconButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: AppColors.mutedForeground),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: AppColors.mutedForeground)),
          ],
        ),
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  final List<AiChatUiMessage> messages;
  final ScrollController scrollController;
  final ValueChanged<String> onChipTap;

  const _MessageList({
    required this.messages,
    required this.scrollController,
    required this.onChipTap,
  });

  @override
  Widget build(BuildContext context) {
    final showWelcome = messages.isEmpty;
    final itemCount = messages.length + (showWelcome ? 2 : 0);

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (showWelcome && index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: _AssistantBubble(content: _welcomeMessage, isStreaming: false),
          );
        }
        if (showWelcome && index == 1) {
          return _SuggestionChips(onChipTap: onChipTap);
        }
        final message = messages[index - (showWelcome ? 2 : 0)];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: message.role == 'user'
              ? _UserBubble(message: message)
              : _AssistantBubble(content: message.content, isStreaming: message.isStreaming),
        );
      },
    );
  }
}

/// Suggestion chips shown on a fresh chat — pill buttons matching web's
/// `rounded-full border border-border bg-card` chips.
class _SuggestionChips extends StatelessWidget {
  final ValueChanged<String> onChipTap;

  const _SuggestionChips({required this.onChipTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 36),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final chip in _suggestionChips)
            OutlinedButton(
              onPressed: () => onChipTap(chip.$2),
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.card,
                foregroundColor: AppColors.foreground,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(chip.$1, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            ),
        ],
      ),
    );
  }
}

/// Assistant bubble: tiger avatar + card-style bubble with a squared
/// top-left corner (`rounded-2xl rounded-tl-sm`).
class _AssistantBubble extends StatelessWidget {
  final String content;
  final bool isStreaming;

  const _AssistantBubble({required this.content, required this.isStreaming});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.orange500.withValues(alpha: 0.2), AppColors.rose600.withValues(alpha: 0.15)],
            ),
          ),
          alignment: Alignment.center,
          child: const TigerIcon(size: 18),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: AppColors.shadowSm,
            ),
            child: content.isEmpty
                ? (isStreaming ? const _TypingDots() : const SizedBox.shrink())
                : Text(
                    content,
                    style: const TextStyle(fontSize: 14, color: AppColors.foreground, height: 1.5),
                  ),
          ),
        ),
      ],
    );
  }
}

/// User bubble: solid primary background, squared top-right corner
/// (`rounded-2xl rounded-tr-sm`), white text.
class _UserBubble extends StatelessWidget {
  final AiChatUiMessage message;

  const _UserBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          boxShadow: AppColors.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final att in message.attachments)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(att.url, height: 160, fit: BoxFit.cover),
                ),
              ),
            Text(
              message.content,
              style: const TextStyle(fontSize: 14, color: Colors.white, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small daily-quota counter from `GET /ai/chat-status` (already fetched by
/// [aiChatStatusProvider]). Hidden for premium users (unlimited) and while
/// the status call is in flight/failed — this is a soft hint, not a gate.
/// The header already surfaces the remaining count, so this banner only adds
/// value once it nears zero — kept for parity with the previous behavior.
class _QuotaBanner extends ConsumerWidget {
  const _QuotaBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(aiChatStatusProvider);
    final status = statusAsync.valueOrNull;
    if (status == null || status.isPremium || status.dailyLimit <= 0 || status.remaining > 3) {
      return const SizedBox.shrink();
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: AppColors.warning.withValues(alpha: 0.12),
      child: Text(
        'Còn ${status.remaining}/${status.dailyLimit} lượt chat hôm nay',
        style: const TextStyle(fontSize: 12, color: AppColors.warning),
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
    final color = kind == AiChatBannerKind.error ? AppColors.error : AppColors.warning;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: color.withValues(alpha: 0.10),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message.isEmpty ? 'Đã xảy ra lỗi. Vui lòng thử lại.' : message,
              style: TextStyle(color: color, fontSize: 13),
            ),
          ),
          if (onRetry != null) TextButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    );
  }
}

/// Three-dot typing indicator — matches web's bouncing dots in the empty
/// streaming bubble.
class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
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
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.mutedForeground.withValues(
                  alpha: progress < 0.5 ? progress * 2 : 2 - progress * 2,
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

/// Composer: rounded input pill + circular action button. The action button
/// swaps between send (primary gradient, paper-plane icon) and stop (red,
/// square-stop icon) while streaming — mirrors web's right action button.
class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final VoidCallback onStop;
  final bool isSending;

  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onStop,
    required this.isSending,
  });

  @override
  Widget build(BuildContext context) {
    final hint = AppLocalizations.of(context).socialTypeMessageHint;
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 44),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                enabled: !isSending,
                style: const TextStyle(fontSize: 15, color: AppColors.foreground, height: 1.3),
                decoration: InputDecoration(
                  hintText: isSending ? 'Đã hết lượt...' : hint,
                  hintStyle: const TextStyle(color: AppColors.mutedForeground),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                maxLines: 4,
                minLines: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isSending)
            _CircleActionButton(
              onTap: onStop,
              backgroundColor: AppColors.error,
              icon: Icons.stop_rounded,
              label: 'Dừng',
            )
          else
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                final hasText = value.text.trim().isNotEmpty;
                return _CircleActionButton(
                  onTap: hasText ? onSend : null,
                  gradient: hasText ? AppColors.primaryGradient : null,
                  backgroundColor: hasText ? null : AppColors.muted,
                  icon: Icons.send_rounded,
                  iconColor: hasText ? Colors.white : AppColors.mutedForeground,
                  label: 'Gửi tin nhắn',
                );
              },
            ),
        ],
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final LinearGradient? gradient;
  final IconData icon;
  final Color iconColor;
  final String label;

  const _CircleActionButton({
    required this.onTap,
    this.backgroundColor,
    this.gradient,
    required this.icon,
    this.iconColor = Colors.white,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
              gradient: gradient,
              boxShadow: onTap != null ? AppColors.shadowSm : null,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 20, color: iconColor),
          ),
        ),
      ),
    );
  }
}
