import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'ai_provider.dart';
import '../domain/ai_models.dart';
import '../widgets/chat_history_sidebar.dart';
import '../widgets/voice_recording_overlay.dart';

class AIChatPage extends ConsumerStatefulWidget {
  const AIChatPage({super.key});

  @override
  ConsumerState<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends ConsumerState<AIChatPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _showSidebar = false;
  bool _showVoiceOverlay = false;
  String _currentMode = 'grammar';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(aiChatNotifierProvider).startNewSession(_currentMode);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    ref.read(aiChatNotifierProvider).sendMessage(text);
    _textController.clear();
    
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _startNewSession() {
    ref.read(aiChatNotifierProvider).startNewSession(_currentMode);
  }

  void _onSessionSelected(ChatHistoryItem session) {
    ref.read(aiChatNotifierProvider).loadSession(session.id);
    setState(() => _showSidebar = false);
  }

  void _onModeChanged(String mode) {
    setState(() => _currentMode = mode);
  }

  void _showRecordingOverlay() {
    setState(() => _showVoiceOverlay = true);
  }

  void _hideRecordingOverlay() {
    setState(() => _showVoiceOverlay = false);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(aiChatNotifierProvider);
    final state = notifier.state;
    final modesAsync = ref.watch(aiModesProvider);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('AI Tutor'),
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => setState(() => _showSidebar = !_showSidebar),
            ),
            actions: [
              modesAsync.when(
                data: (modes) => PopupMenuButton<String>(
                  icon: const Icon(Icons.psychology),
                  tooltip: 'Change Mode',
                  onSelected: _onModeChanged,
                  itemBuilder: (context) => modes.map((mode) {
                    return PopupMenuItem<String>(
                      value: mode.id,
                      child: Row(
                        children: [
                          Icon(
                            _getModeIcon(mode.id),
                            size: 20,
                            color: _currentMode == mode.id 
                                ? AppColors.primary 
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Text(mode.name),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
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
                    currentSessionId: state.currentSession?.id,
                    onClose: () => setState(() => _showSidebar = false),
                  ),
                ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: state.messages.isEmpty && !state.isLoading
                          ? _EmptyState(
                              onStartChat: () => _startNewSession(),
                            )
                          : _MessageList(
                              messages: state.messages,
                              scrollController: _scrollController,
                              isLoading: state.isLoading,
                            ),
                    ),
                    if (state.isLoading) _LoadingIndicator(),
                    _InputBar(
                      controller: _textController,
                      onSend: _sendMessage,
                      onVoiceInput: _showRecordingOverlay,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_showVoiceOverlay)
          VoiceRecordingOverlay(
            onCancel: _hideRecordingOverlay,
            onConfirm: (audioPath) {
              _hideRecordingOverlay();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Voice input recorded: ${audioPath.length} chars'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          ),
      ],
    );
  }

  IconData _getModeIcon(String mode) {
    switch (mode) {
      case 'grammar':
        return Icons.school;
      case 'conversation':
        return Icons.chat;
      case 'vocabulary':
        return Icons.book;
      case 'exam':
        return Icons.assignment;
      default:
        return Icons.psychology;
    }
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
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Start a Conversation',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ask questions, practice German, or just chat!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onStartChat,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Chatting'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  final List<AIChatMessage> messages;
  final ScrollController scrollController;
  final bool isLoading;

  const _MessageList({
    required this.messages,
    required this.scrollController,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= messages.length) {
          return _TypingIndicator();
        }
        
        final message = messages[index];
        final isUser = message.role == 'user';
        
        return _MessageBubble(
          message: message,
          isUser: isUser,
          showTranslation: !isUser,
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final AIChatMessage message;
  final bool isUser;
  final bool showTranslation;

  const _MessageBubble({
    required this.message,
    required this.isUser,
    required this.showTranslation,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  if (message.grammarCorrections.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _GrammarCorrections(corrections: message.grammarCorrections),
                  ],
                ],
              ),
            ),
            if (showTranslation && message.translation.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.translate,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        message.translation,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (message.vocabularyHighlight.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: message.vocabularyHighlight.map((word) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      word,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.foreground,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GrammarCorrections extends StatelessWidget {
  final List<GrammarCorrection> corrections;

  const _GrammarCorrections({required this.corrections});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: corrections.map((c) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 13),
                children: [
                  TextSpan(
                    text: '${c.original} → ',
                    style: TextStyle(color: Colors.red[700]),
                  ),
                  TextSpan(
                    text: c.correction,
                    style: TextStyle(color: Colors.green[700]),
                  ),
                  TextSpan(
                    text: '\n${c.explanation}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'AI is thinking...',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(18),
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                final delay = index * 0.2;
                final progress = (_controller.value - delay).clamp(0.0, 1.0);
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[400]!.withAlpha((255 * (progress < 0.5 ? progress * 2 : 2 - progress * 2)).toInt()),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onVoiceInput;

  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.onVoiceInput,
  });

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
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.mic),
            color: AppColors.primary,
            onPressed: onVoiceInput,
            tooltip: 'Voice Input',
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                maxLines: null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send),
              color: Colors.white,
              onPressed: onSend,
            ),
          ),
        ],
      ),
    );
  }
}
