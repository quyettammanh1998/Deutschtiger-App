/// Live-backend DTOs for AI chat (`/api/v1/ai/*`). These map 1:1 to the Go
/// handlers in `internal/shared/aihttp` — see phase-01 plan for the endpoint
/// list. Kept separate from `ai_models.dart` (the older mock-era models used
/// by the still-mock writing-practice feature) to avoid mixing live and mock
/// contracts in one file.
library;

/// One image attachment on a chat message. Sent as a Supabase Storage URL —
/// the backend fetches and re-encodes it server-side (see
/// `fetchImageFromURL` in `ai_chat_streaming.go`); the app never uploads raw
/// bytes to `/ai/chat` itself.
class ChatAttachment {
  const ChatAttachment({required this.url, required this.type, this.path = ''});

  final String url;
  final String type; // MIME, e.g. "image/jpeg" — whitelisted server-side.
  final String path;

  factory ChatAttachment.fromJson(Map<String, dynamic> json) => ChatAttachment(
    url: json['url'] as String? ?? '',
    type: json['type'] as String? ?? '',
    path: json['path'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {'url': url, 'type': type, 'path': path};
}

/// Exam-context metadata forwarded to `/ai/chat` when the user arrives from a
/// specific exam Teil (mirrors Go `examContext`).
class AiExamContext {
  const AiExamContext({
    required this.provider,
    required this.level,
    required this.slug,
    required this.skill,
    this.teil = 1,
    this.topic = '',
    this.contentOverride = '',
  });

  final String provider; // "telc" | "goethe"
  final String level;
  final String slug;
  final String skill; // "schreiben" | "sprechen"
  final int teil;
  final String topic;
  final String contentOverride;

  Map<String, dynamic> toJson() => {
    'provider': provider,
    'level': level,
    'slug': slug,
    'skill': skill,
    'teil': teil,
    if (topic.isNotEmpty) 'topic': topic,
    if (contentOverride.isNotEmpty) 'contentOverride': contentOverride,
  };
}

/// A persisted chat message returned by `GET /ai/sessions/{id}/messages`.
class ChatMessageDto {
  const ChatMessageDto({
    required this.id,
    required this.sessionId,
    required this.role,
    required this.content,
    this.attachments = const [],
    this.createdAt,
  });

  final String id;
  final String sessionId;
  final String role; // "user" | "assistant"
  final String content;
  final List<ChatAttachment> attachments;
  final DateTime? createdAt;

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) {
    final rawAttachments = json['attachments'] as List<dynamic>? ?? const [];
    return ChatMessageDto(
      id: json['id'] as String? ?? '',
      sessionId: json['sessionId'] as String? ?? '',
      role: json['role'] as String? ?? 'assistant',
      content: json['content'] as String? ?? '',
      attachments: rawAttachments
          .map((a) => ChatAttachment.fromJson(a as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }
}

/// A chat session summary, as returned by `GET /ai/sessions`.
class ChatSessionSummary {
  const ChatSessionSummary({
    required this.id,
    required this.title,
    this.messageCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final int messageCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ChatSessionSummary.fromJson(Map<String, dynamic> json) => ChatSessionSummary(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    messageCount: json['messageCount'] as int? ?? 0,
    createdAt: json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'] as String)
        : null,
    updatedAt: json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt'] as String)
        : null,
  );
}

/// `GET /ai/chat-status` — daily/session quota usage for the current user.
class ChatStatus {
  const ChatStatus({
    required this.isPremium,
    this.dailyLimit = 0,
    this.usedToday = 0,
    this.remaining = 0,
    this.sessionLimit = 0,
  });

  final bool isPremium;
  final int dailyLimit;
  final int usedToday;
  final int remaining;
  final int sessionLimit;

  factory ChatStatus.fromJson(Map<String, dynamic> json) => ChatStatus(
    isPremium: json['isPremium'] as bool? ?? false,
    dailyLimit: json['dailyLimit'] as int? ?? 0,
    usedToday: json['usedToday'] as int? ?? 0,
    remaining: json['remaining'] as int? ?? 0,
    sessionLimit: json['sessionLimit'] as int? ?? 0,
  );
}

/// One remembered fact from `GET /ai/memory` (`database.UserFact`).
class AiMemoryFact {
  const AiMemoryFact({
    required this.id,
    required this.factKey,
    required this.factValue,
    this.updatedAt,
  });

  final String id;
  final String factKey;
  final String factValue;
  final DateTime? updatedAt;

  factory AiMemoryFact.fromJson(Map<String, dynamic> json) => AiMemoryFact(
    id: json['id'] as String? ?? '',
    factKey: json['factKey'] as String? ?? '',
    factValue: json['factValue'] as String? ?? '',
    updatedAt: json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt'] as String)
        : null,
  );
}

/// One free-form note in the user-authored AI profile.
class AiProfileNote {
  const AiProfileNote({required this.raw, required this.de});
  final String raw;
  final String de;

  factory AiProfileNote.fromJson(Map<String, dynamic> json) =>
      AiProfileNote(raw: json['raw'] as String? ?? '', de: json['de'] as String? ?? '');
}

/// `GET`/`PUT /ai/profile` — user-authored "Tiger AI Memory" (mirrors Go
/// `profileResponse`). `fields`/`fieldsDe` are keyed by
/// name/age/gender/location/interests/job/family/goal/other.
class AiProfile {
  const AiProfile({this.fields = const {}, this.fieldsDe = const {}, this.notes = const []});

  final Map<String, String> fields;
  final Map<String, String> fieldsDe;
  final List<AiProfileNote> notes;

  static const fieldKeys = [
    'name',
    'age',
    'gender',
    'location',
    'interests',
    'job',
    'family',
    'goal',
    'other',
  ];

  factory AiProfile.empty() => const AiProfile();

  factory AiProfile.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'] as Map<String, dynamic>? ?? const {};
    final rawFieldsDe = json['fieldsDe'] as Map<String, dynamic>? ?? const {};
    final rawNotes = json['notes'] as List<dynamic>? ?? const [];
    return AiProfile(
      fields: rawFields.map((k, v) => MapEntry(k, v as String? ?? '')),
      fieldsDe: rawFieldsDe.map((k, v) => MapEntry(k, v as String? ?? '')),
      notes: rawNotes
          .map((n) => AiProfileNote.fromJson(n as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// One decoded SSE payload from `POST /ai/chat`. The backend only ever emits
/// three shapes: `{"content": "..."}` tokens, a trailing `[DONE]` literal, or
/// (rarely, mid-stream) `{"error": "..."}` when the upstream LLM fails after
/// the first token was already flushed.
sealed class AiChatStreamEvent {
  const AiChatStreamEvent();
}

class AiChatContentEvent extends AiChatStreamEvent {
  const AiChatContentEvent(this.text);
  final String text;
}

class AiChatDoneEvent extends AiChatStreamEvent {
  const AiChatDoneEvent();
}

class AiChatErrorEvent extends AiChatStreamEvent {
  const AiChatErrorEvent(this.message);
  final String message;
}

/// Structured pre-stream failure: the backend rejects the whole request
/// before opening the SSE response (auth, malformed body, or a quota/session
/// limit hit — see `reserveChatSlot`/`resolveLastUserMessage` in
/// `ai_chat_request_handler.go`). Distinguished from a generic [Exception] so
/// the UI can show "upgrade" vs. "new session" vs. a plain retry banner.
class AiChatRequestException implements Exception {
  AiChatRequestException(this.message, {this.code, this.limit, this.used, this.statusCode});

  /// Human-readable, already-localized (Vietnamese) message from the backend.
  final String message;

  /// One of free_limit_reached | premium_limit_reached | session_limit_reached,
  /// or null for a plain error (validation, auth, 5xx).
  final String? code;
  final int? limit;
  final int? used;
  final int? statusCode;

  bool get isQuotaExceeded =>
      code == 'free_limit_reached' || code == 'premium_limit_reached';
  bool get isSessionLimitReached => code == 'session_limit_reached';

  @override
  String toString() => 'AiChatRequestException($code): $message';
}
