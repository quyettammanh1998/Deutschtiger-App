import 'dart:typed_data';

import 'package:deutschtiger/data/home/dashboard_data.dart';
import 'package:deutschtiger/features/heartbeat/heartbeat_provider.dart';
import 'package:deutschtiger/l10n/app_localizations.dart';
import 'package:deutschtiger/features/daily_path/data/daily_path_repository.dart';
import 'package:deutschtiger/features/daily_path/domain/daily_path.dart';
import 'package:deutschtiger/screens/home/widgets/resume_section.dart';
import 'package:deutschtiger/services/api_client.dart';
import 'package:deutschtiger/services/auth_provider.dart';
import 'package:deutschtiger/view_models/providers.dart';
import 'package:deutschtiger/widgets/dashboard/streak_claim_modal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('dashboard parser keeps all production count fields', () {
    final data = DashboardData.fromJson({
      'profile': {
        'display_name': 'Mai',
        'avatar_url': 'https://example.test/mai.jpg',
        'email': 'mai@example.test',
      },
      'due_review_count': 3,
      'due_backlog_total': 11,
      'reviews_today': 7,
      'words_learned': 120,
      'lookup_count': 80,
      'flashcard_deck_count': 4,
      'online_time_today': 600,
    });

    expect(data.profile?.displayName, 'Mai');
    expect(data.profile?.avatarUrl, 'https://example.test/mai.jpg');
    expect(data.dueBacklogTotal, 11);
    expect(data.reviewsToday, 7);
    expect(data.lookupCount, 80);
    expect(data.flashcardDeckCount, 4);
  });

  test('heartbeat posts to user endpoint and stores claim state', () async {
    final setup = _clientWithResponse(
      '{"active_minutes":12,"streak_counted":false,"current_streak":4,"claimable":true}',
    );
    final container = ProviderContainer(
      overrides: [apiClientProvider.overrideWithValue(setup.client)],
    );
    final subscription = container.listen(heartbeatProvider, (_, _) {});
    addTearDown(() {
      subscription.close();
      container.dispose();
    });

    for (
      var i = 0;
      i < 20 && container.read(heartbeatProvider).onlineSeconds == 0;
      i++
    ) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    final state = container.read(heartbeatProvider);

    expect(setup.adapter.requests.single.path, '/user/heartbeat');
    expect(state.onlineSeconds, 720);
    expect(state.streak, 4);
    expect(state.claimable, isTrue);
  });

  test('daily path repository parses next free step and sends timezone', () async {
    final setup = _clientWithResponse(
      '{"steps":['
      '{"key":"premium","skill":"writing","title":"Premium","premium":true,"done":false},'
      '{"key":"vocab","skill":"vocab","title":"Học 10 từ","description":"A1","route":"/learn/session/today","est_minutes":8,"done":false}'
      '],"done_count":1,"total_count":3,"est_minutes_remaining":12}',
    );

    final path = await DailyPathRepository(
      setup.client,
    ).fetchToday(timezone: 'Asia/Bangkok');

    expect(path.currentStep?.key, 'vocab');
    expect(path.doneCount, 1);
    expect(path.estimatedMinutesRemaining, 12);
    expect(setup.adapter.requests.single.path, '/user/learn/path/today');
    expect(setup.adapter.requests.single.queryParameters['tz'], 'Asia/Bangkok');
  });

  testWidgets('daily path card fits a narrow mobile viewport', (tester) async {
    tester.view.physicalSize = const Size(340, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    const path = DailyPath(
      steps: [
        DailyPathStep(
          key: 'vocab',
          skill: 'vocab',
          title: 'Học từ vựng theo lộ trình hôm nay',
          description: 'A1',
          route: '/learn/session/today',
          estimatedMinutes: 8,
          done: false,
          premium: false,
        ),
      ],
      doneCount: 1,
      totalCount: 3,
      estimatedMinutesRemaining: 12,
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16),
            child: ResumeLearningCard(
              path: path,
              dailyXp: 25,
              dailyGoal: 50,
              onTap: _noop,
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.textContaining('1/3 bước'), findsOneWidget);
  });

  testWidgets('streak modal claims through the backend', (tester) async {
    final setup = _clientWithResponse(
      '{"success":true,"current_streak":5,"longest_streak":8}',
    );
    var claimed = false;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiClientProvider.overrideWithValue(setup.client)],
        child: MaterialApp(
          home: Scaffold(
            body: StreakClaimModal(
              open: true,
              heartbeatStreak: 4,
              onClose: () {},
              onClaimed: (_) => claimed = true,
            ),
          ),
        ),
      ),
    );

    final claimButton = find.widgetWithText(ElevatedButton, 'Nhận ngay');
    await tester.ensureVisible(claimButton);
    await tester.runAsync(() async {
      tester.widget<ElevatedButton>(claimButton).onPressed!.call();
      for (var i = 0; i < 20 && !claimed; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
    });
    await tester.pumpAndSettle();

    expect(setup.adapter.requests.single.path, '/user/streak/claim');
    expect(claimed, isTrue);
    expect(find.text('Đã nhận phần thưởng!'), findsOneWidget);
  });
}

void _noop() {}

({ApiClient client, _Adapter adapter}) _clientWithResponse(String response) {
  final client = ApiClient(
    baseUrl: 'https://example.test/api/v1',
    tokenProvider: _NoTokenProvider(),
  );
  final adapter = _Adapter(response);
  client.raw.httpClientAdapter = adapter;
  return (client: client, adapter: adapter);
}

class _NoTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> refresh() async => null;
}

class _Adapter implements HttpClientAdapter {
  _Adapter(this.response);
  final String response;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      response,
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
