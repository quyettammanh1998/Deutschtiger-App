import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_tokens.dart';
import 'package:deutschtiger/data/ai/ai_chat_live_models.dart';
import 'package:deutschtiger/view_models/ai/ai_provider.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Chat history sidebar backed by the live `GET /ai/sessions` list.
class ChatHistorySidebar extends ConsumerStatefulWidget {
  final ValueChanged<ChatSessionSummary> onSessionSelected;
  final String? currentSessionId;
  final VoidCallback onClose;

  const ChatHistorySidebar({
    super.key,
    required this.onSessionSelected,
    this.currentSessionId,
    required this.onClose,
  });

  @override
  ConsumerState<ChatHistorySidebar> createState() => _ChatHistorySidebarState();
}

class _ChatHistorySidebarState extends ConsumerState<ChatHistorySidebar> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(aiChatNotifierProvider.notifier).loadSessions());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiChatNotifierProvider);

    return Container(
      decoration: BoxDecoration(
        color: context.tokens.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _SidebarHeader(onClose: widget.onClose),
          Expanded(
            child: state.sessionsLoading
                ? const Center(child: CircularProgressIndicator())
                : state.sessions.isEmpty
                ? const _EmptyHistory()
                : _HistoryList(
                    sessions: state.sessions,
                    currentSessionId: widget.currentSessionId,
                    onSessionSelected: widget.onSessionSelected,
                  ),
          ),
        ],
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _SidebarHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.tokens.primary.withValues(alpha: 0.1),
        border: Border(bottom: BorderSide(color: context.tokens.border)),
      ),
      child: Row(
        children: [
          Icon(PhosphorIcons.clockCounterClockwise, color: context.tokens.primary),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Chat History',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(icon: const Icon(PhosphorIcons.x), onPressed: onClose, iconSize: 20),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.chatCircle,
              size: 48,
              color: context.tokens.mutedForeground,
            ),
            const SizedBox(height: 16),
            Text(
              'No chat history yet',
              style: TextStyle(color: context.tokens.mutedForeground, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a conversation to see it here',
              style: TextStyle(color: context.tokens.mutedForeground, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  final List<ChatSessionSummary> sessions;
  final String? currentSessionId;
  final ValueChanged<ChatSessionSummary> onSessionSelected;

  const _HistoryList({
    required this.sessions,
    this.currentSessionId,
    required this.onSessionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: sessions.length,
      separatorBuilder: (_, _) => Divider(height: 1, color: context.tokens.border),
      itemBuilder: (context, index) {
        final item = sessions[index];
        final isSelected = item.id == currentSessionId;

        return _HistoryItem(
          item: item,
          isSelected: isSelected,
          onTap: () => onSessionSelected(item),
        );
      },
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final ChatSessionSummary item;
  final bool isSelected;
  final VoidCallback onTap;

  const _HistoryItem({required this.item, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? context.tokens.primary.withValues(alpha: 0.1) : null,
          border: isSelected
              ? Border(left: BorderSide(color: context.tokens.primary, width: 3))
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.tokens.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(PhosphorIcons.robot, size: 18, color: context.tokens.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title.isEmpty ? 'Cuộc trò chuyện' : item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? context.tokens.primary
                          : context.tokens.foreground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        PhosphorIcons.chatCircle,
                        size: 12,
                        color: context.tokens.mutedForeground,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item.messageCount} messages',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.tokens.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (item.updatedAt != null) ...[
              const SizedBox(width: 8),
              Text(
                _formatDate(item.updatedAt!),
                style: TextStyle(fontSize: 11, color: context.tokens.mutedForeground),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}
