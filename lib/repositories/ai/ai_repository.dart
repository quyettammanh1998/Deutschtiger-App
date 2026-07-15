import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/ai/ai_chat_live_models.dart';
import '../../services/api/sse_client.dart';
import '../../services/api_client.dart';
import '../../view_models/providers.dart';

/// Live repository for Tiger AI chat — `/api/v1/ai/*`
/// (`internal/shared/aihttp` on the backend; see phase-01 plan). Streaming
/// send uses the shared [SseClient]; everything else is plain JSON via
/// [ApiClient].
class AIRepository {
  AIRepository(this._apiClient) : _sse = SseClient(_apiClient.raw);

  final ApiClient _apiClient;
  final SseClient _sse;

  /// Sends one chat turn and streams the assistant's reply token-by-token.
  ///
  /// [onSessionId] fires once, as soon as the response headers arrive, with
  /// the session id the backend created/resumed (`X-Session-Id`) — the caller
  /// needs this before the first token to attach subsequent turns to the same
  /// session. A quota/session-limit/validation rejection surfaces as
  /// [AiChatRequestException] *before* any [AiChatContentEvent] is emitted
  /// (the backend rejects those requests pre-SSE-header); a failure after
  /// streaming started surfaces as an in-band [AiChatErrorEvent] instead, per
  /// `ai_chat_stream_handler.go`.
  Stream<AiChatStreamEvent> sendMessage({
    required String content,
    String? sessionId,
    List<ChatAttachment> attachments = const [],
    AiExamContext? examContext,
    CancelToken? cancelToken,
    void Function(String sessionId)? onSessionId,
  }) async* {
    final body = <String, dynamic>{
      'payload_mode': 'session',
      'content': content,
      if (attachments.isNotEmpty)
        'attachments': attachments.map((a) => a.toJson()).toList(),
      if (sessionId != null && sessionId.isNotEmpty) 'sessionId': sessionId,
      if (examContext != null) 'examContext': examContext.toJson(),
    };

    Stream<SseEvent> raw;
    try {
      raw = _sse.stream(
        '/ai/chat',
        body: body,
        cancelToken: cancelToken,
        onHeaders: (headers) {
          final id = headers.value('x-session-id');
          if (id != null && id.isNotEmpty) onSessionId?.call(id);
        },
      );
    } on SseException catch (e) {
      throw _toRequestException(e);
    }

    try {
      await for (final event in raw) {
        if (event.data == '[DONE]') {
          yield const AiChatDoneEvent();
          continue;
        }
        Map<String, dynamic> json;
        try {
          json = jsonDecode(event.data) as Map<String, dynamic>;
        } catch (_) {
          continue; // Malformed payload — skip, do not abort the whole turn.
        }
        final error = json['error'] as String?;
        if (error != null) {
          yield AiChatErrorEvent(error);
          continue;
        }
        final text = json['content'] as String?;
        if (text != null && text.isNotEmpty) yield AiChatContentEvent(text);
      }
    } on SseException catch (e) {
      throw _toRequestException(e);
    }
  }

  /// GET /ai/sessions
  Future<List<ChatSessionSummary>> getSessions({int limit = 20}) async {
    final data = await _apiClient.get<List<dynamic>>(
      '/ai/sessions',
      query: {'limit': limit},
    );
    return data
        .map((e) => ChatSessionSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /ai/sessions/{sessionId}/messages
  Future<List<ChatMessageDto>> getSessionMessages(String sessionId) async {
    final data = await _apiClient.get<dynamic>(
      '/ai/sessions/$sessionId/messages',
    );
    // Empty-history shape is a bare `[]`; populated shape is
    // `{"messages": [...], "metadata": {...}}` (see GetSessionMessages).
    final list = data is Map<String, dynamic>
        ? data['messages'] as List<dynamic>? ?? const []
        : (data as List<dynamic>? ?? const []);
    return list
        .map((e) => ChatMessageDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /ai/chat-status
  Future<ChatStatus> getChatStatus() async {
    final data = await _apiClient.get<Map<String, dynamic>>('/ai/chat-status');
    return ChatStatus.fromJson(data);
  }

  /// GET /ai/memory
  Future<List<AiMemoryFact>> getMemory() async {
    final data = await _apiClient.get<Map<String, dynamic>>('/ai/memory');
    final facts = data['facts'] as List<dynamic>? ?? const [];
    return facts
        .map((e) => AiMemoryFact.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// DELETE /ai/memory/{factKey}
  Future<void> deleteMemoryFact(String factKey) async {
    await _apiClient.delete<dynamic>('/ai/memory/$factKey');
  }

  /// DELETE /ai/memory
  Future<void> deleteAllMemory() async {
    await _apiClient.delete<dynamic>('/ai/memory');
  }

  /// GET /ai/profile
  Future<AiProfile> getProfile() async {
    final data = await _apiClient.get<Map<String, dynamic>>('/ai/profile');
    return AiProfile.fromJson(data);
  }

  /// PUT /ai/profile — bulk save of fields + notes.
  Future<AiProfile> updateProfile({
    required Map<String, String> fields,
    required List<String> notes,
  }) async {
    final data = await _apiClient.put<Map<String, dynamic>>(
      '/ai/profile',
      body: {'fields': fields, 'notes': notes},
    );
    return AiProfile.fromJson(data);
  }

  /// Maps a pre-stream [SseException] (backend rejected the request before
  /// opening SSE headers — auth, validation, or a quota/session-limit hit) to
  /// a typed [AiChatRequestException] the UI can branch on.
  AiChatRequestException _toRequestException(SseException e) {
    try {
      final json = jsonDecode(e.message) as Map<String, dynamic>;
      final error = json['error'] as String?;
      if (error == 'free_limit_reached' ||
          error == 'premium_limit_reached' ||
          error == 'session_limit_reached') {
        return AiChatRequestException(
          json['message'] as String? ?? e.message,
          code: error,
          limit: json['limit'] as int?,
          used: json['used'] as int?,
          statusCode: e.statusCode,
        );
      }
      // Plain `{"error": "..."}` from httpx.RespondError.
      if (error != null) {
        return AiChatRequestException(error, statusCode: e.statusCode);
      }
    } catch (_) {
      // Not JSON (network error, HTML error page, etc.) — fall through.
    }
    return AiChatRequestException(e.message, statusCode: e.statusCode);
  }
}

final aiRepositoryProvider = Provider<AIRepository>((ref) {
  return AIRepository(ref.watch(apiClientProvider));
});
