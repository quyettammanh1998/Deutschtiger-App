import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

/// One parsed server-sent event: optional event name + the un-prefixed data
/// payload (multiple `data:` lines are joined with `\n`, per the SSE spec).
class SseEvent {
  const SseEvent({this.event, required this.data});
  final String? event;
  final String data;

  @override
  String toString() => 'SseEvent(event: $event, data: $data)';

  @override
  bool operator ==(Object other) =>
      other is SseEvent && other.event == event && other.data == data;

  @override
  int get hashCode => Object.hash(event, data);
}

/// Raised when the SSE request itself fails: non-2xx status, network error,
/// or the connection is dropped. Malformed individual event lines are skipped
/// per the SSE spec — they never raise this.
class SseException implements Exception {
  SseException(this.message, {this.statusCode, this.originalError});
  final String message;
  final int? statusCode;
  final Object? originalError;

  @override
  String toString() => 'SseException: $message (status: $statusCode)';
}

/// Parses a raw byte stream into [SseEvent]s per the subset of the WHATWG SSE
/// line algorithm our Go backend actually emits: `data:`/`event:` fields,
/// `:`-prefixed comments (keep-alive pings, e.g. `: ping`) are ignored, and a
/// blank line dispatches the accumulated event. `id:`/`retry:` fields are
/// accepted (skipped) but unused — this backend never sends them.
///
/// Exposed standalone so tests can exercise parsing — including chunk splits
/// that cut a line or a multi-byte UTF-8 character in half — without a real
/// HTTP round-trip. [Utf8Decoder] + [LineSplitter] both buffer partial input
/// across chunks internally, so a split anywhere (mid-character, mid-line, or
/// mid-event) is reassembled correctly before a line ever reaches the switch
/// below.
Stream<SseEvent> parseSseByteStream(Stream<List<int>> bytes) async* {
  String? currentEvent;
  final dataLines = <String>[];

  final lines = bytes
      .transform(const Utf8Decoder(allowMalformed: true))
      .transform(const LineSplitter());

  await for (final line in lines) {
    if (line.isEmpty) {
      if (dataLines.isNotEmpty) {
        yield SseEvent(event: currentEvent, data: dataLines.join('\n'));
        dataLines.clear();
      }
      currentEvent = null;
      continue;
    }
    if (line.startsWith(':')) continue; // comment / keep-alive ping

    final colonIndex = line.indexOf(':');
    final field = colonIndex == -1 ? line : line.substring(0, colonIndex);
    var value = colonIndex == -1 ? '' : line.substring(colonIndex + 1);
    if (value.startsWith(' ')) value = value.substring(1);

    switch (field) {
      case 'data':
        dataLines.add(value);
      case 'event':
        currentEvent = value;
      default:
        // id/retry/unrecognized fields — not used by this backend, ignore.
        break;
    }
  }

  // Defensive flush: the backend always terminates an event with a blank
  // line, but do not silently drop a trailing event if the connection closes
  // (or is cancelled) before one arrives.
  if (dataLines.isNotEmpty) {
    yield SseEvent(event: currentEvent, data: dataLines.join('\n'));
  }
}

/// Shared SSE client for `text/event-stream` endpoints. Reuses the caller's
/// [Dio] instance (pass `ApiClient.raw` so auth/version headers and the
/// existing interceptor pipeline apply) and exposes the parsed event stream.
/// One implementation for AI chat now; sprechen-partner (MASTER P8) and
/// grading (GĐ2 P2) reuse it later — see phase-01 plan.
class SseClient {
  SseClient(this._dio);
  final Dio _dio;

  /// Opens [path] as an SSE stream. [cancelToken] lets the caller abort the
  /// underlying HTTP request (e.g. user navigates away or retries mid-stream)
  /// — cancellation ends the returned stream silently, it does not throw.
  /// [onHeaders], if given, is invoked once with the response headers as soon
  /// as they arrive (before any event is parsed) — used by callers that need
  /// a response header such as `X-Session-Id`.
  Stream<SseEvent> stream(
    String path, {
    String method = 'POST',
    Object? body,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    void Function(Headers headers)? onHeaders,
  }) async* {
    final Response<ResponseBody> response;
    try {
      response = await _dio.request<ResponseBody>(
        path,
        data: body,
        queryParameters: query,
        cancelToken: cancelToken,
        options: Options(
          method: method,
          responseType: ResponseType.stream,
          headers: const {'Accept': 'text/event-stream'},
        ),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) return;
      throw await _toSseException(e);
    }
    onHeaders?.call(response.headers);

    try {
      // `await for` (not `yield*`) is required here: `yield*` forwards errors
      // raised by the delegated stream straight to the outer subscriber,
      // bypassing this try/catch. `await for` re-raises them as a normal
      // exception in this function, which the catch below can then swallow
      // (clean cancel) or rethrow as a client-facing [SseException].
      await for (final event
          in parseSseByteStream(response.data!.stream.cast<List<int>>())) {
        yield event;
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) return;
      throw await _toSseException(e);
    }
  }

  Future<SseException> _toSseException(DioException e) async {
    final status = e.response?.statusCode;
    var message = e.message ?? 'SSE request failed';
    final data = e.response?.data;
    if (data is ResponseBody) {
      try {
        final body = await data.stream
            .cast<List<int>>()
            .transform(const Utf8Decoder(allowMalformed: true))
            .join();
        if (body.isNotEmpty) message = body;
      } catch (_) {
        // Body already consumed/unreadable — keep e.message.
      }
    }
    return SseException(_truncate(message), statusCode: status, originalError: e);
  }

  String _truncate(String s) => s.length > 200 ? '${s.substring(0, 200)}…' : s;
}
