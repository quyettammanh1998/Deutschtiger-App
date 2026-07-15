import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deutschtiger/data/social/message_models.dart';
import 'social_repository_providers.dart';

/// Conversation list (`GET /user/messages/conversations`). Callers refresh
/// via pull-to-refresh or on app resume — no background polling.
final conversationsProvider = FutureProvider.autoDispose<List<ChatConversation>>(
  (ref) async {
    return ref.watch(messageRepositoryProvider).getConversations();
  },
);

/// Message thread with one friend, keyed by friendId.
final chatMessagesProvider = FutureProvider.autoDispose
    .family<List<ChatMessage>, String>((ref, friendId) async {
      final repo = ref.watch(messageRepositoryProvider);
      final messages = await repo.getMessages(friendId);
      // Best-effort mark-as-read; failures should not block rendering.
      unawaited(repo.markAsRead(friendId));
      return messages;
    });

/// Combined messages+notifications unread badge (`GET /user/unread-counts`).
final unreadCountsProvider = FutureProvider.autoDispose((ref) async {
  return ref.watch(unreadCountsRepositoryProvider).getUnreadCounts();
});

class ChatActions {
  ChatActions(this._ref);

  final Ref _ref;

  Future<ChatMessage> sendMessage(String friendId, String content) async {
    final message = await _ref
        .read(messageRepositoryProvider)
        .sendMessage(friendId, content);
    _ref.invalidate(chatMessagesProvider(friendId));
    _ref.invalidate(conversationsProvider);
    return message;
  }

  Future<void> refresh(String friendId) async {
    _ref.invalidate(chatMessagesProvider(friendId));
  }
}

final chatActionsProvider = Provider.autoDispose<ChatActions>((ref) {
  return ChatActions(ref);
});

/// Small helper to fire an async call without awaiting it inline.
void unawaited(Future<void> future) {
  future.catchError((_) {});
}
