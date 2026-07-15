import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:deutschtiger/services/api/sse_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseSseByteStream', () {
    Stream<List<int>> chunksOf(List<String> parts) =>
        Stream.fromIterable(parts.map(utf8.encode));

    test('parses a single event delivered in one chunk', () async {
      final events = await parseSseByteStream(
        chunksOf(['data: {"content":"Hallo"}\n\n']),
      ).toList();

      expect(events, [const SseEvent(data: '{"content":"Hallo"}')]);
    });

    test('reassembles an event whose line is split across chunks', () async {
      // Splits mid key ("cont" | "ent"), simulating a TCP chunk boundary
      // landing inside a single `data:` line.
      final events = await parseSseByteStream(
        chunksOf(['data: {"cont', 'ent":"Hallo"}\n', '\n']),
      ).toList();

      expect(events, [const SseEvent(data: '{"content":"Hallo"}')]);
    });

    test('reassembles a multi-byte UTF-8 character split across chunks', () async {
      // "ü" (U+00FC) encodes to 2 bytes in UTF-8 — split the byte pair itself.
      final full = utf8.encode('data: {"content":"Tschü"}\n\n');
      final splitAt = full.indexOf(0xC3) + 1; // cut right after the lead byte
      final events = await parseSseByteStream(
        Stream.fromIterable([full.sublist(0, splitAt), full.sublist(splitAt)]),
      ).toList();

      expect(events, [const SseEvent(data: '{"content":"Tschü"}')]);
    });

    test('delivers multiple sequential token events in order', () async {
      final events = await parseSseByteStream(
        chunksOf([
          'data: {"content":"Hallo"}\n\n',
          ': ping\n\n', // keep-alive comment — ignored
          'data: {"content":" Welt"}\n\n',
          'data: [DONE]\n\n',
        ]),
      ).toList();

      expect(events.map((e) => e.data), [
        '{"content":"Hallo"}',
        '{"content":" Welt"}',
        '[DONE]',
      ]);
    });

    test('joins multi-line data fields with newline per the SSE spec', () async {
      final events = await parseSseByteStream(
        chunksOf(['data: line one\n', 'data: line two\n', '\n']),
      ).toList();

      expect(events, [const SseEvent(data: 'line one\nline two')]);
    });

    test('captures the event: field alongside data', () async {
      final events = await parseSseByteStream(
        chunksOf(['event: error\n', 'data: {"error":"quota"}\n', '\n']),
      ).toList();

      expect(events, [
        const SseEvent(event: 'error', data: '{"error":"quota"}'),
      ]);
    });

    test('ignores malformed/unrecognized lines without throwing', () async {
      final events = await parseSseByteStream(
        chunksOf([
          'not-a-field-at-all\n',
          'id: 123\n',
          'retry: 5000\n',
          'data: ok\n',
          '\n',
        ]),
      ).toList();

      expect(events, [const SseEvent(data: 'ok')]);
    });

    test('flushes a trailing event when the stream ends without a blank line', () async {
      final events = await parseSseByteStream(
        chunksOf(['data: {"content":"cut off"}']),
      ).toList();

      expect(events, [const SseEvent(data: '{"content":"cut off"}')]);
    });

    test('emits nothing for an empty stream', () async {
      final events = await parseSseByteStream(const Stream.empty()).toList();
      expect(events, isEmpty);
    });
  });

  group('SseClient', () {
    test('streams parsed events from a 200 response', () async {
      final controller = StreamController<Uint8List>();
      final adapter = _ScriptedAdapter((options) async {
        scheduleMicrotask(() async {
          controller.add(utf8.encode('data: {"content":"Hi"}\n\n'));
          controller.add(utf8.encode('data: [DONE]\n\n'));
          await controller.close();
        });
        return ResponseBody(controller.stream, 200, headers: {
          Headers.contentTypeHeader: ['text/event-stream'],
        });
      });
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = adapter;
      final client = SseClient(dio);

      final events = await client.stream('/ai/chat', body: {'x': 1}).toList();

      expect(events.map((e) => e.data), [
        '{"content":"Hi"}',
        '[DONE]',
      ]);
      expect(adapter.lastOptions?.method, 'POST');
      expect(
        adapter.lastOptions?.headers['Accept'],
        'text/event-stream',
      );
    });

    test('invokes onHeaders once with the response headers', () async {
      final adapter = _ScriptedAdapter((options) async {
        return ResponseBody.fromString('data: {"content":"Hi"}\n\n', 200, headers: {
          Headers.contentTypeHeader: ['text/event-stream'],
          'x-session-id': ['session-123'],
        });
      });
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = adapter;
      final client = SseClient(dio);

      Headers? seenHeaders;
      await client
          .stream('/ai/chat', onHeaders: (h) => seenHeaders = h)
          .toList();

      expect(seenHeaders?.value('x-session-id'), 'session-123');
    });

    test('surfaces a non-2xx response as SseException with the body text', () async {
      final adapter = _ScriptedAdapter((options) async {
        return ResponseBody.fromString(
          '{"error":"Tất cả tài khoản AI tạm hết quota"}',
          429,
          headers: {
            Headers.contentTypeHeader: ['application/json'],
          },
        );
      });
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = adapter;
      final client = SseClient(dio);

      await expectLater(
        client.stream('/ai/chat').toList(),
        throwsA(
          isA<SseException>()
              .having((e) => e.statusCode, 'statusCode', 429)
              .having((e) => e.message, 'message', contains('quota')),
        ),
      );
    });

    test('surfaces a network failure as SseException', () async {
      final adapter = _ScriptedAdapter((options) async {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'connection refused',
        );
      });
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = adapter;
      final client = SseClient(dio);

      await expectLater(
        client.stream('/ai/chat').toList(),
        throwsA(isA<SseException>()),
      );
    });

    test('stops delivering events once the subscriber cancels', () async {
      // This is the cancel path a real caller uses (e.g. AI chat repository
      // cancelling mid-stream when the user navigates away): drop the
      // subscription rather than waiting for the server to notice. Exercised
      // directly against the parser (what SseClient.stream delegates to)
      // since Dio's own CancelToken plumbing has unrelated, version-specific
      // timing that would make this test flaky.
      final controller = StreamController<List<int>>();
      final received = <SseEvent>[];
      final sub = parseSseByteStream(controller.stream).listen(received.add);

      controller.add(utf8.encode('data: {"content":"partial"}\n\n'));
      await Future<void>.delayed(Duration.zero);
      expect(received, [const SseEvent(data: '{"content":"partial"}')]);

      // Fire-and-forget, matching how real callers use StreamSubscription —
      // the returned Future only resolves once the upstream source (here an
      // open, never-closed controller) finishes, so awaiting it here would
      // hang for the same reason a caller should not await it in production.
      unawaited(sub.cancel());
      await Future<void>.delayed(Duration.zero);
      // Pushed after cancel — must not reach `received` nor crash the test.
      controller.add(utf8.encode('data: {"content":"too late"}\n\n'));
      await Future<void>.delayed(Duration.zero);

      expect(received.length, 1);
    });

    test('a Dio cancel error mid-stream ends the stream silently', () async {
      // Simulates what Dio's own cancel-token wiring does to the response
      // body stream (adds a DioException(type: cancel) then closes) without
      // depending on the installed Dio version's exact CancelToken timing.
      final controller = StreamController<Uint8List>();
      final adapter = _ScriptedAdapter((options) async {
        return ResponseBody(controller.stream, 200, headers: {
          Headers.contentTypeHeader: ['text/event-stream'],
        });
      });
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = adapter;
      final client = SseClient(dio);

      final events = <SseEvent>[];
      final done = Completer<void>();
      client.stream('/ai/chat').listen(
            events.add,
            onError: (Object e) => done.completeError(e),
            onDone: () => done.complete(),
          );

      await Future<void>.delayed(const Duration(milliseconds: 10));
      controller.add(utf8.encode('data: {"content":"partial"}\n\n'));
      controller.addError(
        DioException(
          requestOptions: RequestOptions(path: '/ai/chat'),
          type: DioExceptionType.cancel,
        ),
      );
      await controller.close();

      await done.future; // must complete cleanly, not with an error
      expect(events, [const SseEvent(data: '{"content":"partial"}')]);
    });
  });
}

/// Minimal scripted [HttpClientAdapter] — the request handler decides the
/// response (or throws), letting each test control status/body/timing
/// directly instead of hitting the network.
class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this._handler);
  final Future<ResponseBody> Function(RequestOptions options) _handler;
  RequestOptions? lastOptions;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    lastOptions = options;
    return _handler(options);
  }

  @override
  void close({bool force = false}) {}
}
