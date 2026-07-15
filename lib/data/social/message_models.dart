/// Direct-message DTOs matching the Go backend contract
/// (`internal/infra/database/message_repo.go`, routes under
/// `GET/POST/PUT /user/messages*`). Mobile uses poll-based refresh only — no
/// realtime transport in this phase (see phase-03 spec: realtime/WebRTC
/// deferred).
class MessageReaction {
  const MessageReaction({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.emoji,
  });

  final String id;
  final String messageId;
  final String userId;
  final String emoji;

  factory MessageReaction.fromJson(Map<String, dynamic> json) =>
      MessageReaction(
        id: json['id'] as String? ?? '',
        messageId: json['message_id'] as String? ?? '',
        userId: json['user_id'] as String? ?? '',
        emoji: json['emoji'] as String? ?? '',
      );
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.content,
    this.readAt,
    required this.createdAt,
    this.attachmentUrl,
    this.reactions = const [],
  });

  final String id;
  final String senderId;
  final String receiverId;
  final String? content;
  final DateTime? readAt;
  final DateTime createdAt;
  final String? attachmentUrl;
  final List<MessageReaction> reactions;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'] as String? ?? '',
    senderId: json['sender_id'] as String? ?? '',
    receiverId: json['receiver_id'] as String? ?? '',
    content: json['content'] as String?,
    readAt: json['read_at'] != null
        ? DateTime.tryParse(json['read_at'] as String)
        : null,
    createdAt:
        DateTime.tryParse(json['created_at'] as String? ?? '') ??
        DateTime.now(),
    attachmentUrl: json['attachment_url'] as String?,
    reactions:
        (json['reactions'] as List<dynamic>?)
            ?.map((e) => MessageReaction.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
  );
}

/// Conversation summary — one row per friend with an exchanged message.
class ChatConversation {
  const ChatConversation({
    required this.friendId,
    required this.displayName,
    required this.avatarUrl,
    required this.lastMessageContent,
    required this.lastMessageAt,
    required this.unreadCount,
    required this.isSender,
    required this.isOnline,
    this.lastSeen,
  });

  final String friendId;
  final String displayName;
  final String avatarUrl;
  final String lastMessageContent;
  final DateTime lastMessageAt;
  final int unreadCount;
  final bool isSender;
  final bool isOnline;
  final String? lastSeen;

  factory ChatConversation.fromJson(Map<String, dynamic> json) =>
      ChatConversation(
        friendId: json['friend_id'] as String? ?? '',
        displayName: json['display_name'] as String? ?? '',
        avatarUrl: json['avatar_url'] as String? ?? '',
        lastMessageContent: json['last_message_content'] as String? ?? '',
        lastMessageAt:
            DateTime.tryParse(json['last_message_at'] as String? ?? '') ??
            DateTime.now(),
        unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
        isSender: json['is_sender'] as bool? ?? false,
        isOnline: json['is_online'] as bool? ?? false,
        lastSeen: json['last_seen'] as String?,
      );
}
