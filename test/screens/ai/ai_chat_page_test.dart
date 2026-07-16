import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:deutschtiger/data/ai/ai_chat_live_models.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/repositories/ai/ai_repository.dart';
import 'package:deutschtiger/screens/ai/ai_chat_page.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  setUp(() {
    // ApiClient reads the app version via package_info_plus on every request.
    // Without a mock value, the platform-channel call never resolves inside
    // a widget test's binding (unlike a plain `test()`, where it throws
    // immediately) and silently stalls every `_dio.request` forever.
    PackageInfo.setMockInitialValues(
      appName: 'DeutschTiger',
      packageName: 'com.deutschtiger.app',
      version: '0.0.0',
      buildNumber: '0',
      buildSignature: '',
    );
  });

  testWidgets('streams assistant tokens into the transcript as they arrive', (tester) async {
    final controller = StreamController<Uint8List>();
    final adapter = _ScriptedAdapter((options) async {
      return ResponseBody(controller.stream, 200, headers: {
        Headers.contentTypeHeader: ['text/event-stream'],
        'x-session-id': ['session-1'],
      });
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [aiRepositoryProvider.overrideWithValue(AIRepository(_client(adapter)))],
        child: MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const AIChatPage(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Wie geht es dir?');
    // `enterText` doesn't pump a frame — the send button's `onTap` is
    // computed from `hasText` in a `ValueListenableBuilder` and stays
    // wired to the pre-text (disabled/null) callback until the widget
    // tree rebuilds, so tapping it immediately would silently no-op.
    await tester.pump();
    await tester.tap(find.byIcon(Icons.send_rounded));
    await _flush(tester);

    // User bubble appears immediately; assistant bubble starts as typing dots.
    expect(find.text('Wie geht es dir?'), findsOneWidget);

    controller.add(utf8.encode('data: {"content":"Mir"}\n\n'));
    await _flush(tester);
    expect(find.textContaining('Mir'), findsOneWidget);

    controller.add(utf8.encode('data: {"content":" geht es gut"}\n\n'));
    controller.add(utf8.encode('data: [DONE]\n\n'));
    await controller.close();
    await _flush(tester);

    expect(find.textContaining('Mir geht es gut'), findsOneWidget);
  });

  testWidgets('shows a quota-exceeded banner without a Retry action', (tester) async {
    // A 429 rejection also triggers ApiClient's real 2s auto-retry Timer
    // (see `_responseInterceptor`), which a widget test can't fast-forward.
    // Exercised at the repository/contract level instead (see
    // `ai_chat_contract_test.dart`); here a fake repository throws the
    // already-mapped [AiChatRequestException] directly so the test stays
    // fast and deterministic.
    final repo = _FakeRejectingRepository(
      AiChatRequestException(
        'Bạn đã dùng hết 7 lượt chat miễn phí hôm nay.',
        code: 'free_limit_reached',
        limit: 7,
        used: 7,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [aiRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const AIChatPage(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Hallo');
    // See comment above — the send button needs a frame to pick up the
    // now-non-empty text before its `onTap` is wired.
    await tester.pump();
    await tester.tap(find.byIcon(Icons.send_rounded));
    await _flush(tester);

    expect(find.textContaining('7 lượt chat miễn phí'), findsOneWidget);
    expect(find.text('Thử lại'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a Retry banner on a generic error and resends on tap', (tester) async {
    var requestCount = 0;
    final adapter = _ScriptedAdapter((options) async {
      requestCount++;
      if (requestCount == 1) {
        return ResponseBody.fromString(
          'data: {"error":"AI đang quá tải, vui lòng thử lại sau."}\n\n'
          'data: [DONE]\n\n',
          200,
          headers: {
            Headers.contentTypeHeader: ['text/event-stream'],
          },
        );
      }
      return ResponseBody.fromString(
        'data: {"content":"Ok, thử lại đây"}\n\ndata: [DONE]\n\n',
        200,
        headers: {
          Headers.contentTypeHeader: ['text/event-stream'],
        },
      );
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [aiRepositoryProvider.overrideWithValue(AIRepository(_client(adapter)))],
        child: MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const AIChatPage(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Hallo');
    // See comment above — the send button needs a frame to pick up the
    // now-non-empty text before its `onTap` is wired.
    await tester.pump();
    await tester.tap(find.byIcon(Icons.send_rounded));
    await _flush(tester);

    expect(find.textContaining('quá tải'), findsOneWidget);
    expect(find.text('Thử lại'), findsOneWidget);

    await tester.tap(find.text('Thử lại'));
    await _flush(tester);

    expect(requestCount, 2);
    expect(find.textContaining('Ok, thử lại đây'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

/// Advances several frames without `pumpAndSettle` — the chat bubble's typing
/// indicator uses a `..repeat()` [AnimationController], which never settles
/// and would make `pumpAndSettle` hang forever while a streaming bubble is
/// visible.
Future<void> _flush(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 20));
  }
}

ApiClient _client(HttpClientAdapter adapter) {
  final client = ApiClient(
    baseUrl: 'https://example.test/api/v1',
    tokenProvider: _NoTokenProvider(),
  );
  client.raw.httpClientAdapter = adapter;
  return client;
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}

class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this._handler);
  final Future<ResponseBody> Function(RequestOptions options) _handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    // AIChatPage also renders a quota banner via `GET /ai/chat-status`
    // (see aiChatStatusProvider) — answer that out-of-band so it never
    // consumes a slot in the scripted `sendMessage` response sequence.
    if (options.path.contains('/ai/chat-status')) {
      return _chatStatusResponse();
    }
    return _handler(options);
  }

  @override
  void close({bool force = false}) {}
}

Future<ResponseBody> _chatStatusResponse() async => ResponseBody.fromString(
  jsonEncode({
    'isPremium': false,
    'dailyLimit': 0,
    'usedToday': 0,
    'remaining': 0,
    'sessionLimit': 0,
  }),
  200,
  headers: {
    Headers.contentTypeHeader: ['application/json'],
  },
);

/// Repository stub that rejects every `sendMessage` immediately with a fixed
/// [AiChatRequestException] — never touches the network, so it can't hit
/// [ApiClient]'s real 429-retry Timer.
class _FakeRejectingRepository extends AIRepository {
  _FakeRejectingRepository(this._error)
    : super(
        ApiClient(baseUrl: 'https://example.test/api/v1', tokenProvider: _NoTokenProvider()),
      );
  final AiChatRequestException _error;

  // Avoids a real network call from the quota banner's aiChatStatusProvider
  // (this fake never wires an HttpClientAdapter for the base `sendMessage`
  // rejection scenario).
  @override
  Future<ChatStatus> getChatStatus() async => const ChatStatus(isPremium: true);

  @override
  Stream<AiChatStreamEvent> sendMessage({
    required String content,
    String? sessionId,
    List<ChatAttachment> attachments = const [],
    AiExamContext? examContext,
    CancelToken? cancelToken,
    void Function(String sessionId)? onSessionId,
  }) async* {
    throw _error;
  }
}
