import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../presentation/ai_provider.dart';
import '../domain/ai_models.dart';

class ChatHistorySidebar extends ConsumerWidget {
  final Function(ChatHistoryItem) onSessionSelected;
  final String? currentSessionId;
  final VoidCallback onClose;

  const ChatHistorySidebar({
    super.key,
    required this.onSessionSelected,
    this.currentSessionId,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(aiChatHistoryProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _SidebarHeader(onClose: onClose),
          Expanded(
            child: historyAsync.when(
              data: (history) => history.isEmpty
                  ? _EmptyHistory()
                  : _HistoryList(
                      history: history,
                      currentSessionId: currentSessionId,
                      onSessionSelected: onSessionSelected,
                    ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (e, _) => Center(
                child: Text('Error: $e'),
              ),
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
        color: AppColors.primary.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.history, color: AppColors.primary),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Chat History',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
            iconSize: 20,
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No chat history yet',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a conversation to see it here',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  final List<ChatHistoryItem> history;
  final String? currentSessionId;
  final Function(ChatHistoryItem) onSessionSelected;

  const _HistoryList({
    required this.history,
    this.currentSessionId,
    required this.onSessionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: history.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        color: Colors.grey[200],
      ),
      itemBuilder: (context, index) {
        final item = history[index];
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
  final ChatHistoryItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _HistoryItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
          border: isSelected
              ? Border(left: BorderSide(color: AppColors.primary, width: 3))
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getModeColor(item.mode).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getModeIcon(item.mode),
                size: 18,
                color: _getModeColor(item.mode),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item.messageCount} messages',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (item.lastMessageAt != null) ...[
              const SizedBox(width: 8),
              Text(
                _formatDate(item.lastMessageAt!),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ],
        ),
      ),
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

  Color _getModeColor(String mode) {
    switch (mode) {
      case 'grammar':
        return Colors.blue;
      case 'conversation':
        return Colors.green;
      case 'vocabulary':
        return Colors.orange;
      case 'exam':
        return Colors.purple;
      default:
        return AppColors.primary;
    }
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
