import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deutschtiger/core/icons/app_phosphor_icons.dart';
import 'package:deutschtiger/core/theme/app_tokens.dart';
import 'package:deutschtiger/data/social/message_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/view_models/social/messages_provider.dart';

import 'widgets/social_avatar.dart';

/// Conversation list — `GET /user/messages/conversations`. Poll-based: the
/// list refreshes on open, on app resume (`didChangeAppLifecycleState`) and
/// pull-to-refresh. No background polling / realtime transport. Web parity:
/// `pages/social/messages-page.tsx` (flat rows, "Bạn:" sender prefix).
class MessagesPage extends ConsumerStatefulWidget {
  const MessagesPage({super.key});

  @override
  ConsumerState<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends ConsumerState<MessagesPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(conversationsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tokens = context.tokens;
    final conversationsAsync = ref.watch(conversationsProvider);
    final count = conversationsAsync.valueOrNull?.length ?? 0;

    return Scaffold(
      backgroundColor: tokens.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () =>
                        context.canPop() ? context.pop() : context.go('/home'),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.socialMessagesTitle,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: tokens.foreground,
                        ),
                      ),
                      Text(
                        count > 0
                            ? l10n.socialConversationsCount(count)
                            : l10n.socialNoMessagesYet,
                        style: TextStyle(
                          fontSize: 12,
                          color: tokens.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: conversationsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text(l10n.socialLoadMessagesError)),
                data: (conversations) {
                  if (conversations.isEmpty) {
                    return _buildEmptyState(context, l10n);
                  }
                  return RefreshIndicator(
                    onRefresh: () async => ref.invalidate(conversationsProvider),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: conversations.length,
                      itemBuilder: (context, index) => _ConversationRow(
                        conversation: conversations[index],
                        l10n: l10n,
                        onTap: () => context
                            .push('/social/chat/${conversations[index].friendId}'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    final tokens = context.tokens;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AppPhosphorIcons.chatText, size: 48, color: tokens.mutedForeground),
          const SizedBox(height: 12),
          Text(
            l10n.socialNoMessagesYet,
            style: TextStyle(color: tokens.mutedForeground, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _ConversationRow extends StatelessWidget {
  const _ConversationRow({
    required this.conversation,
    required this.l10n,
    required this.onTap,
  });

  final ChatConversation conversation;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final unread = conversation.unreadCount > 0;
    final previewPrefix = conversation.isSender ? '${l10n.socialYouPrefix}: ' : '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              SocialAvatar(
                displayName: conversation.displayName,
                avatarUrl: conversation.avatarUrl,
                showOnlineDot: true,
                isOnline: conversation.isOnline,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.displayName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: unread
                                  ? tokens.foreground
                                  : tokens.foreground.withValues(alpha: 0.8),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          _formatTime(conversation.lastMessageAt, l10n),
                          style: TextStyle(fontSize: 11, color: tokens.mutedForeground),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$previewPrefix${conversation.lastMessageContent}',
                            style: TextStyle(
                              fontSize: 13,
                              color: tokens.mutedForeground,
                              fontWeight: unread ? FontWeight.w600 : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (unread) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: tokens.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              conversation.unreadCount > 99
                                  ? '99+'
                                  : '${conversation.unreadCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return l10n.justNow;
    if (diff.inMinutes < 60) return '${diff.inMinutes}p';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${time.day}/${time.month}';
  }
}
