import 'dart:async';

import 'package:flutter/foundation.dart';

import 'api_client.dart';

/// Một event gửi lên BE `/api/v1/user/events`.
class TrackEvent {
  const TrackEvent._({
    required this.event,
    required this.source,
    this.metadata,
  });

  final String event;
  final String source;
  final Map<String, Object?>? metadata;

  Map<String, Object?> toJson() => {
    'event': event,
    'source': source,
    if (metadata != null) 'metadata': metadata,
  };
}

/// Event tracking nhẹ — mirror web `src/lib/shared/event-tracking.ts`:
/// - buffer events, flush mỗi 5s
/// - khi app vào background → flush ngay (AppLifecycleState.paused/inactive)
/// - fire-and-forget, KHÔNG bao giờ chặn UI
/// - silent on failure
///
/// Endpoint BE: `POST /api/v1/user/events` body `{ events: [...] }`.
class EventTracking {
  EventTracking({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;
  final List<TrackEvent> _buffer = [];
  Timer? _flushTimer;
  bool _flushing = false;

  /// Queue một event. Không bao giờ throw.
  void track(String event, {String? source, Map<String, Object?>? metadata}) {
    final safeEvent = _sanitizeToken(event);
    final safeSource = _sanitizeToken(source ?? 'app');
    if (safeEvent == null || safeSource == null) return;

    final safeMetadata = sanitizeMetadata(metadata);
    final ev = TrackEvent._(
      event: safeEvent,
      source: safeSource,
      metadata: safeMetadata.isEmpty ? null : safeMetadata,
    );
    _buffer.add(ev);
    _ensureTimer();
  }

  /// AppLifecycle observer — flush sớm khi user rời app (mirror web
  /// `visibilitychange → hidden`).
  void onAppPaused() => flush();

  /// Force flush (vd. logout, test). Trả Future cho caller nếu muốn await.
  Future<void> flush() async {
    if (_buffer.isEmpty || _flushing) return;
    _flushing = true;
    final batch = List<TrackEvent>.unmodifiable(_buffer);
    _buffer.clear();
    try {
      await _api.post<dynamic>(
        '/user/events',
        body: {'events': batch.map((e) => e.toJson()).toList()},
      );
    } catch (_) {
      if (kDebugMode) debugPrint('[EventTracking] flush failed');
      // Đừng requeue — analytics không được vượt quyền UX (mirrors web).
    } finally {
      _flushing = false;
    }
  }

  void _ensureTimer() {
    _flushTimer ??= Timer.periodic(const Duration(seconds: 5), (_) => flush());
  }

  /// Dọn tài nguyên (vd. khi logout/test teardown).
  void dispose() {
    _flushTimer?.cancel();
    _flushTimer = null;
  }

  /// Test helpers.
  @visibleForTesting
  int get pendingCount => _buffer.length;

  @visibleForTesting
  Future<void> flushForTest() => flush();

  /// Keeps telemetry aggregate-only. Event names and source identify the
  /// category; metadata cannot carry learner text, file paths, URLs or tokens.
  @visibleForTesting
  static Map<String, Object?> sanitizeMetadata(Map<String, Object?>? metadata) {
    if (metadata == null) return const {};

    final sanitized = <String, Object?>{};
    for (final entry in metadata.entries) {
      if (!_metadataKey.hasMatch(entry.key)) continue;
      final value = entry.value;
      if (value is bool || value is int) {
        sanitized[entry.key] = value;
      } else if (value is double && value.isFinite) {
        sanitized[entry.key] = value;
      }
    }
    return sanitized;
  }
}

final _telemetryToken = RegExp(r'^[A-Za-z0-9_-]{1,80}$');
final _metadataKey = RegExp(r'^[a-z][a-z0-9_]{0,39}$');

String? _sanitizeToken(String value) {
  final token = value.trim();
  return _telemetryToken.hasMatch(token) ? token : null;
}
