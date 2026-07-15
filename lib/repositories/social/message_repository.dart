import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/data/social/message_models.dart';

/// Direct messages — `internal/feature/social/message/message_handler.go`,
/// mounted under `/user/messages*`. Mobile refreshes by polling (resume +
/// pull-to-refresh) only; no realtime transport in this phase.
class MessageRepository {
  MessageRepository(this._api);

  final ApiClient _api;

  Future<List<ChatConversation>> getConversations() async {
    final json = await _api.get<List<dynamic>>('/user/messages/conversations');
    return json
        .map((e) => ChatConversation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ChatMessage>> getMessages(String friendId, {int limit = 40}) async {
    final json = await _api.get<List<dynamic>>(
      '/user/messages/$friendId',
      query: {'limit': limit},
    );
    return json
        .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ChatMessage> sendMessage(String receiverId, String content) async {
    final json = await _api.post<Map<String, dynamic>>(
      '/user/messages',
      body: {'receiver_id': receiverId, 'content': content},
    );
    return ChatMessage.fromJson(json);
  }

  Future<void> markAsRead(String senderId) async {
    await _api.put<Map<String, dynamic>>('/user/messages/$senderId/read');
  }

  Future<int> getUnreadCount() async {
    final json = await _api.get<Map<String, dynamic>>(
      '/user/messages/unread-count',
    );
    return (json['count'] as num?)?.toInt() ?? 0;
  }
}
