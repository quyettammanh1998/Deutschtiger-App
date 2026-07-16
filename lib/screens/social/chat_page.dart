import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/core/theme/app_colors.dart';
import 'package:deutschtiger/data/social/message_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/providers.dart';
import 'package:deutschtiger/view_models/social/friends_provider.dart';
import 'package:deutschtiger/view_models/social/messages_provider.dart';
import 'package:deutschtiger/view_models/social/public_profile_provider.dart';

import 'widgets/social_avatar.dart';

const Map<String, String> _kChatActivityLabels = {
  'dashboard': 'Đang online',
  'learning': 'Đang học từ vựng',
  'practicing': 'Đang luyện tập',
  'playing_matching': 'Đang chơi Matching',
  'playing_cloze': 'Đang chơi Cloze',
  'playing_listening': 'Đang chơi Listening',
  'playing_writing': 'Đang chơi Writing',
  'playing_word_sprint': 'Đang chơi Word Sprint',
  'watching_youtube': 'Đang xem YouTube',
  'chatting': 'Đang nhắn tin',
  'reviewing_flashcards': 'Đang ôn Flashcard',
  'taking_exam': 'Đang làm bài thi',
  'in_call': 'Đang gọi điện',
};

/// DM thread with one friend, keyed by `friendId` (`GET/POST
/// /user/messages/{friendId}`). Poll-based refresh only: manual pull, and on
/// app resume — no realtime transport, no background timer.
class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key, required this.friendId});

  final String friendId;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage>
    with WidgetsBindingObserver {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(chatActionsProvider).refresh(widget.friendId);
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    _messageController.clear();
    try {
      await ref.read(chatActionsProvider).sendMessage(widget.friendId, text);
      _scrollToBottom();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).socialSendMessageError)),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(publicProfileProvider(widget.friendId));
    final messagesAsync = ref.watch(chatMessagesProvider(widget.friendId));
    final myId = ref.watch(myProfileProvider).valueOrNull?.id;

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: GestureDetector(
          onTap: () => context.push('/social/profile/${widget.friendId}'),
          child: Builder(
            builder: (context) {
              final profile = profileAsync.valueOrNull;
              final activityLabel = profile?.currentActivity != null
                  ? _kChatActivityLabels[profile!.currentActivity]
                  : null;
              return Row(
                children: [
                  SocialAvatar(
                    displayName: profile?.displayName ?? '',
                    avatarUrl: profile?.avatarUrl,
                    size: 36,
                    showOnlineDot: true,
                    isOnline: profile?.isOnline ?? false,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        profile?.displayName ?? '…',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      if (profile != null)
                        Text(
                          profile.isOnline
                              ? (activityLabel ?? l10n.socialOnlineNow)
                              : l10n.socialOffline,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: profile.isOnline ? FontWeight.w600 : FontWeight.normal,
                            color: profile.isOnline
                                ? const Color(0xFF16A34A)
                                : AppColors.mutedForeground,
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'profile') {
                context.push('/social/profile/${widget.friendId}');
              } else if (value == 'block') {
                await _confirmAndBlock(context, ref, l10n);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'profile', child: Text(l10n.socialViewProfile)),
              PopupMenuItem(
                value: 'block',
                child: Text(
                  l10n.socialBlockUser,
                  style: const TextStyle(color: AppColors.destructive),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(chatActionsProvider).refresh(widget.friendId),
              child: messagesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => ListView(
                  children: [
                    const SizedBox(height: 80),
                    Center(child: Text(l10n.socialLoadMessagesError)),
                  ],
                ),
                data: (messages) => messages.isEmpty
                    ? ListView(
                        children: [
                          const SizedBox(height: 80),
                          Center(
                            child: Text(
                              l10n.socialStartChatting,
                              style: TextStyle(color: AppColors.mutedForeground),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) => _MessageBubble(
                          message: messages[index],
                          isMe: myId != null && messages[index].senderId == myId,
                        ),
                      ),
              ),
            ),
          ),
          _buildMessageInput(l10n),
        ],
      ),
    );
  }

  Future<void> _confirmAndBlock(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.socialBlockUser),
        content: Text(l10n.socialBlockUserConfirmGeneric),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.socialBlockUser,
              style: const TextStyle(color: AppColors.destructive),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(friendsActionsProvider).blockUser(widget.friendId);
    if (context.mounted) context.pop();
  }

  Widget _buildMessageInput(AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: l10n.socialTypeMessageHint,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: _sending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
            onPressed: _sending ? null : _sendMessage,
            color: AppColors.tigerOrange,
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMe});

  final ChatMessage message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    // Web parity: time + read-receipt ticks render OUTSIDE the bubble
    // (`message-bubble.tsx`), not stacked inside it.
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.tigerOrange : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isMe ? 16 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 16),
                  ),
                  border: isMe ? null : Border.all(color: AppColors.border),
                  boxShadow: isMe
                      ? null
                      : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)],
                ),
                child: Text(
                  message.content ?? '',
                  style: TextStyle(
                    color: isMe ? Colors.white : AppColors.foreground,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTime(message.createdAt),
                style: TextStyle(fontSize: 10, color: AppColors.mutedForeground),
              ),
              if (isMe) ...[
                const SizedBox(width: 4),
                Icon(
                  message.readAt != null ? Icons.done_all : Icons.done,
                  size: 12,
                  color: message.readAt != null
                      ? AppColors.tigerOrange
                      : AppColors.mutedForeground,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}
